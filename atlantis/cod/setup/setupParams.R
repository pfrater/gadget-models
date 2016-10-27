init.params <- read.gadget.parameters(sprintf('%s/params.out', gd$dir))

#  rc <- 19

rn <- rownames(init.params)
init.params[grep('linf', rn), ] <- c('cod.linf', 170, 150, 250, 1)
init.params[grep('k', rn), ] <- c('cod.k', 0.2, 0.01, 0.30, 1)
init.params[grep('bbin', rn), ] <- c('cod.bbin', 6, 1e-08, 100, 1)
init.params[grep('mult', rn), ][1,] <- c('cod.mult', 5, 1e-05, 10, 1)
init.params[grep('init.abund', rn), ] <- c('cod.init.abund', 10, 1e-05, 30, 1)
init.params[grep('rec.sd', rn), ] <- c('cod.rec.sd', 2, 0.1, 10, 1)
init.params[grep('rec.mult', rn), ] <- c('cod.rec.mult', 100, 1e-05, 300, 1)
init.params[grep('age', rn), ] <- data.frame(switch=sprintf('cod.age%s', 1:rc),
                                             value=rep(20, rc), lower=rep(1e-05, rc),
                                             upper=rep(50, rc), optimise=rep(1, rc))
init.params$switch <- rownames(init.params)

init.params[grepl('rec[0-9]',init.params$switch),'value'] <- 1
init.params[grepl('rec[0-9]',init.params$switch),'upper'] <- 100
init.params[grepl('rec[0-9]',init.params$switch),'lower'] <- 0.001
init.params[grepl('rec[0-9]',init.params$switch),'optimise'] <- 1

init.params['cod.recl',-1] <- c(20, 5, 40,1)

init.params[grepl('alpha',init.params$switch),'value'] <- 0.5
init.params[grepl('alpha',init.params$switch),'upper'] <- 10
init.params[grepl('alpha',init.params$switch),'lower'] <- 0.01
init.params[grepl('alpha',init.params$switch),'optimise'] <- 1

init.params[grepl('l50',init.params$switch),'value'] <- 50
init.params[grepl('l50',init.params$switch),'upper'] <- 200
init.params[grepl('l50',init.params$switch),'lower'] <- 5
init.params[grepl('l50',init.params$switch),'optimise'] <- 1

init.params[init.params$switch=='igfs.alpha',] <- c('igfs.alpha', 40, 1, 200, 1)
init.params[init.params$switch=='igfs.beta',] <- c('igfs.beta', 0.9, 0.06, 5, 1)
# #init.params[init.params$switch=='igfs.gamma',] <- c('igfs.gamma', 0.5, 0, 1, 1)
# #init.params[init.params$switch=='igfs.delta',] <- c('igfs.delta', 0.5, 0, 1, 1)

init.params[init.params$switch=='aut.alpha',] <- c('aut.alpha', 40, 1, 200, 1)
init.params[init.params$switch=='aut.beta',] <- c('aut.beta', 0.9, 0.06, 10, 1)
# #init.params[init.params$switch=='aut.gamma',] <- c('aut.gamma', 0.5, 0, 1, 1)
# #init.params[init.params$switch=='aut.delta',] <- c('aut.delta', 0.5, 0, 1, 1)

# init.params[init.params$switch=='igfs.p1',] <- c('igfs.p1', 0.5, 0.01, 1, 1)
# init.params[init.params$switch=='igfs.p2',] <- c('igfs.p2', 0.5, 0.01, 1, 1)
# #init.params[init.params$switch=='igfs.p3',] <- c('igfs.p3', 0.5, 0.01, 1, 1)
# init.params[init.params$switch=='igfs.p4',] <- c('igfs.p4', 5, 0.1, 100, 1)
# init.params[init.params$switch=='igfs.p5',] <- c('igfs.p5', 5, 0.1, 100, 1)

#init.params[init.params$switch=='aut.p1',] <- c('aut.p1', 0.5, 0.01, 1, 1)
#init.params[init.params$switch=='aut.p2',] <- c('aut.p2', 0.5, 0.01, 1, 1)
#init.params[init.params$switch=='aut.p3',] <- c('aut.p3', 0.5, 0.01, 1, 1)
#init.params[init.params$switch=='aut.p4',] <- c('aut.p4', 5, 0.1, 100, 1)
#init.params[init.params$switch=='aut.p5',] <- c('aut.p5', 5, 0.1, 100, 1)


write.gadget.parameters(init.params,file=sprintf('%s/params.in', gd$dir))
