# define and plot the exponentiall50 suitability function in gadget
exp.l50 <- function(alpha, l, l50) {
    1 / (1 + exp((-alpha)*(l - l50)))
}

# alpha <- 0.046
# l50 <- 66
# 
# curve(exp.l50(alpha, x, l50), 0, 199)