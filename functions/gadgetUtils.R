# handy wrapper functions for producing gadget files in association with Rgadget
von_b_formula <- function(age, linf, k, recl) {
    vonb <- as.quoted(paste('(',
                  linf,
                  '* (1 - exp(-1 *',
                  k,
                  '* (1 - (1 + log((1 - (',
                  recl, '/', linf,
                  '))) /',
                  k,
                  ')))))'))[[1]]
    to.gadget.formulae(vonb)
    
}

fleet.suit <- function(fleet, stock, fun) {
    if (fun == 'exponentiall50') {
        suit <- paste0('\n', 
                       paste(stock, 
                             'function', 
                             'exponentiall50', 
                             sprintf('#%1$s.%2$s.alpha', stock, fleet),
                             sprintf('#%1$s.%2$s.l50', stock, fleet)),
                       collapse='\n')
    }
    else if (fun == 'constant') {
        suit <- paste0('\n',
                       paste(stock, 'function', 'constant', '1', sep='\t'),
                       collapse='\n')
    }
}

init.params <- function(params.data, switch, value, 
                        lower.bound, upper.bound, optimise) {
    w.switch <- grep(switch, params.data$switch);
    if (length(w.switch) != 0) {
        update.switch <- data.frame(switch = params.data$switch[w.switch], 
                                value = value, lower = lower.bound, 
                                upper = upper.bound, optimise = optimise);
        update.switch$switch <- as.character(update.switch$switch);
        params.data[w.switch, ] <- update.switch;
        return(params.data);
    }
    else {return(params.data)}
}

standard.age.factor <- 'exp(-1*(%2$s.M+%3$s.init.F)*%1$s)*%2$s.init.%1$s'
andy.age.factor <- '(%2$s.age.alpha * exp((-1)  * (((log(%1$s)) - %2$s.age.beta) * ((log(%1$s)) - %2$s.age.beta) / %2$s.age.gamma)) + %2$s.age.delta)'
gamma.age.factor <- '(%1$s / ((%2$s.age.alpha - 1) * (%2$s.age.beta * %2$s.age.gamma))) ** (%2$s.age.alpha - 1) * exp(%2$s.age.alpha - 1 - (%1$s / (%2$s.age.beta * %2$s.age.gamma)))'
