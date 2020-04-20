library(stringr)
library(openfda)
library(dplyr)
library(ggplot2)
library(ggthemes)

# helper functions to query the openFDA API
get_adverse <- function(gender, brand_name, age) {
  fda_query("/drug/event.json") %>%
    fda_filter("patient.drug.openfda.brand_name", brand_name) %>% 
    fda_filter("patient.patientsex", gender) %>% 
    fda_filter("patient.patientonsetage", age) %>% 
    fda_count("patient.reaction.reactionmeddrapt.exact") %>% 
    fda_limit(10) %>% 
    fda_exec()
}
create_age <- function(min, max){#
  sprintf('[%d+TO+%d]', min, max)
}

# specify drug
drug <- "Keytruda"

# specify age range
age <- create_age(20,65)

# get adverse event data from the openfda API
jnk <- capture.output(male <- get_adverse("1", drug, age))
if (!is.null(male)) {
  male$gender <- 'male'
}
jnk <- capture.output(female <- get_adverse("1", drug, age))
if (!is.null(female)) {
  female$gender <- 'female'
}

# comnbine male and female event data
adverse <- rbind(male, female)

#STOP Open adverse with esquisse

# plot all events  
adverse %>% 
  group_by(term) %>% 
  summarise(count = sum(count)) %>% 
  ggplot() +
  geom_bar(aes(reorder(term,count), count), stat = 'identity') +
  coord_flip() +
  labs(
    title = drug,
    x = NULL,
    y = NULL
  ) +
  theme_minimal()

# plot by gender
ggplot(adverse) +
  geom_bar(aes(reorder(term,count), count, fill = gender), stat = 'identity') +
  facet_wrap(~gender)+
  coord_flip() +
  labs(
    title = drug,
    x = NULL,
    y = NULL
  ) +
  theme_minimal() + 
  guides(fill = FALSE) + 
  scale_fill_manual(values = c("#d54a30","#4c83b6"))

