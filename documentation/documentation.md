# NBA Draft Big Board

## Overview

The goal of this project is to leverage any available public data sources for basketball at any level and use them to create projections for impact at the NBA level. In an ideal world we have data available for all NCAA D1 teams, G League teams, and major international pro teams. In reality, data coverage varies in the NCAA, data for the G League is hard to come by, and there's very little available data for international basketball as far as I'm aware.

## Data Sources

Below is a list of data sources that will be useful for this project:
- hoopR
- cbbdata
- nbastatR
- gamezoneR

In summary we have the following:
- NBA Lineup Data (hoopR) (This will have to be wrangled on our end but there's probably a lot of code to do this already)
- NCAA Box Score Data for D1 games (hoopR)
- NCAA Lineup/pbp Data for select games (gamezoneR) (I believe all games are already pre-processed, just need to confirm)
- NBA G League pbp data, could get lineup data (hoopR)
- Torvik Game Info


## Models

- Predictors: APM in college? Possession rate stats, etc
- Target: Distribution of some kind of APM (probably built in house model)

## Future Plans

For now, the main focus is NCAA D1 and G League. In the future we plan to expand this project to include international stats. The following sites look fairly easy to scrape and could be really helpful additions down the road:

- EuroLeague Game Center https://www.euroleaguebasketball.net/euroleague/game-center/ (Note that there *is* an API endpoint available for this)
- FIBA Events play-by-play https://www.fiba.basketball/basketballworldcup/2023/games

Some young international prospects get their start in the EuroLeague, and many talented prospects play in FIBA tournaments in the offseason in college.
