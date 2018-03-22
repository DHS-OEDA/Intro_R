
packages<-c("rgl","vcd","dismo","rgdal","raster", "RODBC","rgeos","snowfall","ROCR","randomForest")
install.packages(packages)
for(i in packages)library(i,character.only = T)

function.dir<-"C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/Functions"
for(i in (list.files(function.dir))){ 
  source(paste(function.dir,"/",i,sep = ""))
}
