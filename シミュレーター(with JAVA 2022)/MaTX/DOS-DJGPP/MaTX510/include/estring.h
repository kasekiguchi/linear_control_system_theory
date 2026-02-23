
/*
 *
 * Copyright (C) 1989-1994 Masanobu Koga
 *            All Rights Reserved.
 *
 * No part of this software may be used, copied, modified, and distributed
 * in any form or by any means, electronic, mechanical, manual, optical or
 * otherwise, without prior permission of Masanobu Koga.
 *
 */

/*
  estring.h : 

  $Author: koga $
  $Revision: 1.1 $
  $Date: 1994/06/21 13:21:48 $
  $Log: estring.h,v $
 * Revision 1.1  1994/06/21  13:21:48  koga
 * Initial revision
 *
*/

#ifndef estring_header
#define estring_header

#ifdef MSC60
#pragma optimize( "t", off )
#endif

#define	STR_NULL		strcpy((char *)emalloc(1), "")

/*
 * String Class Definition
 */

typedef char *String;

#ifdef HAVE_STDARG
String	StringPrintf(char *format, ...);
#else
String	StringPrintf();
#endif
String	StringDef();
String	StringDup();
String	StringCharToString();
String	StringAssign();
String	StringEdit();
int		StringFileWrite();
int		StringFileSave();
String	StringWrite();
int		StringRead();
int		StringReadContent();
int		StringIndex();
int		StringLastIndex();
void	StringFree();
String	StringAdd();
#ifdef HAVE_STDARG
String	StringCats(int n, ...);
#else
String	StringCats();
#endif
String	StringGetElem();
String	StringSetElem();
String	StringCut();
String	StringPut();
String	StringFgets();
String	StringGets();
#endif

/*
String	StringDef(char *ss);
String	StringDup(String str);
String	StringCharToString(char c);
String	StringAssign(String *str, char *name);
String	StringEdit(String *str, char *name);
String	StringPrintf(char *format, ...);
int		StringFileWrite(String str, char *filename);
int		StringFileSave(String str, char *filename, char *name,
						int append, int cr);
String	StringWrite(String str, FILE *fp, char *name);
int		StringRead(String *str, FILE *fp, char *name);
int		StringReadContent(String *str, FILE *fp, StringData *data);
int		StringIndex(String *str, String *key_word);
void	StringFree(String str);
String	StringAdd(String str1, String str2);
String	StringCats(int n, ...);
String	StringGetElem(String str1, int n);
String	StringSetElem(String str1, int n);
String	StringCut(String str1, int n1, int n2);
String	StringPut(String str1, int n1, String str2);
String	StringGets(int size);
String	StringFgets(int fd, int size);
*/
