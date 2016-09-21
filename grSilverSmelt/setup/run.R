library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(spr.sind=c('igfs.si.short', 'igfs.si.mid',
                                             'igfs.si.long'),
                                      aut.sind=c('aut.si.short', 
                                             'aut.si.mid', 'aut.si.long'),
                                      survey=c('ldist.igfs', 'ldist.aut',
                                               'aldist.igfs', 'aldist.aut'),
                                      comm=c('ldist.bmt', 'aldist.bmt')),
                        wgts='WGTS')