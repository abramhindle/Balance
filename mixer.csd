<CsoundSynthesizer>  

<CsOptions>

</CsOptions>

<CsInstruments>
       	sr = 44100
	kr = 441
	ksmps = 100
	nchnls = 4

      gkmute1 init 1
      gkmute2 init 1
      gkmute3 init 1
      gkmute4 init 1

      gkent1 init 0
      gkent2 init 0
      gkent3 init 0

      gkval1 init 0
      gkval2 init 0
      gkval3 init 0

      gkrval1 init 1
      gkrval2 init 1
      gkrval3 init 1

      gkent init 0
      gkgate init 0.1

FLcolor	180,200,199
FLpanel 	"Balance Mixer",200,300
    istarttim = 0
    idropi = 666
    idur = 1
                
    gkamp1,    iknob1 FLknob  "AMP1", 0.0001, 16, -1,1, -1, 50, 0,0
    gkamp2,    iknob2 FLknob  "AMP2", 0.0001, 16, -1,1, -1, 50, 50,0
    gkamp3,    iknob3 FLknob  "AMP3", 0.0001, 16, -1,1, -1, 50, 100,0
    gkamp4,    iknob4 FLknob  "AMP4", 0.0001, 16, -1,1, -1, 50, 150,0
    ;                                      ionioffitype
    gkmute1,    gimute1 FLbutton  "Mute1", 1, 0, 22, 50, 50, 0  ,100, -1
    gkmute2,    gimute2 FLbutton  "Mute2", 1, 0, 22, 50, 50, 50 ,100, -1
    gkmute3,    gimute3 FLbutton  "Mute3", 1, 0, 22, 50, 50, 100,100, -1
    gkmute4,    gimute4 FLbutton  "Mute4", 1, 0, 22, 50, 50, 150,100, -1
 
    ittm1  FLvalue "V1", 100, 20, 0, 210
    ittm2  FLvalue "V2", 100, 20, 0, 230
    ittm3  FLvalue "V3", 100, 20, 0, 250
    ittm4  FLvalue "V3", 100, 20, 0, 270
    gkgate,    iknob7 FLknob  "B Gate", 0.01, 1, -1,1, ittm4, 50, 150,210
    gkgate4,    iknob8 FLknob  "4Gate", 0.01, 1, 0,1, ittm4, 50, 100,210
    gkrval1m, gim1  FLslider "V1", 0, 1.0, 0, 1, ittm1, 200, 20, 0, 150
    gkrval2m, gim2  FLslider "V2", 0, 1.0, 0, 1, ittm2, 200, 20, 0, 170
    gkrval3m, gim3  FLslider "V3", 0, 1.0, 0, 1, ittm3, 200, 20, 0, 190
    gkrval4m, gim4  FLslider "V4", 0, 1.0, 0, 1, -1, 200, 20, 0, 290
   
;    gkdrop1,    ibutton4 FLbutton  "Drop 12->34", 0, 0, 1, 100, 50, 0,   200, 0, idropi, istarttim, idur, 0
;   gkdrop2,    ibutton4 FLbutton  "Drop 34->12", 0, 0, 1, 100, 50, 100, 200, 0, idropi, istarttim, idur, 1
    
    
    
    FLsetVal_i   1.0, iknob1
    FLsetVal_i   1.0, iknob2
    FLsetVal_i   1.0, iknob3
    FLsetVal_i   1.0, iknob4
    
    FLsetVal_i   1.0, gimute1
    FLsetVal_i   1.0, gimute2
    FLsetVal_i   1.0, gimute3
    FLsetVal_i   1.0, gimute4
    
    
FLpanel_end	;***** end of container

FLrun		;***** runs the widget thread 


      gkamp1 init 1
      gkamp2 init 1
      gkamp3 init 1
      gkamp4 init 1

      gkmute1 init 1
      gkmute2 init 1
      gkmute3 init 1
      gkmute4 init 1



; the mixer
        instr 1
	a1,a2,a3,a4 inq
	gkr1 = (gkrval1>gkgate)?gkrval1:0
	gkr2 = (gkrval2>gkgate)?gkrval2:0
	gkr3 = (gkrval3>gkgate)?gkrval3:0
	gkr4 = (abs(gkrval1 - gkrval2) + abs(gkrval1 - gkrval3) + abs(gkrval2 - gkrval3))/3
	; if the value is less than gate4 then scale it to linearly to the volume of 4
	kr4lim = 1 - ((gkr4 < gkgate4)?gkr4/gkgate4:1)
	kamp1 portk (1-kr4lim)*gkamp1*gkr1, 0.05
	kamp2 portk (1-kr4lim)*gkamp2*gkr2, 0.05
	kamp3 portk (1-kr4lim)*gkamp3*gkr3, 0.05
	kamp4 portk gkamp4*kr4lim, 0.666
	aa1 = a1 * kamp1 * gkmute1
	aa2 = a2 * kamp2 * gkmute2
	aa3 = a3 * kamp3 * gkmute3
        aa4 = a4 * kamp4 * gkmute4
	
	ktrig metro 10
	FLsetVal ktrig, gkrval1, gim1
	FLsetVal ktrig, gkrval2, gim2
	FLsetVal ktrig, gkrval3, gim3
	FLsetVal ktrig, gkr4, gim4
	;printks "%f %f %f", 1, gkrval1, gkrval2, gkrval3


	outq aa1,aa2,aa3,aa4
        endin   

; the dropper
; the dropper will save state of p4
; and then set p4 (the amp) to the envelope * p4
; and then set p3 (the amp) to the (1-envelope) * p3
; p3 - from 
; p4 - to
; we'll just do 1&2 to 3&4
;
        instr 666
        idur = p3
        idir = p4 ; direction 0  
        print idur, idir
        ; get the envelope
        ;kenv oscili 1, 1/idur, 666
        ;kenv expseg   0.0001, idur, 1.0001
        ;kenv = kenv - 0.0001
        kenv linseg 0, idur, 1
        krenv linseg 1, idur, 0
        gkmute1 = ((idir>0)?kenv:krenv)
        gkmute2 = ((idir>0)?kenv:krenv)
        gkmute3 = ((idir>0)?krenv:kenv)
        gkmute4 = ((idir>0)?krenv:kenv)
        ;FLsetVal 1,gkmute1,gimute1
        ;FLsetVal 1,gkmute2,gimute2
        ;FLsetVal 1,gkmute3,gimute3
        ;FLsetVal 1,gkmute4,gimute4
        endin

        instr setEntropy
        gkent = p4
	turnoff
        endin

        instr setValues
        gkval1 = p4
        gkval2 = p5
        gkval3 = p6
	turnoff
        endin

        instr setRelValues
        gkrval1 = p4
        gkrval2 = p5
        gkrval3 = p6
	turnoff
        endin

        instr setEntropies
        gkent1 = p4
        gkent2 = p5
        gkent3 = p6
	turnoff
        endin
</CsInstruments>

<CsScore>
; Table #1, a sine wave.
f 1 0 16384 10 1
f 3 0 1024 10 1
f 4 0 1024 10 1 ; amp
f 5 0 1024 10 1 ; freq

i1 0 180000
</CsScore>
</CsoundSynthesizer>

