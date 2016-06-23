library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(sind=c('igfs.si.1525', 'igfs.si.2540',
                                             'igfs.si.4055', 'aut.si.1525',
                                             'aut.si.2540', 'aut.si.4055'),
                                      survey=c('ldist.igfs', 'aldist.igfs',
                                               'ldist.aut', 'aldist.aut'),
                                      comm=c('ldist.bmt', 'aldist.bmt')),
                        wgts='WGTS')

