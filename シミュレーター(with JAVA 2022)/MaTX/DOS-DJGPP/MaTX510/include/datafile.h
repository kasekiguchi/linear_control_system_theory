
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
  datafile.h : 

  $Author: koga $
  $Revision: 1.2 $
  $Date: 1994/06/21 13:23:07 $
  $Log: datafile.h,v $
 * Revision 1.2  1994/06/21  13:23:07  koga
 * *** empty log message ***
 *
 * Revision 1.1  1992/03/25  12:09:20  koga
 * Initial revision
 *
*/

#ifndef datafile_header
#define datafile_header

/**************************************************************************/
/*                                                                        */
/*                Data format for Version 4                               */
/*                                                                        */
/**************************************************************************/

#define MASK_M       0XFF000000L
#define SUN_M        0X10000000L
#define DEC_M        0X20000000L
#define APOLLO_M     0X10000000L
#define MAC_M        0X10000000L
#define MOTOROLA_M   0X10000000L
#define X68K_M		 0X10000000L
#define PC_M         0X20000000L

#define MASK_O       0X00FF0000L
#define COLUMN_O     0X00000000L
#define ROW_O        0X00010000L
#define DUMMY_O      0X00000000L

#define MASK_P       0X0000FF00L
#define DOUBLE_P     0X00000000L
#define SINGLE_P     0X00000100L
#define SGN_INT32_P  0X00000200L
#define SGN_INT16_P  0X00000300L
#define USGN_INT16_P 0X00000400L
#define USGN_INT8_P  0X00000500L
#define DUMMY_P      0x00000000L

#define MASK_C        0X000000FFL
#define MATRIX_C      0X00000000L
#define INTEGER_C     0X00000001L
#define REAL_C        0X00000002L
#define COMPLEX_C     0X00000003L
#define STRING_C      0X00000004L
#define POLYNOMIAL_C  0X00000005L
#define RATIONAL_C    0X00000006L
#define LIST_C        0X00000007L
#define ARRAY_C       0X00000008L
#define INDEX_C       0X00000009L

#define IMAGF_R      0
#define IMAGF_C      1

#define CLASS_REAL   0
#define CLASS_COMP   1
#define CLASS_R_POLY 2
#define CLASS_C_POLY 3
#define CLASS_R_RAT  4
#define CLASS_C_RAT  5

#define MAX_DATA_NAMELEN	1024

/*
 *	type : [M|O|P|C] (4 bytes)
 *         M : Machine
 *             0 : Sun, Apollo, Macintosh, or Other Motorola
 *             1 : PC or Other Intel
 *             2 : VAX D-float
 *             3 : VAX G-float
 *         O : Orientation
 *             0 : column-wise orientation (varies fastest down a column)
 *             1 : row-wise    orientation (varies fastest down a row)
 *         P : Precision
 *             0 : double-precison (8 bytes/element)
 *             1 : single-precison (4 bytes/element)
 *             2 : signed 32-bit integer
 *             3 : signed 16-bit integer
 *             4 : unsigned 16-bit integer
 *         C : Class
 *             0 : Matrix
 *             1 : Integer
 *             2 : Real Number
 *             3 : Complex Number
 *             4 : String
 *             5 : Polynomial
 *             6 : Rational
 *             7 : List
 *             8 : Array
 *             9 : Index
 *
 *  imagf : Flag indicating imaginary part
 *          0 : Real
 *          1 : Complex
 *
 *  class : Class of Matrix
 *          0 : Real Matrix
 *          1 : Complex Matrix
 *          2 : Real Polynomial Matrix
 *          3 : Complex Polynomial Matrix
 *          4 : Real Rational Matrix
 *          5 : Complex Rational Matrix
 */

typedef struct {
	unsigned long type;		/* [***0]            */
	unsigned long rows;		/* Row dimension     */
	unsigned long cols;		/* Column dimension  */
	unsigned long class;	/* Class of matrix   */
	unsigned long namelen;	/* Length of name    */
} MatrixData;

typedef struct {
	unsigned long type;		/* [***1]            */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long dummy3;
	unsigned long namelen;	/* Length of name    */
} IntegerData;

typedef struct {
	unsigned long type;		/* [***2]            */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long dummy3;
	unsigned long namelen;	/* Length of name    */
} RealData;

typedef struct {
	unsigned long type;		/* [***3]            */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long dummy3;
	unsigned long namelen;	/* Length of name    */
} ComplexData;

#ifdef MXSTR
typedef struct {
	unsigned long type;		/* [***4]            */
	unsigned long length;   /* Length of string  */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long namelen;	/* Length of name    */
} mxStringData;
#endif

typedef struct {
	unsigned long type;		/* [***4]            */
	unsigned long stringlen;/* Length of string  */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long namelen;	/* Length of name    */
} StringData;

typedef struct {
	unsigned long type;		/* [***5]               */
	unsigned long degree;	/* Degree of polynomial */
	unsigned long dummy;
	unsigned long imagf;	/* Flag of complex      */
	unsigned long namelen;	/* Length of name       */
} PolynomialData;

typedef struct {
	unsigned long type;		/* [***6]                */
	unsigned long ndegree;	/* Degree of Numerator   */
	unsigned long ddegree;	/* Degree of Denominator */
	unsigned long imagf;	/* Flag of complex       */
	unsigned long namelen;	/* Length of name        */
} RationalData;

typedef struct {
	unsigned long type;		/* [***7]            */
	unsigned long length;	/* Length of list    */
	unsigned long dummy1;
	unsigned long dummy2;
	unsigned long namelen;	/* Length of name    */
} ListData;

typedef struct {
	unsigned long type;
	unsigned long dummy2;
	unsigned long dummy3;
	unsigned long dummy4;
	unsigned long namelen;
} Data;

/*
 *  [Real Matrix]
 *    sizeof(double) * rows*cols
 *
 *  [Complex Matrix]
 *    (2*sizeof(double)) * rows*cols
 *
 *  [Real Polynomial Matrix]
 *    (sizeof(long) + sizeof(double) * degree) * rows*cols
 *
 *  [Complex Polynomial Matrix]
 *    (sizeof(long) + 2*sizeof(double) * degree) * rows*cols
 *
 *  [Real Rational Matrix]
 *    (2*sizeof(long) + sizeof(double) * (ndegree + ddegree)) * rows*cols
 *
 *  [Complex Rational Matrix]
 *    (2*sizeof(long) + 2*sizeof(double) * (ndegree + ddegree)) * rows*cols
 */

/**************************************************************************/
/*                                                                        */
/*                Data format for Version 5                               */
/*                                                                        */
/**************************************************************************/
 
#define SINT8_P    0X00000100L
#define UINT8_P    0X00000200L
#define SINT16_P   0X00000300L
#define UINT16_P   0X00000400L
#define SINT32_P   0X00000500L
#define UINT32_P   0X00000600L
#define SINT64_P   0X00000700L
#define UINT64_P   0X00000800L
#define REAL32_P   0X00001000L
#define REAL64_P   0X00002000L
#define REAL128_P  0X00003000L

#define MASK_T       0X000000FFL

#define STRING_T     0X00000001L
#define INTEGER_T    0X00000002L
#define REAL_T       0X00000003L
#define COMPLEX_T    0X00000004L
#define POLYNOMIAL_T 0X00000005L
#define RATIONAL_T   0X00000006L
#define MATRIX_T     0X00000007L
#define ARRAY_T      0X00000008L
#define INDEX_T      0X00000009L
#define LIST_T       0X0000000AL

#define MXS_STRING     STRING_T
#define MXS_INTEGER    INTEGER_T
#define MXS_REAL       REAL_T
#define MXS_COMPLEX    COMPLEX_T
#define MXS_POLYNOMIAL POLYNOMIAL_T
#define MXS_RATIONAL   RATIONAL_T
#define MXS_MATRIX     MATRIX_T
#define MXS_ARRAY      ARRAY_T
#define MXS_INDEX      INDEX_T
#define MXS_LIST       LIST_T

/*
 *         P : Precision
 *             0x01 : signed 8-bit integer
 *             0x02 : unsigned 8-bit integer
 *             0x03 : signed 16-bit integer
 *             0x04 : unsigned 16-bit integer
 *             0x05 : signed 32-bit integer
 *             0x06 : unsigned 32-bit integer
 *             0x07 : signed 64-bit integer
 *             0x08 : unsigned 64-bit integer
 *             0x10 : 32-bit real (4 bytes/element)
 *             0x20 : 64-bit real (8 bytes/element)
 *             0x30 : 128-bit real (16 bytes/element)
 *         T : Type
 *             0x1 : String
 *             0x2 : Integer
 *             0x3 : Real
 *             0x4 : Complex
 *             0x5 : Polynomial
 *             0x6 : Rational
 *             0x7 : Matrix
 *             0x8 : Array
 *             0x9 : Index
 *             0xA : List
 *
 */

/*
 *	For datafile_read_open() and datafile_write_open()
 */

extern FILE *matx_fp;
FILE *datafile_read_open();
FILE *datafile_write_open();

/*
  FILE *datafile_read_open(char *filename);
  FILE *datafile_write_open(char *filename);
*/
#endif

