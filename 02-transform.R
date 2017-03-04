library(lubridate)
library(ggplot2)

load("messages_dt.RData")

Sys.setlocale("LC_ALL", "English")
dt[, time := parse_date_time(gsub("(^[a-zA-Z]*, |at | UTC\\+0[12]*)", "", meta),
                             "B!d!Y!I!M!p!")]
dt[substr(meta, nchar(meta), nchar(meta)) == "2", time := time - 3600]

ggplot(dt[, .N, by = .(date = as.Date(time))],
       aes(x = date, y = N)) +
  geom_bar(stat = "identity")
