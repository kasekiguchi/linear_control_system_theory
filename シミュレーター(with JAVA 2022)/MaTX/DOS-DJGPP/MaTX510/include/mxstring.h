
/*
 *
 * Copyright (C) 1999 Masanobu Koga
 *            All Rights Reserved.
 *
 * No part of this software may be used, copied, modified, and distributed
 * in any form or by any means, electronic, mechanical, manual, optical or
 * otherwise, without prior permission of Masanobu Koga.
 *
 */

/*
  mxstring.h : 

  $Author:$
  $Revision:$
  $Date:$
  $Log:$
*/

#ifndef mxstring_header
#define mxstring_header

#include <matxconf.h>

/* ------------------------------------------------------------------------- */

#define	STRING_TMP					0
#define	STRING_VAR					1
#define STRING_LIST					2
#define STRING_MATX					3

#define STRING_NULL					mxStringDef("", -1)
#define STRING_DEF					mxStringSetType(STRING_NULL, STRING_VAR)
#define STRING_STC					mxStringSetType(mxStringNull(), STRING_MATX)

#define	mxStringGetClass(a)			((a)->class)
#define	mxStringClass(a)			mxStringGetClass(a)
#define	mxStringGetType(a)			((a)->type)
#define	mxStringType(a)				mxStringGetType(a)
#define	mxStringGetName(a)			((a)->name)
#define	mxStringName(a)				mxStringGetName(a)
#define	mxStringLength(a)			mxStringGetLength(a)
#define mxStringGetString(a)		((a)->string)
#define mxStringString(a)			mxStringGetString(a)

#define mxStringIsVar(a)			(mxStringType(a) == STRING_VAR)
#define mxStringIsTmp(a)			(mxStringType(a) == STRING_TMP)
#define mxStringIsUndef(a)			(mxStringLength(a) == -1)

#define mxStringIsSameClass(a, b)	(mxStringClass(a) == mxStringClass(b))
#define mxStringIsSameLength(a, b)	(mxStringLength(a) == mxStringLength(b))
#define mxStringIsLonger(a,b)		(mxStringLength(a) > mxStringLength(b))
#define mxStringIsShorter(a,b)		(mxStringLength(a) < mxStringLength(b))

#define mxStringErrorName(a)		(a)->name, mxStringLength(a)

typedef struct __mxString _mxString, *mxString;

struct __mxString {	 /* mxString                   */
	char	*name;	 /* Name of String             */	
	int		type;	 /* Data Type ( VAR, TMP )     */
	int		length;	 /* Length of String           */
	char	*string; /* Content of String          */
	mxString prev;	 /* To link to previous String */
	mxString next;	 /* To link to nest String     */
};

#define MXSTRING_ERR_LENGTH 256

extern char	*mxstring_err_src;				/* Error source code */

/* ------------------------------------------------------------------------- */

void 		mxStringError();
void 		mxStringError2();
void 		mxStringWarning();
void 		mxStringWarning2();
void		mxStringUndefCheck();
void		mxStringUndefCheck2();
void		mxStringInit();
void		mxStringFree();
void		mxStringFrees();
void		mxStringInstall();
void		mxStringDestroy();
void		mxStringUndef();
void		mxStringUndefs();
void		mxStringTmpUndef();
#ifdef MATX_RT
void		mxStringTmpUndefs();
#endif
void		mxStringAllPrint();
void		mxStringPrint();
void		mxStringSwap();

mxString	mxStringSetName();
mxString	mxStringSetType();
mxString	mxStringSetString();
mxString	mxStringSetLength();
mxString	mxStringSetChar();
mxString	mxStringCharToString();

mxString	mxStringInput();
mxString	mxStringEdit();
mxString	mxStringCopy();
mxString	mxStringPartCopy();
mxString	mxStringPut();
mxString	mxStringElementCopy();
mxString	mxStringElementChange();
mxString	mxStringMove();
mxString	mxStringDup();
mxString	mxStringAssign();
mxString	mxStringAssignOnly();
mxString	mxStringFileRead();
mxString	mxStringFileSave();
mxString	mxStringFileWrite();
mxString	mxStringWrite();
mxString	mxStringRead();
int			mxStringReadContent();
int			mxStringCompare();		
int			mxStringIndex();
int			mxStringLastIndex();
int			mxStringIsEqual();
int			mxStringIsNotEqual();
int			mxStringGetLength();

mxString	mxStringDef();
mxString	mxStringRequest();
mxString	mxStringStringDef();
mxString	mxStringNull();
mxString	mxStringSameDef();
mxString	mxStringGetElem();
mxString	mxStringSetElem();
mxString	mxStringCut();
mxString	mxStringFgets();
mxString	mxStringGets();
#ifdef HAVE_STDARG
mxString	mxStringSprintf(char *format, ...);
#else
mxString	mxStringSprintf();
#endif /* HAVE_STDARG */

mxString	mxStringReverse();
mxString	mxStringAdd();
mxString	mxStringMul();

mxString mxStringGetSubString();
mxString mxStringGetSubString2();
mxString mxStringSetSubString();
mxString mxStringSetSubString2();

#endif

/*
--------------------------------------------------------------------------

void 		mxStringError(char *func, char *statement, char *var);
void 		mxStringError2(char *func, char *statement,
						mxString a, mxString b);
void 		mxStringWarning(char *func, char *statement, char *var);
void 		mxStringWarning2(char *func, char *statement,
						mxString a, mxString b);
void		mxStringUndefCehck(mxString a, char *name);
void		mxStringUndefCehck2(mxString a, mxString b, char *name);
void		mxStringInit();
void		mxStringFree(mxString a);
void		mxStringFrees(mxString a);
void		mxStringAllFree();
void		mxStringInstall(mxString a);
void		mxStringDestroy(mxString a);
void		mxStringUndef(mxString a);
void		mxStringUndefs(mxString a);
void		mxStringTmpUndef(void);
#ifdef MATX_RT
void		mxStringTmpUndefs(mxString a);
#endif
void		mxStringAllUndef();
void		mxStringAllPrint();
void		mxStringPrint(mxString a);
void		mxStringSwap(mxString b, mxString a);
void		mxStringExchangeListposition(mxString b, mxString a);
char		*mxStringToString(mxString a, char **str, int save, char *var);
char		*C_mxStringToString(mxString a, char **str, int save);

mxString	mxStringSetName(mxString a, char *name);
mxString	mxStringSetType(mxString a, int type);
mxString	mxStringSetClass(mxString a, int class);
mxString	mxStringSetStrintg(mxString a, Matrix b);
mxString	mxStringSetLength(mxString a, int length);
mxString	mxStringSetChar(mxString a, int number, char c)
mxString	mxStringCharToString(c);

mxString	mxStringInput(char *name);
mxString	mxStringEdit(mxString a);
mxString	mxStringCopy(mxString b, mxString a);
mxString	mxStringPartCopy(mxString b, int bl, int bh,
                         mxString a, int al, int ah);
mxString	mxStringPut(mxString a, int b1, mxString a);
mxString	mxStringElementCopy(mxString b, mxString a);
mxString	mxStringElementChange(mxString b, mxString a);
mxString	mxStringMove(mxString b, mxString a);
mxString	mxStringDup(mxString a);
mxString	mxStringAssign(mxString b, mxString a);
mxString	mxStringAssignOnly(mxString b, mxString a);
mxString	mxStringFileRead(char *filename);
mxString	mxStringFileWrite(mxString a, char *filename);
mxString	mxStringFileSave(mxString a, char *filename, int append, int cr);
mxString	mxStringWrite(mxString pp, FILE *fp);
int			mxStringRead(mxString pl, FILE *fp, mxStringData *data)
int			mxStringReadContent(mxString pl, FILE *fp, mxStringData *data)
int			mxStringCompare(mxString a, mxString b);
int			mxStringIndex(mxString a, mxString b);
int			mxStringLastIndex(mxString a, mxString b);
int			mxStringIsEqual(mxString a, mxString b);
int			mxStringIsNotEqual(mxString a, mxString b);
int			mxStringGetLength(mxString a);

mxString	mxStringDef(char *name, int m);
mxString	mxStringRequest(int degree, int class);
mxString	mxStringCoefDef(Matrix m);
mxString	mxStringSameDef(mxString a);
mxString	mxStringNull();
mxString	mxStringGetElem(mxString a, int n);
mxString	mxStringSetElem(mxString a, int n, mxString b);
mxString	mxStringCut(mxString a, int n1, int n2);
mxString	mxStringFgets(int fd, unsigend int size);
mxString	mxStringGets(unsigned int size);
mxString	mxStringSprintf(char *format, ...);

mxString	mxStringReverse(mxString a);
mxString	mxStringAdd(mxString a, mxString b);

mxString mxStringGetSubString(mxString a, int from, int to, int by);
mxString mxStringGetSubString2(mxString a, Marix idx);
mxString mxStringSetSubString(mxString a, int from, int to, int by,
                              mxString b);
mxString mxStringSetSubString2(mxString a, Marix idx, mxString b);

----------------------------------------------------------------------------
*/
