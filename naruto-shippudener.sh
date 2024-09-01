#! /usr/bin/env bash

# pacman -S --needed xorg-xinput

# set -euo pipefail
# this causes the script to fail

########## key codes

KEY_1=10
KEY_2=11
KEY_3=12
KEY_4=13

KEY_C=54
KEY_L=46
KEY_I=31
KEY_J=44
KEY_K=45
KEY_O=32
KEY_P=33
KEY_U=30
KEY_X=53
KEY_Z=52

NUMPAD_1=87
NUMPAD_2=88
NUMPAD_4=83
NUMPAD_5=84
NUMPAD_7=79
NUMPAD_8=80
NUMPAD_9=81

KEY_INS=118
KEY_HOME=110
KEY_PAGE_UP=112
KEY_DEL=119
KEY_END=115
KEY_PAGE_DOWN=117

########## settings

##### in-game

ATTACK=$KEY_J
JUMP=$KEY_2
CHAKRA=$KEY_L
KUNAI=$KEY_4

##### new controls

CHAKRA_DASH=$KEY_K
ABILITY=$KEY_X
POWERFUL_ABILITY=$KEY_C

########## basic fncs

##### keyboard


send_key(){
	k=$1

    # in some games just using `xdtool key` works better
    # however, in other manually sending the keyup and keydown events
    # with a sleed inbetween does the job better

	# xdotool key $k

	xdotool keydown $k
	sleep 0.01
	xdotool keyup $k
}

##### output

log(){
	>&2 echo $@
}

########## fncs

keylogger(){
	# the commented code used to work but it no longer does
	# this is probable due to the output of xinput being changed
	# the old code is kept in case an older version of xinput is being used

	# xinput test-xi2 --root 3 | grep -A2 --line-buffered RawKeyRelease | while read -r line;
	# do
	#     if [[ $line == *"detail"* ]];
	#     then
	#         key=$(echo $line | sed "s/[^0-9]*//g")
	# 		echo $key
	#     fi
	# done

	xinput test-xi2 --root 3 | grep --line-buffered detail | while read -r line;
	do
		line=$(echo "$line" | cut -d ' ' -f 2)
		echo $line
	done
}

ability_activator(){

    while true; do
        read -t 0.001 -r key
        read_ret=$?

        if [ $read_ret != 0 ]; then
            continue
        fi

        case $key in

            $CHAKRA_DASH)
                # log 'chakra dash'
                send_key $CHAKRA
                send_key $JUMP
                ;;
            
            $ABILITY)
                # log 'ability'
                send_key $CHAKRA
                send_key $ATTACK
                ;;

            $POWERFUL_ABILITY)
                # log 'powerful ability'
                send_key $CHAKRA
                send_key $CHAKRA
                send_key $ATTACK
                ;;

            *)
                echo $key
                ;;
        esac
    done

}

########## main

# you can get the keycodes by calling:
# keylogger

keylogger | ability_activator > /dev/null
