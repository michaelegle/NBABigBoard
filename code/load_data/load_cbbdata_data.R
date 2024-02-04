library(cbbdata)
devtools::install_github("andreweatherman/cbbdata")



cbbdata::cbd_login()

torvik_game <- cbd_torvik_player_game()
