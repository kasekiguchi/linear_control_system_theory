
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
  rational.h : 

  $Author: koga $
  $Revision: 1.3 $
  $Date: 1992/06/10 12:21:44 $
  $Log: rational.h,v $
 * Revision 1.3  1992/06/10  12:21:44  koga
 *  Optimization
 *
 * Revision 1.2  1992/03/25  12:17:56  koga
 * Optimization
 *
*/

#ifndef rational_header
#define rational_header

#include <matxconf.h>

/* ------------------------------------------------------------------------- */

#define	RAT_TMP					0
#define	RAT_VAR					1
#define	RAT_MAT					2
#define	RAT_LIST				3
#define	RAT_MATX				4

#define RAT_REAL				0
#define RAT_COMPLEX				1

#define RAT_NULL				RatDef("", -1, -1)
#define C_RAT_NULL				C_RatDef("", -1, -1)
#define RAT_DEF					RatSetType(RAT_NULL, RAT_VAR)
#define RAT_STC					RatSetType(RatConst(0.0), RAT_MATX)
#define C_RAT_DEF				RatSetType(C_RAT_NULL, RAT_VAR)
#define C_RAT_STC				RatSetType(C_RatConst(COMP_NULL), RAT_MATX)

#define RatNumerator(a)			((a)->numerator)
#define RatDenominator(a)		((a)->denominator)
#define	RatGetClass(a)			((a)->class)
#define	RatClass(a)				((a)->class)
#define	RatGetType(a)			((a)->type)
#define	RatType(a)				((a)->type)
#define	RatGetName(a)			((a)->name)
#define	RatName(a)				((a)->name)
#define	RatNDegree(a)			((a)->ndegree)
#define	RatGetNDegree(a)		((a)->ndegree)
#define	RatDDegree(a)			((a)->ddegree)
#define	RatGetDDegree(a)		((a)->ddegree)
#define RatIsReal(a)			(RatClass(a) == RAT_REAL)
#define RatIsComplex(a)			(RatClass(a) == RAT_COMPLEX)
#define RatIsVar(a)				(RatType(a) == RAT_VAR)
#define RatIsTmp(a)				(RatType(a) == RAT_TMP)
#define RatIsConst(a)		    (PolyIsCont(RatNumerator(a))&&\
                                 PolyIsCont(RatDenominator(a)))
#define RatIsZero(a)			(PolyIsZero(RatNumerator(a)))
#define RatIsNonZero(a)			(! RatIsZero(a))
#define RatIsSameClass(a, b)	(RatClass(a) == RatClass(b))
#define RatIsSameNDegree(a, b)	(RatNDegree(a) == RatNDegree(b))
#define RatIsSameDDegree(a, b)	(RatDDegree(a) == RatDDegree(b))
#define RatIsSameDegree(a, b)	(RatIsSameNDegree(a,b)&&RatIsSameDDegree(a,b))
#define RatIsImproper(a,b)		(PolyDegree(RatNumerator(a))>\
                                PolyDegree(RatDenominator(b)))
#define RatIsProper(a,b)		(PolyDegree(RatNumerator(a))<=\
                                PolyDegree(RatDenominator(b)))
#define RatIsStrictlyProper(a,b) (PolyDegree(RatNumerator(a))<\
                                  PolyDegree(RatDenominator(b)))
#define RatNumeIsUndef(a)		(PolyIsUndef(RatNumerator(a)))
#define RatDenoIsUndef(a)		(PolyIsUndef(RatDenominator(a)))
#define RatIsUndef(a)			(RatNumeIsUndef(a) || RatDenoIsUndef(a))
#define RatIsEqual(a,b)			(PolyIsEqual(RatNumerator(a),RatNumerator(b)) && PolyIsEqual(RatDenominator(a),RatDenominator(b)))
#define RatIsNotEqual(a,b)		(PolyIsNotEqual(RatNumerator(a),RatNumerator(b)) || PolyIsNotEqual(RatDenominator(a),RatDenominator(b)))

#define RatErrorName(a)		(a)->name, RatNDegree(a), RatDDegree(a)

typedef struct __Rational _Rational, *Rational;

#include <matrix.h>

#ifdef HAVE_SHORT_FILENAME
#include <poly.h>
#else
#include <polynomial.h>
#endif

struct __Rational {				/* Rational                     */
	char		*name;			/* Name of Rational             */	
	int			type;			/* Data Type ( VAR, TMP, MAT )  */
	int			class;			/* Data Class ( COMPLEX, REAL ) */
	int			ndegree;		/* Degree of Numerator          */
	int			ddegree;		/* Degree of Denominator        */
	Polynomial	numerator;		/* Coefficient of Numerator     */
	Polynomial	denominator;	/* Coefficient of Denominator   */
	Rational	prev;			/* To link to previous Rational */
	Rational	next;			/* To link to nest Rational     */
};

#define RAT_ERR_LENGTH 256

extern char	*rat_err_src;			/* Error source code */

/* ------------------------------------------------------------------------- */

void		RatInit();
void 		RatError();
void 		RatError2();
void 		RatWarning();
void 		RatWarning2();
void		RatUndefCheck();
void		RatUndefCheck2();
void		RatTmpUndef();
#ifdef MATX_RT
void		RatTmpUndefs();
#endif
void		RatInstall();
void		RatUndef();
void		RatUndefs();
void		RatDestroy();
void 		RatFree();
void 		RatFrees();
void 		RatAllPrint();
void 		RatPrint();
void		RatSwap();
void		RatToString();

Rational 	RatSetName();
Rational 	RatSetVar();
Rational 	RatSetType();
Rational 	RatSetClass();
Rational 	RatSetNume();
Rational 	RatSetDeno();
Rational	RatSetZero();
Rational	RatCeil();
Rational	RatFloor();
Rational	RatRint();
Rational	RatFixToZero();
Rational	RatRoundToZero();
Rational 	RatInput();
Rational 	RatEdit();
Rational 	RatCopy();
Rational 	RatElementCopy();
Rational 	RatElementChange();
Rational 	RatMove();
Rational 	RatDup();
Rational 	RatAssign();
Rational 	RatAssignOnly();
Rational 	RatFileRead();
Rational 	RatFileWrite();
Rational 	RatFileSave();
Rational	RatWrite();
Rational	RatRead();
int			RatReadContent();

Rational 	RatDef();
Rational 	RatRequest();
Rational 	RatNumeDef();
Rational 	RatDenoDef();
Rational 	RatNumeDenoDef();
Rational 	C_RatDef();
Rational 	RatSameClassDef();
Rational 	RatSameDef();
Rational 	RatMulDef();
Rational 	RatAddDef();
Rational 	RatIDef();
Rational 	C_RatIDef();
Rational 	RatConst();
Rational 	C_RatConst();

Rational 	RatAdd();
Rational 	RatAdd_Polynomial();
Rational 	RatAdd_Complex();
Rational 	RatAdd_double();
Rational 	RatSub();
Rational 	RatSub_Polynomial();
Rational 	RatSub_Complex();
Rational 	RatSub_double();
Rational 	RatInv();
Rational 	RatMul();
Rational 	RatDiv();
Rational 	RatScale();
Rational 	RatScaleSelf();
Rational 	RatScaleC();
Rational 	RatScaleP();
Rational 	RatPow();
Rational 	RatNegate();
Rational 	RatConj();
Rational 	RatRealPart();
Rational 	RatImagPart();
Rational 	RatRealAndImag();
Rational 	RatRealToComp();
Rational 	RatSimplify();
Rational	RatDerivative();
Rational	RatLowerShift();
Rational	RatHigherShift();

Polynomial	RatNume();
Polynomial	RatDeno();

Matrix		RatZeros();
Matrix		RatPoles();

double		RatEval();
Complex 	RatEvalC();
Rational	RatEvalP();
Rational	RatEvalR();
Matrix		RatEvalM();		/* this function return Matrix */
Rational	PolyEvalR();	/* this function return Rational */
Complex 	C_RatEval();
Complex 	C_RatEvalC();

#endif

/* ---------------------------------------------------------------------------

void		RatInit();
void 		RatError(char *func, char *statement, Rational a);
void 		RatError2(char *func, char *statement, Rational a, Rational b);
void 		RatWarning(char *func, char *statement, Rational a);
void 		RatWarning(char *func, char *statement, Rational a, Rational b);
void		RatUndefCheck(Rational a, char *name);
void		RatUndefCheck2(Rational a, Rational b, char *name);
void		RatUndef(Rational a);
void		RatInstall(Rational a);
void		RatDestroy(Rational a);
void		RatTmpUndef(void);
#ifdef MATX_RT
void		RatTmpUndefs(Rational a);
#endif
void 		RatFree(Rational a);
void 		RatTmpFree();
void 		RatFrees(Rational a);
void 		RatAllFree();
void 		RatAllPrint();
void 		RatPrint(Rational a);
void		RatSwap(Rational b, Rational a);
void		RatToString(Rational a, char *strn, char *strd, int save);

Rational 	RatSetName(Rational a, char *name);
Rational 	RatSetVar(Rational a, char *var);
Rational 	RatSetType(Rational a, int type);
Rational 	RatSetClass(Rational a, int class);
Rational 	RatSetNume(Rational a, Polynomial p);
Rational 	RatSetDeno(Rational a, Polynomial p);
Rational	RatSetZero(Rational a);
Rational	RatCeil(Rational a);
Rational	RatFloor(Rational a);
Rational	RatRint(Rational a);
Rational	RatFixToZero(Rational a);
Rational	RatRoundToZero(Rational a, double tol);
Rational 	RatSarch(char *name);
Rational 	RatInput(char *name);
Rational 	RatEdit(Rational a);
Rational 	RatCopy(Rational b, Rational a);
Rational 	RatElementCopy(Rational b, Rational a);
Rational 	RatElementChange(Rational b, Rational a);
Rational 	RatMove(Rational b, Rational a);
Rational 	RatDup(Rational a);
Rational 	RatAssign(Rational b, Rational a);
Rational 	RatAssignOnly(Rational b, Rational a);
Rational 	RatFileRead(char *filename);
Rational 	RatFileWrite(Rational a, char *filename);
Rational 	RatFileSave(Rational a, char *filename, int append, int cr);
Rational	RatWrite(Rational rr, FILE *fp);
Rational	RatRead(Rational rt, FILE *fp);
int			RatReadContent(Rational rt, FILE *fp, RationalData *data);

Rational 	RatRequest();
Rational 	RatDef(char *name, int n, int d);
Rational 	RatNumeDef(Polynomial n);
Rational 	RatDenoDef(Polynomial d);
Rational 	RatNumeDenoDef(Polynomial n, Polynomial d);
Rational 	C_RatDef(char *name, int n, int d);
Rational 	RatSameClassDef(Rational a, int n, int d);
Rational 	RatSameDef(Rational a);
Rational 	RatMulDef(Rational a, Rational b);
Rational 	RatAddDef(Rational a, Rational b);
Rational 	RatIDef(int n, int d);
Rational 	C_RatIDef(int n, int d);
Rational 	RatConst(double d);
Rational 	C_RatConst(Complex c);

Rational 	RatAdd(Rational a, Rational b);
Rational 	RatAdd_Polynomial(Rational a, Polynomial b);
Rational 	RatAdd_Complex(Rational a, Complex b);
Rational 	RatAdd_double(Rational a, double b);
Rational 	RatSub(Rational a, Rational b);
Rational 	RatSub_Polynomial(Rational a, Polynomial b);
Rational 	RatSub_Complex(Rational a, Complex b);
Rational 	RatSub_double(Rational a, double b);
Rational 	RatInv(Rational a);
Rational 	RatMul(Rational a, Rational b);
Rational 	RatDiv(Rational a, Rational b);
Rational 	RatScale(Rational a, double scale);
Rational 	RatScaleSelf(Rational a, double scale);
Rational 	RatScaleC(Rational a, Complex scale);
Rational 	RatScaleP(Rational a, Polynomial scale);
Rational 	RatPow(Rational a, int m);
Rational 	RatNegate(Rational a);
Rational 	RatConj(Rational a);
Rational 	RatRealPart(Rational a);
Rational 	RatImagPart(Rational a);
Rational 	RatRealAndImag(Rational a, Rational b);
Rational 	RatRealToComp(Rational a);
Rational 	RatSimplify(Rational a, double tol);
Rational 	RatDerivative(Rational a, int m);
Rational 	RatLowerShift(Rational a, int m);
Rational 	RatHigherShift(Rational a, int m);

Polynomial	RatNume(Rational a);
Polynomial	RatDeno(Rational a);

Matrix		RatZeros(Rational a);
Matrix		RatPoles(Rational a);

double		RatEval(Rational a, double d);
Complex 	RatEvalC(Rational a, Complex c);
Rational	RatEvalP(Rational a, Polynomial b);
Rational	RatEvalR(Rational a, Rational b);
Matrix		RatEvalM(Rational a, Matrix b);
Rational	PolyEvalR(Polynomial a, Rational b);
Complex 	C_RatEval(Rational a, double d);
Complex 	C_RatEvalC(Rational a, Complex c);

---------------------------------------------------------------------------- */

