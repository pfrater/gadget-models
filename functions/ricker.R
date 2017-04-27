# code to specify and optimize a ricker recruitment function based on given data
library(ggplot2)

ricker <- function(a,b,c,age) {
	a*age*exp(((-b)*age) - c)
}

ricker.optimizer <- function(params, age) {
	a <- params[1]
	b <- params[2]
	c <- params[3]
	return(ricker(a,b,c,age))
}

ricker.sse <- function(params, vals, age) {
	init.hat <- ricker.optimizer(params, age);
	return(sum((vals - init.hat)^2))
}

# make up some basic data and calculate parameter estimates
age <- 0:10
vals <- c(5,10,20,30,35,30,20,10,5,1,1)

params <- nlm(ricker.sse, c(100,1,0), vals, age)$estimate

#plot(vals ~ age)
#curve(ricker.optimizer(c(2,50,5), x), add=T)

a <- -100:100
b <- seq(-5,5,by=0.05)
test.params <- expand.grid(a=a,b=b,age=age)
test.params$ricker <- ricker(test.params$a, test.params$b, 0, test.params$age)

g <- ggplot(data=test.params, aes(x=age, y=ricker, color=factor(a))) + facet_wrap(~b)


#test <- function(b,x) {
#	exp(-(b+(x)))
#}
#curve(test(-10, x), -20, 20)
#for (i in -10:10) {
#curve(test(i, x), col=(i+11), add=T)
#}
