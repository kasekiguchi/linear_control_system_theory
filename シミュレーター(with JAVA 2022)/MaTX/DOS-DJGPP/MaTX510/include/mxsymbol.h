#define mxsClass(s)				(s)->class

#define mxsString(s)			(s)->u.str
#define mxsInteger(s)			(s)->u.val2
#define mxsReal(s)				(s)->u.val
#define mxsComplex(s)			(s)->u.cmp
#define mxsPolynomial(s)		(s)->u.poly
#define mxsRational(s)			(s)->u.rat
#define mxsMatrix(s)			(s)->u.mat
#define mxsList(s)				(s)->u.list

#define mxsIsString(s)			((s)->class == MXS_STRING)
#define mxsIsInteger(s)			((s)->class == MXS_INTEGER)
#define mxsIsReal(s)			((s)->class == MXS_REAL)
#define mxsIsComplex(s)			((s)->class == MXS_COMPLEX)
#define mxsIsPolynomial(s)		((s)->class == MXS_POLYNOMIAL)
#define mxsIsRational(s)		((s)->class == MXS_RATIONAL)
#define mxsIsMatrix(s)			((s)->class == MXS_MATRIX)
#define mxsIsArray(s)			((s)->class == MXS_ARRAY)
#define mxsIsIndex(s)			((s)->class == MXS_INDEX)
#define mxsIsMatrixArrayIndex(s)((s)->class==MXS_MATRIX||(s)->class==MXS_ARRAY||(s)->class==MXS_INDEX)
#define mxsIsLIST(s)			((s)->class == MXS_LIST)

#define mxsSetString(s,v)		((s)->u.str = (v),  (s)->class = MXS_MATRIX)
#define mxsSetInteger(s,v)		((s)->u.val2 = (v), (s)->class = MXS_INTEGER)
#define mxsSetReal(s,v)			((s)->u.val = (v),  (s)->class = MXS_REAL)
#define mxsSetComplex(s,v)		((s)->u.cmp = (v),  (s)->class = MXS_COMPLEX)
#define mxsSetPolynomial(s,v)	((s)->u.poly = (v), (s)->class =MXS_POLYNOMIAL)
#define mxsSetRational(s,v)		((s)->u.rat = (v),  (s)->class = MXS_RATIONAL)
#define mxsSetMatrix(s,v)		((s)->u.mat = (v),  (s)->class = MXS_MATRIX)
#define mxsSetArray(s,v)		((s)->u.mat = (v),  (s)->class = MXS_ARRAY)
#define mxsSetIndex(s,v)		((s)->u.mat = (v),  (s)->class = MXS_INDEX)
#define mxsSetList(s,v)			((s)->u.list = (v), (s)->class = MXS_LIST)

typedef struct __Symbol Symbol, *mxSymbol;

struct __Symbol { 	/* symbol table entry                      */
	char	*name;
	short	scope;	/* STATIC                                  */
	short	type;	/* VAR, BLTIN, CONST, UNDEF, FUNC, PROC, UNSET        */
	short	class;	/* INTEGER, REAL, COMPLEX, STRINS, MATRIX, POLYNOMIAL */
	short	modify; /* Symbol was modified in the function     */
	_Object	u;		/* object              */
	Symbol	*prev;	/* to link to prev one */
	Symbol	*next;	/* to link to next one */
};


void mxsInstallFunction();
void mxsInstallProcedure();

/*
void mxsInstallFunction(name, d);
void mxsInstallProcedure(name, d);
*/
