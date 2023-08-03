#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "create table if not exists teams("team_id" serial not null primary key,"name" varchar(64) not null unique);")"

echo "$($PSQL "create table if not exists games("game_id" serial not null primary key,"year" int not null,"round" varchar(64) not null,"winner_id" int not null references teams("team_id"),"opponent_id" int not null references teams("team_id"),winner_goals int not null,opponent_goals int not null);")"
echo $($PSQL "TRUNCATE teams, games")

cat games.csv|while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [ "$winner" != "winner" ]
  then
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$winner')")
      if [[ $INSERT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $winner
      fi
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    fi
  fi
  if [ "$opponent" != "opponent" ]
  then
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$opponent')")
      if [[ $INSERT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $opponent
      fi
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    fi
    echo $winner_id,$opponent_id
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals)")
    if [[ $INSERT_MAJORS_COURSES_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into majors_courses, $MAJOR : $COURSE
    fi
  fi
done

