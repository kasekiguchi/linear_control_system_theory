RTMATC=rtmatc -v

rtpend.exe: rtpend.obj pinit.obj hardware.obj
	$(RTMATC) rtpend.obj pinit.obj hardware.obj

simple.exe: simple.obj pinit.obj hardware.obj
	$(RTMATC) simple.obj pinit.obj hardware.obj

pinit.obj: pinit.c
	$(RTMATC) -c pinit.c

rtpend.obj: rtpend.c
	$(RTMATC) -c rtpend.c

rtpend.c: rtpend.mm
	$(RTMATC) -mm rtpend.mm

simple.obj: simple.c
	$(RTMATC) -c simple.c

simple.c: simple.mm
	$(RTMATC) -mm simple.mm

hardware.obj: hardware.c
	$(RTMATC) -c hardware.c

hardware.c: hardware.mm
	$(RTMATC) -mm hardware.mm

