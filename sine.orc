	sr = 22050
	kr = 2205
	ksmps = 10
	nchnls = 1

	instr	1
        idur = p3
a1	oscil	p4, p5, 1
a2	oscil	(0.1+p8), 5*p6, 1
	iamp  = exp(p6 * p9* p7)
asig1  rand  iamp,         .5, 1 ; High quality random number

asig2  randh iamp, sr/2,   .5, 1 ; Hold random number for 2 samples

asig3  randh iamp, sr/4,   .5, 1 ; Hold for 4   samples

asig4  randh iamp, sr/8,   .5, 1 ; Hold for 8   samples

asig5  randh iamp, sr/16,  .5, 1 ; Hold for 16  samples

asig6  randh iamp, sr/32,  .5, 1 ; Hold for 32  samples

asig7  randh iamp, sr/64,  .5, 1 ; Hold for 64  samples

asig8  randh iamp, sr/128, .5, 1 ; Hold for 128 samples

aseg   linseg 0, (0.1*idur), 1, (0.8 * idur), 0.1, (0.1*idur), 0

	out	aseg * ( a1*a2 + asig1+asig2+asig3+asig4+asig5+asig6+asig7+asig8 )
	endin

