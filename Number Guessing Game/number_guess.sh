#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$((RANDOM % 1000 + 1))
NUMBER_OF_GUESSES=0
GAMES_PLAYED=0

GUESS_LOOP() {
read GUESS

if [[ $GUESS =~ ^[0-9]+$ ]]
then
  if [[ $GUESS = $NUMBER ]]
  then
    let NUMBER_OF_GUESSES++

    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!"
    
    #Update number of games played
    let GAMES_PLAYED++
    RESULT=$($PSQL "UPDATE users SET games_played = '$GAMES_PLAYED' WHERE username = '$USERNAME'")

    #Update best game yet
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username = '$USERNAME'")
    if [[ $BEST_GAME -eq 0 || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
    then
      RESULT=$($PSQL "UPDATE users SET best_game = '$NUMBER_OF_GUESSES' WHERE username = '$USERNAME'")
    fi
      
  else if [[ $GUESS > $NUMBER ]]
    then
      let NUMBER_OF_GUESSES++
      echo "It's lower than that, guess again:"
      GUESS_LOOP
    else 
      let NUMBER_OF_GUESSES++
      echo "It's higher than that, guess again:"
      GUESS_LOOP
    fi
  fi
else
  echo "That is not an integer, guess again:"
  GUESS_LOOP
fi
}

echo "Enter your username:"
read USERNAME

IFS="|" read GAMES_PLAYED BEST_GAME <<< $($PSQL "SELECT games_played, best_game FROM users WHERE username = '$USERNAME'")

#If the user doesn't exist, create the user.
if [[ $GAMES_PLAYED -eq 0 ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."   
fi

echo "Guess the secret number between 1 and 1000:"

GUESS_LOOP
