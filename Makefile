mixer: mixer.pl mixer.csd
	perl mixer.pl | csound -dm6 -+rtaudio=jack  -+jack_client=csoundBalanceMixer -i devaudio  -o devaudio -b 400 -B 2048 -L stdin mixer.csd 
