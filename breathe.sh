#!/bin/bash

RELAXING_TRACK="spotify:track:039xzKjVgqdnmoUOCXuEI2"
MAX_VOLUME=50

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
  printf "Get comfortable..."
  start_spotify &
  sleep 5

  printf "\rBegin breathing in... "
  for((i=3;i>=1; i--)){
    printf "%s\b" "$i"
    sleep 1.5
  }
  printf "\r                           \r"
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
    exit_with_usage
  fi
}

say_goodbye() {
  stop_spotify
  printf "\n🧘 goodbye 🧘\n"
}

start_spotify() {
  osascript -e "tell application \"Spotify\" to set sound volume to 0"
  osascript -e "tell application \"Spotify\" to play track \"$RELAXING_TRACK\""

  for((v=0;v<=MAX_VOLUME; v++)){
    osascript -e "tell application \"Spotify\" to set sound volume to $v"
  }
}

stop_spotify() {
  for((v=MAX_VOLUME;v>0; v--)){
    osascript -e "tell application \"Spotify\" to set sound volume to $v"
  }

  osascript -e "tell application \"Spotify\" to pause"
}

trap say_goodbye EXIT

parse_arguments "$@"
run