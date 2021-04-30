#!/bin/bash

source frames.sh

CURSOR_ORIGIN="\033[0;0H"
RELAXING_TRACK="spotify:track:039xzKjVgqdnmoUOCXuEI2"
MAX_VOLUME=50

breathe() {
  frame_count=${#FRAMES[@]}

  # inhale
  for((b=0;b<frame_count;b++)){
    echo -ne "$CURSOR_ORIGIN"
    echo -e "${FRAMES[b]}"
    sleep 0.3
  }

  sleep 1

  # exhale
  for((b=frame_count-1;b>=0;b--)){
    echo -ne "$CURSOR_ORIGIN"
    echo -e "${FRAMES[b]}"
    sleep 0.5
  }
}

breathe_n_times() {
  local n=$1
  for((i=0;i<n;i++)){
    breathe
  }
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
  clear
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
  if [ -n "$OPTNUM" ]
  then
    intro
    breathe_n_times "$OPTNUM"
    COMPLETE=1
  else
    exit_with_usage
  fi
}

say_goodbye() {
  if [ -n "$OPTNUM" ]
  then
    stop_spotify
    clear
    echo -e "\033[0m\n🧘 Goodbye :) 🧘"
  fi
}

start_spotify() {
  osascript -e "tell application \"Spotify\" to set sound volume to 0"
  osascript -e "tell application \"Spotify\" to play track \"$RELAXING_TRACK\""

  for((v=0;v<=MAX_VOLUME; v++)){
    osascript -e "tell application \"Spotify\" to set sound volume to $v"
  }
}

stop_spotify() {
  if [ -n "$COMPLETE" ]
  then
    for((v=MAX_VOLUME;v>0; v--)){
      osascript -e "tell application \"Spotify\" to set sound volume to $v"
    }
  fi

  osascript -e "tell application \"Spotify\" to pause"
  # reset spotify volume
  osascript -e "tell application \"Spotify\" to set sound volume to 100"
}

trap say_goodbye EXIT

parse_arguments "$@"
run
