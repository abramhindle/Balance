	sr = 44100
	kr = 441
	ksmps = 100
	nchnls = 1

gkoscamp   init 0
gkoscpitch init 0
gkosc2amp  init 0
gkosc2pitch  init 0
gkentropy  init 0

	instr	1
        idur = p3
k1	oscil	1, 1/3, 2
kpitch  = cpspch(k1)  * gkoscpitch
a1	oscil	gkoscamp, kpitch , 1
a2	oscil	(0.1+gkosc2amp), 5*gkosc2pitch, 1


a4	oscil	gkoscamp, 1.01*kpitch, 1
a5	oscil	gkoscamp, 1.02*kpitch, 1
a6	oscil	gkoscamp, 0.99*kpitch, 1

ah1	oscil	gkoscamp, (101/100)*kpitch, 1
ah2	oscil	gkoscamp, (99/100)*kpitch, 1
ah3	oscil	gkoscamp, (102/100)*kpitch, 1
ah4	oscil	gkoscamp, (98/100)*kpitch, 1
ah5	oscil	gkoscamp, (103/100)*kpitch, 1
ah6	oscil	gkoscamp, (97/100)*kpitch, 1
ah7	oscil	gkoscamp, (104/100)*kpitch, 1
ah8	oscil	gkoscamp, (96/100)*kpitch, 1
ah9	oscil	gkoscamp, (105/100)*kpitch, 1
ah10	oscil	gkoscamp, (95/100)*kpitch, 1

aharm   = ah1 + ((gkentropy>0.1)?1:0) * ah2 + ((gkentropy>0.3)?1:0) * ah3 + ((gkentropy>0.6)?2:0) * ah4 + ((gkentropy>0.8)?2:0) * ah5 + ((gkentropy>0.9)?3:0) * ah6 + ((gkentropy>0.95)?3:0) * ah7 + ((gkentropy>0.99)?4:0) * ah8 + ((gkentropy>0.999)?4:0) * ah9 + ((gkentropy>0.9999)?4:0) * ah10 +  ((gkentropy>0.99999)?5:0) * a1

	kamp  = (1 - gkentropy) * 100
asig1  rand  kamp,         .5, 1 ; High quality random number

asig2  randh kamp, sr/2,   .5, 1 ; Hold random number for 2 samples

asig3  randh kamp, sr/4,   .5, 1 ; Hold for 4   samples

asig4  randh kamp, sr/8,   .5, 1 ; Hold for 8   samples

asig5  randh kamp, sr/16,  .5, 1 ; Hold for 16  samples

asig6  randh kamp, sr/32,  .5, 1 ; Hold for 32  samples

asig7  randh kamp, sr/64,  .5, 1 ; Hold for 64  samples

asig8  randh kamp, sr/128, .5, 1 ; Hold for 128 samples

;aharm   = ( (gkentropy > 0.9) ? (1 - gkentropy) : 0 ) * (a4+a5+a6) 
;	out	 ( a1*a2 + aharm   + asig1+asig2+asig3+asig4+asig5+asig6+asig7+asig8 )
	out	 aharm   + asig1+asig2+asig3+asig4+asig5+asig6+asig7+asig8 
;	out a1
	endin


	instr	666
	ientropy    = p4
	isc1        = p5
	isc1entropy = p6
	isc2        = p7
	isc2entropy = p8

	gkoscamp    init 100 + 1000 * (isc1 + isc2) / 100
	;gkoscpitch  init 440 * (ientropy + isc1entropy + isc2entropy)
	gkoscpitch  init (ientropy + isc1entropy + isc2entropy)
	gkosc2amp   init ientropy 
	gkentropy   init ientropy 
	gkosc2pitch init ((0.01+isc1entropy) * (0.01+isc2entropy))
	turnoff
	endin
