
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
  complex.h : 

  $Author: koga $
  $Revision: 2.3 $
  $Date: 1992/06/10 12:18:54 $
  $Log: complex.h,v $
 * Revision 2.3  1992/06/10  12:18:54  koga
 *  Optimization
 *
 * Revision 2.2  1992/03/25  12:07:42  koga
 * *** empty log message ***
 *
*/

#ifndef complex_header
#define complex_header

#include <matxconf.h>

#define	COMP_TMP					0
#define	COMP_VAR					1
#define COMP_LIST					2
#define COMP_MATX					3

#define COMP_NULL					CompDef("", 0.0, 0.0)
#define COMP_DEF					CompSetType(COMP_NULL, COMP_VAR)
#define COMP_STC					CompSetType(COMP_NULL, COMP_MATX)

#define	CompGetClass(a)			((a)->class)
#define	CompClass(a)			CompGetClass(a)
#define	CompGetType(a)			((a)->type)
#define	CompType(a)				CompGetType(a)
#define	CompGetName(a)			((a)->name)
#define	CompName(a)				CompGetName(a)

#define CompIsVar(a)			(CompType(a) == COMP_VAR)
#define CompIsTmp(a)			(CompType(a) == COMP_TMP)

#define CompIsSameClass(a, b)	(CompClass(a) == CompClass(b))

#define CompErrorName(a)		(a)->name, (a)->real, (a)->imag

typedef struct __Complex _Complex, *Complex;
  
struct __Complex {
	char  *name;	/* Name of Complex             */	
	int    type;	/* Data Type ( VAR, TMP )      */
	double real;	/* Real Part                   */
	double imag;	/* Imaginary Part              */
	Complex prev;	/* To link to previous Complex */
	Complex next;	/* To link to nest Complex     */
};

typedef struct __ComplexValue _ComplexValue, *ComplexValue;

struct __ComplexValue {
	double real;	/* Real Part                   */
	double imag;	/* Imaginary Part              */
};

#define CompRealPart(a)		((a)->real)
#define CompImagPart(a)		((a)->imag)
#define	CompIsZero(a)		((a)->real == 0.0 && (a)->imag == 0.0)
#define	CompIsEqual(a,b)	((a)->real == (b)->real && (a)->imag == (b)->imag)
#define	CompIsNotEqual(a,b)	((a)->real != (b)->real || (a)->imag != (b)->imag)

#define COMP_ERR_LENGTH 256

extern char	*complex_err_src;				/* Error source code */

/* ------------------------------------------------------------------------- */
void 		CompError();
void 		CompError2();
void 		CompWarning();
void 		CompWarning2();
void		CompUndefCheck();
void		CompUndefCheck2();
void		CompInit();
void		CompFree();
void		CompFrees();
void		CompInstall();
void		CompDestroy();
void		CompUndef();
void		CompUndefs();
void		CompTmpUndef();
#ifdef MATX_RT
void		CompTmpUndefs();
#endif
void		CompAllPrint();
void		CompPrint();
void		CompSwap();

Complex		CompSetName();
Complex		CompSetType();

Complex		CompInput();
Complex		CompEdit();
Complex		CompCopy();
Complex		CompElementCopy();
Complex		CompElementChange();
Complex		CompMove();
Complex		CompDup();
Complex		CompAssign();
Complex		CompAssignOnly();
Complex		CompFileRead();
Complex		CompFileSave();
Complex		CompFileWrite();
Complex		CompWrite();
Complex		CompRead();
int			CompReadContent();

Complex		CompDef();
Complex		CompDef2();
Complex		CompRequest();

Complex	CompSetRealPart();
Complex	CompSetImagPart();
Complex	CompSetValue();
Complex CompSetZero();
Complex CompSetOne();
Complex CompSetInf();
Complex CompSetNaN();

char	*CompToString();

ComplexValue ComplexValueDef();
ComplexValue ComplexValueCopy();
ComplexValue ComplexValueSetRe();
ComplexValue ComplexValueSetIm();
ComplexValue ComplexValueSetZero();
ComplexValue ComplexValueSetOne();
ComplexValue ComplexValueSetNaN();
ComplexValue ComplexValueSetInf();
ComplexValue ComplexValueConj();
ComplexValue ComplexValueAdd();
ComplexValue ComplexValueSub();
ComplexValue ComplexValueAddSelf();
ComplexValue ComplexValueSubSelf();
ComplexValue ComplexValueMulSelf();
ComplexValue ComplexValueDivSelf();
ComplexValue ComplexValueInv();
ComplexValue ComplexValueMulSelf2();
ComplexValue ComplexValueNegate();
ComplexValue ComplexValueNegateSelf();
ComplexValue ComplexValueMul();
ComplexValue ComplexValueMul1();
ComplexValue ComplexValueMul2();
ComplexValue ComplexValueDiv();
ComplexValue ComplexValueConjSelf();
ComplexValue ComplexValueSqrt();
ComplexValue ComplexValueLog();
ComplexValue ComplexValueExp();
ComplexValue ComplexValueExpSelf();
ComplexValue ComplexValuePow2();
ComplexValue ComplexValueSetValue();
ComplexValue ComplexValueDup();
ComplexValue CompToComplexValue();
Complex ComplexValueToComp();
char *ComplexValueToString();
double ComplexValueAbs();
double ComplexValueArg();
void ComplexValueSwap();
void ComplexValueDestroy();
int ComplexValueIsZero();
int ComplexValueIsInf();
int ComplexValueIsNaN();
int ComplexValueIsFinite();

Complex	CompAdd();
Complex	CompAddSelf();
Complex	CompAddSelf1();
Complex	CompAddSelf2();
Complex	CompSub();
Complex	CompSubSelf();
Complex	CompSubSelf1();
Complex	CompSubSelf2();
Complex	CompMul();
Complex	CompMulSelf();
Complex	CompMulSelf1();
Complex	CompMulSelf2();
Complex	CompDiv();
Complex	CompDivSelf();
Complex	CompDivSelf1();
Complex	CompDivSelf2();
Complex	CompAdd1();
Complex	CompAdd2();
Complex	CompSub1();
Complex	CompSub2();
Complex	CompMul1();
Complex	CompMul2();
Complex	CompDiv1();
Complex	CompDiv2();
Complex	CompInv();
Complex	CompInvSelf();
Complex	CompConj();
Complex	CompConjSelf();
Complex	CompNegate();
Complex	CompNegateSelf();
Complex	CompPow();
Complex CompLog();
Complex CompLogSelf();
Complex CompLog10();
Complex	CompExp();
Complex	CompExpSelf();
Complex	CompPow2();
Complex	CompSin();
Complex	CompAsin();
Complex	CompSinh();
Complex	CompAsinh();
Complex	CompCos();
Complex	CompAcos();
Complex	CompCosh();
Complex	CompAcosh();
Complex	CompTan();
Complex	CompAtan();
Complex	CompTanh();
Complex	CompAtanh();
Complex	CompSqrt();
Complex	CompSqrtSelf();
Complex CompSgn();
Complex CompCeil();
Complex CompFloor();
Complex CompRint();
Complex CompFixToZero();
Complex CompRoundToZero();

double	CompAbs();
double	CompArg();

int		CompIsFinite();
int		CompIsNaN();
int		CompIsInf();
#endif

/* ---------------------------------------------------------------------------
Complex	CompDef(char *, double r, double i);
Complex	CompDef2(Complex a, Complex b);
Complex	CompInput(char *name);
Complex	CompCopy(Complex b, Complex a);
Complex	CompDup(Complex a);
Complex	CompAssign(Complex *b, Complex a);
Complex CompEdit(Complex a, char *name);
Complex CompFileSave(Complex a, char *filename, char *name, int append,int cr);
Complex	CompWrite(Complex cc, FILE *fp, char *name);
int		CompRead(Complex cc, FILE *fp, char *name);
int		CompReadContent(Complex cc, FILE *fp, ComplexData *data);
Complex	CompSetRealPart(Complex a, double d);
Complex	CompSetImagPart(Complex a, double d);
Complex	CompSetValue(Complex a, double dr, double di);
Complex CompSetZero(Complex a);
Complex CompSetOne(Complex a);
Complex CompSetInf(Complex a);
Complex CompSetNaN(Complex a);
void	CompPrint(Complex a, char *name);
void	CompSwap(Complex a, Complex b);

char	*CompToString(Complex a, char *str, char *fmt);

ComplexValue ComplexValueDef(double r, double i);
ComplexValue ComplexValueCopy(ComplexValue b, ComplexValue a);
ComplexValue ComplexValueSetRe(ComplexValue b, double x);
ComplexValue ComplexValueSetIm(ComplexValue b, double x);
ComplexValue ComplexValueSetZero(ComplexValue a);
ComplexValue ComplexValueSetOne(ComplexValue a);
ComplexValue ComplexValueSetNaN(ComplexValue a);
ComplexValue ComplexValueSetInf(ComplexValue a);

ComplexValue ComplexValueConj(ComplexValue ans, ComplexValue a);
Complex ComplexValueToComp(ComplexValue a):
ComplexValue ComplexValueMulSelf2(ComplexValue a, ComplexValue b);
ComplexValue ComplexValueAddSelf(ComplexValue a, ComplexValue b);
ComplexValue ComplexValueMul(ComplexValue ans, ComplexValue a, ComplexValue b);
ComplexValue ComplexValueSqrt(ComplexValue ans, ComplexValue a);
ComplexValue ComplexValueLog(ComplexValue ans, ComplexValue a);
ComplexValue ComplexValueExp(ComplexValue ans, ComplexValue a);
ComplexValue ComplexValuePow2(ComplexValue ans, ComplexValue a, ComplexValue b);

char *ComplexValueToString(ComplexValue a, char *str, char *fmt);
double ComplexValueAbs(ComplexValue a);
void ComplexValueSwap(ComplexValue a, ComplexValue b);
void ComplexValueDestroy(ComplexValue an);
int ComplexValueIsZero(ComplexValue a);

Complex	CompAdd(Complex a, Complex b);
Complex	CompAddSelf(Complex c, Complex a);
Complex	CompAddSelf1(double c, Complex a);
Complex	CompAddSelf2(Complex c, double a);
Complex	CompSub(Complex a, Complex b);
Complex	CompSubSelf(Complex c, Complex a);
Complex	CompSubSelf1(double c, Complex a);
Complex	CompSubSelf2(Complex c, double a);
Complex	CompMul(Complex a, Complex b);
Complex	CompMulSelf(Complex c, Complex b);
Complex	CompMulSelf1(double c, Complex b);
Complex	CompMulSelf2(Complex c, double b);
Complex	CompDiv(Complex a, Complex b);
Complex	CompDivSelf(Complex c, Complex a);
Complex	CompDivSelf1(double c, Complex a);
Complex	CompDivSelf2(Complex c, double a);
Complex	CompAdd1(double a, Complex b);
Complex	CompSub1(double a, Complex b);
Complex	CompMul1(double a, Complex b);
Complex	CompDiv1(double a, Complex b);
Complex	CompAdd2(Complex a, double b);
Complex	CompSub2(Complex a, double b);
Complex	CompMul2(Complex a, double b);
Complex	CompMulSelf2(Complex c, double b);
Complex	CompDiv2(Complex a, double b);
Complex	CompInv(Complex b, Complex a);
Complex	CompInvSelf(Complex b, Complex a);
Complex	CompConj(Complex a);
Complex	CompConjSelf(Complex a);
Complex	CompNegate(Complex a);
Complex	CompNegateSelf(Complex a);
Complex	CompPow(Complex a, int m);
Complex CompLog(Complex a);
Complex CompLog10(Complex a);
Complex CompExp(Complex a);
Complex CompExpSelf(Complex a);
Complex CompPow2(Complex a;, Complex b);
Complex	CompSin(Complex a);
Complex	CompAsin(Complex a);
Complex	CompSinh(Complex a);
Complex	CompAsinh(Complex a);
Complex	CompCos(Complex a);
Complex	CompAcos(Complex a);
Complex	CompCosh(Complex a);
Complex	CompAcosh(Complex a);
Complex	CompTan(Complex a);
Complex	CompAtan(Complex a);
Complex	CompTanh(Complex a);
Complex	CompAtanh(Complex a);
Complex CompSqrt(Complex a);
Complex CompSgn(Complex a);
Complex CompCeil(Complex a);
Complex CompFloor(Complex a);
Complex CompRint(Complex a);
Complex CompFixToZero(Complex a);
Complex CompRoundToZero(Complex a, double tol);

double	CompAbs(Complex a);
double	CompArg(Complex a);
double	CompRealPart(Complex a);
double	CompImagPart(Complex a);

int		CompIsFinite(Complex a);
int		CompIsNaN(Complex a);
int		CompIsInf(Complex a);
---------------------------------------------------------------------------- */
