### in scripts, I like to define some variables up at the top
### that get used more than once up at the top.  
### This makes changes to those things easy and straightforward.

base.dir<-"C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/"
eo.dir<-"C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/Data/EO"
spatial.dir<-"C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/Data/Spatial"
map.dir<-"C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/Maps"

setwd(base.dir)

library(sp)
library(rgeos)
library(raster)
library(rgdal)
library(RODBC)



########### Step 1: Read in spatial grids ##########

  #### create a 'gridlist' object from the spatial data folder.
  #### save the info to our database.

  tiflist<-list.files(spatial.dir)
  tiflist<-tiflist[substr(tiflist,nchar(tiflist) - 3, nchar(tiflist))  == ".tif"]
  tiflist<-tiflist[!grepl("MeanDiurnalRange",tiflist)] ## drop mean diurnal range.  The map needs fixing.
  gridlist<-as.list(paste(spatial.dir,tiflist,sep = "/"))
  nm<-substr(tiflist,1,nchar(tiflist) - 4)
  names(gridlist)<-nm

  ch1<-odbcConnectAccess2007(paste(eo.dir,"/EO.mdb",sep = ""))
  tmp<-data.frame(Variable = nm, Grids = paste(spatial.dir,tiflist,sep = "/"))  
  sqlDrop(ch1,"gridlist")  
  sqlSave(ch1,tmp,"gridlist",rownames = F)
  odbcClose(ch1)

  
  ## Create a grid stack (a brick might be smart for production work, but it takes longer 
  ## to build so a stack will do for now.)
  stk<-stack(gridlist)
  plot(stk)
  plot(stk,"Eglin_30m_dem")
  help(plot, package = "raster")

########################################################################################
########### Step 2: Read in spatial data from an element occurrence shapefile ##########
########################################################################################

  ## enter file name (without extension) of the shapefile
  list.files(eo.dir)
  eo<-"Eglin_RAW_EOs_100km"


  ## use the readOGR function from the rgdal package to read in the shapefile into a 'SpatialPolygonsDataFrame'
  eo<-readOGR(dsn = eo.dir,layer = eo)

  ## If needed (not needed here) project the polygons created above to match the raster data.
  ## eo<-spTransform(eo,CRS(projection(stk)))

  ### Plot the eo data on top of the map to make sure they match up
  plot(eo, add = T, border = "forestgreen",lwd = 2)
  
  ### You can see that we will want to drop some polygons from our analysis because
  ### they are probably too big for what we need (esp. those large circles.)
  ### This type of editing is can be done in ArcGIS, but the following code will let you scroll 
  ### through the polygons, and create a True/False vector that describes which EOs to use
  ### and which ones to drop from further analysis.
  

UseMe<-ScreenEOs(eo,stk,"Eglin_30m_dem")

## Note: With this quick-screening tool, you will undoubtedly make mistakes, 
## and miss dropping some polygons that you wish to drop.
## Keep a pen on hand to note their number so you an fix the UseMe object.
## Also worth noting: The screening tool goes through the biggest
## polygons first (these are the ones you're most likely to drop)
## It gets faster as the script progresses!

UseMe[c(224)]<-F

## check your work
plot(eo[UseMe,],add = T, border = "red", lwd = 2)
plot(eo[!UseMe,],add = T, border = "black", lwd = 2)

## If all looks well, subset and overwrite the eo object
eo<-eo[UseMe,]

## Extract information for only one species
levels(factor(eo$display_na))
eo.lily<-eo[eo$display_na %in% "Lilium iridollae (Panhandle Lily)",]

plot(eo.lily,border = "purple", add = T, lwd = 3)

############################################################
########### Step 3: Define the area to be modeled ##########
############################################################

  ## Create a buffered convex hull around the observations to set the modeling area. 
  ## Note: the 'width' value relates to the units associated with the object (meters in this case)
  ## This will give us a starting region of interest.
  ## As Jimmy mentioned, it may be worthwhile to review the modeling boundaries, and
  ## modify them by hand in Arc if it seems merited.
  ## a modified boundary polygon could be read back in to R using
  ## the same function we used to access our eo shapefile.

  bnd<-gBuffer(gConvexHull(eo.lily),width = 10000)## buffer a convex hull by 10km

  plot(bnd, add = T, border = "darkgreen", lwd = 2)


#########################################################################
########### Step 4: Develop a set of points to use in modeling ##########
#########################################################################

## The following identifies cells that overlap with the polygons, subsamples
## those cells according to a logistic area sampling (max. # samples = 200, curve-shape paramater = .004)
## returns a spatial points data frame containing point midpoints, and extracted values from the 
## raster stack
## function is in 'functions' folder.
## One minor quirk here is that the xy coordinates returned may fall outside of the 
## eo polygons, esp. when eo polygons are smaller, or narrower than 30-m cells.
## Note:  To get more points/polygon when polygon sizes are small,
## play with 'k' (larger value means more pixels are sampled at the bottom levels)
  pts.pos<-MakeSample_eo(eo.lily,stk,A = 200, k = .004, mapvar = "Eglin_30m_dem",whole.extent = F)

## display positive modeling points, color-coded by their parent.
  points(pts.pos, col = pts.pos$ID, cex = .2, pch = 4)

## the following code creates background points for modeling on hexagonal grid
## across the area of interest defined by the 'bnd' or boundary defined above.

  pts.neg<-MakeSample_bnd(bnd,stk,npoints= nrow(pts.pos),idStart = max(pts.pos$ID)+1)
  points(pts.neg,pch = 1, cex = .1, col = "black")

## put the positive and negative points together into a single SpatialPoints object
  pts<-rbind(pts.pos,pts.neg)       

## R doesn't magically carry projection infomration forwards, so we have to 
## re-assign the 'projection' attribute for the new 'pts' object.
  projection(pts)<-projection(pts.pos)

## Because a few of our eos fall outside of our spatial data, our environmental data have some na values.  
## This will not work for input data into a random forest model
## and so we need to drop those points from the objects that we will use in our analysis,
## and also from those objects that we save. records.
## 

env<-data.frame(pts)[,names(stk)]
na.fix<-apply(env,1,function(x){!any(is.na(x))})
pts<-pts[na.fix,]

########################################
##### Step 5: Saving your work #########
########################################

## Save the information generated to  shapefiles
writeOGR(pts, dsn = eo.dir, layer = "modelpoints_lily", driver="ESRI Shapefile", overwrite_layer = T)
writeOGR(eo.lily, dsn = eo.dir, layer = "eo_used_lily", driver="ESRI Shapefile", overwrite_layer = T)


## Save the table to the access database that we created earlier today.
ch1<-odbcConnectAccess2007(paste(eo.dir,"/EO.mdb",sep = ""))
sqlDrop(ch1,"modelpoints_lily")#note: if the table already exists, R won't overwrite.  You'll have to choose a new name, or delete the old table.
sqlSave(ch1,data.frame(pts), "modelpoints_lily")
odbcClose(ch1)

## save the R workspace
save.image(paste(map.dir,"ModelData_lily.RData",sep = "/"))


                         