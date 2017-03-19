HTM <- read_html("data/messages.htm", encoding = "UTF-8")

thread_divs <- html_nodes(HTM, "div.thread")
thread_text <- html_text(thread_divs)

thread_names <- gsub("(^\\d+@facebook\\.com(, \\d+@facebook\\.com)+).*$", 
                     "\\1",
                     thread_text)
thread_lengths <- unlist(lapply(thread_divs, 
                                function(x) length(html_nodes(x, "span.user"))))

thread_names_full <- rep(thread_names, thread_lengths)


users <- html_nodes(thread_divs, "span.user") %>% html_text()
metas <- html_nodes(thread_divs, "span.meta") %>% html_text()
texts <- html_nodes(thread_divs, "p") %>% html_text()


dt <- data.table(thread = thread_names_full,
                 meta = metas,
                 user = users,
                 message = texts)


# ---------------
# add index for ordering 
# (minutes are not enough but messages are sorted from the newest)
dt[, id := .N:1L, by = thread]  

# time --------------------------------------------------------------------
dt[, time := parse_date_time(str_replace_all(meta, 
                                             "(^[a-zA-Z]*, |at | UTC\\+0[12]*)",
                                             ""),
                             "B!d!Y!I!M!p!", locale = "English")]
# subtract 1 hour for summer time (UTC+02)
dt[str_sub(meta, -1L, -1L) == "2", time := time - 3600]
dt[, meta := NULL]


# thread info -------------------------------------------------------------
dt[, threadname := paste0(unique(user), collapse = "\n"),
   by = thread]
dt[, threadname := gsub(paste0("(\\d*@facebook.com|", name_regex, ")"), 
                        "", threadname)]
dt[, threadname := gsub("\n(\n)+", "\n", threadname)]
dt[, threadname := gsub("(^\n|\n$)", "", threadname)]
dt[str_count(threadname, "\n") > 3,
   threadname := paste0(str_replace(threadname, 
                                    "(^(.+\\n){3})[\\s\\S]+", "\\1"),
                        "...")]

dt[, thread := gsub("@facebook.com", "", thread)]
dt[, thread := paste0("fb_", thread)]

setcolorder(dt, c("thread", "threadname", "id", "time", "user", "message"))


save(dt, file = "messages_dt.RData")
