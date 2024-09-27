#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 = '' ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]];then
      VARIABLE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")

  elif [[ "$1" =~ ^.{1,2}$ ]];then
      VARIABLE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'")

  else
      VARIABLE=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'")
  fi


  echo "$VARIABLE" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
  do
    if [[ -z $VARIABLE ]] ;then
        echo "I could not find that element in the database."
    else
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius.";
    fi
  done
fi