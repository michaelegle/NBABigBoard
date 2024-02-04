library(hoopR)

tictoc::tic()
progressr::with_progress({
  nba_pbp <- hoopR::load_nba_pbp(2023)
})
tictoc::toc()

test <- load_mbb_pbp(seasons = 2023)

nba_box <- load_nba_player_box(2023)


gleague <- nbagl_pbp(2012200001)

