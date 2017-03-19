wa_files <- list.files("data", pattern = "WhatsApp Chat with .*\\.txt")
wa_dt <- data.table()

for (wa_file in wa_files) {
  thread_name <- str_replace_all(wa_file, "(^WhatsApp Chat with |\\.txt$)", "")

  wa <- data.table(meta = readLines(paste0("data/", wa_file),
                                    encoding = "UTF-8")) 
  wa[, id := cumsum(str_detect(meta, "^\\d+/\\d+/\\d+, \\d+:\\d+"))]
  wa <- wa[, .(meta = paste0(meta, collapse = " ")), by = id]
  wa[, timestamp := str_sub(meta, 1L, str_locate(meta, "\\d - ")[,1])]
  wa[, user := str_sub(meta, 
                       str_locate(meta, "\\d - ")[,2],
                       str_locate(meta, ": ")[,1] - 1)]
  wa[, message := ifelse(is.na(user),
                         str_sub(meta, 
                                 str_locate(meta, "\\d - ")[,2], -1L),
                         str_sub(meta, 
                                 str_locate(meta, ": ")[,2], -1L))]
    wa[, thread := paste0("wa_", thread_name)]
  wa[, threadname := thread_name]
  wa[, time := parse_date_time(timestamp, "m!d!y!H!M!", locale = "English")]
  wa[, meta := NULL]
  wa[, timestamp := NULL]
  setcolorder(wa, c("thread", "threadname", "id", "time", "user", "message"))
  
  wa_dt <- rbindlist(list(wa_dt, wa))
  
}
