library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(sind=c('igfs.si.2030', 'igfs.si.3040',
                                             'igfs.si.4055', 'aut.si.2030',
                                             'aut.si.3040', 'aut.si.4055'),
                                      survey=c('ldist.igfs', 'aldist.igfs',
                                               'ldist.aut', 'aldist.aut'),
                                      comm=c('ldist.bmt', 'aldist.bmt')),
                        wgts='WGTS')

