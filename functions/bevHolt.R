bevHolt <- function(s, mu, lambda) {
    (mu*s) / (lambda + s)
}

bevHolt.optimizer <- function(data, s) {
    mu <- data[1]
    lambda <- data[2]
    return(bevHolt(s, mu, lambda))
}

bevHolt.sse <- function(data, s, recruits) {
    rec.hat <- bevHolt.optimizer(data, s);
    return(sum((recruits - rec.hat)^2))
}

s <- 1:1000
rec <- log(s)*1000

params <- nlm(bevHolt.sse, c(6500,100), s, rec)

plot(rec ~ s)
curve(bevHolt.optimizer(params$estimate, x), add=T)
