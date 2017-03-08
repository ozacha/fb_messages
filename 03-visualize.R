library(ggplot2)

ggplot(dt[plus5000 == T, 
          .(.N, date = as.Date(min(time))), 
          by = .(year(time), 
                 week(time), 
                 threadname)],
       aes(x = date, y = N, color = threadname, fill = threadname)) +
  geom_bar(stat = "identity", position = "stack") +
  # scale_color_discrete(guide = FALSE) + 
  theme(legend.text = element_text(size = 6),
        legend.key.size = unit(2, "mm"),
        legend.spacing = unit(1, "mm"))

ggplot(dt[plus5000 == T, 
          .(.N, date = as.Date(min(time))), 
          by = .(year(time), 
                 week(time), 
                 threadname)],
       aes(x = date, y = N, color = threadname, fill = threadname)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_color_discrete(guide = FALSE) + 
  scale_fill_discrete(guide = FALSE) + 
  facet_wrap(~threadname, scales = "free_y")

ggplot(dt[plus5000 == T & hour(time) %between% list(0, 5) & time > '2012-01-01', 
          .(.N, date = as.Date(min(time))), 
          by = .(year(time), 
                 week(time), 
                 threadname)],
       aes(x = date, y = N, color = threadname, fill = threadname)) +
  geom_bar(stat = "identity", position = "stack") +
  # scale_color_discrete(guide = FALSE) + 
  theme(legend.text = element_text(size = 6),
        legend.key.size = unit(2, "mm"),
        legend.spacing = unit(1, "mm"))

# message length distribution
ggplot(dt[nchar(message) < 40000],
       aes(x = nchar(message))) +
  geom_histogram(bins = 100) +
  scale_x_sqrt(breaks = c(10, 20, 50, 100, 500, 1000), labels = scales::comma) +
  xlim(0, 1000)

# messages distribution by time
ggplot(dt[plus5000 == T],
       aes(x = hour(time), fill = threadname)) +
  geom_histogram(bins = 24) +
  facet_wrap(~threadname, scales = "free_y")

# last message before going to bed
ggplot(dt[by_me == T,
          .(lastmessage = max(difftime(time, as.POSIXct(realday), units = "hours"))), 
          by = realday],
       aes(x = realday, y = lastmessage)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 24) +
  scale_y_continuous(labels = function(x) paste0(x %% 24, ":00"))
