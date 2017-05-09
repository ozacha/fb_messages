library(data.table)
library(rvest)
library(magrittr)
library(lubridate)
library(stringr)
library(ggplot2)
library(knitr)

fb_id <- "1445006818"
name_regex <- "(Ond.ej Zacha|Ond.ej)"

source("01-load-scrape.R")
source("01b-whatsapp-import.R")
source("02-transform.R")
# source("03-visualize.R")

rmarkdown::render("output/report.Rmd")
if (interactive()) browseURL("output/report.html")
