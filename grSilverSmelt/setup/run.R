library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(sind=c('surv.si.2030', 'surv.si.3040', 'surv.si.4055'),
                                      survey=c('ldist.surv', 'aldist.surv'),
                                      comm=c('ldist.bmt', 'aldist.bmt')),
                        wgts='WGTS')

