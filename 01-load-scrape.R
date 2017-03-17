library(data.table)
library(rvest)
library(magrittr)

HTM <- read_html("data/messages.htm", encoding = "UTF-8")

thread_divs <- html_nodes(HTM, "div.thread")
thread_text <- html_text(thread_divs)

thread_names <- gsub("(^\\d*@facebook.com), 1445006818@facebook.com.*", "\\1", thread_text)
# thread_names <- gsub("(^\\d*@facebook.com, \\d*@facebook.com).*", "\\1", thread_text)
thread_lengths <- unlist(lapply(thread_divs, function(x) length(html_nodes(x, "span.user"))))

thread_names_full <- rep(thread_names, thread_lengths)


users <- html_nodes(thread_divs, "span.user") %>% html_text()
metas <- html_nodes(thread_divs, "span.meta") %>% html_text()
texts <- html_nodes(thread_divs, "p") %>% html_text()


dt <- data.table(thread = thread_names_full,
                 meta = metas,
                 user = users,
                 message = texts)

# save(dt, file = "messages_dt.RData")


# ---------------------------------

library(stringr)
wa <- data.table(meta = readLines("data/WhatsApp Chat with COOL KIDS.txt")) #, encoding = "Unicode")
wa[, messageid := cumsum(str_detect(meta, "^\\d+/\\d+/\\d+, \\d+:\\d+"))]
wa <- wa[, .(meta = paste0(meta, collapse = " ")), by = messageid]
wa[, timestamp := str_sub(meta, 1L, str_locate(meta, "\\d - ")[,1])]
wa[, user := str_sub(meta, 
                     str_locate(meta, "\\d - ")[,2],
                     str_locate(meta, ": ")[,1] - 1)]
wa[, message := ifelse(is.na(user),
                       str_sub(meta, 
                               str_locate(meta, "\\d - ")[,2], -1L),
                       str_sub(meta, 
                               str_locate(meta, ": ")[,2], -1L))]
wa[, meta := NULL]
