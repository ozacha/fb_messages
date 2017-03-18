library(lubridate)
library(stringr)
library(data.table)

load("messages_dt.RData")

dt[, id := .N:1L, by = thread]  # add index for ordering (minutes are not enough)
# setkey(dt, thread, id)

# time --------------------------------------------------------------------
dt[, time := parse_date_time(gsub("(^[a-zA-Z]*, |at | UTC\\+0[12]*)", "", meta),
                             "B!d!Y!I!M!p!", locale = "English")]
# subtract 1 hour for summer time (UTC+02)
dt[str_sub(meta, -1L, -1L) == "2", time := time - 3600]
dt[, meta := NULL]


# thread info -------------------------------------------------------------
dt[, threadname := paste0(unique(user), collapse = "\n"),
   by = thread]
dt[, threadname := gsub(paste0("(\\d*@facebook.com|", name_regex, ")"), 
                        "", threadname)]
dt[, threadname := gsub("\n(\n)*", "\n", threadname)]
dt[, threadname := gsub("(^\n|\n$)", "", threadname)]
# dt[str_count(threadname, "\n") > 3, 
#    threadname := str_sub(threadname, 1L, 30L)]

dt[, thread := gsub("@facebook.com", "", thread)]
dt[, thread := paste0("fb_", thread)]

setcolorder(dt, c("thread", "threadname", "id", "time", "user", "message"))

dt <- rbindlist(list(dt, wa_dt))

# for filtering -----------------------------------------------------------
dt[, realday := as.Date(time - 3600 * 6)]  # because it's not tomorrow yet if i don't go to sleep


dt[, plus1000 := .N > 1000L, by = thread]  # 43 threads
dt[, plus5000 := .N > 5000L, by = thread]  # 15 threads
dt[, by_me := grepl(paste0("(", fb_id, "@facebook.com|", name_regex, ")"), user)]


# response delay ----------------------------------------------------------
setkey(dt, thread, time, id)
dt[, response_delay := ifelse(user != shift(user) & time > min(time),
                              difftime(time, shift(time), units = "min"),
                              NA_real_),
   by = .(thread, realday)]  # or just thread (doesn't exclude first message each day)
# dt[by_me == T & !(is.na(response_delay)), response_delay := -response_delay]
# ???


# emoji -------------------------------------------------------------------

# ???



