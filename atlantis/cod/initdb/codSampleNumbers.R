library(dplyr)
library(tidyr)
library(ggplot2)
library(fjolst)
#devtools::install_github('pfrater/fjolstTranslate')
library(fjolstTranslate)



## doing spring surveys first
stations <- 
    select(translate.stodvar(), sample.id, year, sampling.type) %>%
    filter(sampling.type %in% c(30, 35))

## import number of length samples
nlengths <- 
    translate.all.le() %>%
    filter(species.code == 1, sample.id %in% stations$sample.id) %>%
    left_join(stations) %>%
    group_by(year) %>%
    summarize(nLengths = sum(count))


# get lengths at age by year
nages <- 
    translate.all.kv() %>%
    filter(species.code == 1, sample.id %in% stations$sample.id, !is.na(age)) %>%
    left_join(stations) %>%
    group_by(year) %>%
    summarize(nAges = n())


# get total survey numbers
survey.numbers <- 
    translate.all.nu() %>%
    filter(species.code == 1 & sample.id %in% stations$sample.id) %>%
    left_join(stations) %>%
    mutate(count = ifelse(number.counted == 1 & number.measured == 0, 
                          0,
                          number.counted + number.measured)) %>%
    group_by(year) %>%
    summarize(Total = sum(count, na.rm=T))

# join together and gather for plotting
surveys <- 
    left_join(survey.numbers, nlengths) %>% 
    left_join(nages) %>%
    mutate(length.prop = nLengths / Total,
           age.prop = nAges / Total)

survey.plot.data <- gather(surveys, key=Data, value=value, Total:nAges)
survey.plot.data$Data <- ordered(survey.plot.data$Data, 
                                 levels = c('Total', 'nLengths', 'nAges'))

g <- ggplot(data=survey.plot.data, aes(x=year, y=value, linetype=Data, color=Data)) + geom_line() +
    theme_bw() + xlab('Year') + ylab('Number of Samples')

