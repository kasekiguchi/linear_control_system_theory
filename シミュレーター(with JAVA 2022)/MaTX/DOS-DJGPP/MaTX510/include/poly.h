
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
  polynomial.h : 

  $Author: koga $
  $Revision: 2.3 $
  $Date: 1992/06/10 12:21:22 $
  $Log: polynomial.h,v $
 * Revision 2.3  1992/06/10  12:21:22  koga
 *  Optimization
 *
 * Revision 2.2  1992/03/25  12:16:14  koga
 * Optimization
 *
*/

#ifndef polynomial_header
#define polynomial_header

#include <matxconf.h>

/* ------------------------------------------------------------------------- */

#define	POLY_TMP				0
#define	POLY_VAR				1
#define	POLY_RAT				2
#define	POLY_MAT				3
#define	POLY_LIST				4
#define	POLY_MATX				5

#define POLY_REAL				0
#define POLY_COMPLEX			1

#define POLY_NULL				PolyDef("", -1, (char *)0)
#define C_POLY_NULL				C_PolyDef("", -1, (char *)0)
#define POLY_DEF				PolySetType(POLY_NULL, POLY_VAR)
#define POLY_STC				PolySetType(PolyConst(0.0), POLY_MATX)
#define C_POLY_DEF				PolySetType(C_POLY_NULL, POLY_VAR)
#define C_POLY_STC				PolySetType(C_PolyConst(COMP_NULL), POLY_MATX)

#define	PolyPtr(a,i)			MatPtr(PolyCoefficient(a), 1, (i)+1)
#define	PolyValue(a,i)			MatValue(PolyCoefficient(a), 1, (i)+1)
#define PolyCoefficient(a)		((a)->coef)
#define PolyGetCoef(a)			PolyCoefficient(a)
#define	PolyGetClass(a)			((a)->class)
#define	PolyClass(a)			PolyGetClass(a)
#define	PolyGetType(a)			((a)->type)
#define	PolyType(a)				PolyGetType(a)
#define	PolyGetName(a)			((a)->name)
#define	PolyName(a)				PolyGetName(a)
#define	PolyGetDegree(a)		((a)->degree)
#define	PolyDegree(a)			PolyGetDegree(a)
#define PolyGetVar(a)			((a)->var)
#define PolyVar(a)				PolyGetVar(a)

#define PolyIsReal(a)			(PolyClass(a) == POLY_REAL)
#define PolyIsComplex(a)		(PolyClass(a) == POLY_COMPLEX)

#define PolyIsVar(a)			(PolyType(a) == POLY_VAR)
#define PolyIsTmp(a)			(PolyType(a) == POLY_TMP)
#define PolyIsRat(a)			(PolyType(a) == POLY_RAT)
#define PolyIsMat(a)			(PolyType(a) == POLY_MAT)

#define PolyIsConst(a)			(PolyDegree(a) == 0)
#define PolyIsUndef(a)			(PolyDegree(a) == -1)
#define PolyIsSameClass(a, b)	(PolyClass(a) == PolyClass(b))
#define PolyIsSameDegree(a, b)	(PolyDegree(a) == PolyDegree(b))
#define PolyIsLarger(a,b)		(PolyDegree(a) > PolyDegree(b))
#define PolyIsSmaller(a,b)		(PolyDegree(a) < PolyDegree(b))
#define PolyIsNonZero(a)		(! PolyIsZero(a))
#define	PolyIsEqual(a,b)		(MatIsEqual((a)->coef, (b)->coef))
#define	PolyIsNotEqual(a,b)		(MatIsNotEqual((a)->coef, (b)->coef))

#define C_PolyPtr(a, i)			C_MatPtr(PolyCoefficient(a), 1, (i)+1)
#define	C_PolyValue(a, i)		C_MatValue(PolyCoefficient(a), 1, (i)+1)

#define PolyErrorName(a)		(a)->name, (a)->var?(a)->var:"s", PolyDegree(a)

typedef struct __Polynomial _Polynomial, *Polynomial;

#include <matrix.h>

struct __Polynomial {	/* Polynomial                       */
	char	*name;		/* Name of Polynomial               */	
	char	*var;		/* Name of variable                 */	
	int		type;		/* Data Type ( VAR, TMP, RAT, MAT ) */
	int		class;		/* Data Class ( COMPLEX, REAL )     */
	int		degree;		/* Degree of Polynomial             */
	Matrix	coef;		/* Coefficient of Polynomial        */
	Polynomial prev;	/* To link to previous Polynomial   */
	Polynomial next;	/* To link to nest Polynomial       */
};

#define POLY_ERR_LENGTH 256
#define POLY_STRING_LENGTH 1024

extern char	*poly_err_src;				/* Error source code */

/* ------------------------------------------------------------------------- */

void 		PolyError();
void 		PolyError2();
void 		PolyWarning();
void 		PolyWarning2();
void		PolyVarCheck();
void		PolyUndefCheck();
void		PolyUndefCheck2();
void		PolyInit();
void		PolyFree();
void		PolyFrees();
void		PolyInstall();
void		PolyDestroy();
void		PolyUndef();
void		PolyUndefs();
void		PolyTmpUndef();
#ifdef MATX_RT
void		PolyTmpUndefs();
#endif
void		PolyAllPrint();
void		PolyPrint();
void		PolySwap();
char		*PolyToString();
char		*C_PolyToString();

Polynomial	PolySetName();
Polynomial	PolySetVar();
Polynomial	PolySetType();
Polynomial	PolySetClass();
Polynomial	PolySetValue();
Polynomial	C_PolySetValue();
Polynomial	PolySetCoef();
Polynomial	PolySetZero();
Polynomial	PolyCeil();
Polynomial	PolyFloor();
Polynomial	PolyRint();
Polynomial	PolyFixToZero();
Polynomial	PolyRoundToZero();

Polynomial	PolyInput();
Polynomial	PolyEdit();
Polynomial	PolyCopy();
Polynomial	PolyPartCopy();
Polynomial	PolyElementCopy();
Polynomial	PolyElementChange();
Polynomial	PolyMove();
Polynomial	PolyDup();
Polynomial	PolyAssign();
Polynomial	PolyAssignOnly();
Polynomial	PolyFileRead();
Polynomial	PolyFileSave();
Polynomial	PolyFileWrite();
Polynomial	PolyWrite();
Polynomial	PolyRead();
int			PolyReadContent();
int			PolyIsZero();

Polynomial	PolyDef();
Polynomial	PolyRequest();
Polynomial	PolyCoefDef();
Polynomial	C_PolyDef();
Polynomial	PolySameClassDef();
Polynomial	PolySameDef();
Polynomial	PolyMulDef();
Polynomial	PolyIDef();
Polynomial	C_PolyIDef();
Polynomial	PolyFirst();
Polynomial	C_PolyFirst();
Polynomial	PolyConst();
Polynomial	C_PolyConst();

Polynomial	PolyAdd();
Polynomial	PolyAdd_double();
Polynomial	PolyAdd_Complex();
Polynomial	PolySub();
Polynomial	PolySub_double();
Polynomial	PolySub_Complex();
Polynomial	PolyMul();
Polynomial	PolyScale();
Polynomial	PolyScaleSelf();
Polynomial	PolyScaleC();
Polynomial	PolyPow();
Polynomial	PolyNegate();
Polynomial	PolyConj();
Polynomial	PolyRealPart();
Polynomial	PolyImagPart();
Polynomial	PolyCut();
Polynomial	PolyRealAndImag();
Polynomial	PolyRealToComp();
Polynomial	PolyExpand();
Polynomial	PolySimplify();
Polynomial	PolyDerivative();
Polynomial	PolyIntegral();
Polynomial	PolyLowerShift();
Polynomial	PolyHigherShift();
double		PolyEval();
Complex		PolyEvalC();
Polynomial	PolyEvalP();
Matrix		PolyEvalM();
Complex		C_PolyEval();
Complex		C_PolyEvalC();
Matrix		PolyRoots();
Matrix		PolyCoef();
double		*PolyGetPtr();
double		PolyGetValue();
ComplexValue C_PolyGetPtr();
Complex		C_PolyGetValue();
char		*stringwrap();
double		PolyCoefFrobNorm();

#endif

/* --------------------------------------------------------------------------

void 		PolyError(char *func, char *statement, char *var);
void 		PolyError2(char *func, char *statement,
						Polynomial a, Polynomial b);
void 		PolyWarning(char *func, char *statement, char *var);
void 		PolyWarning2(char *func, char *statement,
						Polynomial a, Polynomial b);
void		PolyVarCheck(Polynomial a, Polynomial b, char *name);
void		PolyUndefCehck(Polynomial a, char *name);
void		PolyUndefCehck2(Polynomial a, Polynomial b, char *name);
void		PolyInit();
void		PolyFree(Polynomial a);
void		PolyFrees(Polynomial a);
void		PolyAllFree();
void		PolyInstall(Polynomial a);
void		PolyDestroy(Polynomial a);
void		PolyUndef(Polynomial a);
void		PolyUndefs(Polynomial a);
void		PolyTmpUndef(void);
#ifdef MATX_RT
void		PolyTmpUndefs(Polynomial a);
#endif
void		PolyAllUndef();
void		PolyAllPrint();
void		PolyPrint(Polynomial a);
void		PolySwap(Polynomial b, Polynomial a);
void		PolyExchangeListposition(Polynomial b, Polynomial a);
char		*PolyToString(Polynomial a, char **str, int save, char *var);
char		*C_PolyToString(Polynomial a, char **str, int save);

Polynomial	PolySetName(Polynomial a, char *name);
Polynomial	PolySetVar(Polynomial a, char *var);
Polynomial	PolySetType(Polynomial a, int type);
Polynomial	PolySetClass(Polynomial a, int class);
Polynomial	PolySetValue(Polynomial a, int degree, double d);
Polynomial	C_PolySetValue(Polynomial a, int m, Complex c);
Polynomial	PolySetCoef(Polynomial a, Matrix b);
Polynomial	PolySetZero(Polynomial a);
Polynomial	PolyCeil(Polynomial a);
Polynomial	PolyFloor(Polynomial a);
Polynomial	PolyRint(Polynomial a);
Polynomial	PolyFixToZero(Polynomial a);
Polynomial	PolyRoundToZero(Polynomial a, double tol);
Polynomial	PolySarch(char *name);

Polynomial	PolyInput(char *name);
Polynomial	PolyEdit(Polynomial a);
Polynomial	PolyCopy(Polynomial b, Polynomial a);
Polynomial	PolyPartCopy(Polynomial b, int bl, int bh,
                         Polynomial a, int al, int ah);
Polynomial	PolyElementCopy(Polynomial b, Polynomial a);
Polynomial	PolyElementChange(Polynomial b, Polynomial a);
Polynomial	PolyMove(Polynomial b, Polynomial a);
Polynomial	PolyDup(Polynomial a);
Polynomial	PolyAssign(Polynomial b, Polynomial a);
Polynomial	PolyAssignOnly(Polynomial b, Polynomial a);
Polynomial	PolyFileRead(char *filename);
Polynomial	PolyFileWrite(Polynomial a, char *filename);
Polynomial	PolyFileSave(Polynomial a, char *filename, int append, int cr);
Polynomial	PolyWrite(Polynomial pp, FILE *fp);
polynomial	PolyRead(Polynomial pl, FILE *fp);
int			PolyReadContent(Polynomial pl, FILE *fp, PolynomialData *data)
int			PolyIsZero(Polynomial a);

Polynomial	PolyDef(char *name, int m, char *var);
Polynomial	PolyRequest(int degree, int class);
Polynomial	PolyCoefDef(Matrix m);
Polynomial	C_PolyDef(char *name, int m, char *var);
Polynomial	PolySameClassDef(Polynomial a, int m);
Polynomial	PolySameDef(Polynomial a);
Polynomial	PolyMulDef(Polynomial a, Polynomial b);
Polynomial	PolyIDef(int n, char *var);
Polynomial	C_PolyIDef(int n, char *var);
Polynomial	PolyFirst(double d, char *var);
Polynomial	C_PolyFirst(Complex c, char *var);
Polynomial	PolyConst(double d);
Polynomial	C_PolyConst(Complex c);

Polynomial	PolyAdd(Polynomial a, Polynomial b);
Polynomial	PolyAdd_double(Polynomial a, double sc);
Polynomial	PolyAdd_Complex(Polynomial a, Complex sc);
Polynomial	PolySub(Polynomial a, Polynomial b);
Polynomial	PolySub_double(Polynomial a, double sc);
Polynomial	PolySub_Complex(Polynomial a, Complex sc);
Polynomial	PolyMul(Polynomial a, Polynomial b);
Polynomial	PolyScale(Polynomail a, double scale);
Polynomial	PolyScaleSelf(Polynomail a, double scale);
Polynomial	PolyScaleC(Polynomial a, Complex scale);
Polynomial	PolyPow(Polynomial a, int m);
Polynomial	PolyNegate(Polynomial a);
Polynomial	PolyConj(Polynomial a);
Polynomial	PolyRealPart(Polynomial a);
Polynomial	PolyImagPart(Polynomial a);
Polynomial	PolyCut(Polynomial a, int s, int e);
Polynomial	PolyRealAndImag(Polynomial a, Polynomial b);
Polynomial	PolyRealToComp(Polynomial a);
Polynomial	PolyExpand(Polynomial a, int m);
Polynomial	PolySimplify(Polynomial a, double tol);
Polynomial	PolyDerivative(Polynomial a, int m);
Polynomial	PolyIntegral(Polynomial a, int m);
Polynomial	PolyLowerShift(Polynomial a, int m);
Polynomial	PolyHigherShift(Polynomial a, int m);

double		PolyEval(Polynomial a, double d);
Complex		PolyEvalC(Polynomial a, Complex c);
Polynomial	PolyEvalP(Polynomial a, Polynomial b);
Matrix		PolyEvalM(Polynomial a, Matrix b);
Complex		C_PolyEval(Polynomial a, double d);
Complex		C_PolyEvalC(Polynomial a, Complex c);

Matrix		PolyRoots(Polynomial a);
Matrix		PolyCoef(Polynomial a);
double		*PolyGetPtr(Polynomial a, int m);
double		PolyGetValue(Polynomial a, int m);
Complex		C_PolyGetPtr(Polynomial a, int m);
Complex		C_PolyGetValue(Polynomial a, int m);
char		*stringwrap(char **str, int margin, int width, char *eol);
double		PolyCoefFrobNorm(Polynomial a);

---------------------------------------------------------------------------- */
