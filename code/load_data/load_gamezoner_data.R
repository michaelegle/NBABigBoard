library(tidyverse)
library(gamezoneR)

future::plan("multisession")
tictoc::tic()
progressr::with_progress({
  pbp <- gamezoneR::load_gamezone_pbp(c("2021-22", "2022-23", "2023-24"))
})
tictoc::toc()


pbp %>% 
  filter(substitution == 1) %>% 
  filter(is.na(home_1)) %>% 
  group_by(season) %>% 
  summarize(games_with_recoverable_lineup_data = n_distinct(game_id))

pbp %>% 
  group_by(season) %>% 
  summarize(games = n_distinct(game_id),
            games_with_fully_missing_lineup_data = n_distinct(game_id[all(is.na(home_1))]),
            games_with_recoverable_lineup_data = n_distinct(game_id[any(is.na(home_1) & substitution == 1)]))

team_games_played <- pbp %>% 
  group_by(event_team, season) %>% 
  summarize(games = n_distinct(game_id)) %>% 
  arrange(desc(games)) %>% 
  filter(!is.na(event_team))

head(pbp) %>% View()


subs <- pbp %>% 
  filter(substitution == 1 & is.na(home_1))

broken_subs <- subs %>% 
  filter(desc == "Substitution:  in for .")

test <- pbp %>% 
  filter(!is.na(home_1))

test_game <- pbp %>% 
  # just use one game for now to get a feel for what the data looks like
  filter(season == "2023-24") %>% 
  filter(!is.na(home_1)) %>% 
  # assign a point value to each event
  mutate(point_value = case_when(shot_outcome == "missed" ~ 0,
                                 is.na(shot_outcome) ~ 0,
                                 three_pt ~ 3,
                                 free_throw ~ 1,
                                 T ~ 2))
  
test_game %>% 
  group_by(event_team) %>% 
  summarize(points = sum(point_value))

lineups_agg <- test_game %>% 
  group_by(game_id, poss_number) %>% 
  # find the offense team and assign the lineups for offense and defense
  mutate(offense_team = first(poss_before[!is.na(poss_before)]),
         defense_team = ifelse(offense_team == home, away, home),
         off_1 = ifelse(offense_team == home, home_1, away_1),
         off_2 = ifelse(offense_team == home, home_2, away_2),
         off_3 = ifelse(offense_team == home, home_3, away_3),
         off_4 = ifelse(offense_team == home, home_4, away_4),
         off_5 = ifelse(offense_team == home, home_5, away_5),
         def_1 = ifelse(offense_team == home, away_1, home_1),
         def_2 = ifelse(offense_team == home, away_2, home_2),
         def_3 = ifelse(offense_team == home, away_3, home_3),
         def_4 = ifelse(offense_team == home, away_4, home_4),
         def_5 = ifelse(offense_team == home, away_5, home_5)) %>% 
  filter(!is.na(poss_number)) %>% 
  # for each possession, find the offensive and defensive lineups as well as how many points were scored on the play
  summarize(offense_team = first(offense_team),
            defense_team = first(defense_team),
            points = sum(point_value),
            across(c(starts_with("off_"), starts_with("def_")),
                   ~ first(.x[!is.na(.x)]))) %>% 
  ungroup()

# split out the offensive lineup possessions
off_poss_outcomes <- lineups_agg %>% 
  select(game_id, poss_number, points, offense_team, starts_with("off_"))

# split out the defensive lineup possessions
def_poss_outcomes <- lineups_agg %>% 
  select(game_id, poss_number, points, defense_team, starts_with("def_")) %>% 
  mutate(points = -points)


off_poss_outcomes_wide <- off_poss_outcomes %>% 
  pivot_longer(cols = starts_with("off_"),
               names_to = "temp",
               values_to = "player_name") %>% 
  select(-temp) %>% 
  mutate(seen = 1) %>% 
  pivot_wider(id_cols = c(game_id, poss_number, points),
              names_from = c(offense_team, player_name),
              values_from = seen,
              values_fn = max,
              values_fill = 0,
              names_sep = " - ")

def_poss_outcomes_wide <- def_poss_outcomes %>% 
  pivot_longer(cols = starts_with("def_"),
               names_to = "temp",
               values_to = "player_name") %>% 
  select(-temp) %>% 
  pivot_wider(names_from = c(defense_team, player_name),
              values_from = points,
              values_fn = sum)

test_game_2 <- test_game %>% 
  group_by(poss_number) %>% 
  mutate(offense_team = first(poss_before[!is.na(poss_before)]),
         defense_team = ifelse(offense_team == home, away, home))

