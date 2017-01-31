asf <- function(p0, p1, p2, p3, p4, L, l) {
    if (log(L/l) <= p1) {
        tmp <- p0 + (p2*exp(-(((log(L/l)-p1)^2)/p4)));
    } 
    else {
        tmp <- p0 + (p2*exp(-(((log(L/l)-p1)^2)/p3)));
    }
    return(tmp);
}

a <- seq(0,1,by=0.1)
plot(a ~ 1, type='n', xlim=c(0,60))
for (i in 1:10) {
    curve(asf(0,1,i,1,1,10,x),0,60,add=T,col=i)
}

curve(asf(0.010000378, 0.010000313, 0.9999587, 0.029918172, 0.088193321, 35, x), 0,60)
