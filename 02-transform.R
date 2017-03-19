load("messages_dt.RData")

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

# emoji -------------------------------------------------------------------

save(dt, file = "messages_dt_final.RData")
# ???



