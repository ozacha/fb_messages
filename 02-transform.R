library(lubridate)
library(data.table)

load("messages_dt.RData")

# to ensure the date parsing works
Sys.setlocale("LC_ALL", "English")
# strptime should theoretically work as well, unfortunately it does not
dt[, time := parse_date_time(gsub("(^[a-zA-Z]*, |at | UTC\\+0[12]*)", "", meta),
                             "B!d!Y!I!M!p!")]
# subtract 1 hour for summer time (UTC+02)
dt[substr(meta, nchar(meta), nchar(meta)) == "2", time := time - 3600]


# dt[, threadname := paste0(unique(ifelse(user %in% c("1445006818@facebook.com",
#                                                     "Ondrej Zacha",
#                                                     "Ondřej Zacha"),
#                                         "", user)), 
#                                  collapse = " "),
#                           by = thread]
dt[, threadname := paste0(unique(user), collapse = "\n"),
   by = thread]
dt[, threadname := gsub("(\\d*@facebook.com|Ond.ej Zacha)", 
                        "", threadname)]
dt[, threadname := gsub("\n\n*", 
                        "\n", threadname)]
# dt[, threadname := gsub("(1445006818@facebook.com|Ond.ej Zacha)", 
#                         "", threadname)]


dt[, thread2 := ifelse(.N > 1000L, thread, "others"), by = thread]
dt[, thread5000 := ifelse(.N > 5000L, thread, "others"), by = thread]

