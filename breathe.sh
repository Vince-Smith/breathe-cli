#!/bin/bash

RELAXING_TRACK="spotify:track:039xzKjVgqdnmoUOCXuEI2"

breathe() {
  local CHARACTERS="....ooooooOOOOoooooooo...."
  length=${#CHARACTERS}

  for((j=0; j<length; j++)){
    ch="${CHARACTERS:j:1}"

    printf "%s" $ch

    case $ch in
      'O') sleep 1 ;;
      *) sleep 0.5 ;;
    esac
  }

  printf "\r"
}

breathe_n_times() {
  local n=$1
  for((i=0;i<n;i++)){
    breathe
  }
  printf "\n"
}

exit_with_usage() {
  printf "Usage: %s: [-n value]\n"  "$0"
  exit 2
}

intro() {
  start_spotify

  echo "Get comfortable..."
  sleep 5

  printf "Begin breathing in... "
  for((i=3;i>=1; i--)){
    printf "%s\b" "$i"
    sleep 1.5
  }
  printf " \n\n"
}

parse_arguments() {
  local OPTIND
  while getopts n: option ; do
    case $option in
      n ) OPTNUM=$OPTARG;;
      ? ) exit_with_usage ;;
    esac
  done
}

run()
{
  intro

  if [ -n "$OPTNUM" ]
  then
    breathe_n_times "$OPTNUM"
  else
    echo "Come back when you're ready to breathe properly"
  fi
}

say_goodbye() {
  printf "\n🧘 goodbye 🧘\n"
  stop_spotify
}

start_spotify() {
  osascript -e "tell application \"Spotify\" to play track \"$RELAXING_TRACK\""
}

stop_spotify() {
  osascript -e "tell application \"Spotify\" to pause"
}

trap say_goodbye EXIT

parse_arguments "$@"
run