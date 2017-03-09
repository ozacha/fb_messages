library(lubridate)
library(data.table)

load("messages_dt.RData")


# time --------------------------------------------------------------------
# to ensure the date parsing works
Sys.setlocale("LC_ALL", "English")
# strptime should theoretically work as well, unfortunately it does not
dt[, time := parse_date_time(gsub("(^[a-zA-Z]*, |at | UTC\\+0[12]*)", "", meta),
                             "B!d!Y!I!M!p!")]
# subtract 1 hour for summer time (UTC+02)
dt[substr(meta, nchar(meta), nchar(meta)) == "2", time := time - 3600]
dt[, meta := NULL]

dt[, realday := as.Date(time - 3600 * 6)]  # because it's not tomorrow yet if i don't go to sleep


# thread info -------------------------------------------------------------
dt[, threadname := paste0(unique(user), collapse = "\n"),
   by = thread]
dt[, threadname := gsub("(\\d*@facebook.com|Ond.ej Zacha)", 
                        "", threadname)]
dt[, threadname := gsub("\n\n*", "\n", threadname)]
dt[, threadname := gsub("(^\n|\n$)", "", threadname)]

dt[, thread := gsub("@facebook.com", "", thread)]

# for filtering -----------------------------------------------------------
dt[, plus1000 := .N > 1000L, by = thread]  # 43 threads
dt[, plus5000 := .N > 5000L, by = thread]  # 15 threads
dt[, by_me := grepl("(1445006818@facebook.com|Ond.ej.Zacha)", user)]

# dt[, group_chat := sapply(thread, function(x) length(gregexpr(",", x)[[1]])) > 1]


# emoji -------------------------------------------------------------------

# ???



