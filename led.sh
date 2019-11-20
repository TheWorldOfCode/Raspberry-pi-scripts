#! /bin/bash

while getopts ":bO:o:t" o; do
        echo "$o"
	case "${o}" in
		b)
			echo "Setting blik"
			blik="1"
                        ;;
		t)
                        echo "Setting Toggle"
			toggle="1"
			;;
                O)
                       ON=$OPTARG
                       ;;

                o)    
                      OFF=$OPTARG
                      ;;
	esac
done

function Toggle {
       
        current=$(cat /sys/class/leds/led0/brightness)


	if [ $current -eq 0 ]; then
		echo 1 | sudo tee /sys/class/leds/led0/brightness
        else
                echo 0 | sudo tee /sys/class/leds/led0/brightness
        fi
}


echo none | sudo tee /sys/class/leds/led0/trigger
if [ "x$blik" = "x1" ]; then
        i=10 
        while [ $i -gt 0 ]; do

	        Toggle

		if [ $(($i % 2)) -ne 0 ] && [ "x$ON" != "x" ]; then
                    sleep ${ON}s
                elif [ $(($i % 2)) -eq 0 ] && [ "x$OFF" != "x" ]; then
                    sleep ${OFF}s
                else
                   sleep  1s
                fi

                ((i--))
        done
fi

if [ "x$toggle" = "x1" ]; then
         Toggle
fi

exit 0
