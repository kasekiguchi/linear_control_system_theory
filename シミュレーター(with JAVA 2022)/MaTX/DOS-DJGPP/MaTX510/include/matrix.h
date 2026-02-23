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
  matrix.h : 

  $Author: koga $
  $Revision: 1.4 $
  $Date: 1994/06/21 13:29:05 $
  $Log: matrix.h,v $
 * Revision 1.4  1994/06/21  13:29:05  koga
 * *** empty log message ***
 *
 * Revision 1.3  1992/06/10  12:21:02  koga
 *  Optimization
 *
 * Revision 1.2  1992/04/12  09:20:56  koga
 * Several filename were changed.
 *
 * Revision 1.1  1992/03/25  12:14:13  koga
 * Initial revision
 *
*/

#ifndef matrix_header
#define matrix_header

#include <matxconf.h>
#include <stdio_my.h>

#ifdef VXWORKS
#include <stdioLib.h>
#else
#include <stdio.h>
#endif

#ifdef BSD42
#include <strings.h>
#else
#include <string.h>
#endif

#include <math.h>
#include <util.h>
#include <estring.h>
#include <complex.h>

#define MATX_TMP_DESTROY	MatObjectTmpUndef

/*
 *	Module
 */
#ifdef MATX_SMALL
#undef MAT_FFT
#undef MAT_RUNGE
#undef MAT_C_RUNGE
#undef MAT_SVD
#undef MAT_C_SVD
#undef MAT_LUQR
#undef MAT_C_LUQR
#undef MAT_C_EIG
#undef MAT_EIG
#undef MAT_HEIG
#undef MAT_GEIG
#undef MAT_C_GEIG
#else
#define MAT_FFT
#define MAT_RUNGE
#define MAT_C_RUNGE
#define MAT_SVD
#define MAT_C_SVD
#define MAT_LUQR
#define MAT_C_LUQR
#define MAT_C_EIG
#define MAT_EIG
#define MAT_HEIG
#define MAT_GEIG
#define MAT_C_GEIG
#endif
/*
 *	End of Module
 */

/*
 * MatEnlarge()
 */
#define MAT_ENLARGE 1

/* Data Type */
#define	MAT_TMP					0
#define	MAT_VAR					1
#define	MAT_POLY				2
#define	MAT_LIST				3
#define MAT_MATX				4

/* Data Class */
#define MAT_REAL				0
#define MAT_COMPLEX				1
#ifdef P_MAT
#define MAT_R_POLYNOMIAL		2
#define MAT_C_POLYNOMIAL		3
#endif
#ifdef R_MAT
#define MAT_R_RATIONAL			4
#define MAT_C_RATIONAL			5
#endif

#define MAT_NULL				MatDef("", 0, 0)
#define MAT_DEF					MatSetType(MAT_NULL, MAT_VAR)
#define MAT_STC					MatSetType(MAT_NULL, MAT_MATX)
#define C_MAT_NULL				C_MatDef("", 0, 0)
#define C_MAT_DEF				MatSetType(C_MAT_NULL, MAT_VAR)
#ifdef P_MAT
#define P_MAT_NULL				P_MatDef("", 0, 0)
#define P_MAT_DEF				MatSetType(P_MAT_NULL, MAT_VAR)
#define R_P_MAT_NULL			P_MAT_NULL
#define C_P_MAT_NULL			MatSetClass(P_MAT_NULL, MAT_C_POLYNOMIAL)
#endif
#ifdef R_MAT
#define R_MAT_NULL				R_MatDef("", 0, 0)
#define R_MAT_DEF				MatSetType(R_MAT_NULL, MAT_VAR)
#define R_R_MAT_NULL			R_MAT_NULL
#define C_R_MAT_NULL			MatSetClass(R_MAT_NULL, MAT_C_RATIONAL)
#endif

#define MatConst(d)				MatSetValue(MatDef("", 1, 1), 1, 1, (d))
#define	MatValue(a, i, j)		(*MatPtr(a, i, j))
#define	MatPtr(a, i, j)			((a)->elm.r + ((i)-1)*Cols(a) + (j)-1)
#define	MatVecValue(a, i)		(*MatVecPtr(a, i))
#define	MatVecPtr(a, i)			((a)->elm.r + (i)-1)
#define C_MatConst(d)			C_MatSetValue(C_MatDef("", 1, 1), 1, 1, (d))
#define	C_MatValue(a, i, j)		ComplexValueToComp(C_MatPtr(a, i, j))
#define	C_MatPtr(a, i, j)		((a)->elm.c + ((i)-1)*Cols(a) + (j)-1)
#define	C_MatVecValue(a, i)		ComplexValeuToComp(C_MatVecPtr(a, i))
#define	C_MatVecPtr(a, i)		((a)->elm.c + (i)-1)

#ifdef P_MAT
#define	P_MatValue(a, i, j)		PolyDup(P_MatPtr(a, i, j))
#define	P_MatPtr(a, i, j)		(*((a)->elm.poly + ((i)-1)*Cols(a) + (j)-1))
#define P_MatConst(d)			P_MatSetValue(P_MatDef("", 1, 1), 1, 1, (d))
#endif
#ifdef R_MAT
#define	R_MatValue(a, i, j)		RatDup(R_MatPtr(a, i, j))
#define	R_MatPtr(a, i, j)		(*((a)->elm.rat + ((i)-1)*Cols(a) + (j)-1))
#define R_MatConst(d)			R_MatSetValue(R_MatDef("", 1, 1), 1, 1, (d))
#endif

#define	MatGetClass(a)			((a)->class)
#define	MatClass(a)				((a)->class)
#define	MatGetType(a)			((a)->type)
#define	MatGetType(a)			((a)->type)
#define	MatType(a)				((a)->type)
#define	MatGetName(a)			((a)->name)
#define	MatName(a)				((a)->name)

#define MatRows(a)				MatGetRows(a)
#define MatCols(a)				MatGetCols(a)

#ifdef SYSV
#define	CSize(a)				MatGetRows(a)
#define	RSize(a)				MatGetCols(a)
#define	Rows(a)					MatGetRows(a)
#define	Cols(a)					MatGetCols(a)
#else
#define	CSize(a)				Rows(a)
#define	RSize(a)				Cols(a)
#define	Rows(a)					((a)->rows)
#define	Cols(a)					((a)->cols)
#endif

#define	MatRand(m,n)			MatUniformRand(m,n)
#define	C_MatRand(m,n)			C_MatUniformRand(m,n)

#define MatIsReal(a)			(MatClass(a) == MAT_REAL)
#define MatIsNotReal(a)			(MatClass(a) != MAT_REAL)
#define MatIsComplex(a)			(MatClass(a) == MAT_COMPLEX)
#define MatIsNotComplex(a)		(MatClass(a) != MAT_COMPLEX)

#define MatIsRealValue2(a,b)	(MatIsRealValue(a) && MatIsRealValue(b))
#define MatIsComplexValue2(a,b)	(MatIsComplexValue(a) || MatIsComplexValue(b))

#ifdef P_MAT
#define MatIsR_Polynomial(a)	(MatClass(a) == MAT_R_POLYNOMIAL)
#define MatIsR_Polynomial2(a,b)	(MatIsR_Polynomial(a) && MatIsR_Polynomial(b))
#define MatIsC_Polynomial(a)	(MatClass(a) == MAT_C_POLYNOMIAL)
#define MatIsC_Polynomial2(a,b)	(MatIsC_Polynomial(a) || MatIsC_Polynomial(b))
#define MatIsPolynomial(a)		(MatIsR_Polynomial(a) || MatIsC_Polynomial(a))
#define MatIsPolynomial2(a,b)	(MatIsPolynomial(a) || MatIsPolynomial(b))
#endif

#ifdef R_MAT
#define MatIsR_Rational(a)		(MatClass(a) == MAT_R_RATIONAL)
#define MatIsR_Rational2(a,b)	(MatIsR_Rational(a) && MatIsC_Rational(b))
#define MatIsC_Rational(a)		(MatClass(a) == MAT_C_RATIONAL)
#define MatIsC_Rational2(a,b)	(MatIsC_Rational(a) || MatIsC_Rational(b))
#define MatIsRational(a)		(MatIsR_Rational(a) || MatIsC_Rational(a))
#define MatIsRational2(a,b)		(MatIsRational(a) || MatIsRational(b))
#endif

#define MatIsTmp(a)				(MatType(a) == MAT_TMP)
#define MatIsVar(a)				(MatType(a) == MAT_VAR)
#define MatIsPoly(a)			(MatType(a) == MAT_POLY)
#define MatIsList(a)			(MatType(a) == MAT_LIST)

#define MatIsColumnLong(a)		(Rows(a) > Cols(a))
#define MatIsRowLong(a)			(Rows(a) < Cols(a))
#define MatIsSquare(a)			(Rows(a) == Cols(a))
#define MatIsNonSquare(a)		(Rows(a) != Cols(a))
#define MatIsNonSquare2(a,b)	(MatIsNonSquare(a) || MatIsNonSquare(b))
#define MatIsRowVec(a)			(Rows(a) == 1)
#define MatIsColumnVec(a)		(Cols(a) == 1)
#define MatIsVector(a)			(MatIsRowVec(a) || MatIsColumnVec(a))
#define MatIsScalar(a)			(Rows(a) == 1 && Cols(a) == 1)
#define MatIsZeroSize(a)		(Rows(a) == 0 || Cols(a) == 0)
#define MatIsNotZeroSize(a)		(Rows(a) != 0 && Cols(a) != 0)
#define MatIsZeroSize2(a,b)		(MatIsZeroSize(a) || MatIsZeroSize(b))
#define MatIsEmpty(a)			MatIsZeroSize(a)
#define MatIsNotEmpty(a)		MatIsNotZeroSize(a)
#define MatIsSameClass(a,b)		(MatClass(a) == MatClass(b))
#define MatIsNotSameClass(a,b)	(MatClass(a) != MatClass(b))
#define MatIsSameSize(a,b)		(Rows(a) == Rows(b) && Cols(a) == Cols(b))
#define MatIsNotSameSize(a,b)	(Rows(a) != Rows(b) || Cols(a) != Cols(b))
#define ErrorName(a)			(a)->name, Rows(a), Cols(a)

typedef union __Element {
	double	              *r;		/* Real Element       */
	struct __ComplexValue *c;		/* Complex Elemen     */
#ifdef P_MAT
	struct __Polynomial   **poly;	/* Polynomial Element */
#endif
#ifdef R_MAT
	struct __Rational     **rat;	/* Rational Element   */
#endif
} Element;

typedef struct __Matrix _Matrix, *Matrix;

struct __Matrix {	/* Matrix                  */
	char	*name;	/* Name of Matrix          */	
	int		type;	/* Data Type               */
	int		class;	/* Data Class              */
	int		rows;	/* Row Dimension           */
	int		cols;	/* Column Dimension        */
	Element elm;	/* Element                 */
	Matrix  prev;	/* Link to previous Matrix */
	Matrix  next;	/* Link to next Matrix     */
};

/*
  Data Type : {VAR, TMP, POLY, RAT}
  Data Class: {REAL, COMPLEX, POLYNOMIAL, RATIONAL}
*/

#define MAT_ERR_LENGTH 256

extern char *mat_err_src;			/* Error source code */

#ifdef P_MAT
#ifdef HAVE_SHORT_FILENAME
#include <poly.h>
#else
#include <polynomial.h>
#endif
#endif

#ifdef R_MAT
#include <rational.h>
#endif

/* ------------------------------------------------------------------------- */
void	MatInit();
void	MatFree();
void	MatFrees();
void	MatInstall();
void	MatDestroy();
void	MatUndef();
void	MatElementDestroy();
void	MatUndefs();
#ifdef HAVE_STDARG
void	MatMultiUndefs(int n, ...);
#else
void	MatMultiUndefs();
#endif
void	MatTmpUndef();
#ifdef MATX_RT
void	MatTmpUndefs();
#endif
void	MatObjectTmpUndef();

void	MatPrint();
void	MatPrintArray();
void	MatPrintIndex();
void	MatAllPrint();
void	MatError();
void	MatError2();
void	MatWarning();
void	MatWarning2();
void	MatErrorNotRealNorComplex();
void	MatErrorNotRealNorComplex2();
void	MatSwap();
void	MatSameSizeCheck();
void	MatSameClassCheck();
void	MatZeroSizeCheck();
void	MatZeroSizeCheck2();
void	MatNotRealCheck();
void	MatNotComplexCheck();
void	MatNotPolynomialCheck();
void	MatNotRationalCheck();
void	MatNonSquareCheck();
void	MatNonSquareCheck2();

int		MatGetRows();
int		MatGetCols();
int		MatLength();

Matrix	MatAssign();
Matrix	MatAssignOnly();
Matrix	MatChangeColumn();
Matrix	MatChangeRow();
Matrix	MatPermutate();
Matrix 	MatCopy();
Matrix	MatElementCopy();
Matrix 	MatElementChange();
Matrix 	MatMove();
Matrix 	MatDup();
Matrix	MatInput();
Matrix	MatFileRead();
Matrix	MatFileWrite();
Matrix	MatFileSave();
Matrix	MatWrite();
Matrix	MatRead();
int		MatReadContent();
int		MatReadContentV5();
Matrix	MatFread();
int		MatFwrite();

Matrix	MatEdit();
Matrix	MatEditComplex();
Matrix	MatSetName();
Matrix	MatSetVar();
Matrix	MatSetType();
Matrix	MatSetClass();
Matrix	MatSetValue();
Matrix	Mat_SetValue();
Matrix	MatSetValueC();
Matrix	MatSetValueP();
Matrix	MatSetValueR();
Matrix	MatFillValue();
Matrix	MatSetVecValue();
Matrix	Mat_SetVecValue();
Matrix	MatSetVecValueC();
Matrix	MatSetVecValueP();
Matrix	MatSetVecValueR();

Matrix	MatDef();
Matrix	MatRequest();
Matrix	MatNonNameDef();
Matrix	MatEigValDef();
Matrix	MatEigVecDef();
#ifdef HAVE_STDARG
Matrix	MatDiagDef(int n, ...);
#else
Matrix	MatDiagDef();
#endif
Matrix	MatVecToDiag();
Matrix	MatVecToDiag2();
Matrix	MatDiagToVec();
Matrix	MatDiagToVec2();
#ifdef HAVE_STDARG
Matrix	MatVander(int n, ...);
#else
Matrix	MatVander();
#endif
Matrix	MatMulDef();
Matrix	MatSameDef();
Matrix	MatSameZDef();
Matrix	MatSameClassDef();
Matrix	MatSameClassZDef();
Matrix	MatTransDef();
Matrix	MatIDef();
Matrix	MatIDef2();
Matrix	MatOneDef();
Matrix	MatSameSizeFillDef();
Matrix	MatFillDef();
Matrix	MatZDef();
Matrix	MatZDef2();
#ifdef HAVE_STDARG
Matrix	MatColumnVec(int n, ...);
Matrix	MatRowVec(int n, ...);
#else
Matrix	MatColumnVec();
Matrix	MatRowVec();
#endif
Matrix	MatColumnVector();
Matrix	MatRowVector();
#ifdef HAVE_STDARG
Matrix	MatBlockDiag(int n, ...);
#else
Matrix	MatBlockDiag();
#endif
Matrix	MatCompanion();
Matrix	MatNormalRand();
Matrix	MatUniformRand();
Matrix	MatSeries();
Matrix	MatReshape();
Matrix	MatString2Mat();
char	*MatMat2String();
Matrix	MatGetTime();
Matrix	mxStringCompareElem();

Matrix	MatAdd();
Matrix	MatAdd_double();
Matrix	MatAdd_Complex();
Matrix	MatAdd_Polynomial();
Matrix	MatAdd_Rational();
Matrix	MatSub();
Matrix	MatSub_double();
Matrix	MatSub_Complex();
Matrix	MatSub_Polynomial();
Matrix	MatSub_Rational();
Matrix	MatMul();
Matrix	MatMulElem();
Matrix	MatDivElem();
Matrix	MatInv();
Matrix	MatInvElem();
Matrix	MatPseudoInv();
Matrix	MatTrans();
Matrix	MatFlipLR();
Matrix	MatFlipUD();
Matrix	MatShiftLeft();
Matrix	MatShiftRight();
Matrix	MatShiftUp();
Matrix	MatShiftDown();
Matrix	MatRotateLeft();
Matrix	MatRotateRight();
Matrix	MatRotateUp();
Matrix	MatRotateDown();
Matrix	MatSort();
Matrix	MatNegate();
Matrix	MatIncrement();
Matrix	MatDecrement();
Matrix	MatSetZero();
Matrix	MatRoundToZero();
Matrix	MatExp();
Matrix	MatExpElem();
Matrix	MatConj();
Matrix	MatConjTrans();
Matrix	MatPow();
Matrix	MatPowElem();
Matrix	MatPowElemToReal();
Matrix	MatPowElemToComp();
Matrix	MatPowElemEach();
Matrix	MatRemElem();
Matrix	MatRemElemEach();

Matrix	MatApply();
Matrix	MatApplyPolyFunc();
Matrix	MatApplyRatFunc();
Matrix	MatAbsElem();
Matrix	MatArgElem();
Matrix	MatCeilElem();
Matrix	MatFloorElem();
Matrix	MatFixToZeroElem();
Matrix	MatRintElem();
Matrix	MatSinElem();
Matrix	MatAsinElem();
Matrix	MatSinhElem();
Matrix	MatAsinhElem();
Matrix	MatCosElem();
Matrix	MatAcosElem();
Matrix	MatCoshElem();
Matrix	MatAcoshElem();
Matrix	MatTanElem();
Matrix	MatAtanElem();
Matrix	MatAtan2Elem();
Matrix	MatBitAndElem();
Matrix	MatBitComplementElem();
Matrix	MatBitOrElem();
Matrix	MatBitLShiftElem();
Matrix	MatBitRShiftElem();
Matrix	MatBitXorElem();
Matrix	MatTanhElem();
Matrix	MatAtanhElem();
Matrix	MatLog();
Matrix	MatLogElem();
Matrix	MatLog10Elem();
Matrix	MatSgnElem();
Matrix	MatCompareElem();
Matrix	MatCompareElemD();
Matrix	MatCompareElemC();
Matrix	MatCompareElemP();
Matrix	MatCompareElemR();
Matrix	MatNotElem();
Matrix	MatFiniteElem();
Matrix	MatNaNElem();
Matrix	MatInfElem();
Matrix	MatFindNonZeroElem();
Matrix	MatIndexOneElem();

Matrix	MatScale();
Matrix	MatScaleSelf();
Matrix	MatScaleC();

#ifdef P_MAT
Matrix	MatScaleP();
Matrix	MatEval();
Matrix	MatEvalC();
Matrix	MatEvalP();
Matrix	MatEvalM();
Matrix	MatEvalMElem();
#endif

#ifdef R_MAT
Matrix	MatScaleR();
Matrix	MatEvalR();
#endif

Matrix	MatRealPart();
Matrix	MatImagPart();
Matrix	MatNumeElem();
Matrix	MatDenoElem();
Matrix	MatCatColumn();
Matrix	MatCatRow();
#ifdef HAVE_STDARG
Matrix	MatCatColumns(int n, ...);
Matrix	MatCatRows(int n, ...);
#else
Matrix	MatCatColumns();
Matrix	MatCatRows();
#endif
Matrix	MatCat4();
Matrix	MatCut();
Matrix	MatPut();
Matrix	MatEnlarge();
Matrix	MatEnlargeClass();
Matrix	MatSetSubMatrix();
Matrix	MatSetRowVecs();
Matrix	MatSetColVecs();
Matrix	MatSetSubMatrix2();
Matrix	MatSetRowVecs2();
Matrix	MatSetColVecs2();
Matrix	MatSetSubVec();
Matrix	MatSetVecSubMatrix2();
Matrix	MatSetVecSubMatrix();
Matrix	MatGetSubMatrix();
Matrix	MatGetSubMatrix2();
Matrix	MatGetVecSubMatrix();
Matrix	MatGetVecSubMatrix2();
Matrix	MatSetBlockSubMatrix();
Matrix	MatSetBlockRowVecs();
Matrix	MatSetBlockColVecs();
Matrix	MatPutBlock();
Matrix	MatGetBlockSubMatrix();
Matrix	MatAreaCopy();
Matrix	MatRealAndImag();

Matrix	MatRealToComp();

#ifdef P_MAT
Matrix	MatRealToPoly();
Matrix	MatCompToPoly();
#endif

#ifdef R_MAT
Matrix	MatRealToRat();
Matrix	MatCompToRat();
Matrix	MatPolyToRat();
#endif

Matrix	MatVectorProduct();
Matrix	MatVectorSquare();
Matrix	MatSingVal();
Matrix	MatSingVec();
Matrix	MatSingValVec();
Matrix	MatSingLeftVec();
Matrix	MatSingRightVec();
Matrix	MatFunc();
Matrix	MatSqrt();
Matrix	MatSqrtElem();
Matrix	MatSqrtElem();
Matrix	MatEigVal();
Matrix	MatEigVec();
Matrix	MatEigValVec();
Matrix	MatGEigVal();
Matrix	MatGEigVec();
Matrix	MatGEigValVec();
Matrix	MatKernel();
Matrix	MatDerivative();
Matrix	MatIntegral();
Matrix	MatLowerShift();
Matrix	MatHigherShift();
Matrix	MatRungeKutta4();
Matrix	MatRungeKutta4Link();
Matrix	MatRKF45();
Matrix	MatRKF45Link();
Matrix	MatForSub();
Matrix	MatBackSub();
Matrix	MatLUSolve();
Matrix	MatLeastSquare();
Matrix	MatLinearEQ();
Matrix	MatLinearEQ2();
Matrix	MatFFT();
Matrix	MatIFFT();
Matrix	MatFrobNorms();

double	MatDeterm();
double	MatScalarProduct();
double	MatFrobNorm();
double	MatInfNorm();
double	MatNorm();
double	MatTrace();
double	MatMaxElem();
double	MatMinElem();
double	MatMaximumElem();
double	MatMinimumElem();
double	MatSumElem();
double	MatProdElem();
double	MatMeanElem();
double	MatStdDevElem();
Matrix	MatAll();
Matrix	MatAny();
Matrix	MatMax();
Matrix	MatMin();
Matrix	MatSum();
Matrix	MatProd();
Matrix	MatCumSum();
Matrix	MatCumSumElem();
Matrix	MatCumProd();
Matrix	MatCumProdElem();
Matrix	MatMean();
Matrix	MatStdDev();
Matrix	MatMaximum();
Matrix	MatMinimum();
double	MatMaxSingVal();
double	MatMinSingVal();

int		MatIsSingular();
int		MatIsNonSingular();
int		MatIsFullRank();
int		MatIsAnyZero();
int		MatRank();
/* int		MatRankTOL(); */

double	MatGetValue();
double	MatGetValueOne();
double	*MatGetPtr();
double	MatGetVecValue();
double	*MatGetVecPtr();

int		MatIsPositive();
int		MatIsPositiveSemi();
int		MatIsNonPositive();
int		MatIsNegative();
int		MatIsNegativeSemi();
int		MatIsNonNegative();
int		MatIsZero();
int		MatIsNonZero();
int		MatIsEqual();
int		MatIsNotEqual();
int		MatIsRealValue();
int		MatIsComplexValue();

void	MatEig();
void	MatGEig();
void	MatHermitEig();
void	MatSVD();
void	MatLU();
void	MatHessenberg();
void	MatSchur();
void	MatQR();
void	MatQZ();
void	MatBalance();
void	MatOde();
void	MatOde45();
void	MatOdeHybrid();
void	MatOde45Hybrid();
void	MatOdeStop();
void	ode_int_link();

Matrix	Mat_Add();
Matrix	Mat_Add_double();
Matrix	Mat_AddSelf();
Matrix	Mat_Sub();
Matrix	Mat_Sub_double();
Matrix	Mat_SubSelf();
Matrix	Mat_Mul();
Matrix	Mat_MulElem();
Matrix	Mat_MulElemSelf();
Matrix	Mat_DivElem();
Matrix	Mat_DivElemSelf();
Matrix	Mat_Inv();
Matrix	Mat_InvElem();
Matrix	Mat_InvElemSelf();
Matrix	Mat_PseudoInv();
Matrix	Mat_Trans();
Matrix	Mat_FlipLR();
Matrix	Mat_FlipUD();
Matrix	Mat_ShiftLeft();
Matrix	Mat_ShiftRight();
Matrix	Mat_ShiftUp();
Matrix	Mat_ShiftDown();
Matrix	Mat_RotateLeft();
Matrix	Mat_RotateRight();
Matrix	Mat_RotateUp();
Matrix	Mat_RotateDown();
Matrix	Mat_Sort();
Matrix	Mat_Negate();
Matrix	Mat_Decrement();
Matrix	Mat_Increment();
Matrix	Mat_SetZero();
Matrix	Mat_RoundToZero();
Matrix	Mat_Exp();
Matrix	Mat_Pow();
Matrix	Mat_PowElem();
Matrix	Mat_PowElemToReal();
Matrix	Mat_PowElemEach();
Matrix	Mat_RemElem();
Matrix	Mat_RemElemEach();

Matrix	Mat_Scale();
Matrix	Mat_ScaleSelf();
Matrix	Mat_CatColumn();
Matrix	Mat_CatRow();
Matrix	Mat_Cat4();
Matrix	Mat_Cut();
Matrix	Mat_Put();
Matrix	Mat_SetSubMatrix();
Matrix	Mat_GetSubMatrix();
Matrix	Mat_SetVecSubMatrix();
Matrix	Mat_GetVecSubMatrix();
Matrix	Mat_SetBlockSubMatrix();
Matrix	Mat_GetBlockSubMatrix();
Matrix	Mat_AreaCopy();
Matrix	Mat_Copy();
Matrix	Mat_VectorProduct();
Matrix	Mat_VectorSquare();
Matrix	Mat_Integral();
Matrix	Mat_HigherShift();
Matrix	Mat_Apply();
Matrix	Mat_ApplyTwo();
Matrix	Mat_ApplyPolyFunc();
Matrix	Mat_ApplyC_PolyFunc();
Matrix	Mat_ApplyRatFunc();
Matrix	Mat_ApplyC_RatFunc();
Matrix	Mat_CompareElem();
Matrix	Mat_NotElem();
Matrix	Mat_FiniteElem();
Matrix	Mat_NaNElem();
Matrix	Mat_InfElem();
Matrix	Mat_RungeKutta4();
Matrix	Mat_RungeKutta4Link();
Matrix	Mat_RKF45();
Matrix	Mat_RKF45Link();
Matrix	Mat_ForSub();
Matrix	Mat_BackSub();
Matrix	Mat_LUSolve();
Matrix	Mat_FFT();
Matrix	Mat_IFFT();
Matrix	Mat_All();
Matrix	Mat_Any();
Matrix	Mat_Max();
Matrix	Mat_Min();
Matrix	Mat_Maximum();
Matrix	Mat_Minimum();
Matrix	Mat_Sum();
Matrix	Mat_Prod();
Matrix	Mat_CumSum();
Matrix	Mat_CumSumElem();
Matrix	Mat_CumProd();
Matrix	Mat_CumProdElem();
Matrix	Mat_Mean();
Matrix	Mat_StdDev();
Matrix	Mat_FrobNorms();

void	Mat_Eig();
void	Mat_GEig();
void	Mat_SVD();
void	Mat_LU();
void	Mat_Hessenberg();
void	Mat_Schur();
void	Mat_QR();
void	Mat_QZ();
void	Mat_Balance();
int		Mat_Ode();
int		Mat_Ode45();
int		Mat_OdeHybrid();
int		Mat_Ode45Hybrid();
int		Mat_OdeGetXY();
void	Mat_Swap();
void	Mat_Print();
Matrix	Mat_ChangeColumn();
Matrix	Mat_ChangeRow();
Matrix	Mat_EigVal();
Matrix	Mat_EigVec();
Matrix	Mat_EigValVec();
Matrix	Mat_GEigVal();
Matrix	Mat_GEigVec();
Matrix	Mat_GEigValVec();
Matrix	Mat_Integral();
/* ------------------------------------------------------------------------- */
Matrix	C_MatCopy();
Matrix	C_MatSetValue();
Matrix	C_MatFillValue();
Matrix	C_MatSetVecValue();
Complex	C_MatDeterm();
Complex	C_MatScalarProduct();
Complex	C_MatTrace();
Complex	C_MatMaxElem();
Complex	C_MatMinElem();
Complex	C_MatMaximumElem();
Complex	C_MatMinimumElem();
Complex	C_MatSumElem();
Complex	C_MatProdElem();
Complex	C_MatMeanElem();
double	C_MatStdDevElem();

Complex C_MatGetValue();
Complex C_MatGetValueOne();
ComplexValue C_MatGetPtr();
Complex C_MatGetVecValue();
ComplexValue C_MatGetVecPtr();

void	C_Mat_Print();
void	C_MatSwap();
Matrix	C_Mat_ChangeColumn();
Matrix	C_Mat_ChangeRow();

Matrix	C_MatDef();
Matrix	C_MatNonNameDef();
Matrix	C_MatSameDef();
Matrix	C_MatTransDef();
Matrix	C_MatMulDef();
#ifdef HAVE_STDARG
Matrix	C_MatDiagDef(int n, ...);
#else
Matrix	C_MatDiagDef();
#endif
#ifdef HAVE_STDARG
Matrix	C_MatVander(int n, ...);
#else
Matrix	C_MatVander();
#endif
Matrix	C_MatIDef();
Matrix	C_MatIDef2();
Matrix	C_MatOneDef();
Matrix	C_MatSameSizeFillDef();
Matrix	C_MatFillDef();
Matrix	C_MatZDef();
Matrix	C_MatZDef2();
Matrix	C_MatRealPart();
Matrix	C_MatImagPart();
#ifdef HAVE_STDARG
Matrix	C_MatColumnVec(int n, ...);
Matrix	C_MatRowVec(int n, ...);
#else
Matrix	C_MatColumnVec();
Matrix	C_MatRowVec();
#endif
Matrix	C_MatNormalRand();
Matrix	C_MatUniformRand();

Matrix	C_Mat_Add();
Matrix	C_Mat_Add_double();
Matrix	C_Mat_Add_Complex();
Matrix	C_Mat_AddSelf();
Matrix	C_Mat_Sub();
Matrix	C_Mat_Sub_double();
Matrix	C_Mat_Sub_Complex();
Matrix	C_Mat_SubSelf();
Matrix	C_Mat_Mul();
Matrix	C_Mat_MulElem();
Matrix	C_Mat_MulElemSelf();
Matrix	C_Mat_DivElem();
Matrix	C_Mat_DivElemSelf();
Matrix	C_Mat_Inv();
Matrix	C_Mat_InvElem();
Matrix	C_Mat_InvElemSelf();
Matrix	C_Mat_PseudoInv();
Matrix	C_Mat_Trans();
Matrix	C_Mat_FlipLR();
Matrix	C_Mat_FlipUD();
Matrix	C_Mat_ShiftLeft();
Matrix	C_Mat_ShiftRight();
Matrix	C_Mat_ShiftUp();
Matrix	C_Mat_ShiftDown();
Matrix	C_Mat_RotateLeft();
Matrix	C_Mat_RotateRight();
Matrix	C_Mat_RotateUp();
Matrix	C_Mat_RotateDown();
Matrix	C_Mat_Sort();
Matrix	C_Mat_Negate();
Matrix	C_Mat_SetZero();
Matrix	C_Mat_RoundToZero();
Matrix	C_Mat_Exp();
Matrix	C_Mat_Conj();
Matrix	C_Mat_ConjTrans();
Matrix	C_Mat_Pow();
Matrix	C_Mat_PowElem();
Matrix	C_Mat_PowElemToReal();
Matrix	C_Mat_PowElemToComp();
Matrix	C_Mat_PowElemEach();
Matrix	C_Mat_CompareElem();
Matrix	C_Mat_FiniteElem();
Matrix	C_Mat_NaNElem();
Matrix	C_Mat_InfElem();
Matrix	C_Mat_Scale();
Matrix	C_Mat_ScaleSelf();
Matrix	C_Mat_ScaleSelfC();
Matrix	C_Mat_ScaleC();
Matrix	C_Mat_Put();
Matrix	C_Mat_Cut();
Matrix	C_Mat_GetSubMatrix();
Matrix	C_Mat_GetVecSubMatrix();
Matrix	C_Mat_SetSubMatrix();
Matrix	C_Mat_SetVecSubMatrix();
Matrix	C_Mat_GetBlockSubMatrix();
Matrix	C_Mat_SetBlockSubMatrix();
Matrix	C_Mat_AreaCopy();
Matrix	C_Mat_RealPart();
Matrix	C_Mat_ImagPart();
Matrix	C_Mat_CatColumn();
Matrix	C_Mat_CatRow();
Matrix	C_Mat_RealAndImag();
Matrix	C_Mat_RealToComp();
Matrix	C_Mat_VectorProduct();
Matrix	C_Mat_VectorSquare();
Matrix	C_Mat_EigVal();
Matrix	C_Mat_EigVec();
Matrix	C_Mat_EigValVec();
Matrix	C_Mat_GEigVal();
Matrix	C_Mat_GEigVec();
Matrix	C_Mat_GEigValVec();
Matrix	C_Mat_Integral();
Matrix	C_Mat_HigherShift();
Matrix	C_Mat_Apply();
Matrix	C_Mat_ApplyTwo();
Matrix	C_Mat_Apply2();
Matrix	C_Mat_ApplyPolyFunc();
Matrix	C_Mat_ApplyC_PolyFunc();
Matrix	C_Mat_ApplyRatFunc();
Matrix	C_Mat_ApplyC_RatFunc();
Matrix	C_Mat_RungeKutta4();
Matrix	C_Mat_RungeKutta4Link();
Matrix	C_Mat_RKF45();
Matrix	C_Mat_RKF45Link();
Matrix	C_Mat_ForSub();
Matrix	C_Mat_BackSub();
Matrix	C_Mat_LUSolve();
Matrix	C_Mat_FFT();
Matrix	C_Mat_IFFT();
Matrix	C_Mat_All();
Matrix	C_Mat_Any();
Matrix	C_Mat_Max();
Matrix	C_Mat_Min();
Matrix	C_Mat_Maximum();
Matrix	C_Mat_Minimum();
Matrix	C_Mat_Sum();
Matrix	C_Mat_Prod();
Matrix	C_Mat_CumSum();
Matrix	C_Mat_CumSumElem();
Matrix	C_Mat_CumProd();
Matrix	C_Mat_CumProdElem();
Matrix	C_Mat_Mean();
Matrix	C_Mat_StdDev();
Matrix	C_Mat_FrobNorms();

void	C_Mat_Eig();
void	C_Mat_GEig();
void	C_Mat_LU();
void	C_Mat_Hessenberg();
void	C_Mat_Schur();
void	C_Mat_QR();
void	C_Mat_QZ();
void	C_Mat_Balance();
int		C_Mat_Ode();
int		C_Mat_Ode45();
int		C_Mat_OdeHybrid();
int		C_Mat_Ode45Hybrid();
void	C_Mat_HermitEig();

/* ------------------------------------------------------------------------- */

#ifdef P_MAT
Matrix	P_MatCopy();
Matrix	P_MatEdit();
Matrix	P_MatInput();
Matrix	P_MatSetValue();
Matrix	P_MatFillValue();
Matrix	P_MatSetVecValue();
Matrix	P_MatSetVar();

Polynomial P_MatDeterm();
Polynomial P_MatScalarProduct();
Polynomial P_MatTrace();
Polynomial P_MatSumElem();
Polynomial P_MatMeanElem();
Polynomial P_MatProdElem();

Polynomial P_MatGetValue();
Polynomial P_MatGetValueOne();
Polynomial P_MatGetPtr();
Polynomial P_MatGetVecValue();
Polynomial P_MatGetVecPtr();

void	P_Mat_Print();
void	P_MatSwap();
Matrix	P_Mat_ChangeColumn();
Matrix	P_Mat_ChangeRow();

Matrix	P_MatDef();
Matrix	P_MatNonNameDef();
Matrix	P_MatSameDef();
Matrix	P_MatTransDef();
Matrix	P_MatMulDef();
#ifdef HAVE_STDARG
Matrix	P_MatDiagDef(int n, ...);
#else
Matrix	P_MatDiagDef();
#endif
#ifdef HAVE_STDARG
Matrix	P_MatVander(int n, ...);
#else
Matrix	P_MatVander();
#endif
Matrix	P_MatIDef();
Matrix	P_MatIDef2();
Matrix	P_MatOneDef();
Matrix	P_MatSameSizeFillDef();
Matrix	P_MatFillDef();
Matrix	P_MatZDef();
Matrix	P_MatZDef2();
Matrix	P_MatRealPart();
Matrix	P_MatImagPart();
#ifdef HAVE_STDARG
Matrix	P_MatColumnVec(int n, ...);
Matrix	P_MatRowVec(int n, ...);
#else
Matrix	P_MatColumnVec();
Matrix	P_MatRowVec();
#endif

Matrix	P_Mat_Add();
Matrix	P_Mat_Add_double();
Matrix	P_Mat_Add_Complex();
Matrix	P_Mat_Add_Polynomial();
Matrix	P_Mat_Sub();
Matrix	P_Mat_Sub_double();
Matrix	P_Mat_Sub_Complex();
Matrix	P_Mat_Sub_Polynomial();
Matrix	P_Mat_Mul();
Matrix	P_Mat_MulElem();
Matrix	P_Mat_DivElem();
Matrix	P_Mat_InvElem();
Matrix	P_Mat_Trans();
Matrix	P_Mat_FlipLR();
Matrix	P_Mat_FlipUD();
Matrix	P_Mat_ShiftLeft();
Matrix	P_Mat_ShiftRight();
Matrix	P_Mat_ShiftUp();
Matrix	P_Mat_ShiftDown();
Matrix	P_Mat_RotateLeft();
Matrix	P_Mat_RotateRight();
Matrix	P_Mat_RotateUp();
Matrix	P_Mat_RotateDown();
Matrix	P_Mat_Negate();
Matrix	P_Mat_SetZero();
Matrix	P_Mat_RoundToZero();
Matrix	P_Mat_Conj();
Matrix	P_Mat_ConjTrans();
Matrix	P_Mat_Pow();
Matrix	P_Mat_PowElem();
Matrix	P_Mat_PowElemEach();
Matrix	P_Mat_CompareElem();
Matrix	P_Mat_Scale();
Matrix	P_Mat_ScaleSelf();
Matrix	P_Mat_ScaleC();
Matrix	P_Mat_ScaleP();
Matrix	P_Mat_ScaleR();
Matrix	P_Mat_Eval();
Matrix	P_Mat_EvalC();
Matrix	P_Mat_EvalP();
Matrix	P_Mat_EvalR();
Matrix	P_Mat_EvalM();
Matrix	P_Mat_EvalMElem();
Matrix	P_Mat_Apply();
Matrix	P_Mat_ApplyPolyFunc();
Matrix	P_Mat_ApplyRatFunc();
Matrix	P_Mat_Put();
Matrix	P_Mat_Cut();
Matrix  P_Mat_GetSubMatrix();
Matrix  P_Mat_GetVecSubMatrix();
Matrix	P_Mat_SetSubMatrix();
Matrix	P_Mat_SetVecSubMatrix();
Matrix  P_Mat_GetBlockSubMatrix();
Matrix	P_Mat_SetBlockSubMatrix();
Matrix	P_Mat_AreaCopy();
Matrix	P_Mat_RealPart();
Matrix	P_Mat_ImagPart();
Matrix	P_Mat_RealAndImag();
Matrix	P_Mat_RealToComp();
Matrix	P_Mat_RealToPoly();
Matrix	P_Mat_CompToPoly();
Matrix	P_Mat_CatColumn();
Matrix	P_Mat_CatRow();
Matrix	P_Mat_VectorProduct();
Matrix	P_Mat_VectorSquare();
Matrix	P_Mat_Derivative();
Matrix	P_Mat_Integral();
Matrix	P_Mat_LowerShift();
Matrix	P_Mat_HigherShift();
Matrix	P_Mat_Sum();
Matrix	P_Mat_Mean();
Matrix	P_Mat_CumSum();
Matrix	P_Mat_CumSumElem();
Matrix	P_Mat_CumProd();
Matrix	P_Mat_CumProdElem();
Matrix	P_Mat_Prod();
#endif

/* ------------------------------------------------------------------------- */

#ifdef R_MAT
Matrix	R_MatCopy();
Matrix	R_MatEdit();
Matrix	R_MatInput();
Matrix	R_MatSetValue();
Matrix	R_MatFillValue();
Matrix	R_MatSetVecValue();
Matrix	R_MatSetVar();

Rational R_MatDeterm();
Rational R_MatScalarProduct();
Rational R_MatTrace();
Rational R_MatSumElem();
Rational R_MatProdElem();
Rational R_MatMeanElem();

Rational R_MatGetValue();
Rational R_MatGetValueOne();
Rational R_MatGetPtr();
Rational R_MatGetVecValue();
Rational R_MatGetVecPtr();

void	R_Mat_Print();
void	R_MatSwap();
Matrix	R_Mat_ChangeColumn();
Matrix	R_Mat_ChangeRow();

Matrix	R_MatDef();
Matrix	R_MatNonNameDef();
Matrix	R_MatSameDef();
Matrix	R_MatTransDef();
Matrix	R_MatMulDef();
#ifdef HAVE_STDARG
Matrix	R_MatDiagDef(int n, ...);
#else
Matrix	R_MatDiagDef();
#endif
#ifdef HAVE_STDARG
Matrix	R_MatVander(int n, ...);
#else
Matrix	R_MatVander();
#endif
Matrix	R_MatIDef();
Matrix	R_MatIDef2();
Matrix	R_MatOneDef();
Matrix	R_MatSameSizeFillDef();
Matrix	R_MatFillDef();
Matrix	R_MatZDef();
Matrix	R_MatZDef2();
Matrix	R_MatRealPart();
Matrix	R_MatImagPart();
#ifdef HAVE_STDARG
Matrix	R_MatColumnVec(int n, ...);
Matrix	R_MatRowVec(int n, ...);
#else
Matrix	R_MatColumnVec();
Matrix	R_MatRowVec();
#endif

Matrix	R_Mat_Add();
Matrix	R_Mat_Add_double();
Matrix	R_Mat_Add_Complex();
Matrix	R_Mat_Add_Polynomial();
Matrix	R_Mat_Add_Rational();
Matrix	R_Mat_Sub();
Matrix	R_Mat_Sub_double();
Matrix	R_Mat_Sub_Complex();
Matrix	R_Mat_Sub_Polynomial();
Matrix	R_Mat_Sub_Rational();
Matrix	R_Mat_Mul();
Matrix	R_Mat_MulElem();
Matrix	R_Mat_DivElem();
Matrix	R_Mat_InvElem();
Matrix	R_Mat_Trans();
Matrix	R_Mat_FlipLR();
Matrix	R_Mat_FlipUD();
Matrix	R_Mat_ShiftLeft();
Matrix	R_Mat_ShiftRight();
Matrix	R_Mat_ShiftUp();
Matrix	R_Mat_ShiftDown();
Matrix	R_Mat_RotateLeft();
Matrix	R_Mat_RotateRight();
Matrix	R_Mat_RotateUp();
Matrix	R_Mat_RotateDown();
Matrix	R_Mat_Negate();
Matrix	R_Mat_SetZero();
Matrix	R_Mat_RoundToZero();
Matrix	R_Mat_Conj();
Matrix	R_Mat_ConjTrans();
Matrix	R_Mat_Pow();
Matrix	R_Mat_PowElem();
Matrix	R_Mat_PowElemEach();
Matrix	R_Mat_CompareElem();
Matrix	R_Mat_Scale();
Matrix	R_Mat_ScaleSelf();
Matrix	R_Mat_ScaleC();
Matrix	R_Mat_ScaleP();
Matrix	R_Mat_ScaleR();
Matrix	R_Mat_Eval();
Matrix	R_Mat_EvalC();
Matrix	R_Mat_EvalP();
Matrix	R_Mat_EvalR();
Matrix	R_Mat_EvalM();
Matrix	R_Mat_EvalMElem();
Matrix	R_Mat_Apply();
Matrix	R_Mat_ApplyPolyFunc();
Matrix	R_Mat_ApplyRatFunc();
Matrix	R_Mat_Put();
Matrix	R_Mat_Cut();
Matrix  R_Mat_GetSubMatrix();
Matrix  R_Mat_GetVecSubMatrix();
Matrix	R_Mat_SetSubMatrix();
Matrix	R_Mat_SetVecSubMatrix();
Matrix  R_Mat_GetBlockSubMatrix();
Matrix	R_Mat_SetBlockSubMatrix();
Matrix	R_Mat_AreaCopy();
Matrix	R_Mat_RealPart();
Matrix	R_Mat_ImagPart();
Matrix	R_Mat_NumeElem();
Matrix	R_Mat_DenoElem();
Matrix	R_Mat_RealAndImag();
Matrix	R_Mat_RealToComp();
Matrix	R_Mat_RealToRat();
Matrix	R_Mat_CompToRat();
Matrix	R_Mat_PolyToRat();
Matrix	R_Mat_CatColumn();
Matrix	R_Mat_CatRow();
Matrix	R_Mat_VectorProduct();
Matrix	R_Mat_VectorSquare();
Matrix	R_Mat_Derivative();
Matrix	R_Mat_LowerShift();
Matrix	R_Mat_HigherShift();
Matrix	R_Mat_Sum();
Matrix	R_Mat_Prod();
Matrix	R_Mat_CumSum();
Matrix	R_Mat_CumSumElem();
Matrix	R_Mat_CumProd();
Matrix	R_Mat_CumProdElem();
Matrix	R_Mat_Mean();
#endif

#endif

/* --------------------------------------------------------------------------

void	MatFree(Matrix mat);
void	MatFrees(Matrix mat);
void	MatAllFree(void);
void	MatInstall(Matrix mat);
void	MatDestroy(Matrix mat);
void	MatUndef(Matrix mat);
void	MatElementDestroy(Matrix mat);
void	MatUndefs(Matrix mat);
void	MatMultiUndefs(int n, Matrix a1, Matrix a2, ...);
void	MatAllUndef(void);
void	MatTmpUndef(void);
#ifdef MATX_RT
void	MatTmpUndefs(Matrix a);
#endif
void	MatObjectTmpUndef(void);
void	MatInit(void);
void	MatSwap(Matrix mat1, Matrix mat2);
void	MatSameSizeCheck(Matrix a, Matrix b, char *name);
void	MatSameClassCheck(Matrix a, Matrix b, char *name);
void	MatZeroSizeCheck(Matrix a, char *name);
void	MatZeroSizeCheck2(Matrix a, Matrix b, char *name);
void	MatNotRealCheck(Matrix a, char *name);
void	MatNotComplexCheck(Matrix a, char *name);
void	MatNotPolynomialCheck(Matrix a, char *name);
void	MatNotRationalCheck(Matrix a, char *name);
void	MatNonSquareCheck(Matrix a, char *name):
void	MatNonSquareCheck2(Matrix a, Matrix b, char *name):

void	MatPrint(Matrix mat);
void	MatPrintArray(Matrix mat);
void	MatPrintIndex(Matrix mat);
void	MatAllPrint(void);
void	MatError(char *func, char *statement, Matrix a);
void	MatError2(char *func, char *statement, Matrix a, Matrix b);
void	MatWarning(char *func, char *statement, Matrix a);
void	MatWarning2(char *func, char *statement, Matrix a, Matrix b);
void	MatErrorNotRealNorComplex(Matrix a, char *name)
void	MatErrorNotRealNorComplex2(Matrix a, Matrix b, char *name)

Matrix	MatAssign(Matrix to, Matrix from);
Matrix	MatAssignOnly(Matrix to, Matrix from);
Matrix	MatChangeColumn(Matrix mat, int column, int row);
Matrix	MatChangeRow(Matrix mat, int column, int row);
Matrix	MatPermutate(Matrix mat, int *piv, int rk int left);
Matrix	MatCopy(Matrix to, Matrix from);
Matrix	MatElementCopy(Matrix to, Matrix from);
Matrix	MatElementChange(Matrix to, Matrix from);
Matrix	MatMove(Matrix to, Matrix from);
Matrix	MatDup(Matrix mat);
Matrix	MatEdit(Matrix mat);
Matrix	MatEditComplex(Matrix mat);
Matrix	MatFileRead(char *filename);
Matrix	MatFileWrite(Matrix mat, char *filename);
Matrix	MatFileSave(Matrix mat, char *filename, int append, int cr,char *cast);
Matrix	MatWrite(Matrix mm, FILE *fp, unsigned long mat_type);
Matrix	MatRead(Matrix ma, FILE *fp, unsinged long mat_type);
int		MatReadContent(Matrix ma, FILE *fp, MatrixData *data);
int		MatReadContentV5(Matrix ma, FILE *fp, MatrixData *data);
Matrix	MatFread(FILE *fp, int num, char *type, int flip);
int		MatFwrite(FILE *fp, Matrix ma, char *type);
Matrix	MatSetName(Matrix mat, char *name);
Matrix	MatSetVar(Matrix mat, char *var);
Matrix	MatSetType(Matrix mat, int type);
Matrix	MatSetClass(Matrix mat, int class);
Matrix	MatSetValue(Matrix mat, int column, int row, double d);
Matrix	Mat_SetValue(Matrix mat, int column, int row, double d);
Matrix	MatSetValueC(Matrix mat, int column, int row, Complex c);
Matrix	MatSetValueP(Matrix mat, int column, int row, Polynomial p);
Matrix	MatSetValueR(Matrix mat, int column, int row, Rational r);
Matrix	MatFillValue(Matrix mat, double d);
Matrix	MatSetVecValue(Matrix mat, int number, double d);
Matrix	Mat_SetVecValue(Matrix mat, int number, double d);
Matrix	MatSetVecValueC(Matrix mat, int number, Complex c);
Matrix	MatSetVecValueP(Matrix mat, int number, Polynomial p);
Matrix	MatSetVecValueR(Matrix mat, int number, Rational r);
Matrix	MatSearch(char *name);
Matrix	MatInput(char *name);

Matrix	MatDef(char *name, int column, int row);
Matrix	MatRequest(int size, int class);
Matrix	MatNonNameDef(int column, int row);
Matrix	MatDiagDef(int size, double elm1, double elm2, ..... );
Matrix	MatVecToDiag(Matrix mat);
Matrix	MatVecToDiag2(Matrix mat, int k);
Matrix	MatDiagtoVec(Matrix mat);
Matrix	MatDiagtoVec2(Matrix mat, int k);
Matrix	MatVander(int size, double elm1, double elm2, ..... );
Matrix	MatEigValDef(Matrix mat);
Matrix	MatEigVecDef(Matrix mat);
Matrix	MatIDef(int size);
Matrix	MatIDef2(int column, int row);
Matrix	MatOneDef(int column, int row);
Matrix	MatSameSizeFillDef(Matrix mat, double data);
Matrix	MatFillDef(int column, int row, double data);
Matrix	MatZDef(int size);
Matrix	MatZDef2(int column, int row);
Mattrix	MatMulDef(Matrix mat1, Matrix mat2);
Matrix	MatSameDef(Matrix mat);
Matrix	MatSameZDef(Matrix mat);
Matrix	MatSameClassDef(Matrix mat, int column, int row);
Matrix	MatSameClassZDef(Matrix mat, int column, int row);
Matrix	MatTransDef(Matrix mat);
Matrix	MatColumnVec(int size, double elm1, double elm2, ..... );
Matrix	MatRowVec(int size, double elm1, double elm2, ..... );
Matrix	MatColumnVector(Matrix mat, int column_number);
Matrix	MatRowVector(Matrix mat, int row_number);
Matrix	MatBlockDiag(int size, Matrix mat1, Matrix mat2, ...);
Matrix	MatCompanion(Matrix mat);
Matrix	MatNormalRand(int m, int n);
Matrix	MatUniformRand(int m, int n);
Matrix	MatSeries(double from, double to, double by);
Matrix	MatReshape(Matrix a, int column, int row);
Matrix	MatString2Mat(int str);
char	*MatMat2String(Matrix a);
Matrix	MatGetTime();
Matrix	mxStringCompareElem(mxString a, mxString b, char *op);

Matrix	MatAdd(Matrix mat1, Matrix mat2);
Matrix	MatAdd_double(Matrix mat1, double sc);
Matrix	MatAdd_Complex(Matrix mat1, Complex sc);
Matrix	MatAdd_Polynomial(Matrix mat1, Polynomial sc);
Matrix	MatAdd_Rational(Matrix mat1, Rational sc);
Matrix	MatSub(Matrix mat1, Matrix mat2);
Matrix	MatSub_double(Matrix mat1, double sc, int flag);
Matrix	MatSub_Complex(Matrix mat1, Complex sc, int flag);
Matrix	MatSub_Polynomial(Matrix mat1, Polynomial sc, int flag);
Matrix	MatSub_Rational(Matrix mat1, Rational sc, int flag);
Matrix	MatMul(Matrix mat1, Matrix mat2);
Matrix	MatMulElem(Matrix mat1, Matrix mat2);
Matrix	MatDivElem(Matrix mat1, Matrix mat2);
Matrix	MatInv(Matrix mat, double tol);
Matrix	MatInvElem(Matrix mat);
Matrix	MatPseudoInv(Matrix mat, double tol);
Matrix	MatPow(Matrix mat, int m);
Matrix	MatPowElem(Matrix mat, int m);
Matrix	MatPowElemToReal(Matrix mat, double dd);
Matrix	MatPowElemToComp(Matrix mat, Complex cc);
Matrix	MatPowElemEach(Matrix mat1, Matrix mat2);
Matrix	MatRemElem(Matrix mat, int m);
Matrix	MatRemElemEach(Matrix mat1, Matrix mat2);

Matrix	MatApply(Matrix mat, double (*func)());
Matrix	MatApplyPolyFunc(Matrix mat, Polynomial poly);
Matrix	MatApplyRatFunc(Matrix mat, Rational rat);
Matrix	MatAbsElem(Matrix mat);
Matrix	MatArgElem(Matrix mat);
Matrix	MatCeilElem(Matrix mat);
Matrix	MatFloorElem(Matrix mat);
Matrix	MatFixToZeroElem(Matrix mat);
Matrix	MatRintElem(Matrix mat);
Matrix	MatSinElem(Matrix mat);
Matrix	MatAsinElem(Matrix mat);
Matrix	MatSinhElem(Matrix mat);
Matrix	MatAsinhElem(Matrix mat);
Matrix	MatCosElem(Matrix mat);
Matrix	MatAcosElem(Matrix mat);
Matrix	MatCoshElem(Matrix mat);
Matrix	MatAcoshElem(Matrix mat);
Matrix	MatTanElem(Matrix mat);
Matrix	MatAtanElem(Matrix mat);
Matrix	MatAtan2Elem(Matrix mat1, Matrix mat2);
Matrix	MatBitAndElem(Matrix mat1, Matrix mat2);
Matrix	MatBitComplementElem(Matrix mat);
Matrix	MatBitOrElem(Matrix mat1, Matrix mat2);
Matrix	MatBitLShiftElem(Matrix mat1, int ii);
Matrix	MatBitRShiftElem(Matrix mat1, int ii);
Matrix	MatBitXorElem(Matrix mat1, Matrix mat2);
Matrix	MatTanhElem(Matrix mat);
Matrix	MatAtanhElem(Matrix mat);
Matrix	MatLog(Matrix mat);
Matrix	MatLogElem(Matrix mat);
Matrix	MatLog10Elem(Matrix mat);
Matrix	MatSgnElem(Matrix mat);
Matrix	MatCompareElem(Matrix mat1, Matrix mat2, char *opt);
Matrix	MatCompareElemD(Matrix mat1, double data, char *opt);
Matrix	MatCompareElemC(Matrix mat1, Complex data, char *opt);
Matrix	MatCompareElemP(Matrix mat1, Polynomial data, char *opt);
Matrix	MatCompareElemR(Matrix mat1, Rational data, char *opt);
Matrix	MatNotElem(Matrix mat);
Matrix	MatFiniteElem(Matrix mat);
Matrix	MatNaNElem(Matrix mat);
Matrix	MatInfElem(Matrix mat);
Matrix	MatFindNonZeroElem(Matrix mat1);
Matrix	MatIndexOneElem(Matrix mat1);
Matrix	MatRungeKutta4(double x, Matrix y, void (*diff)(), 
						Matrix u, double h)
Matrix	MatRungeKutta4Link(double x, Matrix y, void (*diff)(), 
						Matrix (*link)(), double h)
Matrix	MatRKF45(double x, Matrix y, void (*diff)(), 
					Matrix u, double h)
Matrix	MatRKF45Link(double x, Matrix y, void (*diff)(), 
					Matrix (*link)(), double h)

Matrix	MatScale(Matrix mat, double scale);
Matrix	MatScaleSelf(Matrix mat, double scale);
Matrix	MatScaleC(Matrix mat, Complex scale);
Matrix	MatScaleP(Matrix mat, Polynomial scale);
Matrix	MatScaleR(Matrix mat, Rational scale);
Matrix	MatEval(Matrix mat, double scale);
Matrix	MatEvalC(Matrix mat, Complex scale);
Matrix	MatEvalP(Matrix mat, Polynomial scale);
Matrix	MatEvalR(Matrix mat, Rational scale);
Matrix	MatEvalM(Matrix mat, Matrix scale);
Matrix	MatEvalMElem(Matrix mat, Matrix scale);
Matrix	MatTrans(Matrix mat);
Matrix	MatFlipLR(Matrix mat);
Matrix	MatFlipUD(Matrix mat);
Matrix	MatShiftLeft(Matrix mat, int m);
Matrix	MatShiftRight(Matrix mat, int m);
Matrix	MatShiftUp(Matrix mat, int m);
Matrix	MatShiftDown(Matrix mat, int m);
Matrix	MatRotateLeft(Matrix mat, int m);
Matrix	MatRotateRight(Matrix mat, int m);
Matrix	MatRotateUp(Matrix mat, int m);
Matrix	MatRotateDown(Matrix mat, int m);
Matrix	MatSort(Matrix mat, Matrix *idx, int row_col_all);
Matrix	MatNegate(Matrix mat);
Matrix	MatSetZero(Matrix mat);
Matrix	MatRoundToZero(Matrix mat, double tol);
Matrix	MatExp(Matrix mat);
Matrix	MatExpElem(Matrix mat);
Matrix	MatConj(Matrix mat);
Matrix	MatConjTrans(Matrix mat);
Matrix	MatRealPart(Matrix mat);
Matrix	MatImagPart(Matrix mat);
Matrix	MatNumeElem(Matrix mat);
Matrix	MatDenoElem(Matrix mat);
Matrix	MatCatColumn(Matrix mat1, Matrix mat2);
Matrix	MatCatColumns(int size, Matrix mat1, Matrix mat2, ...);
Matrix	MatCatRow(Matrix mat1, Matrix mat2);
Matrix	MatCatRows(int size, Matrix mat1, Matrix mat2, ...);
Matrix	MatCat4(Matrix mat11, Matrix mat12,Matrix mat21, Matrix mat22);
Matrix	MatCut(Matrix mat, int sx, int sy, int ex, int ey);
Matrix	MatPut(Matrix to,int sx, int sy, Matrix from);
Matrix	MatEnlarge(Matrix mat, int row_size, int col_size);
Matrix	MatEnlargeClass(Matrix mat, int row_size, int col_size, Matrix mat2);
Matrix	MatGetSubMatrix(Matrix mat, Matrix columns, Matrix rows, int not);
Matrix	MatGetSubMatrix2(Matrix mat, int from_r, int to_r, int by_r,
                         int from_c, int to_c, int by_c, int not)
Matrix	MatGetVecSubMatrix(Matrix mat, Matrix cols, int not);
Matrix	MatGetVecSubMatrix2(Matrix mat, int from_r, int to_r, int by_r,
                            int not);
Matrix	MatSetSubMatrix(Matrix mat, Matrix columns, Matrix rows, Matrix c);
Matrix	MatSetRowVecs(Matrix mat, int from_r, Matrix rows, Matrix c);
Matrix	MatSetColVecs(Matrix mat, Matrix columns, int from_r, Matrix c);
Matrix	MatSetSubMatrix2(Matrix mat, int from_r, int to_r, int by_r,
                         int from_c, int to_c, int by_c, Matrix c);
Matrix	MatSetRowVecs2(Matrix mat, int from_r, 
                         int from_c, int to_c, int by_c, Matrix c);
Matrix	MatSetColVecs2(Matrix mat, int from_r, int to_r, int by_r,
                         int from_c, Matrix c);
Matrix	MatSetSubVec(Matrix mat, int from_c, Matrix c);
Matrix	MatSetVecSubMatrix2(Matrix mat, int from_c, int to_c, int by_c,
                            Matrix c);
Matrix	MatSetVecSubMatrix(Matrix mat, Matrix cols, Matrix c);

Matrix	MatGetBlockSubMatrix(Matrix mat, Matrix rows, Matrix columns,
                             int pr, int pc, int not);
Matrix	MatSetBlockSubMatrix(Matrix mat, Matrix rows, Matrix columns,
                             int pr, int pc, Matrix c);
Matrix	MatSetBlockRowVecs(Matrix mat, Matrix rows, int from_c,
                             int pr, int pc, Matrix c);
Matrix	MatSetBlockColVecs(Matrix mat, int from_r, Matrix columns,
                             int pr, int pc, Matrix c);
Matrix	MatPutBlock(Matrix mat, int from_r, int from_c,
                             int pr, int pc, Matrix c);
Matrix	MatAreaCopy(Matrix a, int ac, int ar, Matrix b, 
					int bc1, int br1, int bc2, int br2)
Matrix	MatRealAndImag(Matrix real, Matrix imag);
Matrix	MatRealToComp(Matrix mat);
Matrix	MatRealToPoly(Matrix mat);
Matrix	MatRealToRat(Matrix mat);
Matrix	MatCompToPoly(Matrix mat);
Matrix	MatCompToRat(Matrix mat);
Matrix	MatPolytoRat(Matrix mat);
Matrix	MatVectorProduct(Matrix mat1, Matrix mat2);
Matrix	MatVectorSquare(Matrix mat1);
Matrix	MatSingVal(Matrix mat);
Matrix	MatSingVec(Matrix mat);
Matrix	MatSingValVec(Matrix mat);
Matrix	MatSingLeftVec(Matrix mat);
Matrix	MatSingRightVec(Matrix mat);
Matrix	MatFunc(Matrix mat, Complex (*func)(), char *name);
Matrix	MatSqrt(Matrix mat);
Matrix	MatSqrtElem(Matrix mat);
Matrix	MatEigVal(Matrix mat);
Matrix	MatEigVec(Matrix mat);
Matrix	MatEigValVec(Matrix mat);
Matrix	MatGEigVal(Matrix a, Matrix b);
Matrix	MatGEigVec(Matrix a, Matrix b);
Matrix	MatGEigValVec(Matrix a, Matrix b);
Matrix	MatKernel(Matrix mat, double tol);
Matrix	MatForSub(Matrix *l, Matrix *b, double tol);
Matrix	MatBackSub(Matrix *u, Matrix *b, double tol);
Matrix	MatLUSolve(Matrix *a, Matrix *b, double tol);
Matrix	MatLeastSquare(Matrix *a, Matrix *b, double tol);
Matrix	MatLinearEQ(Matrix *a, Matrix *b, double tol);
Matrix	MatLinearEQ2(Matrix *a, Matrix *b, double tol);
Matrix	MatFFT(Matrix a, int datanum, int row_col);
Matrix	MatIFFT(Matrix a, int datanum, int row_col);

double	MatDeterm(Matrix mat);
double	MatScalarProduct(Matrix a, Matrix b);
double	MatFrobNorm(Matrix mat);
double	MatFrobNorms(Matrix mat, int row_col);
double	MatInfNorm(Matrix mat);
double	MatNorm(Matrix mat, int p);
double	MatTrace(Matrix mat);
double	MatMaxElem(Matrix mat);
double	MatMinElem(Matrix mat);
double	MatMaximumElem(Matrix mat, int *ii, int *jj);
double	MatMinimumElem(Matrix mat, int *ii, int *jj);
double	MatSumElem(Matrix mat);
double	MatProdElem(Matrix mat);
double	MatMeanElem(Matrix mat);
double	MatStdDevElem(Matrix mat);
Matrix	MatMaximum(Matrix mat, Matrix *idx, int row_col);
Matrix	MatMinimum(Matrix mat, Matrix *idx, int row_col);
Matrix	MatAll(Matrix mat, int row_col_wise);
Matrix	MatAny(Matrix mat, int row_col_wise);
Matrix	MatMax(Matrix mat, int row_col_wise);
Matrix	MatMin(Matrix mat, int row_col_wise);
Matrix	MatSum(Matrix mat, int row_col_wise);
Matrix	MatProd(Matrix mat, int row_col_wise);
Matrix	MatCumSum(Matrix mat, int row_col_wise);
Matrix	MatCumSumElem(Matrix mat);
Matrix	MatCumProd(Matrix mat, int row_col_wise);
Matrix	MatCumProdElem(Matrix mat);
Matrix	MatMean(Matrix mat, int row_col_wise);
Matrix	MatStdDev(Matrix mat, int row_col_wise);
double	MatMaxSingVal(Matrix mat);
double	MatMinSingVal(Matrix mat);

int		MatIsSingular(Matrix mat, double tol);
int		MatIsNonSingular(Matrix mat, double tol);
int		MatIsFullRank(Matrix mat, double tol);
int		MatIsAnyZero(Matrix mat);
int		MatRank(Matrix mat, double tol);

double	MatGetValue(Matrix mat, int column, int row);
double	MatGetValueOne(Matrix mat, int column, int row);
double	*MatGetPtr(Matrix mat, int column, int row);
double	MatGetVecValue(Matrix mat, int number);
double	*MatGetVecPtr(Matrix mat, int number);

int		MatGetClass(Matrix mat);
int		MatClass(Matrix mat);
int		MatGetType(Matrix mat);
int		MatType(Matrix mat);
char	*MatGetName(Matrix mat);
char	*MatName(Matrix mat);

int		MatLength(Matrix mat);
int		MatGetRows(Matrix mat);
int		MatRows(Matrix mat);
int		Rows(Matrix mat);
int		MatGetCols(Matrix mat);
int		MatCols(Matrix mat);
int		Cols(Matrix mat);

int		MatIsReal(Matrix mat);
int		MatIsComplex(Matrix mat);
int		MatIsPolynomial(Matrix mat);

int		MatIsVar(Matrix mat);
int		MatIsTmp(Matrix mat);
int		MatIsRowVec(Matrix mat)
int		MatIsColumnVec(Matrix mat)
int		MatIsPositive(Matrix mat);
int		MatIsPositiveSemi(Matrix mat);
int		MatIsNonPositive(Matrix mat);
int		MatIsNegative(Matrix mat);
int		MatIsNegativeSemi(Matrix mat);
int		MatIsNonNegative(Matrix mat);
int		MatIsZero(Matrix mat);
int		MatIsNonZero(Matrix mat);
int		MatIsEqual(Matrix mat1, Matrix mat2);
int		MatIsNotEqual(Matrix mat, Matrix mat2);
int		MatIsRealValue(Matrix mat);
int		MatIsRealValue2(Matrix mat1, Matrix mat2);
int		MatIsComplexValue(Matrix mat);
int		MatIsComplexValue2(Matrix mat1, Matrix mat2);

void	MatEig(Matrix mat, Matrix *val, Matrix *vec);
void	MatGEig(Matrix a, matrix *b, Matrix *val, Matrix *vec);
void	MatSVD(Matrix mat, Matrix *val, Matrix *lvec, **rvec);
void	MatHermitEig(Matrix mat, Matrix *val, Matrix *vec);
void	MatLU(Matrix mat, Matrix *l, Matrix *u, Matrix *p);
void	MatHessenberg(Matrix mat, Matrix *h, Matrix *q);
void	MatSchur(Matrix mat, Matrix *t, Matrix *u);
void	MatQR(Matrix mat, Matrix *q, Matrix *r, Matrix *p);
void	MatQZ(Matrix mat1, Matrix mat2, Matrix *q, Matrix *z,
              Matrix *s, Matrix *t);
void	MatBalance(Matrix a, Matrix *d, Matrix *b);
void	MatOde(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, 
		Matrix x, void (*diff)(), void (*input)(),
		double eps, double dtmax, dtmin, double dtsav)
void	MatOde45(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, 
		Matrix x, void (*diff)(), void (*input)(),
		double eps, double dtmax, double dtmin, double dtsav)
void	MatOdeHybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x, 
		void (*diff)(), void (*input)(), double dt,
		double eps, double dtmax, double dtmin, double dtsav)
void	MatOde45Hybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x, 
		void (*diff)(), void (*input)(),
		double dt, double eps, double dtmax, double dtmin, double dtsav)
void	MatOdeStop();

void	ode_int_link(Matrix u, double t, Matrix x);

Matrix	Mat_Add(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_Add_double(Matrix ans, Matrix mat1, double sc);
Matrix	Mat_AddSelf(Matrix mat1, Matrix mat2);
Matrix	Mat_Sub(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_Sub_double(Matrix ans, Matrix mat1, double sc, int flag);
Matrix	Mat_SubSelf(Matrix mat1, Matrix mat2);
Matrix	Mat_Mul(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_MulElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_MulElemSelf(Matrix mat1, Matrix mat2);
Matrix	Mat_DivElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_DivElemSelf(Matrix mat1, Matrix mat2);
Matrix	Mat_Inv(Matrix ans, Matrix mat, double tol);
Matrix	Mat_InvElem(Matrix ans, Matrix mat);
Matrix	Mat_InvElemSelf(Matrix mat);
Matrix	Mat_PseudoInv(Matrix ans, Matrix mat, double tol);
Matrix	Mat_Pow(Matrix ans, Matrix mat, int m);
Matrix	Mat_PowElem(Matrix ans, Matrix mat, int m);
Matrix	Mat_PowElemToReal(Matrix ans, Matrix mat, double dd);
Matrix	Mat_PowElemToComp(Matrix ans, Matrix mat, Complex cc);
Matrix	Mat_PowElemEach(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_RemElem(Matrix ans, Matrix mat, int m);
Matrix	Mat_RemElemEach(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_All(Matrix ans, Matrix mat);
Matrix	Mat_All(Matrix ans, Matrix mat);
Matrix	Mat_Max(Matrix ans, Matrix mat);
Matrix	Mat_Min(Matrix ans, Matrix mat);
Matrix	Mat_Maximum(Matrix ans, Matrix mat, Matrix idx);
Matrix	Mat_Minimum(Matrix ans, Matrix mat, Matrix idx);
Matrix	Mat_Sum(Matrix ans, Matrix mat);
Matrix	Mat_Prod(Matrix ans, Matrix mat);
Matrix	Mat_CumSum(Matrix ans, Matrix mat);
Matrix	Mat_CumSumElem(Matrix ans, Matrix mat);
Matrix	Mat_CumProd(Matrix ans, Matrix mat);
Matrix	Mat_CumProdElem(Matrix ans, Matrix mat);
Matrix	Mat_Mean(Matrix ans, Matrix mat);
Matrix	Mat_StdDev(Matrix ans, Matrix mat);
Matrix	Mat_FrobNorms(Matrix ans, Matrix mat);
Matrix	Mat_Scale(Matrix ans, Matrix mat, double scale);
Matrix	Mat_ScaleSelf(Matrix mat, double scale);
Matrix	Mat_Trans(Matrix ans, Matrix mat);
Matrix	Mat_FlipLR(Matrix ans, Matrix mat);
Matrix	Mat_FlipUD(Matrix ans, Matrix mat);
Matrix	Mat_ShiftLeft(Matrix ans, Matrix mat, int m);
Matrix	Mat_ShiftRight(Matrix ans, Matrix mat, int m);
Matrix	Mat_ShiftUp(Matrix ans, Matrix mat, int m);
Matrix	Mat_ShiftDown(Matrix ans, Matrix mat, int m);
Matrix	Mat_RotateLeft(Matrix ans, Matrix mat, int m);
Matrix	Mat_RotateRight(Matrix ans, Matrix mat, int m);
Matrix	Mat_RotateUp(Matrix ans, Matrix mat, int m);
Matrix	Mat_RotateDown(Matrix ans, Matrix mat, int m);
Matrix	Mat_Sort(Matrix ans, Matrix idx, Matrix mat, int all_row);
Matrix	Mat_Negate(Matrix ans, Matrix mat);
Matrix	Mat_SetZero(Matrix mat);
Matrix	Mat_RoundZero(Matrix ans, Matrix mat, double tol);
Matrix	Mat_Exp(Matrix ans, Matrix mat);
Matrix	Mat_Conj(Matrix ans, Matrix mat);
Matrix	Mat_CatColumn(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_CatRow(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_Cat4(Matrix ans, Matrix mat11,
                  Matrix mat12, Matrix mat21, Matrix mat22);
Matrix	Mat_Cut(Matrix ans, Matrix mat, int sx, int sy, int ex, int ey);
Matrix	Mat_Put(Matrix to,int sc, int sr, Matrix from);
Matrix	Mat_SetSubMatrix(Matrix a, Matrix rows, Matrix columns, Matrix c);
Matrix	Mat_SetVecSubMatrix(Matrix a, Matrix cols, Matrix c);
Matrix	Mat_GetSubMatrix(Matrix a, Matrix rows, Matrix columns);
Matrix	Mat_GetVecSubMatrix(Matrix a, Matrix cols);
Matrix	Mat_SetBlockSubMatrix(Matrix a, Matrix rows, Matrix columns,
                              int pr, int pc, Matrix c);
Matrix	Mat_GetBlockSubMatrix(Matrix a, Matrix rows, Matrix columns,
                              int pr, int pc);
Matrix	Mat_AreaCopy(Matrix a, int ac, int ar, Matrix b, 
					int bc1, int br1, int bc2, int br2)
Matrix	Mat_Copy(Matrix to, Matrix from);
Matrix	Mat_VectorProduct(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	Mat_VectorSquare(Matrix ans, Matrix mat);
Matrix	Mat_Integrall(Matrix ans, Matrix mat, int m);
Matrix	Mat_HigherSfhit(Matrix ans, Matrix mat);
Matrix	Mat_Apply(Matrix ans, Matrix mat, double (*func)());
Matrix	Mat_ApplyTwo(Matrix ans, Matrix mat1, Matrix mat2, double (*func)());
Matrix	Mat_ApplyPolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	Mat_ApplyC_PolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	Mat_Apply_RatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	Mat_Apply_C_RatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	Mat_CompareElem(Matrix ans, Matrix mat1, Matrix mat2, char *opt);
Matrix	Mat_NotElem(Matrix ans, Matrix mat);
Matrix	Mat_FiniteElem(Matrix ans, Matrix mat);
Matrix	Mat_NaNElem(Matrix ans, Matrix mat);
Matrix	Mat_InfElem(Matrix ans, Matrix mat);
Matrix	Mat_EigVal(Matrix ans, Matrix mat);
Matrix	Mat_EigVec(Matrix ans, Matrix mat);
Matrix	Mat_EigValVec(Matrix ans, Matrix mat);
Matrix	Mat_GEigVal(Matrix ans, Matrix a, Matrix b);
Matrix	Mat_GEigVec(Matrix ans, Matrix a, Matrix b);
Matrix	Mat_GEigValVec(Matrix ans, Matrix a, Matrix b);
Matrix	Mat_RungeKutta4(Matrix yout, double x, Matrix y, 
						void (*diff)(), Matrix u, double h);
Matrix	Mat_RungeKutta4Link(Matrix yout, double x, Matrix y, 
						void (*diff)(), Matrix (*link)(), double h);
Matrix	Mat_RKF45(Matrix yout, double x, Matrix y, 
					void (*diff)(), Matrix u, double h);
Matrix	Mat_RKF45Link(Matrix yout, double x, Matrix y, 
					void (*diff)(), Matrix (*link)(), double h);
Matrix	Mat_ForSub(Matrix x, Matrix l, Matrix b);
Matrix	Mat_BackSub(Matrix x, Matrix u, Matrix b);
Matrix	Mat_LUSolve(Matrix x, Matrix a, Matrix b);
Matrix	Mat_FFT(Matrix fft, Matrix data);
Matrix	Mat_IFFT(Matrix fft, Matrix data);

void	Mat_Eig(Matrix mat, Matrix val, Matrix vec);
void	Mat_GEig(Matrix a, Matrix b, Matrix val, Matrix vec);
void	Mat_SVD(Matrix mat, Matrix val, *Matrix lvec, *rvec);
void	Mat_LU(Matrix mat, Matrix l, Matrix u, Matrix p);
void	Mat_Hessenberg(Matrix mat, Matrix h, Matrix q);
void	Mat_Schur(Matrix mat, Matrix t, Matrix u);
void	Mat_QR(Matrix mat, Matrix q, Matrix r, Matrix p);
void	Mat_QZ(Matrix mat1, Matrix mat2, Matrix q, Matrix z, 
               Matrix t, Matrix s);
void	Mat_Balance(Matrix a, Matrix d, Matrix b);
int		Mat_Ode(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x, void (*diff)(),
		void (*input)(), double eps_h, double dtsav, int auto_step)
int		Mat_Ode45(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x, void (*diff)(),
		void (*input)(), double eps_h, double dtsav, int auto_step)
int		Mat_OdeHybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x,	void (*diff)(),
		void (*input)(), double dt, double eps_h, double dtsav, int auto_step)
int		Mat_Ode45Hybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		double t1, double t2, Matrix x,	void (*diff)(),
		void (*input)(), double dt, double eps_h, double dtsav, int auto_step)
int		Mat_OdeGetXY(double x, Matrix y, Matrix u);

void	Mat_Swap(Matrix *mat1, *mat2);
void	Mat_Print(Matrix *mat);
Matrix	Mat_ChangeColumn(Matrix mat, int i, int j);
Matrix	Mat_ChangeRow(Matrix mat, int i, int j);

===============================================================================

Matrix	C_MatCopy(Matrix to, Matrix from);
Matrix	C_MatSetValue(Matrix mat, int column, int row, Complex c);
Matrix	C_MatFillValue(Matrix mat, Complex c);
Matrix	C_MatSetVecValue(Matrix mat, int number, Complex c);
Complex	C_MatDeterm(Matrix mat);
Complex	C_MatScalarProduct(Matrix a, Matrix b);
Complex	C_MatTrace(Matrix mat);
Complex	C_MatMaxElem(Matrix mat);
Complex	C_MatMinElem(Matrix mat);
Complex	C_MatMaximumElem(Matrix mat, int *ii, int *jj);
Complex	C_MatMinimumElem(Matrix mat, int *ii, int *jj);
Complex	C_MatSumElem(Matrix mat);
Complex	C_MatProdElem(Matrix mat);
Complex	C_MatMeanElem(Matrix mat);
double	C_MatStdDevElem(Matrix mat);
Matrix	C_Mat_Maximum(Matrix ans, Matrix mat, Matrix idx);
Matrix	C_Mat_Minimum(Matrix ans, Matrix mat, Matrix idx);
Matrix	C_Mat_All(Matrix ans, Matrix mat);
Matrix	C_Mat_Any(Matrix ans, Matrix mat);
Matrix	C_Mat_Sum(Matrix ans, Matrix mat);
Matrix	C_Mat_Prod(Matrix ans, Matrix mat);
Matrix	C_Mat_CumSum(Matrix ans, Matrix mat);
Matrix	C_Mat_CumSumElem(Matrix ans, Matrix mat);
Matrix	C_Mat_CumProd(Matrix ans, Matrix mat);
Matrix	C_Mat_CumProdElem(Matrix ans, Matrix mat);
Matrix	C_Mat_Mean(Matrix ans, Matrix mat);
Matrix	C_Mat_StdDev(Matrix ans, Matrix mat);
Matrix	C_Mat_FrobNorms(Matrix ans, Matrix mat);

Complex C_MatGetValue(Matrix mat, int column, int row);
Complex C_MatGetValueOne(Matrix mat, int column, int row);
Complex C_MatGetPtr(Matrix mat, int column, int row);
Complex C_MatGetVecValue(Matrix mat, int number);
Complex C_MatGetVecPtr(Matrix mat, int number);

void	C_Mat_Print(Matrix mat);
void	C_MatSwap(Matrix mat1, Matrix mat2);
Matrix	C_Mat_ChangeColumn(Matrix mat, int i, int j);
Matrix	C_Mat_ChangeRow(Matrix mat, int i, int j);

Matrix	C_MatDef(char *name, int column, int row);
Matrix	C_MatNonNameDef(int column, int row);
Matrix	C_MatSameDef(Matrix mat);
Matrix	C_MatTransDef(Matrix mat);
Matrix	C_MatMulDef(Matrix mat1, Matrix mat2);
Matrix	C_MatDiagDef(int size, Complex cmp1, Complex comp2, ...);
Matrix	C_MatVander(int size, Complex cmp1, Complex comp2, ...);
Matrix	C_MatIDef(int size);
Matrix	C_MatIDef2(int column, int row);
Matrix	C_MatOneDef(int column, int row);
Matrix	C_MatSameSizeFillDef(Matrix mat, Complex comp);
Matrix	C_MatFillDef(int column, int row, Complex comp);
Matrix	C_MatZDef(int size);
Matrix	C_MatZDef2(int column, int row);
Matrix	C_MatRealPart(Matrix mat);
Matrix	C_MatImagPart(Matrix mat);
Matrix	C_MatColumnVec(int size, Complex cmp1, Complex comp2, ...);
Matrix	C_MatRowVec(int size, Complex cmp1, Complex comp2, ...);
Matrix	C_MatNormalRand(int m, int n);
Matrix	C_MatUniformRand(int m, int n);

Matrix	C_Mat_Add(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_Add_double(Matrix ans, Matrix mat1, double sc);
Matrix	C_Mat_Add_Complex(Matrix ans, Matrix mat1, Complex sc);
Matrix	C_Mat_AddSelf(Matrix mat1, Matrix mat2);
Matrix	C_Mat_Sub(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_Sub_double(Matrix ans, Matrix mat1, double sc, int flag);
Matrix	C_Mat_Sub_Complex(Matrix ans, Matrix mat1, Complex sc, int flag);
Matrix	C_Mat_SubSelf(Matrix mat1, Matrix mat2);
Matrix	C_Mat_Mul(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_MulElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_MulElemSelf(Matrix mat1, Matrix mat2);
Matrix	C_Mat_DivElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_DivElemSelf(Matrix mat1, Matrix mat2);
Matrix	C_Mat_Inv(Matrix ans, Matrix mat, double tol);
Matrix	C_Mat_InvElem(Matrix ans, Matrix mat);
Matrix	C_Mat_InvElemSelf(Matrix mat);
Matrix	C_Mat_PseudoInv(Matrix ans, Matrix mat, double tol);
Matrix	C_Mat_Pow(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_PowElem(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_PowElemToReal(Matrix ans, Matrix mat, double dd);
Matrix	C_Mat_PowElemToComp(Matrix ans, Matrix mat, Complex cc);
Matrix	C_Mat_PowElemEach(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_CompareElem(Matrix mat1, Matrix mat2, char *opt);
Matrix	C_Mat_FiniteElem(Matrix ans, Matrix mat);
Matrix	C_Mat_NaNElem(Matrix ans, Matrix mat);
Matrix	C_Mat_InfElem(Matrix ans, Matrix mat);
Matrix	C_Mat_Scale(Matrix ans, Matrix mat, double scale);
Matrix	C_Mat_ScaleSelf(Matrix mat, double scale);
Matrix	C_Mat_ScaleSelfC(Matrix mat, Complex scale);
Matrix	C_Mat_ScaleC(Matrix ans, Matrix mat, Complex scale);
Matrix	C_Mat_Trans(Matrix ans, Matrix mat);
Matrix	C_Mat_FlipLR(Matrix ans, Matrix mat);
Matrix	C_Mat_FlipUD(Matrix ans, Matrix mat);
Matrix	C_Mat_ShiftLeft(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_ShiftRight(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_ShiftUp(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_ShiftDown(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_RotateLeft(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_RotateRight(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_RotateUp(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_RotateDown(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_Sort(Matrix ans, Matrix idx, Matrix mat, int all_row);
Matrix	C_Mat_Negate(Matrix ans, Matrix mat);
Matrix	C_Mat_SetZero(Matrix mat);
Matrix	C_Mat_RoundToZero(Matrix ans, Matrix mat, double tol);
Matrix	C_Mat_Exp(Matrix ans, Matrix mat);
Matrix	C_Mat_Conj(Matrix ans, Matrix mat);
Matrix	C_Mat_ConjTrans(Matrix ans, Matrix mat);
Matrix	C_Mat_Put(Matrix to,int sc, int sr, Matrix from);
Matrix  C_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows);
Matrix  C_Mat_GetVecSubMatrix(Matrix mat, Matrix cols);
Matrix	C_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows, Matrix c);
Matrix	C_Mat_SetVecSubMatrix(Matrix mat, Matrix cols, Matrix c);
Matrix  C_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc);
Matrix	C_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc, Matrix c);
Matrix	C_Mat_AreaCopy(Matrix a, int ac, int ar, Matrix b, 
					int bc1, int br1, int bc2, int br2)
Matrix	C_Mat_Cut(Matrix ans, Matrix mat, int sx, int sy, int ex, int ey);
Matrix	C_Mat_RealPart(Matrix ans, Matrix mat);
Matrix	C_Mat_ImagPart(Matrix ans, Matrix mat);
Matrix	C_Mat_CatColumn(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_CatRow(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_RealAndImag(Matrix ans, Matrix real, Matrix imag);
Matrix	C_Mat_RealToComp(Matrix ans, Matrix mat);
Matrix	C_Mat_VectorProduct(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	C_Mat_VectorSquare(Matrix ans, Matrix mat);
Matrix	C_Mat_EigVal(Matrix ans, Matrix mat);
Matrix	C_Mat_EigVec(Matrix ans, Matrix mat);
Matrix	C_Mat_EigValVec(Matrix ans, Matrix mat);
Matrix	C_Mat_GEigVal(Matrix ans, Matrix a, Matrix b);
Matrix	C_Mat_GEigVec(Matrix ans, Matrix a, Matrix b);
Matrix	C_Mat_GEigValVec(Matrix ans, Matrix a, Matrix b);
Matrix	C_Mat_Integral(Matrix ans, Matrix mat, int m);
Matrix	C_Mat_HigherShift(Matrix ans, Matrix mat);
Matrix	C_Mat_Apply(Matrix ans, Matrix mat, Complex (*func)());
Matrix	C_Mat_ApplyTwo(Matrix ans, Matrix mat1, Matrix mat2,Complex (*func)());
Matrix	C_Mat_Apply2(Matrix ans, Matrix mat, double (*func)());
Matrix	C_Mat_ApplyPolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	C_Mat_ApplyC_PolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	C_Mat_ApplyRatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	C_Mat_ApplyC_RatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	C_Mat_RungeKutta4(Matrix yout, double x, Matrix y, 
							void (*diff)(), Matrix u, double h);
Matrix	C_Mat_RungeKutta4Link(Matrix yout, double x, Matrix y, 
							void (*diff)(), Matrix (*link)(), double h);
Matrix	C_Mat_RKF45(Matrix yout, double x, Matrix y, 
					void (*diff)(), Matrix u, double h);
Matrix	C_Mat_RKF45Link(Matrix yout, double x, Matrix y, 
					void (*diff)(), Matrix (*link)(), double h);
Matrix	C_Mat_ForSub(Matrix x, Matrix l, Matrix b);
Matrix	C_Mat_BackSub(Matrix x, Matrix u, Matrix b);
Matrix	C_Mat_LUSolve(Matrix x, Matrix a, Matrix b);
Matrix	C_Mat_FFT(Matrix fft, Matrix data);
Matrix	C_Mat_IFFT(Matrix fft, Matrix data);

void	C_Mat_Eig(Matrix mat, Matrix *val, Matrix *vec);
void	C_Mat_GEig(Matrix a, Matrix b, Matrix *val, Matrix *vec);
void	C_Mat_HermitEig(Matrix mat, Matrix *val, Matrix *vec);
void	C_Mat_LU(Matrix mat, Matrix l, Matrix u, Matrix p);
void	C_Mat_Hessenberg(Matrix mat, Matrix h, Matrix q);
void	C_Mat_Schur(Matrix mat, Matrix t, Matrix u);
void	C_Mat_QR(Matrix mat, Matrix q, Matrix r, Matrix p);
void	C_Mat_QZ(Matrix mat1, Matrix mat2, Matrix q, Matrix z,
                 Matrix t, Matrix s);
void	C_Mat_Balance(Matrix a, Matrix d, Matrix b);
int		C_Mat_Ode(Matrix t_out, Matrix x_out, Matrix u_out,
		 double t1, double t2, 
		Matrix x, void (*diff)(), void (*input)(), double eps, double dtsav)
int		C_Mat_Ode45(Matrix t_out, Matrix x_out, Matrix u_out,
		 double t1, double t2, 
		Matrix x, void (*diff)(), void (*input)(), double eps, double dtsav)
int		C_Mat_OdeHybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		 double t1, double t2, Matrix x,
		 void (*diff)(), void (*input)(), double dt, double eps, double dtsav)
int		C_Mat_Ode45Hybrid(Matrix t_out, Matrix x_out, Matrix u_out,
		 double t1, double t2, Matrix x,
		 void (*diff)(), void (*input)(), double dt, double eps, double dtsav)

===============================================================================

Matrix	P_MatCopy(Matrix to, Matrix from);
Matrix	P_MatEdit(Matrix mat);
Matrix	P_MatInput(char *name);
Matrix	P_MatSetValue(Matrix mat, int column, int row, Polynomial p);
Matrix	P_MatFillValue(Matrix mat, Polynomial p);
Matrix	P_MatSetVecValue(Matrix mat, int number, Polynomial p);
Matrix	P_MatSetVar(Matrix mat, char *var);

Polynomial P_MatDeterm(Matrix mat);
Polynomial P_MatScalarProduct(Matrix a, Matrix b);
Polynomial P_MatTrace(Matrix mat);
Polynomial P_MatSumElem(Matrix mat);
Polynomial P_MatProdElem(Matrix mat);
Polynomial P_MatMeanElem(Matrix mat);
Matrix	   P_Mat_Sum(Matrix ans, Matrix mat);
Matrix	   P_Mat_Prod(Matrix ans, Matrix mat);
Matrix	   P_Mat_CumSum(Matrix ans, Matrix mat);
Matrix	   P_Mat_CumSumElem(Matrix ans, Matrix mat);
Matrix	   P_Mat_CumProd(Matrix ans, Matrix mat);
Matrix	   P_Mat_CumProdElem(Matrix ans, Matrix mat);
Matrix	   P_Mat_Mean(Matrix ans, Matrix mat);

Polynomial P_MatGetValue(Matrix mat, int column, int row);
Polynomial P_MatGetValueOne(Matrix mat, int column, int row);
Polynomial P_MatGetPtr(Matrix mat, int column, int row);
Polynomial P_MatGetVecValue(Matrix mat, int number);
Polynomial P_MatGetVecPtr(Matrix mat, int number);

void	P_Mat_Print(Matrix mat);
void	P_MatSwap(Matrix mat1, Matrix mat2);
Matrix	P_Mat_ChangeColumn(Matrix mat, int i, int j);
Matrix	P_Mat_ChangeRow(Matrix mat, int i, int j);

Matrix	P_MatDef(char *name, int column, int row);
Matrix	P_MatNonNameDef(int column, int row);
Matrix	P_MatSameDef(Matrix mat);
Matrix	P_MatTransDef(Matrix mat);
Matrix	P_MatMulDef(Matrix mat1, Matrix mat2);
Matrix	P_MatDiagDef(int size, Polynomial poly1, Polynomial poly2, ...);
Matrix	P_MatVander(int size, Polynomial poly1, Polynomial poly2, ...);
Matrix	P_MatIDef(int size);
Matrix	P_MatIDef2(int column, int row);
Matrix	P_MatOneDef(int column, int row);
Matrix	P_MatSameSizeFillDef(Matrix mat, Polynomial poly);
Matrix	P_MatFillDef(int column, int row, Polynomial poly);
Matrix	P_MatZDef(int size);
Matrix	P_MatZDef2(int column, int row);
Matrix	P_MatRealPart(Matrix mat);
Matrix	P_MatImagPart(Matrix mat);
Matrix	P_MatColumnVec(int size, Polynomial poly1, Polynomial poly2, ...);
Matrix	P_MatRowVec(int size, Polynomial poly1, Polynomial poly2, ...);

Matrix	P_Mat_Add(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_Add_double(Matrix ans, Matrix mat1, doubl sc);
Matrix	P_Mat_Add_Complex(Matrix ans, Matrix mat1, Complex sc);
Matrix	P_Mat_Add_Polynomial(Matrix ans, Matrix mat1, Polynomial sc);
Matrix	P_Mat_Sub(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_Sub_double(Matrix ans, Matrix mat1, double sc, int flag);
Matrix	P_Mat_Sub_Complex(Matrix ans, Matrix mat1, Complex sc, int flag);
Matrix	P_Mat_Sub_Polynomial(Matrix ans, Matrix mat1, Polynomial sc, int flag);
Matrix	P_Mat_Mul(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_MulElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_DivElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_InvElem(Matrix ans, Matrix mat);
Matrix	P_Mat_Pow(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_PowElem(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_PowElemEach(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_CompareElem(Matrix ans, Matrix mat1, Matrix mat2, char *op);
Matrix	P_Mat_Scale(Matrix ans, Matrix mat, double scale);
Matrix	P_Mat_ScaleSelf(Matrix mat, double scale);
Matrix	P_Mat_ScaleC(Matrix ans, Matrix mat, Complex scale);
Matrix	P_Mat_ScaleP(Matrix ans, Matrix mat, Polynomial scale);
Matrix	P_Mat_ScaleR(Matrix ans, Matrix mat, Rational scale);
Matrix	P_Mat_Eval(Matrix mat, double d);
Matrix	P_Mat_EvalC(Matrix mat, Complex c);
Matrix	P_Mat_EvalP(Matrix mat, Polynomial p);
Matrix	P_Mat_EvalR(Matrix mat, Rational r);
Matrix	P_Mat_EvalM(Matrix mat, Matrix scale);
Matrix	P_Mat_EvalMElem(Matrix mat, Matrix scale);
Matrix	P_Mat_Apply(Matrix ans, Matrix mat, Polynomial (*func)());
Matrix	P_Mat_ApplyPolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	P_Mat_ApplyRatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	P_Mat_Trans(Matrix ans, Matrix mat);
Matrix	P_Mat_FlipLR(Matrix ans, Matrix mat);
Matrix	P_Mat_FlipUD(Matrix ans, Matrix mat);
Matrix	P_Mat_ShiftLeft(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_ShiftRight(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_ShiftUp(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_ShiftDown(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_RotateLeft(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_RotateRight(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_RotateUp(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_RotateDown(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_Negate(Matrix ans, Matrix mat);
Matrix	P_Mat_SetZero(Matrix mat);
Matrix	P_Mat_RoundToZero(Matrix ans, Matrix mat, double tol);
Matrix	P_Mat_Conj(Matrix ans, Matrix mat);
Matrix	P_Mat_ConjTrans(Matrix ans, Matrix mat);
Matrix	P_Mat_Put(Matrix to,int sc, int sr, Matrix from);
Matrix  P_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows);
Matrix  P_Mat_GetVecSubMatrix(Matrix mat, Matrix cols);
Matrix	P_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows, Matrix c);
Matrix	P_Mat_SetVecSubMatrix(Matrix mat, Matrix cols, Matrix c);
Matrix  P_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc);
Matrix	P_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc, Matrix c);
Matrix	P_Mat_AreaCopy(Matrix a, int ac, int ar, Matrix b, 
					int bc1, int br1, int bc2, int br2)
Matrix	P_Mat_Cut(Matrix ans, Matrix mat, int sx, int sy, int ex, int ey);
Matrix	P_Mat_RealPart(Matrix ans, Matrix mat);
Matrix	P_Mat_ImagPart(Matrix ans, Matrix mat);
Matrix	P_Mat_RealAndImag(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_RealToComp(Matrix ans, Matrix mat);
Matrix	P_Mat_RealToPoly(Matrix ans, Matrix mat);
Matrix	P_Mat_CompToPoly(Matrix ans, Matrix mat);
Matrix	P_Mat_CatColumn(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_CatRow(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_VectorProduct(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	P_Mat_VectorSquare(Matrix ans, Matrix mat);
Matrix	P_Mat_Derivative(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_Integral(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_LowerShift(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_HigherShift(Matrix ans, Matrix mat, int m);

===============================================================================

Matrix	R_MatCopy(Matrix to, Matrix from);
Matrix	R_MatEdit(Matrix mat);
Matrix	R_MatInput(char *name);
Matrix	R_MatSetValue(Matrix mat, int column, int row, Rational r);
Matrix	R_MatFillValue(Matrix mat, Rational r);
Matrix	R_MatSetVecValue(Matrix mat, int number, Rational r);
Matrix	R_MatSetVar(Matrix mat, char *var);

Rational R_MatDeterm(Matrix mat);
Rational R_MatScalarProduct(Matrix a, Matrix b);
Rational R_MatTrace(Matrix mat);
Rational R_MatSumElem(Matrix mat);
Rational R_MatProdElem(Matrix mat);
Rational R_MatMeanElem(Matrix mat);
Matrix   R_Mat_Sum(Matrix ans, Matrix mat);
Matrix   R_Mat_Prod(Matrix ans, Matrix mat);
Matrix   R_Mat_CumSum(Matrix ans, Matrix mat);
Matrix   R_Mat_CumSumElem(Matrix ans, Matrix mat);
Matrix   R_Mat_CumProd(Matrix ans, Matrix mat);
Matrix   R_Mat_CumProdElem(Matrix ans, Matrix mat);
Matrix   R_Mat_Mean(Matrix ans, Matrix mat);

Rational R_MatGetValue(Matrix mat, int column, int row);
Rational R_MatGetValueOne(Matrix mat, int column, int row);
Rational R_MatGetPtr(Matrix mat, int column, int row);
Rational R_MatGetVecValue(Matrix mat, int number);
Rational R_MatGetVecPtr(Matrix mat, int number);

void	R_Mat_Print(Matrix mat);
void	R_MatSwap(Matrix mat1, Matrix mat2);
Matrix	R_Mat_ChangeColumn(Matrix mat, int i, int j);
Matrix	R_Mat_ChangeRow(Matrix mat, int i, int j);

Matrix	R_MatDef(char *name, int column, int row);
Matrix	R_MatNonNameDef(int column, int row);
Matrix	R_MatSameDef(Matrix mat);
Matrix	R_MatTransDef(Matrix mat);
Matrix	R_MatMulDef(Matrix mat1, Matrix mat2);
Matrix	R_MatDiagDef(int size, Rational rat1, Rational rat2, ...);
Matrix	R_MatVander(int size, Rational rat1, Rational rat2, ...);
Matrix	R_MatIDef(int size);
Matrix	R_MatIDef2(int column, int row);
Matrix	R_MatOneDef(int column, int row);
Matrix	R_MatSameSizeFillDef(Matrix mat, Rational rat);
Matrix	R_MatFillDef(int column, int row, Rational rat);
Matrix	R_MatZDef(int size);
Matrix	R_MatZDef2(int column, int row);
Matrix	R_MatRealPart(Matrix mat);
Matrix	R_MatImagPart(Matrix mat);
Matrix	R_MatColumnVec(int size, Rational rat1, Rational rat2, ...);
Matrix	R_MatRowVec(int size, Rational rat1, Rational rat2, ...);

Matrix	R_Mat_Add(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_Add_double(Matrix ans, Matrix mat1, double sc);
Matrix	R_Mat_Add_Complex(Matrix ans, Matrix mat1, Complex sc);
Matrix	R_Mat_Add_Polynomial(Matrix ans, Matrix mat1, Polynomial sc);
Matrix	R_Mat_Add_Rational(Matrix ans, Matrix mat1, Rational sc);
Matrix	R_Mat_Sub(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_Sub_double(Matrix ans, Matrix mat1, double sc, int flag);
Matrix	R_Mat_Sub_Complex(Matrix ans, Matrix mat1, Complex sc, int flag);
Matrix	R_Mat_Sub_Polynomial(Matrix ans, Matrix mat1, Polynomial sc, int flag);
Matrix	R_Mat_Sub_Rational(Matrix ans, Matrix mat1, Rational sc, int flag);
Matrix	R_Mat_Mul(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_MulElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_DivElem(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_InvElem(Matrix ans, Matrix mat);
Matrix	R_Mat_Pow(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_PowElem(Matrix ans, Matrix mat, int m);
Matrix	P_Mat_CompareElem(Matrix ans, Matrix mat1, Matrix mat2, char *op);
Matrix	R_Mat_PowElemEach(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_Scale(Matrix ans, Matrix mat, double scale);
Matrix	R_Mat_ScaleSelf(Matrix mat, double scale);
Matrix	R_Mat_ScaleC(Matrix ans, Matrix mat, Complex scale);
Matrix	R_Mat_ScaleP(Matrix ans, Matrix mat, Polynomial scale);
Matrix	R_Mat_ScaleR(Matrix ans, Matrix mat, Rational scale);
Matrix	R_Mat_Eval(Matrix mat, double d);
Matrix	R_Mat_EvalC(Matrix mat, Complex c);
Matrix	R_Mat_EvalP(Matrix mat, Polynomial p);
Matrix	R_Mat_EvalR(Matrix mat, Rational r);
Matrix	R_Mat_EvalM(Matrix mat, Matrix scale);
Matrix	R_Mat_EvalMElem(Matrix mat, Matrix scale);
Matrix	R_Mat_Apply(Matrix ans, Matrix mat, Rational (*func)());
Matrix	R_Mat_ApplyPolyFunc(Matrix ans, Matrix mat, Polynomial poly);
Matrix	R_Mat_ApplyRatFunc(Matrix ans, Matrix mat, Rational rat);
Matrix	R_Mat_Trans(Matrix ans, Matrix mat);
Matrix	R_Mat_FlipLR(Matrix ans, Matrix mat);
Matrix	R_Mat_FlipUD(Matrix ans, Matrix mat);
Matrix	R_Mat_ShiftLeft(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_ShiftRight(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_ShiftUp(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_ShiftDown(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_RotateLeft(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_RotateRight(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_RotateUp(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_RotateDown(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_Negate(Matrix ans, Matrix mat);
Matrix	R_Mat_SetZero(Matrix mat);
Matrix	R_Mat_RoundToZero(Matrix ans, Matrix mat, double tol);
Matrix	R_Mat_Conj(Matrix ans, Matrix mat);
Matrix	R_Mat_ConjTrans(Matrix ans, Matrix mat);
Matrix	R_Mat_Put(Matrix to,int sc, int sr, Matrix from);
Matrix  R_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows);
Matrix  R_Mat_GetVecSubMatrix(Matrix mat, Matrix cols);
Matrix	R_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows, Matrix c);
Matrix	R_Mat_SetVecSubMatrix(Matrix mat, Matrix cols, Matrix c);
Matrix  R_Mat_GetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc);
Matrix	R_Mat_SetSubMatrix(Matrix mat, Matrix columns, Matrix rows,
                           int pr, int pc, Matrix c);
Matrix	R_Mat_AreaCopy(Matrix a, int ac, int ar, Matrix b, 
					int bc1, int br1, int bc2, int br2)
Matrix	R_Mat_Cut(Matrix ans, Matrix mat, int sx, int sy, int ex, int ey);
Matrix	R_Mat_RealPart(Matrix ans, Matrix mat);
Matrix	R_Mat_ImagPart(Matrix ans, Matrix mat);
Matrix	R_Mat_NumeElem(Matrix ans, Matrix mat);
Matrix	R_Mat_DenoElem(Matrix ans, Matrix mat);
Matrix	R_Mat_RealAndImag(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_RealToComp(Matrix ans, Matrix mat);
Matrix	R_Mat_RealToRat(Matrix ans, Matrix mat);
Matrix	R_Mat_CompToRat(Matrix ans, Matrix mat);
Matrix	R_Mat_PolyToRat(Matrix ans, Matrix mat);
Matrix	R_Mat_CatColumn(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_CatRow(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_VectorProduct(Matrix ans, Matrix mat1, Matrix mat2);
Matrix	R_Mat_VectorSquare(Matrix ans, Matrix mat);
Matrix	R_Mat_Derivative(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_LowerShift(Matrix ans, Matrix mat, int m);
Matrix	R_Mat_HigherShift(Matrix ans, Matrix mat, int m);

--------------------------------------------------------------------------- */
