
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
  object.h : 

  $Author: koga $
  $Revision: 1.2 $
  $Date: 1992/03/25 12:09:16 $
  $Log: object.h,v $
 * Revision 1.2  1992/03/25  12:09:16  koga
 * Optimization
 *
*/

#ifndef object_header
#define object_header

typedef union __Object  _Object, *Object;

union __Object {
#ifdef MXSTR
	struct __mxString	*str;		/* STRING                */
#else
	char				*str;		/* STRING                */
#endif
	int					val2;		/* INTEGER               */
	double				val;		/* REAL                  */
	struct __Complex	*cmp;		/* COMPLEX               */
	struct __Matrix		*mat;		/* MATRIX                */
#ifdef POLY
	struct __Polynomial	*poly;		/* POLYNOMIAL            */
#endif
#ifdef RAT
	struct __Rational	*rat;		/* RATIONAL              */
#endif
#ifdef LST
	struct __List 		*list;		/* LST                   */
#endif
	double				(*ptr)();	/* BLTIN                 */
#ifdef OBJECT_FUNC
	struct __Function	*func;		/* FUNCTION, PROCEDURE   */
#endif
};

#endif
