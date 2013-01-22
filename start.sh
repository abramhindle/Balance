#!/bin/sh

bash nuke.sh
sleep 2
urxvt +j -title "JACK" -e bash jackd.sh &
sleep 2
qjackctl &

## urxvt +j -title "hw:1,0:in" -e alsa_in -d "hw:1,0" -j "USBExtCard" &
## urxvt +j -title "hw:1,0:out" -e alsa_out -d "hw:1,0" -j "USBExtCardOut" &
## sleep 2
## 
## 
## jack_connect  csoundBalanceMixer:output1 USBExtCardOut:playback_1
## jack_connect  csoundBalanceMixer:output2 USBExtCardOut:playback_2
## jack_connect  csoundBalanceMixer:output3 USBExtCardOut:playback_1
## # double connect
## jack_connect  csoundBalanceMixer:output4 USBExtCardOut:playback_1
## jack_connect  csoundBalanceMixer:output4 USBExtCardOut:playback_2
## 

urxvt +j -title "Balance Mixer" -e make &
sleep 3
jack_connect  csoundBalanceMixer:output1 system:playback_1
jack_connect  csoundBalanceMixer:output2 system:playback_2
jack_connect  csoundBalanceMixer:output3 system:playback_1
jack_connect  csoundBalanceMixer:output4 system:playback_2
jack_connect  csoundBalanceMixer:output4 system:playback_1


cd ~/projects/granular/
urxvt +j -title "Grain" -e csound grainui.csd &
urxvt +j -title "Suk" -e csound suk.csd &
sleep 2
jack_connect csoundGrain:output1 csoundBalanceMixer:input1
jack_connect csoundSuk:output1 csoundBalanceMixer:input4

cd ~/projects/
cd EventTableEditor/
urxvt +j -title "TableEditor1" -e ./RUN-tableset-jack-with-name TableEditor1 simplewg.xml &
urxvt +j -title "TableEditor1" -e ./RUN-tableset-jack-with-name TableEditor2 simplewg.xml &
sleep 5
jack_connect TableEditor1:output1 csoundBalanceMixer:input2
jack_connect TableEditor2:output1 csoundBalanceMixer:input3
