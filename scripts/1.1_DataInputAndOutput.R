library(RODBC)

help(read.table)
help(read.csv)
help(odbcConnectAccess2007)
help(sqlFetch)
help(sqlSave)
help(sqlQuery)
#################


######
## Todo: Create a two-column table, containing spatial variable names, and 
## full paths to the .tif files for each variable.
## Save the  table as a .csv file
## Read the .csv file in to R
## 
## Create an access database in the 'data' folder (a personal geodatabase might 
## be a good idea, but is not mandatory.)
## Save the R object into the access database that you just created using sqlSave.
## Re-read the table back in to R using sqlFetch
## 
## Bonus:  Create a query in Access that shows only 1 line of the table. 
## copy the sql code from the access query sql view
## use sqlQuery to bring the table defined by the query into R.
## This can be especially useful if you need to pull data from a more 
## complex database.