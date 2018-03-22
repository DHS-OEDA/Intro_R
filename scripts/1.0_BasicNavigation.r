### Item #1:  The commenting character for R is # 
### You'll see a lot of these, masking out information that is just for you, and not for R.

## For assistance along the learning curve, navigate the help files.
help(help)# if you know what function you want, but  don't know how to use it, the help function is helpful.
help.search("help")## if you don't quite know the name of the function you want, help.search uses keywords and fuzzy matching to give you a list of possibilities.

## Note: When you don't know enough to ask for help via R's help, just go to Google.  
## Discussion boards, blogs and help files online are abundant!
## If you're stuck and want a human, rather than google, send me an email: emilie.henderson@oregonstate.edu
## 

### getting around your computer
getwd() ## tells your current working directory.

### Note: R thinks like Unix.  use "\\" or "/", rather than "\" for filepaths.
### Unless you're a native UNIX speaker, this quirk probably will trip you up 
### at some point in time.

setwd("C:/workspace/SDMWorkshop/Florida/RareSpeciesMapping_Workshop/Data/EO") #sets your working directory. 
## You can use setwd() to help keep your files organized.

ls() ## shows you what's in your workspace (i.e., the objects in your R workspace.  These are probably mostly functions at this point)
## This is the same information htat's listed under 'Environment' in the top right corner of the 
## RStudio window.

list.files() #shows you what's in your current working directory
list.files("C:/temp")## shows you what's in your temp directory.

### vector creation
myvector <- c(1,2,3,4,5)
print(myvector)
myvector<-c("a","b","c","d","e")
print(myvector)

## vector subsetting
print(myvector[1])     
print(myvector[2])     
print(myvector[3:5])    
print(myvector[c(1,3,5)])   


### data frames - matrices are useful for some things, but data frames are needed to hold vectors of different data types
myvector1<-1:5
myvector1

myvector2<-c("a","b","c","d","e")
myvector2

mydataframe<-data.frame(myvector1, myvector2)
mydataframe

### data frame subsetting
mydataframe[1,]         
mydataframe[,1]   
mydataframe[1,]                                              
mydataframe[2,1]  
mydataframe[1,2]   ## notice factor handling of text vectors  

## Note:  R uses factors to efficiently store repetitive text (i.e., categorical data)
## The actual values within the factor vector are integers, which are linked to text
## in the levels attribute of the factor.
## 

print(mydataframe[,2])
print(as.numeric(mydataframe[,2]))

## This is efficient, but can trip you up when you don't forget that something is 
## being stored as a factor.

myfactor<-factor(c(rep(10,10),rep(25,10)))
print(myfactor)
print(as.numeric(myfactor))


### lists
mylist<-list(myvector1, myvector2, mydataframe)
mylist
mylist[[2]] 
mylist[[3]]                                        
mylist[[3]][,2]

### True/False Vectors
   ## These are useful since they can be used to select, or leave out data elements
   
   ## Some very basic operations
tf1<-myvector1 == 1
print(tf1)
tf2<-myvector2 == "c"
print(tf2)

  ## Using true/false vectors to subset
print(mydataframe[tf1,]) 
print(mydataframe[!tf1,]) # ! means 'not this!'
print(mydataframe[tf1 & tf2,]) # logical vectors can be combined with &  
print(mydataframe[tf1 | tf2,]) # logical vectors can be combined with | , which means 'or'

  ## some other methods of generating true/false vectors.
help(grep) # this is a partial-matching function that helps search vectors for text strings.
help(grepl) # just like grep, but returns a logical flag.

# %in% # uses different syntax as the other logical flags above, but quite useful for 
# matching to many things at once.  

1 %in% 1:5 ## returns T
1 %in% 2:6 ## returns F
1:5 %in% 3:7 ## returns a True/False vector