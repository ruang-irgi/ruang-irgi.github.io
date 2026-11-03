#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL"TRUNCATE teams, games"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#skip judul
if [[ $YEAR != year ]]
then
  #cek id team
  TEAM1_ID=$($PSQL"SELECT team_id FROM teams WHERE name = '$WINNER'")
  TEAM2_ID=$($PSQL"SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  #jika tidak ada tambahkan
  if [[ -z $TEAM1_ID ]] 
  then 
    $PSQL"INSERT INTO teams(name) VALUES('$WINNER')"
    TEAM1_ID=$($PSQL"SELECT team_id FROM teams WHERE name = '$WINNER'")
  fi
  if [[ -z $TEAM2_ID ]] 
  then 
    $PSQL"INSERT INTO teams(name) VALUES('$OPPONENT')"
    TEAM2_ID=$($PSQL"SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi

  #tambahkan pertandingan
  $PSQL"INSERT INTO games(year, winner_id, opponent_id, round, winner_goals, opponent_goals) VALUES($YEAR, $TEAM1_ID, $TEAM2_ID, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)"
fi
done
