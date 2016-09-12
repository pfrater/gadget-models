library(Rgadget)

# find some decent starting values for recl and stddev
mla <- mfdb_sample_meanlength_stddev(mdb, c('age'),
                                     c(list(sampling_type=c("IGFS","AUT"),
                                            age=1:10), #taken from fishbase
                                       defaults))
init.sigma <- 
    mla[[1]] %>% 
    na.omit() %>% 
    group_by(age) %>%
    summarize(ml=mean(mean), ms=mean(stddev, na.rm=T))

lw <- mfdb_sample_meanweight(mdb, c('length'),
                             c(list(sampling_type=c('IGFS','AUT'),
                                    species='CAP',
                                    length=mfdb_interval("", seq(0,25, by=1)))))

lw.tmp <-   
    lw[[1]] %>% 
    mutate(length=as.numeric(as.character(length)),
           weight=mean) %>%
    filter(as.numeric(length) >= 10) %>% #remove odball outlier
    na.omit() %>%
    nls(weight ~ a*length^b,.,start=list(a=0.25,b=1.32)) %>%
    coefficients() %>%
    as.numeric()

## populate the model with starting default values
opt <- gadget.options(type='simple1stock')

## adapt opt list to greater silver smelt
weight.alpha <- lw.tmp[1]
weight.beta <- lw.tmp[2]

opt$area$numofareas <- 1
opt$area$areasize <- cap.area$size
opt$area$area.temperature <- 3
opt$time$firstyear <- st.year
opt$time$lastyear <- end.year


## setting up just a single stock for now
opt$stocks$imm <- within(opt$stock$imm, {
    name <- 'capelin'
    minage <- 1
    maxage <- 5
    minlength <- 1
    maxlength <- 25
    dl <- 1
    growth <- c(linf='#cap.linf',
                k='#cap.k',
                beta='(* 10 #cap.bbin)',
                binn=20, recl='#cap.recl'
    )
    weight <- c(a=weight.alpha, b=weight.beta)
    init.abund <- sprintf('(* %s %s)',
                          c(0.1,0.05, 0.1,0.05,0.01),
                          sprintf('#cap.age%s',1:5))
    n <- sprintf('(* #cap.rec.mult #cap.rec%s)', st.year:end.year)
    doesmature <- 0
    #maturityfunction <- 'continuous'
    #maturestocksandratios <- 'cap.mat 1'
    #maturity.coefficients <- '( * 0.001 #cap.mat1) #cap.mat2 0 0'
    sigma <- init.sigma$ms
    M <- c('#cap.m1', '#cap.m2',  '#cap.m3',  '#cap.m4',  '#cap.m5')
    #M <- c(0.2,0.2,0.73,2.03,2.49) # taken from winters and campbell 1974
    #maturitysteps <- '0'
    doesmove <- 0
    #transitionstep <- 4
    #transitionstockandratios <- 'cap.mat 1'
    doesmigrate <- 0
    doesrenew <- 1
    renewal <- list(minlength=1, maxlength=12)
})


# ## set up immature stock
# opt$stocks$imm <- within(opt$stock$imm, {
#     name <- 'cap.imm'
#     minage <- 1
#     maxage <- 4
#     minlength <- 1
#     maxlength <- 20
#     dl <- 1
#     growth <- c(linf='#cap.linf', 
#                 k='#cap.k',
#                 beta='(* 10 #cap.bbin)', 
#                 binn=10, recl='#cap.recl'
#     )
#     weight <- c(a=weight.alpha, b=weight.beta)
#     init.abund <- sprintf('(* %s %s)', 
#                           c(0,0.1,0.05,0.01),
#                           c(0,sprintf('#cap.age%s',2:4)))
#     n <- sprintf('(* 1000 #cap.rec%s)', st.year:end.year)
#     doesmature <- 1
#     maturityfunction <- 'continuous'
#     maturestocksandratios <- 'cap.mat 1'
#     maturity.coefficients <- '( * 0.001 #cap.mat1) #cap.mat2 0 0'
#     sigma <- head(init.sigma$ms, 4)
#     M <- rep(0.2,4)
#     maturitysteps <- '0'
#     doesmove <- 0
#     transitionstep <- 4
#     transitionstockandratios <- 'cap.mat 1'
#     doesmigrate <- 0
#     doesrenew <- 1
#     renewal <- list(minlength=3, maxlength=15)
# })
# 
# ## set up mature stock
# opt$stocks$mat <- within(opt$stock$mat, {
#     name <- 'cap.mat'
#     minage <- 2
#     maxage <- 10 #maxage taken from fishbase
#     minlength <- 13.5
#     maxlength <- 25
#     dl <- 1
#     M <- rep(0.2, 9)
#     growth <- c(linf='#cap.linf', k='#cap.k',
#                 beta='(* 10 #cap.bbin)', 
#                 binn=10, recl='#cap.recl'
#     )
#     weight <- c(a=weight.alpha, b=weight.beta)
#     init.abund <- sprintf('(* %s %s)', c(0.08, 0.1, 0.1, 0.08, 0.06, 0.04, 0,0, 0),
#                           c(sprintf('#cap.age%s',2:10)))
#     sigma <- c(init.sigma$ms[2:10])
#     doesmature <- 0
#     doesmigrate <- 0
# })


# create gadget skeleton
gm <- gadget.skeleton(time=opt$time, area=opt$area,
                      stocks=opt$stocks, fleets=opt$fleets)

gm@stocks$imm@initialdata$area.factor <- '( * 1000 #cap.mult)'
#gm@stocks$mat@initialdata$area.factor <- '( * 1000 #cap.mult)'

gm@fleets <- list(comm.fleet, igfs.fleet, aut.fleet, aco.fleet)
gm@fleets[[2]]@suitability$params <- c("#igfs.p1 #igfs.p2 (- 1 #igfs.p1) #igfs.p4 #igfs.p5 100")
gm@fleets[[3]]@suitability$params <- c("#aut.p1 #aut.p2 (- 1 #aut.p1) #aut.p4 #aut.p5 100")
gm@fleets[[4]]@suitability$params <- c("0  1")

gd.list <- list(dir=gd$dir)
Rgadget:::gadget_dir_write(gd.list, gm)


curr.dir <- getwd()
setwd(gd$dir)
callGadget(s=1, log='logfile.txt', ignore.stderr=FALSE)

init.params <- read.gadget.parameters('params.out')


init.params[c('cap.linf', 'cap.k', 'cap.bbin', 'cap.mult', 'cap.rec.mult',
              grep('age', rownames(init.params), value=T)),] <-
    read.table(text='switch	 value 	   lower 	upper 	optimise
               cap.linf	         25	     20      30         1
               cap.k	         0.14  0.06      0.30       1
               cap.bbin	         6	   1e-08     100        1
               cap.mult	         100	 0.1     100        1
               cap.rec.mult     1000   1e-05     1e05       1
               cap.age1          50     0.01     200        1
               cap.age2	         35	    0.01     200        1
               cap.age3	         25	    0.01     120        1
               cap.age4	         15	   0.001     100        1
               cap.age5	          7	  0.0001     100        1',header=TRUE) 

init.params$switch <- rownames(init.params)

init.params[grepl('rec[0-9]',init.params$switch),'value'] <- 1
init.params[grepl('rec[0-9]',init.params$switch),'upper'] <- 100
init.params[grepl('rec[0-9]',init.params$switch),'lower'] <- 0.001
init.params[grepl('rec[0-9]',init.params$switch),'optimise'] <- 1

init.params['cap.recl',-1] <- c(8, 1, 12, 1)

init.params[grepl('alpha',init.params$switch),'value'] <- 0.5
init.params[grepl('alpha',init.params$switch),'upper'] <- 3
init.params[grepl('alpha',init.params$switch),'lower'] <- 0.01
init.params[grepl('alpha',init.params$switch),'optimise'] <- 1

init.params[grepl('l50',init.params$switch),'value'] <- 15
init.params[grepl('l50',init.params$switch),'upper'] <- 25
init.params[grepl('l50',init.params$switch),'lower'] <- 8
init.params[grepl('l50',init.params$switch),'optimise'] <- 1

init.params[init.params$switch=='igfs.p1',] <- c('igfs.p1', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='igfs.p2',] <- c('igfs.p2', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='igfs.p3',] <- c('igfs.p3', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='igfs.p4',] <- c('igfs.p4', 5, 0.1, 100, 1)
init.params[init.params$switch=='igfs.p5',] <- c('igfs.p5', 5, 0.1, 100, 1)

# init.params[init.params$switch=='aut.alpha',] <- c('aut.alpha', 20, 10, 60, 1)
# init.params[init.params$switch=='aut.beta',] <- c('aut.beta', 0.9, 0.001, 2, 1)
# #init.params[init.params$switch=='aut.gamma',] <- c('aut.gamma', 0.5, 0, 1, 1)
# #init.params[init.params$switch=='aut.delta',] <- c('aut.delta', 0.5, 0, 1, 1)

init.params[init.params$switch=='aut.p1',] <- c('aut.p1', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='aut.p2',] <- c('aut.p2', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='aut.p3',] <- c('aut.p3', 0.5, 0.01, 1, 1)
init.params[init.params$switch=='aut.p4',] <- c('aut.p4', 5, 0.1, 100, 1)
init.params[init.params$switch=='aut.p5',] <- c('aut.p5', 5, 0.1, 100, 1)

init.params[grepl('cap.m',init.params$switch),'value'] <- 0.5
init.params[grepl('cap.m',init.params$switch),'upper'] <- 3
init.params[grepl('cap.m',init.params$switch),'lower'] <- 0.1
init.params[grepl('cap.m',init.params$switch),'optimise'] <- 1


write.gadget.parameters(init.params,file='params.in')
setwd(curr.dir)
