##############################################
### R's functions for making graphics are quite good.
### The syntax can take a little learning though. 
#####################

## Step 1, make up some data to play with
x<-1:10
y<-10:1
z<-rep(c(2,4),each = 5)

## make a simple plot
plot(x,y)
plot(y~x)## send a function to the plotting function.  This does the same thing as the last line.
plot(x,y,type = "l")## plot a line
plot(x,y,type = "l", main = "My Lovely Plot")  ## add a title
plot(x,y,type = "l",ylab = "My Y Variable",xlab = "My X Variable", main = "My Lovely Plot")

labels<-c("a","b","c","d","e","f","g","h","i","j")

text(x,y,labels, col = "red") ## put some text in the plot at your points.

## 
plot(x,y,pch = z) ## Use different symbols for the tick marks

plot(x,y,pch = z, col = rainbow(length(x)))## Use different colors for the tick marks
plot(x,y,pch = z, col = c(rep("black",4),rep("red",4),rep("skyblue",3)))

colors()

help(par)
par(mfrow =c(1,2))
plot(x,y)
plot(y,-x)

par(mfrow =c(2,1), mar =c(5,4,4,2))
plot(x,y, main = "first graph",xlab = "x")
plot(y,-x, main = "second graph", ylab = "-x")

text(2,-2,"2 and -2")


barplot(cbind(x,y))
barplot(cbind(x,y),beside = T)

help(legend)
help(barplot)
help(plot)

