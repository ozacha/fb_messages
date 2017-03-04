library(data.table)
library(XML)
library(rvest)

HTM <- read_html("E:\\Users\\Ondra\\Documents\\facebook-ozacha\\html\\messages.htm",
                 encoding = "UTF-8")
message_divs <- html_nodes(HTM, xpath = "//div[@class='message']")
thread_divs <- html_nodes(HTM, xpath = "//div[@class='thread']")
users <- html_nodes(message_divs[[1]], xpath = "//span[@class='user']")
metas <- html_nodes(message_divs[[1]], xpath = "//span[@class='meta']")
message_ps <- html_nodes(HTM, xpath = "//p")


thread_text <- html_text(thread_divs)
users_text <- html_text(users)
metas_text <- html_text(metas)
message_texts <- html_text(message_ps)

dt <- data.table(meta = metas_text,
                 user = users_text,
                 message = message_texts)
save(dt, file = "messages_dt.RData")



