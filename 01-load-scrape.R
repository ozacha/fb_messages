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
