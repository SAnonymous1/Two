#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
    then
    INSERTION_TEAMS=$($PSQL "select count(*) from teams where name = '$winner';" | xargs)
    if [[ $INSERTION_TEAMS -eq 0 ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$winner');"
    fi

    INSERTION_TEAMS_OP=$($PSQL "select count(*) from teams where name = '$opponent';" | xargs)
    if [[ $INSERTION_TEAMS_OP -eq 0 ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$opponent');"
    fi
  fi
done


cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do

  if [[ $year != "year" ]]
    then

    SELECTION_WIN=$($PSQL "select team_id from teams where name = '$winner';" | xargs)
    SELECTION_OPP=$($PSQL "select team_id from teams where name = '$opponent';" | xargs)

    INSERTION=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($year,'$round',$SELECTION_WIN,$SELECTION_OPP,$winner_goals,$opponent_goals);")
    if [[ $INSERTION == "INSERT 0 1" ]]
      then
      echo "Inserted game correctly: $year $round $winner vs $opponent"
    fi
  fi
done