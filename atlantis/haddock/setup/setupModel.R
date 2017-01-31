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
                                   species='HAD',
                                   length=mfdb_interval("", seq(0,120, by=1)))))

lw.tmp <-   
    lw[[1]] %>% 
    mutate(length=as.numeric(as.character(length)),
           weight=mean/1e3) %>%
    na.omit() %>%
    nls(weight ~ a*length^b,.,start=list(a=0.1,b=3)) %>%
    coefficients() %>%
    as.numeric()

## populate the model with starting default values
opt <- gadget.options(type='simple1stock')

## adapt opt list to greater silver smelt
weight.alpha <- 0.00000587903
weight.beta <- 3.116172

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
    name <- 'had'
    minage <- 1
    maxage <- 19
    minlength <- 1
    maxlength <- 120
    dl <- 1
    growth <- c(linf='#had.linf', 
                k='#had.k',
                beta='(* 10 #had.bbin)', 
                binn=15, recl='#had.recl'
    )
    weight <- c(a=weight.alpha, b=weight.beta)
    init.abund <- sprintf('#had.age%s', 1:rc)
    n <- sprintf('(* #had.rec.mult  #had.rec%s)', st.year:end.year)
    doesmature <- 0
    sigma <- c(init.sigma$ms, rep(init.sigma$ms[6], 13))
    M <- rep('#had.mort', rc)
    doesmove <- 0
    doesmigrate <- 0
    doesrenew <- 1
    renewal <- list(minlength=1, maxlength=33)
})


# create gadget skeleton
gm <- gadget.skeleton(time=opt$time, area=opt$area,
                      stocks=opt$stocks, fleets=opt$fleets)

gm@stocks$imm@renewal.data$stddev <- '#had.rec.sd'

gm@stocks$imm@initialdata$area.factor <- '( * #had.mult #had.init.abund)'

gm@fleets <- list(lln.fleet, igfs.fleet, aut.fleet)
gm@fleets[[2]]@suitability$params <- c("#igfs.alpha #igfs.l50")
gm@fleets[[3]]@suitability$params <- c("#aut.alpha #aut.l50")

# gm@fleets[[1]]@suitability$params <- c('0.066  70')
# gm@fleets[[2]]@suitability$params <- c('0.046 49')
# gm@fleets[[3]]@suitability$params <- c('0.046 49')


#gm@fleets[[2]]@suitability$params <- c("(* #igfs.alpha (* -1 #igfs.beta)) #igfs.beta 0 1")
#gm@fleets[[3]]@suitability$params <- c("(* #aut.alpha (* -1 #aut.beta)) #aut.beta 0 1")

#gm@fleets[[2]]@suitability$params <- c("#igfs.p1 #igfs.p2 (- 1 #igfs.p1) #igfs.p4 #igfs.p5 100")

gd.list <- list(dir=gd$dir)
Rgadget:::gadget_dir_write(gd.list, gm)