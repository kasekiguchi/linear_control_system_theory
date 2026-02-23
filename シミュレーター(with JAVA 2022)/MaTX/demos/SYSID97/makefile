rtpend.exe: rtpend.o pinit.o hardware.o
	rtmatcc rtpend.o pinit.o hardware.o
	mv a.exe rtpend.exe

pend.exe: pend.o pinit.o hardware.o
	rtmatcc pend.o pinit.o hardware.o
	mv a.exe pend.exe

pinit.o: pinit.c
	-rtmatccc pinit.c

rtpend.o: rtpend.c
	-rtmatccc rtpend.c

rtpend.c: rtpend.mm
	rtmatc rtpend.mm

pend.o: pend.c
	-rtmatccc pend.c

pend.c: pend.mm
	rtmatc pend.mm

hardware.o: hardware.c
	-rtmatccc hardware.c

hardware.c: hardware.mm
	rtmatc hardware.mm
