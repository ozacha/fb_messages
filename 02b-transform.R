library(lubridate)
library(stringr)
library(data.table)

load("messages_dt.RData")

dt[, id := .N:1L, by = thread]  # add index for ordering (minutes are not enough)
# setkey(dt, thread, id)

# time --------------------------------------------------------------------
# # to ensure the date parsing works
# Sys.setlocale("LC_ALL", "English")  # probably not needed anymore
# strptime should theoretically work as well, unfortunately it does not
dt[, time := parse_date_time(gsub("(^[a-zA-Z]*, |at | UTC\\+0[12]*)", "", meta),
                             "B!d!Y!I!M!p!", locale = "English")]
# subtract 1 hour for summer time (UTC+02)
dt[str_sub(meta, -1L, -1L) == "2", time := time - 3600]
dt[, meta := NULL]

dt[, realday := as.Date(time - 3600 * 6)]  # because it's not tomorrow yet if i don't go to sleep


# thread info -------------------------------------------------------------
dt[, threadname := paste0(unique(user), collapse = "\n"),
   by = thread]
dt[, threadname := str_replace(threadname, 
                               "(\\d*@facebook.com|Ond.ej Zacha)", "")]
dt[, threadname := str_replace(threadname, "\n\n*", "\n")]
dt[, threadname := str_replace(threadname, "(^\n|\n$)", "")]
dt[str_count(threadname, "\n") > 3, 
   threadname := str_sub(threadname, 1L, 30L)]
# threadname := str_replace(threadname, "((.*\n){3}).*", "\\1")]

dt[, thread := str_replace(thread, "@facebook.com", "")]

# for filtering -----------------------------------------------------------
dt[, plus1000 := .N > 1000L, by = thread]  # 43 threads
dt[, plus5000 := .N > 5000L, by = thread]  # 15 threads
dt[, by_me := str_detect(user, "(1445006818@facebook.com|Ond.ej.Zacha)")]
