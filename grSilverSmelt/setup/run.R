library(Rgadget)
setwd('~/gadget/gadget-models/grSilverSmelt/gssModel')
tmp <- gadget.iterative(rew.sI=TRUE,
                        main='main',
                        grouping=list(sind=c('si.1525', 'si.2540','si.4055'),
                                      survey=c('ldist.igfs', 'aldist.igfs'),
                                      comm=c('ldist.bmt', 'aldist.bmt',
                                             'ldist.pgt', 'aldist.pgt', 
                                             'ldist.other', 'aldist.other')),
                        wgts='WGTS')

