
library(ff)
library(tidyverse)

#note: sometimes you may get errors that sounds like "NAs produced by integer overflow" this may not be due to actual NAs, etc. it may be due to R's limit in the number of integers it can hold, can try library(bit64)... 

#template to read in things in chunks, process them, then combine them:

#function to use over and over:
make_smaller <- function(table)
{
#convert to a tibble format
table<-as_tibble(table)
names(table) <- c('EXAMPLE')
#use group by and summarize functions, or whatever you like, to make smaller...
table <- table %>%
  group_by_at(vars(-'chr')) %>%
  summarize('chr' = toString(unique(chr)), 'total_chrs_hit' = n_distinct('chr'), 'guideHits' = n()) %>%
  ungroup()
}

#read in your large file in smaller chunks, process it with your function, then combine it after
#there are many ways to do chuncked reads, ff package is just one way

table_1 <- make_smaller(
read.table.ffdf(x = NULL,<yourfile>,,VERBOSE = TRUE, nrows=1000000000, skip=0, next.rows = 5000000)
)

#perform for table_2, 3... by changing skip value... (make sure you don't overlap)
#this would be skip and n_max in readr
#nrows=100, skip=0,   next.rows = 100
#nrows=100, skip=100, next.rows = 100
#nrows=100, skip=100, next.rows = 100
