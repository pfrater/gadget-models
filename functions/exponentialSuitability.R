# example of the exponential suitability function used in gadget
# see gadget manual 4.9.3

exp.suit <- function(alpha, beta, gamma, delta, l, L) {
    delta / (1 + exp(-(alpha) - (beta*l) - (gamma*L)))
}

alpha <- 5
beta <- 0.6
alpha <- alpha*((-1)*beta)
curve(exp.suit(alpha,beta,0,1,x,100), 0, 175)
