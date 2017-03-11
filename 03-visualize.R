library(ggplot2)

# total messages by week
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

# messages by week & thread
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

# after midnight
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
  scale_x_sqrt(breaks = c(10, 20, 50, 100, 500, 1000), 
               labels = scales::comma, 
               limits = c(0, 1000))

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

# proportion of messages written by me
ggplot(dt[plus1000 == T],
       aes(x = threadname, fill = by_me)) +
  geom_bar(position = "fill", stat = "count") +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  theme(axis.text = element_text(size = 7, angle = 65, hjust = 1))

# ... in time (not that relevant)
ggplot(dt[plus5000 == T],
       aes(x = year(time), fill = by_me)) +
  geom_bar(position = "fill", stat = "count") +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  theme(axis.text = element_text(size = 7, angle = 65, hjust = 1)) +
  facet_wrap(~threadname)

# who usually writes the first message
ggplot(dt[plus5000 == T,
          .(by_me = .SD[id == min(id), by_me]),
          by = .(threadname, realday)],
       aes(x = threadname, fill = by_me)) +
  geom_bar(position = "fill", stat = "count") +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  theme(axis.text = element_text(size = 7, angle = 65, hjust = 1))

# ...in time
ggplot(dt[plus5000 == T,
          .(by_me = .SD[id == min(id), by_me]),
          by = .(threadname, realday)],
       aes(x = year(realday), fill = by_me)) +
  geom_bar(position = "fill", stat = "count") +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  theme(axis.text = element_text(size = 7, angle = 65, hjust = 1)) +
  facet_wrap(~threadname) +
  ggtitle("Who messages first?")

# last message?
ggplot(dt[plus5000 == T,
          .(by_me = .SD[id == max(id), by_me]),
          by = .(threadname, realday)],
       aes(x = year(realday), fill = by_me)) +
  geom_bar(position = "fill", stat = "count") +
  geom_hline(yintercept = 0.5, linetype = "dashed") +
  theme(axis.text = element_text(size = 7, angle = 65, hjust = 1)) +
  facet_wrap(~threadname) + 
  ggtitle("Who messages last?")
