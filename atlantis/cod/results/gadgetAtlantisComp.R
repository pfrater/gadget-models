library(tidyr)
library(mfdb)
library(mfdbatlantis)
library(utils)
library(magrittr)
setwd('~/gadget/models/atlantis')
is_dir <- atlantis_directory('~/Dropbox/Paul_IA/OutM57BioV225FMV88_PF')

is_run_options <- atlantis_run_options(is_dir)

# Read in areas / surface temperatures, insert into mfdb
is_area_data <- atlantis_read_areas(is_dir)
is_temp <- atlantis_temperature(is_dir, is_area_data)

# Read in all functional groups, assign MFDB shortcodes where possible
is_functional_groups <- atlantis_functional_groups(is_dir)
is_functional_groups$MfdbCode <- vapply(
    mfdb_find_species(is_functional_groups$LongName)['name',],
    function (x) if (length(x) > 0) x[[1]] else as.character(NA), "")

# assemble and import cod 
fgName <- 'Cod'
fg_group <- is_functional_groups[c(is_functional_groups$Name == fgName),]
is_fg_count <- atlantis_fg_tracer(is_dir, is_area_data, fg_group)


# compare biomass by year in gadget to atlantis
atl.biomass <- 
    read.table('~/Dropbox/Paul_IA/OutM57BioV225FMV88_PF/OutBiomIndx.txt', 
                          header=T) %>%
    mutate(year = 1948:2013) %>%
    select(year, starts_with(fg_group$GroupCode)) %>%
    mutate(atl.biomass = FCD*1000)

# plot gadget biomass against atlantis
gad.biomass <- 
    fit$res.by.year %>%
    group_by(year) %>%
    summarize(total.biomass = sum(total.biomass))

atl.gad.biomass <- 
    left_join(gad.biomass, atl.biomass) %>%
    mutate(scale.diff = total.biomass / atl.biomass)

atl.gad.plot <- 
    ggplot(data=atl.gad.biomass, aes(x=atl.biomass, y=total.biomass)) + geom_point() +
    geom_abline(intercept=0, slope=1) + theme_bw() + 
    xlab('Atlantis Annual Biomass') + ylab('Gadget Annual Biomass')

biomass.comp.plot <-
    ggplot(data=atl.gad.biomass, aes(x=year)) + 
    geom_line(aes(y=total.biomass/1e3, color='Gadget')) +
    geom_line(aes(y=atl.biomass/1e3, color='Atlantis')) + 
    scale_color_manual('', breaks=c('Gadget', 'Atlantis'), values=c('red', 'black')) +
    theme_bw() + xlab('Year') + ylab('Biomass (tons)')

bm.scale.diff.plot <- 
    ggplot(data=atl.gad.biomass, aes(x=year, y=scale.diff)) + 
    geom_line() + geom_hline(yintercept = 1, linetype='dashed') + 
    ylim(0,pmax(1.5, max(atl.gad.biomass$scale.diff, na.rm=T))) +
    theme_bw() + xlab('Year') + ylab('Relative difference in biomass')

#######################################
## to check numbers instead of biomass
#######################################
cod.numbers <- 
    is_fg_count %>% 
    filter(month == 2) %>%
    group_by(year) %>% 
    summarize(atl.number = sum(count))
gad.numbers <- 
    fit$res.by.year %>%
    group_by(year) %>%
    summarize(total.number = sum(total.number))
atl.gad.numbers <- 
    left_join(gad.numbers, cod.numbers) %>%
    mutate(scale.diff = total.number / atl.number)

numbers.comp.plot <- 
    ggplot(data=filter(atl.gad.numbers, year < 2013), aes(x=year)) + 
    geom_line(aes(y=total.number/1e6, color='Gadget')) +
    geom_line(aes(y=atl.number/1e6, color='Atlantis')) +
    scale_color_manual('', breaks=c('Gadget', 'Atlantis'), values=c('red', 'black')) +
    theme_bw() + xlab('Year') + ylab('Numbers (millions of fish)')

nmb.scale.diff.plot <- 
    ggplot(data=atl.gad.numbers, aes(x=year, y=scale.diff)) + geom_line() +
    geom_hline(yintercept = 1, linetype='dashed') +
    ylim(0,pmax(1.5, max(atl.gad.numbers$scale.diff, na.rm=T))) +
    theme_bw() + xlab('Year') + ylab('Relative difference in numbers')


#######################################
## check landings
#######################################
atl.landings <- 
    read.table('~/Dropbox/Paul_IA/OutM57BioV225FMV88_PF/OutCatch.txt', 
               header=T) %>%
    mutate(year = 1948:2012) %>%
    select(year, starts_with(fg_group$GroupCode))

atl.catch.plot <- catch.plot + geom_line(data=atl.landings, aes(x=year, y=FCD))


#######################################
## check numbers by age
#######################################
age.numbers <- 
    fit$stock.std %>%
    filter(step == 4) %>%
    mutate(age = age - (age %% 2)) %>%
    group_by(year, age) %>%
    summarize(total = sum(number))

atl.age.numbers <- 
    is_fg_count %>%
    filter(month == 10, count >= 1) %>%
    group_by(year, age) %>%
    summarize(total = sum(count))

age.numbers.plot <-
    ggplot(data=filter(age.numbers, year < 2013), 
           aes(x=year, y=total/1e6, color='Gadget')) + geom_line() + 
    geom_line(data=filter(atl.age.numbers, year < 2013), 
              aes(x=year, y=total/1e6, color='Atlantis')) + 
    facet_wrap(~age, scales='free_y') + 
    scale_color_manual('', breaks=c('Gadget', 'Atlantis'), 
                       values=c('red', 'black')) +
    theme_bw() + xlab('Year') + ylab('Numbers (millions of fish)')

#######################################
## check growth
#######################################
cod.growth <- 
    is_fg_count %>%
    filter(count > 0) %>%
    sample_n(10000)

gr.check <- 
    ggplot(data=cod.growth, aes(x=age, y=length)) + geom_point() +
    geom_line(data=fit$stock.growth, aes(x=age, y=length)) +
    theme_bw()


#######################################
# compare gadget initial values to 
# atlantis initial values
#######################################
gad.init.year <- min(fit$stock.std$year)
atl.init <- 
    is_fg_count %>%
    filter(year == gad.init.year,
           month == min(month),
           count >= 1) %>%
    group_by(age) %>%
    summarize(atl.init = sum(count))

gad.init <- 
    fit$stock.std %>%
    filter(year == min(year)) %>%
    mutate(age = age - (age %% 2)) %>%
    group_by(age) %>% 
    summarize(gad.init = sum(number))

gad.atl.init.plot <- 
    ggplot(data=gad.init, aes(x=age, y=gad.init)) + 
    geom_bar(stat='identity') + 
    geom_line(data=atl.init, aes(x=age, y=atl.init))