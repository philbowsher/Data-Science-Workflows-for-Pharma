#Just for loading data to DB
library(DBI)
library(odbc)
library(dplyr)
library(dbplyr)
con <- dbConnect(odbc(), "SQL Server")

flights <- readRDS("fligths1.Rds") %>%
  #filter_all(all_vars(!is.na(.))) %>%
  as.data.frame()

dbSendQuery(con, "truncate table indyflights") 
dbSendQuery(con, "drop table indyflights")

for(i in 0:as.integer(nrow(flights)/1000)){
  
  start <- (i * 1000) + 1
  stop <- (i * 1000) + 1000
  if(stop > nrow(flights)) stop <- nrow(flights)
  segment <- flights[start:stop, ]
  print(paste0("Inserting rows: ", start, " to ", stop))
  dbWriteTable(con, 
               "indyflights", 
               segment, 
               append = TRUE)

  print(tally(tbl(con, "indyflights")))
}


