#!/bin/bash

intro() {
  echo "Get comfortable..."
  sleep 5

  printf "Begin breathing in... "
  for((i=3;i>=1; i--)){
    printf "%s\b" "$i"
    sleep 1.5
  }
  printf " \n\n"
}

say_goodbye() {
  printf "\n🧘 goodbye 🧘\n"
  exit
}

trap say_goodbye SIGINT

intro

CHARACTERS="....ooooooOOOOoooooooo...."

while (true)
do
  length=${#CHARACTERS}

  for((i=0; i<length; i++)){
    ch="${CHARACTERS:i:1}"

    printf "%s" $ch

    case $ch in
      'O') sleep 1 ;;
      *) sleep 0.5 ;;
    esac
  }
  printf '\r'
done

