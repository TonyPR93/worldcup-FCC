#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
I=0
echo $($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
  echo $I
  ((I++))
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    # GET WINNER
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT = "INSERT 0 1" ]]
      then
        echo $WINNER, insert via winner
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # GET OPPONENT
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT = "INSERT 0 1" ]]
      then
        echo $OPPONENT, insert via OPPONENT
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  fi
  if [[ $YEAR != "year" && $ROUND != "round" && $WINNER_GOALS != "winner_goals" && $OPPONENT_GOALS != "opponent_goals" ]]
  then
    # GET GAME ID
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id='$WINNER_ID' AND opponent_id='$OPPONENT_ID'")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals, opponent_goals, winner_id, opponent_id) VALUES('$YEAR','$ROUND','$WINNER_GOALS','$OPPONENT_GOALS','$WINNER_ID', '$OPPONENT_ID')")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo -e "Game Inserted"
      fi
    fi
  fi
done