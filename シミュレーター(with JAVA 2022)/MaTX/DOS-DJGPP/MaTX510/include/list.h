
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
  list.h : 

  $Author: koga $
  $Revision: 1.4 $
  $Date: 1994/06/21 13:23:05 $
  $Log: list.h,v $
 * Revision 1.4  1994/06/21  13:23:05  koga
 * *** empty log message ***
 *
 * Revision 1.3  1992/06/10  12:19:04  koga
 *  Optimization
 *
 * Revision 1.2  1992/03/25  12:09:11  koga
 * Optimization
 *
*/

#ifndef list_header
#define list_header

#include <matxconf.h>

#include <matrix.h>

#ifdef MXSTR
#include <mxstring.h>
#endif

#ifdef POLY
#ifdef HAVE_SHORT_FILENAME
#include <poly.h>
#else
#include <polynomial.h>
#endif
#endif

#ifdef RAT
#include <rational.h>
#endif

#ifdef FNC
#include "function.h"
#endif

#include <object.h>

/*****************************************************************************/

#define	LIST_TMP				0
#define	LIST_VAR				1
#define	LIST_MATX				2
#define	LIST_LIST				3

#define LIST_NULL				ListDef("", 0)
#define LIST_DEF				ListSetType(LIST_NULL, LIST_VAR)
#define LIST_STC				ListSetType(LIST_NULL, LIST_MATX)

#define	ListElement(a,i,c)		ListGetElement(a,i,c)
#define	ListElementP(a,i,c)		ListGetElementP(a,i,c)
#define	ListObject(a,i)			ListGetObject(a,i)
#define ListObjectP(a,i)		((a)->elm + (i) - 1)

#define	ListClass(a,i)			(*((a)->class + (i) - 1))
#define	ListGetType(a)			((a)->type)
#define	ListType(a)				ListGetType(a)
#define	ListGetName(a)			((a)->name)
#define	ListName(a)				ListGetName(a)
#define	ListGetLength(a)		((a)->length)
#define	ListLength(a)			ListGetLength(a)

#define ListIsVar(a)			(ListType(a) == LIST_VAR)
#define ListIsTmp(a)			(ListType(a) == LIST_TMP)

#define ListIsSameLength(a,b)	(ListLength(a) == ListLength(b))

typedef struct __List _List, *List;

struct __List {
	char	*name;	/* Name of List        */
	short	type;	/* List type           */
	int		length;	/* Length of the List  */
	short	*class;	/* Element Class       */
	Object	elm;	/* Element             */
	List 	prev;	/* to link to prev one */
	List 	next;	/* to link to next one */
};

#if 0
extern List matx_list;			/* For multiple output function */
#endif

#define LIST_ERR_LENGTH 256

typedef void *VOIDP;

/*****************************************************************************/

void 	ListError();
void 	ListError2();
void 	ListWarning();
void 	ListWarning2();
void	ListInit();
void	ListFree();
void	ListFrees();
void	ListElementDestroy();
void	ListDestroy();
void	ListInstall();
void	ListUndef();
void	ListUndefs();
void	ListTmpUndef();
#ifdef MATX_RT
void	ListTmpUndefs();
#endif
void	ListAllPrint();
void	ListPrint();
void	ListElementPrint();
void	ListElementSave();
void	ListSwap();

List	ListSetName();
List	ListSetType();
List	ListSetClass();
#ifdef HAVE_STDARG
List	ListSetElement(List a, ...);
List	ListSetDeepElement(List a, ...);
List	ListSetDeepElement2(List a, ...);
List	ListSetDeepObject(List a, ...);
List	ListGetDeepSubElement(List a, ...);
List	ListSetDeepSubElement(List a, ...);
#else
List	ListSetElement();
List	ListSetDeepElement();
List	ListSetDeepElement2();
List	ListSetDeepObject();
List	ListGetDeepSubElement();
List	ListSetDeepSubElement();
#endif

List	ListGetDeepListP();
List	ListSetObject();
List	ListSetDeepObject2();
List	ListGetSubElements();
List	ListGetSubElements2();
List	ListSetSubElements();
List	ListSetSubElements2();
List	ListGetDeepSubElement2();
List	ListSetDeepSubElement2();
List	ListAppendObject();
List	ListSetLength();
List	ListFileSave();
List	ListScanf();
List	ListFileScanf();
List	ListFileNameScanf();
List	ListStringScanf();
List	ListWrite();
List	ListRead();
void	ListReadContent();

List	ListCopy();
List	ListElementCopy();
List	ListElementChange();
List	ListMove();
List	ListDup();
List	ListAssign();
List	ListAssignOnly();

List	ListDef();
List	ListRequest();
List	ListReDef();
List	ListSameDef();
#ifdef HAVE_STDARG
List	ListElementsDef(int n, ...);
List	ListObjectsDef(int n, ...);
#else
List	ListElementsDef();
List	ListObjectsDef();
#endif
List	ListMul();

List	ListCat();
List	ListCut();
List	ListPut();
List	ListInsert();

Object	ListGetObject();
VOIDP	ListGetElement();
VOIDP	ListGetElementP();
#ifdef HAVE_STDARG
VOIDP	ListGetDeepElementP(List a, ...);
VOIDP	ListGetDeepElement(List a, ...);
#else
VOIDP	ListGetDeepElementP();
VOIDP	ListGetDeepElement();
#endif
VOIDP	ListGetDeepElement2();
VOIDP	ListGetDeepElementP2();

int		ListGetClass();
int		ListIsEqual();
int		ListIsNotEqual();
Matrix	ListCompareElem();
Matrix	ListNotElem();
#ifdef HAVE_STDARG
Matrix	ListCompareElem2(List a, ...);
#else
Matrix	ListCompareElem2();
#endif
Matrix	ListIsClass();
Matrix	ListIsNotClass();

#ifdef HAVE_STDARG
int		ListGetDeepLength(List a, ...);
int		ListGetDeepClass(List a, ...);
#else
int		ListGetDeepLength();
int		ListGetDeepClass();
#endif
int		ListGetDeepLength2();
int		ListGetDeepClass2();

List	ListMatSize();
List	ListMatBalance();
List	ListMatEig();
List	ListMatGEig();
List	ListMatSVD();
List	ListMatLU();
List	ListMatHessenberg();
List	ListMatSchur();
List	ListMatQR();
List	ListMatQZ();
List	ListMatOde();
List	ListMatOde45();
List	ListMatOdeHybrid();
List	ListMatOde45Hybrid();
List	ListMatOdeGetXY();
List	ListMatSort();
List	ListMatMaximum();
List	ListMatMaximumElem();
List	ListMatMinimum();
List	ListMatMinimumElem();
List	ListGetClasses();
#ifdef HAVE_STDARG
List	ListMakeList(int depth, ...);
#else
List	ListMakeList();
#endif

List	ListMakeList2();

char	*ListClassName();
int		ListMenu();
#endif
/*****************************************************************************

void 	ListError(char *func, char *statement, char *var);
void 	ListError2(char *func, char *statement, char *var1, char *var2);
void 	ListWarning(char *func, char *statement, char *var);
void 	ListWarning2(char *func, char *statement, char *var1, char *var2);
void	ListInit();
void	ListFree(List a);
void	ListFrees(List a);
void	ListAllFree();
void	ListElementDestroy(List a, int number);
void	ListDestroy(List a);
void	ListInstall(List a);
void	ListUndef(List a);
void	ListUndefs(List a);
void	ListTmpUndef(void);
#ifdef MATX_RT
void	ListTmpUndefs(List a);
#endif
void	ListAllUndef();
void	ListAllPrint();
void	ListPrint(List a);
void	ListElementPrint(List a, int number);
void	ListElementSave(List a, int number, char *filename);
void	ListSwap(List b, List a);
void	ListExchangeListposition(List b, List a);

List	ListSetName(List a, char *name);
List	ListSetType(List a, int type);
List	ListSetClass(List a, short class);
List	ListSetElement(List a, int number, short class, an object);
List	ListSetDeepElement(List a, int n1, ..., short class, an object);
List	ListSetDeepElement2(List a, int *number, short class, an object);
List	ListSetObject(List a, int number, short class, Object obj);
List	ListSetDeepObject(List a, int depth, int n1, ...,
        int class, Object obj);
List	ListSetDeepObject2(List a, int depth, int *number,
        int class, Object obj);
List	ListGetDeepListP(List a, int depth, int *number);
List	ListGetDeepSubElement(List a, ....);
List	ListGetSubElements(List a, Matrix idx);
List	ListGetSubElements2(List a, int from, int to, int by);
List	ListSetSubElements(List a, Matrix idx, List b);
List	ListSetSubElements2(List a, int from, int to, int by, List b);
List	ListGetDeepSubElement2(List a, int depth, ListIndex *idxes);
List	ListAppendObject(List a, short class, Object obj);
List	ListSetLength(List a, int length);
List	ListSearch(char *name);
List	ListFileSave(List a, char *filename, int append, int cr);
List	ListScanf(char *format, ...);
List	ListFileScanf(int fd, char *format, ...);
List	ListFileNameScanf(char *path, char *format, ...);
List	ListStringScanf(char *str, char *format, ...);
List	ListWrite(List ll, FILE *fp);
List	ListRead(List ll , FILE *fp);
void	ListReadContent(List ll , FILE *fp, ListData *data, int ver);

List	ListCopy(List b, List a);
List	ListElementCopy(List b, List a);
List	ListElementChange(List b, List a);
List	ListMove(List b, List a);
List	ListDup(List a);
List	ListAssign(List b, List a);
List	ListAssignOnly(List b, List a);

List	ListDef(char *name, int m);
List	ListRequest(int m);
List	ListReDef(List a, int m);
List	ListSameDef(List a);
List	ListElementsDef(int length, short class1, an object, ...);
List	ListObjectsDef(int length, short class1, Object obj1, ...);
List	ListMul(List a, int n);

List	ListCat(List a, List b);
List	ListCut(List a, int s, int e);
List	ListPut(List a, int number, List b);
List	ListInsert(List a, int number, List b);

Object	ListGetElement(List a, int number);
VOIDP	ListGetElement(List a, int number, int class);
VOIDP	ListGetElementP(List a, int number, int class);
VOIDP	ListGetDeepElementP(List a, int n1, ..., int class);
VOIDP	ListGetDeepElementP2(List a, int *number, int class);
VOIDP	ListGetDeepElement(List a, int depth, int n1, ..., int class);
VOIDP	ListGetDeepElement2(List a, int depth, int *number, int class);
int		ListGetClass(List a, int number);
int		ListIsEqual(List a, List b);
int		ListIsNotEqual(List a, List b);
Matrix	ListCompareElem(List a, List b, char *op);
Matrix	ListNotElem(List a);
Matrix	ListCompareElem2(List a, int class, data, char *op);
#endif
Matrix	ListIsClass(List a, int class);
Matrix	ListIsNotClass(List a, int class);
int		ListGetDeepLength(List a, int n1, ..., int nn);
int		ListGetDeepLength2(List a, int depth, int *number);
int		ListGetDeepClass(List a, int n1, ..., int nn);
int		ListGetDeepClass2(List a, int depth, int *number);

List	ListMatSize(Matrix a);           {rows, cols}
List	ListMatBalance(Matrix a);        {d, b}
List	ListMatEig(Matrix a);            {val, vec}
List	ListMatGEig(Matrix a, Matrix b); {val, vec}
List	ListMatSVD(Matrix a);            {lvec, val, rvec}
List	ListMatLU(Matrix a, int pflag);  {l, u, p} or {l, u}
List	ListMatHessenberg(Matrix a);     {q, h}
List	ListMatSchur(Matrix a);          {u, t}
List	ListMatQR(Matrix a);             {q, r, p}
List	ListMatQZ(Matrix a, Matrix b);   {aa, bb, q, z, vec}
List	ListMatOde(t1, t2, x, diff, link, eps_h, dtmax, dtmin, dtsav, auto_step, void_flag);
List	ListMatOde45(t1, t2, x, diff, link, eps_h, dtmax, dtmin, dtsav, auto_step, void_flag);
List	ListMatOdeHybrid(t1, t2, x, diff, link, dt, eps_h, dtmax, dtmin, dtsav, auto_step, void_flag);
List	ListMatOde45Hybrid(t1, t2, x, diff, link, dt, eps_h, dtmax, dtmin, dtsav, auto_step, void_flag)
List	ListMatOdeGetXY(double t);
List	ListMatSort(Matrix a, int class, int row_col_all);
List	ListMatMaximum(Matrix a, int row_col);
List	ListMatMaximumElem(Matrix a);
List	ListMatMinimum(Matrix a, int row_col);
List	ListMatMinimumElem(Matrix a);
List	ListGetClasses(List a);
List	ListMakeList(int depth, int n1, int n2, int n3, ...);
List	ListMakeList2(int depth, int *number);

int		ListMenu(List a);
******************************************************************************/

