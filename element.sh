#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#If you run ./element.sh, it should output only 
#"Please provide an element as an argument." and finish running.
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
 #check for number input
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
    #check for symbol or name input
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol ='$1' OR name = '$1'")
  fi

  if [[ -z $ATOMIC_NUMBER ]]
  then
    #If the argument input to your  element.sh script doesn't exist as an atomic_number, symbol, or name in the database, the only output should be 
    #"I could not find that element in the database.""
    echo I could not find that element in the database.
  else
    #If you run ./element.sh 1, ./element.sh H, or ./element.sh Hydrogen, it should output only 
    #The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    ELEMENT_TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING (type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
