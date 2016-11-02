# code to compute and fit von Bertalanffy growth curves to species

vb <- function(linf, k, a, t0) { #vector with linf[1], k[2], t0[3]
        length <- linf*(1 - exp(-k*(a-t0)));
        return(length);
}

linf <- 150
k <- 0.06
curve(vb(linf, k, x, 0), 0, 150)

# define an sse function that we can minimize on
vb.sse <- function(b) {
    linf <- b[1];
    k <- b[2];
    t0 <- b[3];
    length <- linf*(1 - exp(-k*(a-t0)));
    return(length)
}

sse <- function(b) {
    lhat <- vb.sse(b);
    s <- sum((l-lhat)^2);
    return(s);
}

# read in data here to perform the minimizing function on


# performing a nonlinear minimization on parameters to fit this vb curve to data better
vbMin <- nlm(sse, c(51.816, 0.952, -4.337))

# visualize the output
#plot(mean~age, data=la)
linf.min <- vbMin$estimate[1]
k.min <- vbMin$estimate[2]
t0.min <- vbMin$estimate[3]
#curve(vb(linf.min, k.min, x, t0.min), add=T, col='red', lwd=1.4) # as you can see, not quite there

g <- ggplot(la, aes(x=age, y=mean)) + geom_point() +
    stat_function(fun=function (x) vb(linf.min, k.min, x, t0.min)) 
# curve to test parameter bounds    + stat_function(fun=function(x) vb(linf.min, k.min, x, t0.min))
# curve to test parameter bounds    + stat_function(fun=function(x) vb(linf.min, k.min, x, t0.min)) 


