library(dplyr)
library(tidyr)
library(fjolst)
library(fjolstTranslate)


## doing spring surveys first
stations <- 
    select(translate.stodvar(), sample.id, year, sampling.type) %>%
    filter(sampling.type %in% c(30, 35))

## import cod samples
ldist <- 
    translate.all.le() %>%
    filter(species.code == 1, sample.id %in% stations$sample.id) %>%
    left_join(stations)

# get lengths at age by year
aldist.by.year <- 
    translate.all.kv() %>%
    filter(species.code == 1, sample.id %in% stations$sample.id) %>%
    left_join(stations)

# compute overall lengths at age
aldist <- 
    aldist.by.year %>% group_by(age, length) %>%
    summarize(total = sum(number))

# get numbers at each age
n.by.age <- aldist %>% group_by(age) %>% summarize(total = sum(total))

# assemble data.frame used to calculate mean and sd
lengths.at.age <- data.frame(age=rep(n.by.age$age, n.by.age$total),
                  length=rep(aldist$length, aldist$total))
age.groups <- data.frame(age = 0:19,
                         age.group = sort(rep(seq(0,18, by=2), 2)))
lengths.at.age <- mutate(lengths.at.age, 
                         age.group = ifelse(age %% 2 == 0, age, age-1))

cod.length.mn.sd <- 
    lengths.at.age %>%
    group_by(age.group) %>%
    summarize(length.mean = mean(length), length.sd = sd(length)) %>%
    rename(age = age.group) %>% na.omit()