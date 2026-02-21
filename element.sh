#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# No argument provided
if [[ $# -eq 0 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

#assign argument to input
INPUT="$1"

#if input is not a number
if [[ ! $INPUT =~ ^[0-9]+$ ]]
then
  #get the line against string argument
  LINE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$INPUT' OR name = '$INPUT'")
else
  #get the line against number argument
  LINE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $INPUT")  
fi  
#if no line
if [[ -z $LINE ]]
then
  #print out about failed search
  echo "I could not find that element in the database."
else 
  #collect search variables
  IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$LINE"
  #print search result
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi