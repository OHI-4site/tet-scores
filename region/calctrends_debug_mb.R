
status_data <- lsp_status

CalculateTrend <- function(status_data, trend_years=trend_years){

  if(sum(grepl("rgn_id", names(status_data))>0)){
    names(status_data)[which(names(status_data)=="rgn_id")] <- "region_id"
  }

  if(sum(grepl("scenario_year", names(status_data)) > 0)) {
    names(status_data)[which(names(status_data) == "scenario_year")] <- "year"
  }

  status_data <- status_data %>%
    dplyr::select(region_id, year, status) %>%
    dplyr::filter(year %in% trend_years) %>%
    dplyr::filter(!is.na(status)) %>%
    unique()

  adj_trend_year <- min(trend_years)

  r.trend = status_data %>%
    dplyr::group_by(region_id) %>%
    dplyr::do(mdl = lm(status ~ year, data=.),
              adjust_trend = .$status[.$year == adj_trend_year]) %>%
    dplyr::summarize(region_id, score = ifelse(coef(mdl)['year']==0, 0, coef(mdl)['year']/adjust_trend * 5)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(score = ifelse(score>1, 1, score)) %>%
    dplyr::mutate(score = ifelse(score<(-1), (-1), score)) %>%
    dplyr::mutate(score = round(score, 4)) %>%
    dplyr::mutate(dimension = "trend") %>%
    dplyr::select(region_id, score, dimension)

  return(r.trend)
}
