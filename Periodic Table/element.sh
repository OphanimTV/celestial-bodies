#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

#if no argument passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
fi

#if input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  #Query the database
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done    
  fi
fi

#if input is 1 or 2 characters
if [[ $1 =~ ^[a-zA-Z][a-zA-Z]?$ ]]
then
  #Query the database
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol LIKE '$1'")
  #If query is empty
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done    
  fi
fi

#If input is a string of characters
if [[ $1 =~ ^[a-zA-Z][a-zA-Z][a-zA-Z]+$ ]]
then
  #Query the database
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name = '$1'")
  #If query is empty
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done    
  fi
fi
