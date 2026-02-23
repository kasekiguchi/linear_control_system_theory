
/* -*- MaTX -*-
 *
 *	The MaTX benchmarks
 *
 *	This demo file runs a set of 6 standard benchmarks:
 *
 *		1) N = 200 Real matrix multiply
 *		2) N = 200 Real matrix inverse
 *		3) N = 150 Real eigenvalues
 *		4) 2^17(=131072)-point complex FFT
 *		5) 100000 iteration FOR loop
 *		6) ode (ODE) 1.0[s]
 *
 *	The benchmarks illuminate computer architectural issues that
 *	affect the speed of software like MaTX on different machines.
 *
 *	The time for your machine is measured and displayed versus times
 *	we've already taken from other standard machines. 
 */

#ifdef __MATC__
Func void main()
{
	bench();
}
#endif

Func void bench()
{
	Integer i, j, number;
	Matrix a, b, merit, ts, js5;
	List data, yours;
	Index idx;

	void bench_ode(), bench_head(), bench_print_result();
	Real bench_timer();

	js5 =  [  3.34   3.20   4.74   3.00   4.03   6.90];
	
	data = {
		{"DEC AlphaServer 8400 5/440 437MHz",
		 "DEC Alpha 8400 5/440",
		 [  0.24   0.39   0.32   0.40   0.31   0.56  11.25]},
		{"Handmade Pentium II 450MHz, WinNT",
		 "Handmade PenII 450MHz",
		 [  0.27   0.27   0.44   0.60   0.27   0.49  10.88]},
		{"VT-Alpha 533S/U(Alpha21164A 533MHz), Digital Unix v.4.0D",
		 "VT-Alpah 533S/U",
		 [  0.42   0.34   0.37   0.41   0.39   0.61   9.67]},
		{"Gateway2000 GP6-400, PC100 (Linux 2.0.34)",
		 "Gateway2000 GP6-400",
		 [  0.31   0.30   0.42   0.66   0.37   0.57   9.59]},
		{"SONY VAIO PCV-S720 Pentium III 500MHz Win98",
		 "SONY VAIO PCV-S720",
		 [  0.38   0.38   0.66   0.71   0.27   0.49   8.82]},
		{"Gateway GP6-450, Win95 DJGPP",
		 "Gateway2000 GP6-450",
		 [  0.44   0.44   0.60   0.93   0.33   0.49   7.89]},
		{"Sun Ultra 2 Model 2300 (300MHz x 2)",
		 "Sun Ultra 2 2300",
		 [  0.40   0.35   0.64   0.47   0.52   0.87   7.78]},
		{"JCC JU10/333 (UltraSPARC-IIi 333MHz), Solaris 2.6",
		 "JCC JU10/333",
		 [  0.40   0.34   0.56   0.43   0.51   1.19   7.73]},
		{"Proside Pentium II 400MHz (Win95 OSR2.1)",
		 "Proside PenII400, DJGPP",
		 [  0.49   0.38   0.77   0.77   0.33   0.55   7.72]},
		{"Iiyama V300HC (Pentium II 300MHz, Windows95,DJGPP)",
		 "Iiyama VC300HC, DJGPP",
		 [  0.38   0.38   0.55   0.88   0.49   0.71   7.47]},
		{"MICRON Pro300 (Pentium Pro 300MHz, Solaris x86 2.5.1)",
		 "MICRON Pro300, Solaris",
		 [  0.33   0.42   0.51   0.80   0.50   0.93   7.37]},
		{"Gateway2000 G6-300 (Linux 2.0.30)",
		 "Gateway2000 G6-300",
		 [  0.38   0.39   0.51   0.96   0.49   0.75   7.36]},
		{"Comsatelite Pentium II 333MHz (WinNT4.0)",
		 "Comsatelite PenII333",
		 [  0.27   0.36   1.24   1.06   0.37   0.83   6.90]},
		{"SGI Origin2000 MIPS R10000 (IRIX 6.4 System V Release 4)",
		 "SGI Origin2000 (R10000)",
		 [  0.54   0.38   0.37   1.50   0.87   1.10   5.82]},
		{"Gateway2000 G6-333 (Win95, DJGPP-2.01)",
		 "Gateway2000 G6-333",
		 [  0.60   0.55   0.88   1.43   0.44   0.66   5.72]},
		{"Ultra10 UPA/PCI, UltraSPARC-IIi 300MHz (Solaris 2.5.1)",
		 "Sun Ultra10 300MHz",
		 [  0.55   0.38   0.63   0.98   0.76   1.31   5.66]},
		{"Handmade PenII 233MHz, Linux 2.0.30",
		 "Handmade PenII 233",
		 [  0.47   0.60   0.83   1.01   0.68   0.97   5.48]},
		{"Handmade Pro-200, Mem 64M, Linux 2.0.30",
		 "Handmade Pro-200",
		 [  0.67   0.89   0.69   1.40   0.75   1.14   4.52]},
		{"MICRON Pro200, Solaris x86 2.5.1",
		 "MICRON Pro200, Solaris",
		 [  0.66   0.96   0.70   1.14   0.75   1.38   4.48]},
		{"Gateway2000 G6-200 (Linux 2.0.3)",
		 "Gateway2000 G6-200",
		 [  0.66   1.05   1.08   1.47   0.69   1.16   4.11]},
		{"JCC JU1/170, Solaris 2.5",
		 "JCC JU1/170, Solaris",
		 [  0.76   0.72   1.10   1.05   0.89   1.70   4.05]},
		{"UltraSPARC 167MHz, Solaris 2.5",
		 "SPARC Ultra167",
		 [  0.76   0.69   1.14   1.25   0.87   1.55   4.02]},
		{"Let's note CF-S21 (MMX-200MHz, Linux 2.0.34, gcc2.7.2.3)",
		 "Let's note CF-S21",
		 [  0.99   1.34   1.90   1.78   0.70   1.32   3.17]},
		{"MICRON (Pentium 200MHz, Solaris x86 2.5.1)",
		 "MICRON 200, Solaris",
		 [  0.90   1.22   1.60   1.18   1.12   2.11   3.09]},
		{"JCC JP4 (PowerPC604-133)",
		 "JP4 (PowerPC604-133)",
		 [  1.16   1.18   1.09   2.35   0.99   1.47   3.06]},
		{"MMX 200MHz Linux 2.1.131-ac12, pgcc-1.1.1",
		 "MMX200, RedHat Linux",
		 [  1.02   1.33   1.62   1.77   0.77   1.72   3.06]},
		{"Sony VAIO PCG-505EX, (Win95 OSR2, VC++)",
		 "Sony VAIO PCG-505EX",
		 [  0.83   0.98   3.95   2.69   0.50   1.37   2.99]},
		{"Sony VAIO PCG-505EX, (Win95 OSR2, DJGPP)",
		 "Sony VAIO PCG-505EX",
		 [  0.88   1.15   3.79   2.52   0.50   1.43   2.91]},
		{"MMX 200MHz Linux kernel 2.0.36, pgcc-1.1.1",
		 "MMX200, RedHat Linux",
		 [  1.08   1.42   1.81   1.82   0.76   1.88   2.89]},
		{"MICRON Pro200 (PentiumPro 200MHz, Win95, DJGPP-2.01)",
		 "MICRON PRo200, DJGPP",
		 [  1.59   1.37   2.47   1.81   0.77   1.10   2.83]},
		{"JCC JH20/M151 (SunOS 4.1.4)",
		 "JCC JH20/M151, SunOS",
		 [  0.82   0.99   1.55   4.25   1.03   2.36   2.62]},
		{"Gateway2000 PG-166 (WinNT 4.0 SP3)",
		 "Gateway2000 P5-166",
		 [  0.81   1.16   4.53   2.04   0.79   2.49   2.51]},
		{"NEWS5000X(NEWS-OS 4.2.1R)",
		 "NEWS 5000X",
		 [  1.23   1.50   1.85   3.05   1.11   1.86   2.41]},
		{"IBM APTIVA 2176-H5F Pentium 150M, Win95, DJGPP",
		 "IBM APTIVA 2176-H5F",
		 [  1.32   1.48   2.14   2.25   1.10   2.20   2.39]},
		{"Canon Innova 3100CX P5-133 (Linux 2.0.30)",
		 "Canon Innova P5-133",
		 [  1.25   1.68   2.16   2.02   1.50   2.11   2.29]},
		{"JCC JP4 (PowerPC604-100)",
		 "JP4 (PowerPC604-100)",
		 [  1.62   1.63   1.62   2.59   1.34   2.38   2.22]},
		{"Gateway Solo P5-133 (Linux 2.0.30)",
		 "Gateway Solo P5-133",
		 [  1.46   1.90   2.21   2.59   1.50   2.39   2.05]},
		{"Let's NOTE 133 MHz, Mem 32M, (Linux 2.0.30)",
		 "Let's NOTE 133, Linux",
		 [  1.29   2.18   2.31   3.19   1.22   2.35   2.04]},
		{"SparcStation2 + TurboSparc 170MHz, SunOS 4.1.4",
		 "TurboSparc 170MHz",
		 [  1.16   1.42   1.81   5.47   1.13   3.30   2.03]},
		{"Gateway2000 P5-120 (Solaris x86 2.5.1)",
		 "Gateway2000 P5-120",
		 [  1.49   1.95   2.43   2.27   1.45   2.94   1.99]},
		{"ThinkPad 535 120 MHz (FreeBSD 2.2.2-R)",
		 "ThinkPad 535 120 MHz",
		 [  1.59   2.13   2.81   2.48   1.54   4.49   1.72]},
		{"SPARC station 10 Model 60 (Solaris 2.6)",
		 "SPARC staion 10 M60",
		 [  1.58   1.79   2.87   3.49   1.94   4.01   1.64]},
		{"Gateway2000 P5-100 (FreeBSD 2.2.7-R)",
		 "Gateway2000 P5-100",
		 [  2.08   2.22   3.28   2.23   1.87   4.92   1.54]},
		{"Gateway2000 P5-90 (Linux 2.0.30)",
		 "Gateway2000 P5-90",
		 [  1.93   3.32   3.51   3.98   1.77   3.46   1.41]},
		{"JS5/110 (Micro SPARC 110MHz, SunOS 4.1.4)",
		 "JCC JS5/110, SunOS",
		 [  2.31   2.16   3.11   2.42   3.13   5.79   1.36]},
		{"Macintosh G3 MT 333, Mem 384M, Mac OS 8.5 (Soft Win98)",
		 "Macintosh G3 MT 333",
		 [  3.29   2.85   6.27   2.53   2.25   3.57   1.23]},
		{"Gateway2000 P5-100 (WinNT 4.0, DJGPP-2.01)",
		 "Gateway2000 P5-100",
		 [  3.08   2.36   3.57   4.29   2.97   4.34   1.20]},
		{"Mebius Note 590CD-95 (Win98, DJGPP-2.01)",
		 "Mebius 590-95(DJGPP)",
		 [  3.13   3.41   4.73   5.16   2.38   4.62   1.07]},
		{"Mebius Note 575CD-95 (DOS 6.3, DJGPP-2.01)",
		 "Mebius 575-95(DJGPP)",
		 [  2.64   3.24   4.84   3.74   3.02   6.10   1.07]},
		{"Mebius Note 575CD-95 (LINUX 2.0.30)",
		 "Mebius 575-95(Linux)",
		 [  2.25   3.39   4.51   4.48   3.71   6.34   1.03]},
		{"Gateway2000 P5-60 (Solaris x86 2.5.1)",
		 "Gateway2000 P5-60",
		 [  2.57   3.88   4.98   4.31   2.95   6.21   1.01]},
		{"JS5/70 (Micro SPARC 70MHz, SunOS 4.1.4)",
		 "JCC JS5/70, SunOS",
		 [  3.34   3.20   4.74   3.00   4.03   6.90   1.00]},
		{"Akia Tordade509, Pentium 90MHz,(Win95)",
		 "Akia Tordade509",
		 [  2.96   3.19   8.74   7.91   1.48   5.27   0.97]},
		{"SPARC station 10 Model 30 (SunOS 4.1.3)",
		 "SPARC staion 10 M30",
		 [  3.43   3.74   5.52   3.31   3.37   6.61   0.97]},
		{"SPARC station IPX + Weitek (SunOS 4.1.4)",
		 "SPARC IPX + Weitek",
		 [  5.10   5.38   6.40   7.06   3.20   8.63   0.71]},
		{"SPARC station IPX (SunOS 4.1.4)",
		 "SPARC staion IPX",
		 [  7.45   7.60  11.31   7.48   5.66  10.95   0.49]},
		{"SPARC station 2 (SunOS 4.1.3)",
		 "SPARC staion 2",
		 [  7.29   7.52  11.54   7.71   5.95  10.26   0.49]},
		{"SPARC Classic (SunOS 4.1.4)",
		 "SPARC Classic",
		 [  8.10   7.82  12.28   4.98   6.33  18.39   0.46]},
		{"JCC Classic (SunOS 4.1.4)",
		 "JCC Classic, SunOS",
		 [  8.13   7.90  12.52   5.54   7.69  18.72   0.43]},
		{"SPARC station IPC (SunOS 4.1.3)",
		 "SPARC station IPC",
		 [ 14.32  15.50  24.37  10.93   9.93  17.70   0.27]},
		{"SPARC station 1 (SunOS 4.1.4)",
		 "SPARC station 1",
		 [ 17.25  18.75  29.46  13.11  11.44  19.98   0.23]},
		{"Handmade PC AMD K6-2-450(450MHz), Mem 128M, Win95 DJGPP",
		 "AMD K6-2-450, DJGPP",
		 [  0.38   0.38   0.66   1.32   0.27   0.55   7.76]},
		{"Handmade PC AMD K6-2-450(500MHz), Mem 128M, Win95 DJGPP",
		 "AMD K6-2-500, DJGPP",
		 [  0.38   0.38   0.55   1.26   0.27   0.49   8.19]},
		{"Handmade PC Rise mP6-266(200MHz), Mem 128M, Win95 DJGPP",
		 "Rise mP6-266, DJGPP",
		 [  0.71   0.82   1.48   1.15   0.82   1.43   3.91]},
		{"HandMade Celeron300A(450MHz), WinNT, VC++",
		 "Celeron-450, WinNT",
		 [  0.33   0.40   0.84   0.51   0.25   0.53   9.08]},
		{"Gateway 2000 P5-166 (Linux 2.0.34(Debian JP)",
		 "P5-166, Linux", 
		 [  1.21   1.62   2.41   1.92   1.28   2.64   2.27]},
		{"SPARC SUNW,Ultra-60, SunOS5.5.1",
		 "SPARC Ultra-60",
		 [  0.33   0.29   0.51   0.39   0.44   1.04   8.86]},
		{"Handmade Pentium III 500MHz WinNT sp4 ",
		 "PenIII 500, WinNT",
		 [  0.22   0.27   0.38   0.55   0.27   0.44  11.83]},
		{"Thinkpad 1456, Celeron 366MHz, Mem 128M, Vine 1.1+2.2.8",
		 "Thinkpad 1456, Linux",
		 [  0.66   0.79   0.66   1.62   0.43   0.73   5.40]},
		{"DELL, Pentium III 550MHz, Solaris7 x86",
		 "DELL550, Solaris7",
		 [  0.18   0.25   0.28   0.55   0.29   0.69  12.04]},
		{"DELL, Pentium III 550MHz, Linux 2.2.9 (TurboLinux4.0)",
		 "DELL550, Linux2.2.9",
		 [  0.20   0.27   0.39   0.57   0.28   0.57  11.41]},
		{"P2B-VM 8M, Pentium III 550MHz, WinNT4.0(SP5)",
		 "PenIII550, WinNT4.0",
		 [  0.13   0.22   0.72   0.56   0.23   0.50  12.12]},
		{"Handmade Pentium III Xeon 550MHz Dual, Solaris7 x86",
		 "Xeon550, Solaris7",
		 [  0.17   0.20   0.26   0.49   0.30   0.67  13.01]},
		{"Let's note CF-A77J8, Celeron 300MHz, Vine 1.1",
		 "Let's A77, Linux",
		 [  0.69   0.95   0.56   1.03   0.53   1.07   5.20]},
		{"Compaq AlphaServer DS20 Alpha 500MHz, Tru64-Unix 4.0F",
		 "Compaq500, Tru64-Unix",
		 [  0.10   0.14   0.14   0.30   0.20   0.37  21.39]},
		{"DELL XPS T450, Pentium III 450MHz, Vine 1.1",
		 "DEL T450, Linux",
		 [  0.28   0.33   0.36   0.72   0.35   0.77   9.32]},
		{"Let's note CF-M1V, Celeron 333MHz, Laser5 6.0",
		 "Let's CF-M1V, Linux",
		 [  0.65   0.94   0.52   1.12   0.48   1.04   5.36]},
		{"Let's note CF-M1R, Pentium III 400MHz, Solaris 7 x86",
		 "Let's CF-M1R, Solaris",
		 [  0.37   0.56   0.37   0.54   0.44   0.94   7.92]},
		{"Let's note CF-M1R, Pentium III 400MHz, Win98 DJGPP",
		 "Let's CF-M1R, DJGPP",
		 [  0.44   0.60   0.33   0.49   0.44   0.71   8.23]},
		{"Handmade AMD K6-III-450, Win98 (DJGPP)",
		 "AMD K6-III-450, DJGPP",
		 [  0.27   0.38   0.60   0.99   0.38   0.49   8.40]},
		{"Handmade AMD K6-III-450, Win98 (VC++)",
		 "AMD K6-III-450, VC++",
		 [  0.33   0.50   1.10   1.15   0.27   0.71   6.88]},
		{"ASUS P3B-F Pentium III 600MHz, Win98 SE, VC++6.0",
		 "ASUS P3B-F, VC++",
		 [  0.55   0.22   0.55   0.66   0.22   0.61   9.46]},
		{"NEC VersaPro NX VA40D(Pentium II 400MHz), TurboLinux4.2",
		 "VersaPro NX VA40D, Linux",
		 [  0.39   0.78   0.45   0.94   0.38   0.76   6.96]},
		{"NEC VersaPro NX VA40D(Pentium II 400MHz), Win98, VC++6.0",
		 "VersaPro NX VA40D, VC++",
		 [  0.93   0.60   0.88   1.21   0.33   0.88   5.39]},
		{"VT-Alpha 667 (21264 667MHz), True64 Unix V4.0",
		 "VT-Alpha 667",
		 [  0.09   0.14   0.12   0.26   0.15   0.33  24.47]},
		{"DELL DIMENSION V400, Mem 256M, Win98, VC++5.0",
		 "DELL V400",
		 [  0.28   0.33   0.93   0.82   0.33   0.94   7.60]},
		{"SONY PCG-Z505N_BP(J), DJGPP",
		 "PCG-Z505N_BP",
		 [  0.44   0.49   0.27   1.04   0.38   0.66   8.03]},
		{"EPSON TC500M, Celeron 500MHz, Vine 1.1",
		 "EPSON TC500M",
		 [  0.51   0.58   0.35   0.73   0.32   0.67   7.99]},
		{"DELL DIMENSION V400, Mem 256M, Win2000",
		 "DELL V400, Win2000",
		 [  0.28   0.33   0.93   0.82   0.33   0.94   7.60]},
		{"DELL DIMENSION V400, Mem 256M, Laser5 6.0R2",
		 "DELL V400, Linux",
		 [  0.28   0.39   0.45   0.61   0.37   0.76   8.91]},
		{"Sharp PC-PJ2-X4, PenII 333MHz, Mem 128M, Win98, DJGPP",
		 "PC-PJ2-X4, DJGPP",
		 [  0.49   0.66   0.44   0.71   0.49   0.93   6.69]},
		{"SHARP MN-450-H23, Linux 2.2.13, egcs-2.91.66",
		 "MN-450-H23, Linux",
		 [  0.58   0.75   0.83   1.36   0.67   1.42   4.56]},
		{"Gateway PIII-700, Linux 2.2.13, egcs-2.91.66",
		 "Gateway PIII-700",
		 [  0.31   0.42   0.22   0.52   0.22   0.41  12.10]},
		{"Gateway GP7-450, Windows 98, VC++",
		 "Gateway GP7-450",
		 [  0.22   0.27   0.99   0.82   0.27   0.88   8.47]},
		{"COMPAQ PRESARIO 1919 (Celeron 300MHz), Win98",
		 "COMPAQ PRESARIO 1919",
		 [  1.10   1.21   1.81   1.27   0.44   1.21   3.71]},
		{"IBM ThinkPad 560E, Win95, VC++",
		 "ThinkPad 560E",
		 [  1.21   1.60   4.55   2.47   0.72   2.14   2.24]},
		{"Sun Enterprise 450 (Ultra Sparc 400MHz) Solaris 7",
		 "Sun Enterprise 450",
		 [  0.30   0.26   0.46   0.37   0.42   0.98   9.58]},
		{"Micron Millennia Pro2 Plus, Win95 VC++6.0",
		 "Micron Millennia",
		 [  0.72   1.26   2.91   2.64   0.66   1.81   2.82]},
		{"DELL, Pentium III 450MHz, FreeBSD 3.4-Release",
		 "DELL FreeBSD",
		 [  0.25   0.28   0.46   0.51   0.38   0.91   9.55]},
		{"Dell Inspiron3200, Memory 80Mb, Win98",
		 "DELL Win98",
		 [  0.66   0.55   1.53   1.32   0.55   1.54   4.35]},
		{"Handmade (Pentium III Xeon 500MHz), Linux Laser5 Rel.2",
		 "Handmade Xeon",
		 [  0.19   0.24   0.35   0.71   0.28   0.61  11.78]},
		{"Handmade (Pentium III Xeon 500MHz), WinNT Ver 4.0 SPS",
		 "Handmade Xeon",
		 [  0.11   0.16   0.27   0.60   0.33   0.71  13.47]},
		{"SOTEC WINBOOK EAGLE/X",
		 "SOTEC WINBOOK",
		 [  0.60   0.93   0.49   0.93   0.60   1.04   5.43]},
		{"FUJITSU FMV 6500DX4, Vine 2.0CR",
		 "FMV 6500DX4",
		 [  0.20   0.28   0.38   0.59   0.29   0.71  10.85]},
		{"DELL Optiplex GXMT 5166, Vine 2.0CR",
		 "DELL 5166",
		 [  1.49   1.58   2.25   2.42   1.98   6.39   1.72]},
		{"DELL Optiplex XMT 5133, Vine 2.0CR",
		 "DELL 5133",
		 [  1.60   2.62   2.85   3.66   1.84   4.57   1.50]},
		{"Gateway 2000 P5-133, Vine 2.0CR",
		 "Gateway P5-133",
		 [  1.54   2.03   2.45   2.33   1.62   4.18   1.81]},
		{"Akia MicroBook Giga GM301/86-DR, Vine 2.0",
		 "Akia GM301/86",
		 [  0.38   0.40   0.20   1.01   0.17   0.35  11.50]},
		{"Akia MicroBook Giga GM301/86-DR, Win98, VC++6",
		 "Akia GM301/86",
		 [  0.82   0.66   0.38   1.10   0.17   0.38   8.13]},
		{"Handmade, AMD Athlon 700MHz, 128MSDRAM, Win98, DJGPP",
		 "Athlon 700MHz",
		 [  0.16   0.11   0.22   0.82   0.16   0.33   16.95]},
		{"Handmade, AMD Athlon 800MHz, 128MSDRAM, Win98, DJGPP",
		 "Athlon 800MHz",
		 [  0.11   0.11   0.16   0.71   0.16   0.27   20.08]},
		{"Handmade, AMD Athlon 800MHz, 128MSDRAM, Win98, VC++6",
		 "Athlon 800MHz",
		 [  0.72   0.16   0.50   0.77   0.11   0.39   11.42]},
		{"FMV-DESKPOWER T20, 96MB, Win95, DJGPP",
		 "FMV T20",
		 [  1.15   1.59   2.09   1.76   1.48   5.99    2.03]},
		{"FMV-6300T7A, PenII 300MHz, 128MB, WinNT 4.0, DJGPP",
		 "FMV-6300T7A",
		 [  0.33   0.38   0.49   0.99   0.55   1.37    6.70]},
		{"Handmade AMD Athlon 650MHz, 256MBSDRAM, Win2000",
		 "Athlon 650MHz",
		 [  0.18   0.12   0.51   0.83   0.15   0.43   13.87]},
		{"GRANPOWER5000 model 380, 256MB, PenIII 600MHz, WinNT 4.0, DJGPP",
		 "GRANPOWER5000",
		 [  0.44   0.49   0.22   0.77   0.27   0.55    9.56 ]},
		{"Handmade Pentium III Xeon 550MHz Dual, Solaris7 x86 + lxrun",
		 "Xeon550, lxrun",
		 [  0.17   0.22   0.32   0.53   0.27   0.53   12.92]},
		{"FMV-6200T5(PentiumPro 200MHz, 96MB, FreeBSD 2.2.8-RELEASE)",
		 "FMV-6200T5",
		 [  0.76   1.05   1.48   1.21   0.83   2.13    3.45]},
		{"GRANPOWER5000 model270S, PentiumII 266MHz, 192MB, redhat Linux 5.2)",
		 "GRANPOWER5000",
		 [  0.43   0.60   0.73   1.27   0.59   1.38    5.28]},
		{"ThinkPad 235 (MMX Pentium 233MHz), Win98, DJGPP",
		 "ThinkPad 235",
		 [  0.71   1.54   1.54   3.08   0.77   2.25    2.79]},
		{"DELL Inspiron 5000, Mobile Celeron 500MHz, Windows 98SE, VC6",
		 "Inspiron 5000",
		 [  0.44   0.44   0.94   0.72   0.27   0.66   7.52]},
		{"DELL Inspiron 2000, Mobile Pentium III 400MHz, Windows 2000, VC6",
		 "Inspiron 2000",
		 [  0.99   0.39   0.88   0.66   0.33   0.77   6.48]},
		{"Sun Ultra30 creator 3D, Solaris 2.6",
		 "Ultra30",
		 [  0.43   0.40   0.62   0.60   0.53   1.34   6.73]},
		{"Sun Ultra1 creator 3D, Solaris 2.6",
		 "Ultra1",
		 [  0.69   0.61   1.08   1.00   0.95   2.45   3.98]},
		{"Sun SPARC Station 20, Solaris 2.6",
		 "SPARC Station 20",
		 [  1.42   1.73   2.75   3.32   2.15   7.53   1.51]}
	};

	number = length(data);
#if 0
	for (i = 1; i <= number; i++) {
		times = data(i,3,Matrix);
		fprintf("bench.dat","\t{\"%s\",\n\t\"%s\",\n" +
				"\t[%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f]},\n",
				data(i,1,String), data(i,2,String),
				times(1), times(2), times(3),
				times(4), times(5), times(6),
				times(7));
	}
#endif
	merit = Z(1,number);
	for (i = 1; i <= number; i++) {
		merit(i) = [data(i,3,Matrix)](7);
	}
	idx = fliplr({sort(merit)}(1,2,Index));
	data = data(idx);

	clear;

	print "\n";
	print "This demo file runs a set of 6 benchmarks:\n";
	print "\n";
	print "    1) N = 200 Real matrix multiply\n";
	print "    2) N = 200 Real matrix inverse\n";
	print "    3) N = 150 Real eigenvalues\n";
	print "    4) 2^17(=131072)-point complex FFT\n";
	print "    5) 100000 iteration FOR loopn\n";
	print "    6) ode (ODE) 1.0[s]\n";
	print "\n";
	print "It will take a few minutes.\n\n";

	pause "Hit any key to start benchmark measurements";

	ts = Z(1,7);

	// Print header of benchmark result
	bench_head(1);

	// 100 by 100 real multiply
	a = rand(200);
	bench_timer(0);
	b = a*a;
	ts(1) = bench_timer(1);
	printf("   %6.2f", ts(1));
 
	// N = 200  real inverse
	bench_timer(0);
	b = a~;
	ts(2) = bench_timer(1);
	printf("   %6.2f", ts(2));

	// N = 150 real eigenvalues
	a = rand(150);
	bench_timer(0);
	b = eigval(a);
	ts(3) = bench_timer(1);
	printf("   %6.2f", ts(3));

	// 2^17 point complex FFT
	a = rand(1,2^17) + (0,1)*Array(ONE(1,2^17));
	bench_timer(0);
	b = fft(Array(a));
	ts(4) = bench_timer(1);
	printf("   %6.2f", ts(4));

	// 100000 FOR loops
	a = Z(1,100000);
	bench_timer(0);
	for (i = 1; i <= 100000; i++) {
		a(i) = 1;
	}
	ts(5) = bench_timer(1);
	printf("   %6.2f", ts(5));

	// ode 1[s]
	bench_timer(0);
	bench_ode();
	ts(6) = bench_timer(1);
	printf("   %6.2f", ts(6));

	// merit
	ts(7) = prod(Array(js5./ts(1:6)))^(1.0/6);
	printf("   %6.2f", ts(7));

	print "\n\n\n\n";
	print "  **************************************************************\n";
	print "  * Please report the benchmark result of you machine          *\n";
	print "  * (computer, OS, compiler) to                                *\n";
	print "  *                                                            *\n";
	print "  *  matx-info@matx.org                                        *\n";
	print "  *                                                            *\n";
	print "  * The result is included to the benchmark table.             *\n";
	print "  **************************************************************\n";
	print "\n\n";
	pause;

	yours = {"Your machine", "Your machine", ts};

	print "  ------- Table of benchmark times -------\n";

	for (i = 0; i < number/7; i++) {
		clear;
		if (i == number/7 - 1) {
			print "      ------- Table of benchmark times -------\n\n";
		} else {
			print "      ----- Table of benchmark times (continues) -----\n\n";
		}
		bench_print_result(data, 1+i*7, (i+1)*7, yours);
		print "\n";
		pause;
	}

	clear;
	
	for (i = 0; i < number/16; i++) {
		print "To combine these numbers into a single 'figure of merit'\n";
		print "for each machine, we compute the geometric mean.\n";
		print "Here are the results: \n\n";

		for (j = i*16+1; j <= min(number-1,(i+1)*16); j++) {
			printf("%-24s: %6.2f", data(j,2,String), [data(j,3,Matrix)](7));
			if (16 < number && j < number - 16) {
				printf("         %-24s: %6.2f",
					   data(j+16,2,String), [data(j+16,3,Matrix)](7));
			}
			print "\n";
		}
		printf("\n%s: %6.2f\n\n", yours(2,String), [yours(3,Matrix)](7));
		pause;
		clear;
	}
}

Func void bench_print_result(data, n1, n2, yours)
	List data;
	Integer n1, n2;
	List yours;
{
	Integer i, number;
	List computers, results;
	Matrix result, result_y;

	void bench_head();

	number = length(data);
	computers = data(Index([1:number]),1);
	results = data(Index([1:number]),3);

	for (i = n1; i <= min(n2,number-1); i++) {
		printf("      %2d) %s\n", i, computers(i, String));
	}
	printf("       *) %s\n\n", yours(1, String));

	bench_head(2);
	for (i = n1; i <= min(n2,number-1); i++) {
		result = results(i,Matrix);
		printf("      %2d)  %6.2f   %6.2f   %6.2f   %6.2f   %6.2f   %6.2f   %6.2f\n",
			   i, result(1), result(2), result(3),
			   result(4), result(5), result(6), result(7));
			   
	}

	result_y = yours(3, Matrix);
	printf("       *)  %6.2f   %6.2f   %6.2f   %6.2f   %6.2f   %6.2f   %6.2f\n",
		   result_y(1), result_y(2), result_y(3),
		   result_y(4), result_y(5), result_y(6), result_y(7));
		   
}

Func void bench_head(i)
	Integer i;
{
	if (i == 1) {
		clear;
		print "\nBenchmarks:  ";
		print "     *      inv      eig      fft      for      ode    merit\n";
		print "\n          ";
	} else if (i == 2) {
		print "                *      inv      eig      fft      for";
		print "      ode    merit\n\n";
	}
}

Func void bench_ode()
{
	Real t1,dtsav,h;
	Matrix x0,TC,XC,UC;

	void bench_diff_eqs(), bench_link_eqs();

	h = 1.0E-3;
	dtsav = 1.0E-2;
	t1 = 1.0;
	x0 = [1,0,0]';

	{TC, XC, UC} = Ode(0.0, t1, x0,
					   bench_diff_eqs, bench_link_eqs, h, dtsav);
}

Func void bench_diff_eqs(DX, t, X, UY)
	Real t;
	Matrix X, DX, UY;
{
	Matrix xp, up, dxp;
	static Integer init_flag;
	static Matrix A, B;
	
	if (init_flag == 0) {
		init_flag = 1;
		A = [[0,1,0]
			 [0,0,1]
			 [0,0,0]];
		B = [0,0,1]';
	}

	xp = X;
	up = UY;
	dxp = A*xp + B*up;
	DX = [dxp];
}

Func void bench_link_eqs(UY, t, X)
	Real t;
	Matrix UY, X;
{
	Matrix xp,up;
	static Integer init_flag;
	static Matrix F;
	
	if (init_flag == 0) {
		init_flag = 1;
		F = [-1,-2,-3];
	}

	xp = X;
	up = F*xp;
	UY = [up];
}

Func Real bench_timer(flag)
	Integer flag;
{
#ifdef USE_CLOCK
	static Real start_time;
	
	if (flag == 0) {
		start_time = [clock()](6);
		return 0.0;
	} else {
		return [clock()](6) - start_time;
	}
#else
	if (flag == 0) {
		settimer();
		return 0.0;
	} else {
		return gettimer();
	}
#endif
}
