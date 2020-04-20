##########################################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Pull the data from Zillow
#   - Iterates over zips and months
#   - The dataframe has the following variables:
#       - zipcode
#       - city: city location of zipcode
#       - begin_date: yyyy-mm-dd
#       - sqft: price per square foot
#       - median: median zillow estimate
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##########################################################

library("ggplot2")
library("tidyverse")

house <- read.csv("http://files.zillowstatic.com/research/public/Zip/Zip_Zhvi_AllHomes.csv",header=T)

dczip <- house %>% filter(State == 'DC') %>% 
  gather(month, zhvi, starts_with('X')) %>% 
  filter(!is.na(zhvi)) %>% 
  filter(month == 'X2017.07')

plots <- ggplot(dczip, 
                aes(x = RegionName, y = zhvi, colour = zhvi, fill = month), 
                show.legend = F) + 
  geom_point() + 
  geom_segment(aes(xend = ..x.., yend = 0)) + 
  scale_colour_gradient(low = '#2171b5', high = '#e34a33') + 
  labs(x = 'Zip Code', y = 'Zillow Home Value Index', title = 'Washington DC Home Values July 2017') + 
  scale_y_continuous(labels = scales::comma) + 
  theme(text = element_text(family = "Myriad Pro", colour = "gray30"),
        axis.title = element_text(size = 9, face = 'bold'),
        plot.title = element_text(face = 'bold'), 
        axis.ticks = element_line(colour = 'gray70'),
        legend.position = "none")

plots
