library(Rgadget)

# find some decent starting values for recl and stddev
mla <- mfdb_sample_meanlength_stddev(mdb, c('age'),
                                     c(list(sampling_type=c("SprSurvey","AutSurvey"),
                                            age=0:19),
                                       defaults))
init.sigma <- 
    mla[[1]] %>% 
    na.omit() %>% 
    group_by(age) %>%
    summarize(ml=mean(mean), ms=mean(stddev, na.rm=T))

lw <- mfdb_sample_meanweight(mdb, c('length'),
                            c(list(sampling_type=c('SprSurvey','AutSurvey'),
                                   species='COD',
                                   length=mfdb_interval("", seq(0,200, by=10)))))

lw.tmp <-   
    lw[[1]] %>% 
    mutate(length=as.numeric(as.character(length)),
           weight=mean/1e3) %>%
    na.omit() %>%
    nls(weight ~ a*length^b,.,start=list(a=1e-5,b=3)) %>%
    coefficients() %>%
    as.numeric()

## populate the model with starting default values
opt <- gadget.options(type='simple1stock')

## adapt opt list to greater silver smelt
weight.alpha <- lw.tmp[1]
weight.beta <- lw.tmp[2]

opt$area$numofareas <- 1
opt$area$areasize <- mfdb_area_size(mdb, defaults)[[1]]$size
opt$area$area.temperature <- 3
opt$time$firstyear <- st.year
opt$time$lastyear <- end.year

## setup M and determine initial abundance
nat.mort <- 0.2
rc <- 19

## set up the one stock stock
opt$stocks$imm <- within(opt$stock$imm, {
    name <- 'cod'
    minage <- 1
    maxage <- 19
    minlength <- 1
    maxlength <- 200
    dl <- 1
    growth <- c(linf='#cod.linf', 
                k='#cod.k',
                beta='(* 10 #cod.bbin)', 
                binn=15, recl='#cod.recl'
    )
    weight <- c(a=weight.alpha, b=weight.beta)
    init.abund <- sprintf('#cod.age%s', 1:rc)
    n <- sprintf('(* #cod.rec.mult  #cod.rec%s)', st.year:end.year)
    doesmature <- 0
    sigma <- sort(c(init.sigma$ms, init.sigma$ms[1:9]))
    M <- rep(nat.mort, rc)
    doesmove <- 0
    doesmigrate <- 0
    doesrenew <- 1
    renewal <- list(minlength=1, maxlength=33)
})


# create gadget skeleton
gm <- gadget.skeleton(time=opt$time, area=opt$area,
                      stocks=opt$stocks, fleets=opt$fleets)

gm@stocks$imm@renewal.data$stddev <- '#cod.rec.sd'

gm@stocks$imm@initialdata$area.factor <- '( * #cod.mult #cod.init.abund)'

gm@fleets <- list(bmt.fleet, igfs.fleet, aut.fleet)
gm@fleets[[2]]@suitability$params <- c("(* #igfs.alpha (* -1 #igfs.beta)) #igfs.beta 0 1")
gm@fleets[[3]]@suitability$params <- c("(* #aut.alpha (* -1 #aut.beta)) #aut.beta 0 1")

#gm@fleets[[2]]@suitability$params <- c("#igfs.p1 #igfs.p2 (- 1 #igfs.p1) #igfs.p4 #igfs.p5 100")

gd.list <- list(dir=gd$dir)
Rgadget:::gadget_dir_write(gd.list, gm)

curr.dir <- getwd()
setwd(gd$dir)
# run the next line to create params.out, but much faster to do it in terminal
#callGadget(s=1, log='logfile.txt', ignore.stderr=FALSE)

init.params <- read.gadget.parameters('params.out')


rn <- rownames(init.params)
init.params[grep('linf', rn), ] <- c('cod.linf', 170, 150, 250, 1)
init.params[grep('k', rn), ] <- c('cod.k', 0.2, 0.01, 0.30, 1)
init.params[grep('bbin', rn), ] <- c('cod.bbin', 6, 1e-08, 100, 1)
init.params[grep('mult', rn), ][1,] <- c('cod.mult', 100, 1e-05, 1e+05, 1)
init.params[grep('init.abund', rn), ] <- c('cod.init.abund', 100, 0.1, 100, 1)
init.params[grep('rec.sd', rn), ] <- c('cod.rec.sd', 2, 0.1, 10, 1)
init.params[grep('rec.mult', rn), ] <- c('cod.rec.mult', 100, 1e-05, 1e+05, 1)
init.params[grep('age', rn), ] <- data.frame(switch=sprintf('cod.age%s', 1:rc),
                                             value=rep(100, rc), lower=rep(1e-05, rc),
                                             upper=rep(1e+05, rc), optimise=rep(1, rc))
init.params$switch <- rownames(init.params)

init.params[grepl('rec[0-9]',init.params$switch),'value'] <- 1
init.params[grepl('rec[0-9]',init.params$switch),'upper'] <- 100
init.params[grepl('rec[0-9]',init.params$switch),'lower'] <- 0.001
init.params[grepl('rec[0-9]',init.params$switch),'optimise'] <- 1

init.params['cod.recl',-1] <- c(20, 5, 40,1)

init.params[grepl('alpha',init.params$switch),'value'] <- 0.5
init.params[grepl('alpha',init.params$switch),'upper'] <- 5
init.params[grepl('alpha',init.params$switch),'lower'] <- 0.01
init.params[grepl('alpha',init.params$switch),'optimise'] <- 1

init.params[grepl('l50',init.params$switch),'value'] <- 50
init.params[grepl('l50',init.params$switch),'upper'] <- 200
init.params[grepl('l50',init.params$switch),'lower'] <- 10
init.params[grepl('l50',init.params$switch),'optimise'] <- 1

init.params[init.params$switch=='igfs.alpha',] <- c('igfs.alpha', 40, 1, 200, 1)
init.params[init.params$switch=='igfs.beta',] <- c('igfs.beta', 0.9, 0.06, 5, 1)
# #init.params[init.params$switch=='igfs.gamma',] <- c('igfs.gamma', 0.5, 0, 1, 1)
# #init.params[init.params$switch=='igfs.delta',] <- c('igfs.delta', 0.5, 0, 1, 1)

init.params[init.params$switch=='aut.alpha',] <- c('aut.alpha', 40, 1, 200, 1)
init.params[init.params$switch=='aut.beta',] <- c('aut.beta', 0.9, 0.06, 5, 1)
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


write.gadget.parameters(init.params,file='params.in')
setwd(curr.dir)
