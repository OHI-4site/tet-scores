#### Data Selection Criteria (DSC) Heatmap
#### This script contains code for creating the heatmap scoring each data layer used as 0,0.5, or 1 based on various criteria.
## August 25, 2020

library(ggplot2)
library(googledrive)
library(googlesheets4)
library(dplyr)
library(cowplot)
library(tidyverse)

### read in the data from google sheets
dsc_scores_raw <- read_csv(here("documents/methods-results/data_quality/dq.csv")) %>%
  filter(!is.na(Goal))

##create list arranged by score for graph later
order_layers_df <- dsc_scores_raw %>%
  select(Layer,`Average Score` ) %>%
  unique()  %>%
  arrange(`Average Score`)

order_layers <- c(order_layers_df$Layer)

# criteria order: same as in the table
order_criteria <- c("Spatial Cover",
                    "Temporal Resolution", "Temporal Span", "Temporal Baseline",
                    "Fit Resolution", "Fit Comprehensiveness", "Overall Score")

### Now we want to create a df that we can use to make the heatmap, and apply all these orders that we created
dsc_layers <- dsc_scores_raw %>%
  select(-Goal) %>%
  rename("Overall Score" = "Average Score") %>%
  unique() %>%
  gather("criteria", "score", 2:8) %>% # Data is in long format, need it short
  mutate(score = as.numeric(score), #, na.rm = TRUE
         criteria = as.character(criteria),
         Layer = as.character(Layer),
         criteria = factor(criteria, levels = order_criteria),
         Layer = factor(Layer, levels = order_layers)) %>%
  unique()

### Heatmap!
dsc_all_layers <- ggplot(data = dsc_layers, aes(x = criteria, y = Layer)) +
  geom_tile(aes(fill = score)) +
  scale_fill_gradient2(midpoint = 0.5,
                       low = "darkred", mid = "orange", high = "darkgreen", na.value = "grey80",
                       breaks = c(0,0.5,1),
                       labels = c("Bad","Medium", "Good")) +
  theme_dark()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom") +
  coord_cartesian(expand=FALSE)

dsc_all_layers

#save
ggsave(here("documents/methods-results/assets/dsc_heatmap_gradient.jpg"), width=10, height=8, dpi=300)
