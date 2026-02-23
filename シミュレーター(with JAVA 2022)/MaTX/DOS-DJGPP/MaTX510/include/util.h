
/*
 *
 * Copyright (C) 1989, 1990, 1991 Masanobu Koga
 *            All Rights Reserved.
 *
 * No part of this software may be used, copied, modified, and distributed
 * in any form or by any means, electronic, mechanical, manual, optical or
 * otherwise, without prior permission of Masanobu Koga.
 *
 */

/*
  util.h : 

  $Author: koga $
  $Revision: 1.4 $
  $Date: 1994/06/21 13:21:43 $
  $Log: util.h,v $
 * Revision 1.4  1994/06/21  13:21:43  koga
 * *** empty log message ***
 *
 * Revision 1.3  1992/03/25  12:20:17  koga
 * Optimization
 *
*/

#ifndef util_header
#define util_header

#ifdef MSC60
#pragma optimize( "t", off )
#endif

#ifdef MACINTOSH
#define MATX_RINT
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_LOG2
#define MATX_DRAND48
#endif

#ifdef LINUX
#define MATX_LOG2
#endif

#ifdef NEWS_OS_421
#define MATX_LOG2
#define MATX_DRAND48
#endif

#ifdef X68K
#define MATX_LOG2
#define MATX_RINT
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#endif

#ifdef BSD44
#define MATX_LOG2
#define MATX_DRAND48
#endif

#ifdef NEWS
#define	MATX_LOG2
#define MATX_EXP10
#define MATX_DRAND48
#endif

#ifdef MIPS
#define MATX_LOG2
#define MATX_DRAND48
#endif

#ifdef BSD42
#define	MATX_LOG2
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#endif

#ifdef SOLARIS
#define	MATX_LOG2
#endif

#ifdef IRIX
#define	MATX_LOG2
#endif

#ifdef SYSV
#define MATX_EXP10
#define MATX_LOG2
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#endif

#ifdef TRC15
#define	MATX_LOG2
#define MATX_EXP10
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#endif

#ifdef BRC20
#define	MATX_LOG2
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#endif

#ifdef MSC40
#define	MATX_LOG2
#define MATX_EXP10
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#endif

#ifdef MSC60
#define	MATX_LOG2
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#endif

#ifdef VXWORKS
#define MATX_RAND
#define MATX_DRAND48
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_RINT
#define MATX_ATOI
#define MATX_ATOF
#endif

#ifdef WATCOM
#define MATX_RINT
#define MATX_DRAND48
#endif

#ifdef VC40
#define MATX_RINT
#define MATX_ASINH
#define MATX_ACOSH
#define MATX_ATANH
#define MATX_LOG2
#define MATX_DRAND48
#endif

#ifdef __DJGPP__
#define MATX_RINT
#define MATX_DRAND48
#endif

#ifdef	EPS
#undef	EPS
#endif
#define EPS			MATX_EPS

#define MATX_EPS	matx_eps

#ifdef NaN
#undef NaN
#endif
#define	NaN			(get_nan())

#ifdef Inf
#undef Inf
#endif
#define	Inf			(get_infinity())

#ifndef HAVE_NO_PID
#define	PID			(getpid())
#else
#define	PID			0
#endif

#ifdef PI
#undef PI
#endif
#define PI			3.14159265358979323846

#ifndef max
#define max(a,b)	((a) > (b) ? (a) : (b))
#endif
#ifndef min
#define min(a,b)	((a) < (b) ? (a) : (b))
#endif

extern volatile double matx_eps;

void	*emalloc();
void	*erealloc();
void	efree();

void	bell();
void	print_time();

#ifdef MATX_EXP10
double	exp10();
#endif
#ifdef MATX_LOG2
double	log2();
#endif
#ifdef MATX_DRAND48
double	drand48();
#endif
double	randu();
double	randn();
#ifdef MATX_RINT
double	rint();
#endif
double	factorial();
int		int_factorial();
#ifdef MATX_ASINH
double	asinh();
#endif
#ifdef MATX_ACOSH
double	acosh();
#endif
#ifdef MATX_ATANH
double	atanh();
#endif
double	fix_to_zero();
double	round_to_zero();
double	get_infinity();
double	get_nan();

long	randu_seed();
long	randn_seed();
long	srandu();
long	srandn();

int		isFinite();
int		isNaN();
int		isInf();
double	matxPower();
int		echo2();
int		one_getch();
void	kbhit_init();
void	kbhit_term();
#ifndef HAVE_HBKIT
int		kbhit();
#endif

int		get_int();
double	get_double();
void	pause_sleep();
char	*matx_itoa();
char	*ftoa();
double	real_sgn();
int		int_sgn();
int		IntegerFileSave();
int		IntegerWrite();
int		IntegerRead();
int		IntegerReadContent();
int		IntegerInput();
int		IntegerEdit();
void	RealPrint();
char	*RealToString();
int		RealFileSave();
double	RealEdit();
double	RealInput();
double	RealWrite();
int		RealRead();
int		RealReadContent();
int		ReadDataHead();
void	WriteDataHead();
#ifdef HAVE_STDARG
int		aFilePrintf(char *filename, ...);
#else
int		aFilePrintf();
#endif
int		FileOpen();
int		FileClose();
int		FileIsOpen();
void	FileFlush();
int		FileEOF();
#ifndef WATCOM
FILE		*FilePointer();
#endif
#ifdef HAVE_STDARG
int		FilePrintf(int fd, ...);
#else
int		FilePrintf();
#endif

int		FileAccess();

#ifdef HAVE_PIPE
int		ProcessOpen();
int		ProcessClose();
#ifdef VC40
int		WindowFind();
#endif
#endif

int		set_string();
char	*get_string();
char	*get_next_string();
int		sgetc();
int		unsgetc();

void	util_settimer();
double	util_gettimer();

void	util_disp_move();

int		machine_type_get();
int		machine_endian_get();
int		machine_type_check();
short	flip_short_byte_order();		
long	flip_long_byte_order();		
double	flip_double_byte_order();
float	flip_float_byte_order();

int		system_matx();

#ifdef MATX_ATOF
double	atof();	/* String conversion function in the standard library */
#endif

double	matx_version();

int matx_remove(), matx_mkdir();

#endif

void mxUtilError();

/* ---------------------------------------------------------------------------
void 	*emalloc(unsigned int size);
void 	*erealloc(char *ptr, unsigned int size);
void	efree(char *ptr);
void	bell(int count);
void	print_time(FILE *fp);
void	printspace(int count);
double	real_sgn(double a);
int		int_sgn(int a);
double	matxPower(double x, double y);
double	exp10(double d);
double	factorial(double d);
int		int_factorial(int i);
double	rint(double d);
int		echo2(int switch);
int		one_getch();
int		kbhit();
void	kbhit_init();
void	kbhit_term();
int		get_int(int d, int cr);
double	get_double(double d, int cr);
double	get_infinity();
double	get_nan();
int		isFinite(double d);
int		isNaN(double d);
int		isInf(double d);
void	pause_sleep(char *mess, double sec);
char	*matx_itoa(int i);
char	*ftoa(double d);
int		IntegerFileSave(int a, char *filename, int append, int cr);
int		IntegerWrite(int in, FILE *fp, char *name);
int		IntegerRead(int *in, FILE *fp, char *name);
int		IntegerInput(char *name);
int		IntegerEdit(int a, char *name);
int		IntegerReadContent(int *in, FILE *fp, int flip);
void	RealPrint(double a, char *name);
char	*RealToString(double a, char *str, char *fmt);
int		RealFileSave(double a, char *filename, int append, int cr);
doubel	RealInput(char *name);
doubel	RealEdit(double a, char *name);
double	RealWrite(double rn, FILE *fp, char *name);
int		RealRead(double *rn, FILE *fp, char *name);
int		RealReadContent(double *rn, FILE *fp, int flip);
int		ReadDataHead(MatrixData *mx, FILE *fp);
void	WriteDataHead(FILE *fp);
int		aFilePrintf(char *filename, char *format, ...);
int		FileOpen(char *path, char mode);
int		FileClose(int fd);
int		FileIsOpen(int fd);
void	FileFlush(int fd);
int		FileEOF(int fd);
#ifndef WIN32
FILE	*FilePointer(int fd, int rw);
#endif
int		FilePrintf(int fd, char *format, ...);

int		FileAccess(char *file, char *mode);

int		ProcessOpen(char *command);
int		ProcessClose(int fd);
#ifdef VC40
int		ProcessFind(char *name);
#endif
int		set_string(char *str);
char	*get_string();
char	*get_next_string();
int		sgetc();
int		unsgetc();
double	fix_to_zero(double d);
double	round_to_zero(double d, double tol);
void	util_settimer();
double	util_gettimer();

void	util_disp_move(int y, int x);

int		system_matx(char *cmd_line);

double	matx_version(double v);

int matx_remove(char *path);
int matx_mkdir(char *path);

void mxUtilError(func, statement, err_warn);

---------------------------------------------------------------------------- */

