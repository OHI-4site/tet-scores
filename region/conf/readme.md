Files needed for the toolbox to calculate scores.


`goals.csv` lists all goals included in the assessment.

`pressure_categories.csv` lists all the types of pressures

`pressures_matrix.csv` contains the pressure impact weights for each goal where pressures are present

`resilience_categories.csv` lists all the resilience layers and the pressure they counteract

`resilience_matrix.csv` identifies where and what resilience layers apply to each goal

`scenario_data_years.csv` lists all layers, the data years and what their associated scenario year should be. For example, if data for a layer only includes 2015-2018, this file is where we tell the toolbox to use the scores from 2018 for 2019 and 2020.

`functions.R` contains all goal model functions

`functions_global.R` is a copy of the `functions.R` script from OHI-Global. It is here just as a reference but will not be used to calculate scores.
