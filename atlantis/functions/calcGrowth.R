# this is a source code file to compute growth parameters for use in formatting
# atlantis output
source('../functions/vbParams.R')

# calculate growth parameters
atl.sub <- 
    is_fg_count %>%
    filter(count >= 1)

# compute growth parameters using nlm on functions in vbParams.R
vbMin <- 
    atl.sub %>%
    mutate(age = age + 0.5) %>%
    group_by(year, month) %>%
    summarize(linf = nlm(vb.sse, c(100, 0.1, -1), length, age)$estimate[1],
              k = nlm(vb.sse, c(100, 0.1, -1), length, age)$estimate[2],
              t0 = nlm(vb.sse, c(100, 0.1, -1), length, age)$estimate[3])