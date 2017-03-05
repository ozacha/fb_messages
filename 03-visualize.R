library(ggplot2)

ggplot(dt[thread5000 != "others", .(.N, date = as.Date(min(time))), by = .(year(time), week(time), threadname)],
       aes(x = date, y = N, color = threadname, fill = threadname)) +
  geom_bar(stat = "identity", position = "stack") +
  # scale_color_discrete(guide = FALSE) + 
  theme(legend.text = element_text(size = 6),
        legend.key.size = unit(2, "mm"),
        legend.spacing = unit(1, "mm"))

ggplot(dt[thread5000 != "others", .(.N, date = as.Date(min(time))), by = .(year(time), week(time), threadname)],
       aes(x = date, y = N, color = threadname, fill = threadname)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_color_discrete(guide = FALSE) + 
  scale_fill_discrete(guide = FALSE) + 
  facet_wrap(~threadname, scales = "free_y")
