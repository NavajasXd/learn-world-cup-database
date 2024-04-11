#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"
clear

# Inserting into the database

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # TEAMS
    # We need to insert into the teams table both the WINNER and the OPPONENT variables

    # Find ID of the Winner team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # If not found -> Insert
    if [[ -z $WINNER_ID ]]
    then
      WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo "INSERTING INTO DATABASE THE TEAM:" $WINNER
    fi
    # Find ID of the Opponent team
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # If not found -> Insert
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo "INSERTING INTO DATABASE THE TEAM:" $OPPONENT
    fi
  fi
done


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserting game into the database
    fi
  fi
done