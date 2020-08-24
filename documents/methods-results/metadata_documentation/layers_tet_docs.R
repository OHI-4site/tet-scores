## This creates the layers_tet_XX.csvs for the supplement (maybe?) ##


layers <- read_csv(here("/region/layers.csv")) %>%
  dplyr::select(targets,layer) %>%
  #separate(targets,into = c("goal, dimension"), pattern = " ")
