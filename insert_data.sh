#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    FIND_WINNER_RESULT="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    if [[ -z $FIND_WINNER_RESULT ]]
    then
      INSERT_WINNER_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
    fi
    FIND_OPPONENT_RESULT="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"
    if [[ -z $FIND_OPPONENT_RESULT ]]
    then
      INSERT_OPPONENT_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
    fi
    FIND_WINNER_RESULT="$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")"
    FIND_OPPONENT_RESULT="$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")"
    INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $FIND_WINNER_RESULT, $FIND_OPPONENT_RESULT, $WINNER_GOALS, $OPPONENT_GOALS);")"
  fi
done
