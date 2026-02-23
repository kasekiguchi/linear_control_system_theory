
/* -*- MaTX -*-
 *  
 *  demo()  Demonstration program in Japanese.

 *
 *	Copyright (C) 1989-1995  Masanobu Koga
 *            All Rights Reserved.
 *
 *	No part of this software may be used, copied, modified, and distributed
 *	in any form or by any means, electronic, mechanical, manual, optical or
 *	otherwise, without prior permission of Masanobu Koga.
 */

Func void demo()
{
	Integer i;
	List mm;

	void demo_datatype(), demo_graph(), demo_command();
	void demo_function(), demo_toolbox(), bench();

	mm = {"<<< Introduction to MaTX >>>",
		  "Data Type",     // 1
		  "Graphics",      // 2
		  "Utility",       // 3
		  "Function",      // 4
		  "Benchmarks",    // 5 
		  "Toolboxes",     // 6
		  "Quit"};

	i = 1;
	for (;;) {
		i = menu(mm, i);
		switch (i) {
		  case 1:
			demo_datatype();
			break;
		  case 2:
			demo_graph();
			break;
		  case 3:
			demo_command();
			break;
		  case 4:
			demo_function();
			break;
		  case 5:
			bench();
			break;
		  case 6:
			demo_toolbox();
			break;
		}
		if (i == length(mm)-1) { break; }
		i++;
	}
}

Func void demo_datatype()
{
	Integer i;
	List mm;

	void demo_datatype_all(), demo_matrix(), demo_symbolic();

	mm = {"<<<  Data Type of MaTX  >>>",
		  "Data types",    // 1
		  "Matrix",        // 2
		  "Symbolics",     // 3
		  "Quit"};

	i = 1;
	for (;;) {
		i = menu(mm, i);
		switch (i) {
		  case 1:
			demo_datatype_all();
			break;
		  case 2:
			demo_matrix();
			break;
		  case 3:
			demo_symbolic();
			break;
		}
		if (i == length(mm)-1) { break; }
		i++;
	}
}

Func void demo_datatype_all()
{
	Integer a;
	Real b;
	Complex i;
	String str, str2;
	Polynomial s, p, p2;
	Rational rr, r2;
	Matrix A, A2;
	CoMatrix AC;
	PoMatrix AP;
	RaMatrix AR;
	Array Aa;
	Index idx;
	List l;

	print "\nData Type\n";
	print "\n(a) Scalar\n";

	print "\na=1               // Integer\n";
	pause;
	print a = 1;

	print "\nb=1.4142          // Real number\n";
	pause;
	print b = 1.41412;

	print "\ni=(0,1);          // Complex number (Imaginary unit)\n";
	pause;
	print i = (0,1);

	print "\nstr=\"string\"      // String\n";
	pause;
	print str = "string";

	print "\ns=Polynomial(\"s\") // Polynomial variable\n";
	pause;
	print s = Polynomial("s");

	print "\np=1+3*s+4.5*s^2   // Polynomial\n";
	pause;
	print p = 1 + 3*s + 4.5*s^2;

	print "\nrr=s/p             // Rational polynomial\n";
	pause;
	print rr = s/p;

	print "\n\n(b) Matrix\n";
	pause;

	print "\n";
	print "A=[[a+1 2    3     ]\n";
	print "   [ 0  0 atan(1.0)]\n";
	print "   [ 5  9,  -1     ]]   // Real matrix\n";
	pause;
	print A = [[a+1  2    3     ]
			   [ 0   0 atan(1.0)]
			   [ 5   9,  -1     ]];

	print "\n";
	print "AC=[[1+2*i, 3+4*i]\n";
	print "    [(3,4), (1,2)]]     // Complex matrix\n";
	pause;
	print AC = [[1+2*i, 3+4*i]
				[(3,4), (1,2)]];
		 
	print "\nAP=[p, 1-s]             // Polynomail matrix\n";
	pause;
	print AP = [p, 1-s];

	print "\nAP=[[AP][1 1+s*p]]      // Matrix polynomial\n";
	pause;
	print AP = [[AP][1 1+s*p]];

	print "\nAR=AP/(s^3-3*s^2+4*s-2)  // Rational polynomial matrix\n";
	pause;
	print AR = AP/(s^3-3*s^2+4*s-2);

	print "\nAa = [0:0.1:1.0]        // Real array\n";
	pause;
	print Aa = [0:0.1:1.0];

	print "\nidx = Index([1 3 5 7])  // Index\n";
	pause;
	print idx = Index([1 3 5 7]);

	print "\nAa(idx)                 // 1,3,5,7-element of Aa\n";
	pause;
	print Aa(idx);

	print "\n(c) List\n";
	pause;

	print "\nl={A, p, rr, \"this is a list\"}    // List\n";
	pause;
	print l = {A, p, rr, "this is a list"};
	
	print "\n{A2, p2, r2, str2} = l;          // Elements of list\n";
	pause;
	{A2, p2, r2, str2} = l;

	print "\nprint A2, p2, r2, str2;\n";
	pause;
	print A2, p2, r2, str2;

	print "\nl(1,Matrix)                      // 1st element \n";
	pause;
	print l(1,Matrix);

	print "\nl(2,Polynomial)                  // 2nd element\n";
	pause;
	print l(2,Polynomial);

	print "\nl(3,Rational)                    // 3rd element\n";
	pause;
	print l(3,Rational);

	print "\nl(4,String)                      // 4th element\n";
	pause;
	print l(4,String);
}


Func void demo_matrix()
{
	Integer i;
	List mm;

	void demo_matrix_misc(), demo_matrix_op();
	void demo_matrix_element(), demo_matrix_function();

	mm = {"<<<  Matrix  >>>",
		  "How to write a matrix",       // 1
		  "Manipulation of elements",    // 2
		  "Operation of matrix",         // 3
		  "Function of matrix",          // 4
		  "Quit"};

	i = 1;
	for (;;) {
		i = menu(mm, i);
		switch (i) {
		  case 1:
			demo_matrix_misc();
			break;
		  case 2:
			demo_matrix_element();
			break;
		  case 3:
			demo_matrix_op();
			break;
		  case 4:
			demo_matrix_function();
			break;
		}
		if (i == length(mm)-1) { break; }
		i++;
	}
}

Func void demo_matrix_misc()
{
	Matrix A, B, C, D, E;
	Complex i;
	CoMatrix F;

	print "To enter a row vector, spaces are put between the elements and\n";
	print "brackets are placed around the data. For example, to enter\n";
	print "a row vector a, type:\n";
	print "\n";
	print "\tA = [1 2 3]  // which results in:\n";
	print "\n";
	A = [1 2 3];
	print A, "\n";
	pause;

	print "\n";
	print "To enter a matrix, some row vectors are used and brackets are\n";
	print "placed around the vectors.  For example, to enter a 3-by-3\n";
	print "matrix A, type:\n";

	print "\nCase 1: (one-line)\n\n";
	print "  A=[[1 2 3][4 5 6][7 8 0]]\n";
	pause;
	print A = [[1 2 3][4 5 6][7 8 0]];

	print "\nCase 2:(row-wise)\n\n";
	print "  A=[[1 2 3]\n";
	print "     [4 5 6]\n";
	print "     [7 8 0]]\n";
	pause;
	print A = [[1 2 3]
			   [4 5 6]
			   [7 8 0]];

	print "\nCase 3: (Arbitrary format)\n\n";
	print "  A=[[1 2 3]\n";
	print "     [4 5\n";
	print "  6][7 8 0]]\n";
	pause;
	print A = [[1 2 3]
			   [4 5
				6][7 8 0]];

	print "\nUse a semicolon at the end of line\n";
	print "not to display the result.\n\n";

	print "  A = [[1 2 3][4 5 6][7 8 0]];\n";
	pause;

	print "\nDefine an imaginary unit 'i' to define a complex matrix\n\n";

	print "  i = (0,1);\n";
	pause;
	print i = (0,1);

	print "\n";
	print "  F = [[1+i 2+3*i][3+2*i 4+4*i]]\n";
	pause;
	print F = [[1+i 2+3*i][3+2*i 4+4*i]];

	print "\nMake a 2 x 3 zero matrix\n";
	print "  Z(2,3)\n";
	pause;
	print Z(2,3);

	print "\nMake a 3 x 3 unit matrix\n";
	print "  I(3)\n";
	pause;
	print I(3);

	print "\nMake a 3 x 3 matrix whose all elements are 1\n";
	print "  ONE(3)\n";
	pause;
	print ONE(3);

	print "\nMake a diagonal matrix\n";
	print "  diag(3.0, 7.0, 2.0)\n";
	pause;
	print diag(3.0, 7.0, 2.0);

	print "\nMake a vector with elements from 1 to 3 by 1\n";
	print "  [1:3]\n";
	pause;
	print [1:3];

	print "\nMake a vector with elements from 1 to 3 by 0.5\n";
	print "  [1:0.5:3]\n";
	pause;
	print [1:0.5:3];

	print "\nMake a vector with elements from 3 to 1 by 1\n";
	print "  [3:-1:1]\n";
	pause;
	print [3:-1:1];

	print "\nMake a large matrix from a small matrix A,B,C,D\n\n";

	print "  A = [[1 2 1][3 4 0][0 0 1]];\n";
	print "  B = Z(3,2);\n";
	print "  C = ONE(2,3);\n";
	print "  D = diag(2.0, 3.0);\n";
	print "  E = [[A B]\n";
	print "       [C D]]\n";
	pause;

	A = [[1 2 1][3 4 0][0 0 1]];
	B = Z(3,2);
	C = ONE(2,3);
	D = diag(2.0, 3.0);
	print E = [[A B][C D]];

	pause;
}

Func void demo_matrix_element()
{
	Matrix A, AA;

	A = [[1 2 3][4 5 6][7 8 0]];

	print "\n\nManipulation of elements of matrix\n\n";
	pause;

	print "A\n";
	pause;
	print A;

	print "\nA(1,1)                          // (1,1)-element\n";
	pause;
	print A(1,1);

	print "\nA(:,1)                          // 1st colum\n";
	pause;
	print A(:,1);

	print "\nA(3,:)                          // 3rd row\n";
	pause;
	print A(3,:);

	print "\nA(1:2,2:3)                      // ";
	print "Submatrix consisting of 1sd-2nd rowÅC2nd-3rd colum\n";
	pause;
	print A(1:2,2:3);

	print "\nA(Index([1 3]), :)              // 1st and 3rd row\n";
	pause;
	print A(Index([1 3]), :);

	print "\nA(Index([1 3]), 2:3)            // 1st and 3rd row, 2-3 row\n";
	pause;
	print A(Index([1 3]), 2:3);

	print "\nAA = Z(3,4);                    // 3 x 4 zero matrix\n";
	pause;
	AA = Z(3,4);
	print AA;

	print "\nAA(1,1) = 1.0;                  // set 1.0 to (1,1)-element\n";
	pause;
	AA(1,1) = 1.0;
	print AA;

	print "\nAA(1,3:4) = [2 3];              // set [2 3] to 1st row, 3-4 column\n";
	pause;
	AA(1,3:4) = [2 3];
	print AA;

	print "\nAA(:,2) = [4 5 6]';             // set [4 5 6]' to 2nd colum\n";
	pause;
	AA(:,2) = [4 5 6]';
	print AA;

	print "\nAA(2:3,3:4) = [[7 8][9 10]]; // set [[7 8][9 10]] to 2-3 row, 3-4 colum\n";
	pause;
	AA(2:3,3:4) = [[7 8][9 10]];
	print AA;
}

Func void demo_matrix_op()
{
	Matrix A, B, C, D, Ai, At;
	CoMatrix Cc;

	print "\nFundamental matrix operation\n";
	print "\n";
	print "We can run through some basic matrix operations. They are\n";
	print "done the same way you might write them on paper.\n";

	print "\nAddiction and Subtraction\n";

	print "  A = [[1 2 3][4 5 6][7 8 0]];\n";
	print "  B = [[8 1 6][3 5 7][4 9 2]];\n";
	print "  A + B\n";
	pause;

	A = [[1 2 3][4 5 6][7 8 0]];
	B = [[8 1 6][3 5 7][4 9 2]];
	print A + B;

	print "\n";
	print "  A - B\n";
	pause;
	print A - B;

	print "\n(Matrix) Multiplication\n";

	print "  A * B\n";
	pause;
	print A * B;

	print "\n";
	print "  C = [[1 2 3][3 2 5]\n";
	pause;
	print C = [[1 2 3][3 2 5]];

	print "\n";
	print "  D = [[3 1 6][3 5 7][4 9 1]]\n";
	pause;
	print D = [[3 1 6][3 5 7][4 9 1]];

	print "\n";
	print "  C * D\n";
	pause;
	print C * D;

	print "\nAi = A~                           // Inverse matrix\n";
	pause;
	print Ai = A~;

	print "\nA * Ai\n";
	pause;
	print A * Ai;

	print "\nRight-division (Multiply an inverse matrix from right)\n";
	print "  A / B                             // A * B~\n";
	pause;
	print A / B;

	print "\nLeft-division (Multiply an inverse matrix from left)\n";
	print "  B \ A                             // B~ * A\n";
	pause;
	print B \ A;

	print "\nAt = A'                           // Transpose matrix\n";
	pause;
	print At = A';

	print "\nComplex matrix\n";
	print "  C = (A,B)                         // C = A + B*i\n";
	pause;
	C = (A,B);
	print C;

	print "\nComplex conjugate matrix\n";
	print "  Cc = C#                           // Complex conjugate matrix\n";
	pause;
	print Cc = C#;

	print "\nArray operation(Element-wise operation)\n"; 

	print "\nElment-wise multiplication\n";
	print "  A .* B\n";
	pause;
	print A .* B;

	print "\nElement-wise division\n";
	print "  A ./ B\n";
	pause;
	print A ./ B;

	print "\nElement-wise power\n";
	print "  A .^ 0.3\n";
	pause;
	print A .^ 0.3;
}

Func void demo_matrix_function()
{
	Matrix A, B, d, D, V, U;
	Polynomial s, phi;

	A = [[1 2 3][4 5 6][7 8 0]];

	print "\nMatrix function\n";
	pause;

	print "\nDeterminant of matrix\n\n";
	print "  det(A)\n\n";
	pause;
	print det(A);

	print "\nTrace of marix (Sum of diagonal elements)\n";
	print "  trace(A)\n";
	pause;
	print trace(A);

	print "\nRank\n\n";
	print "  rank(A)\n";
	pause;
	print rank(A);

	print "\nCondition number\n\n";
	print "cond(A)\n";
	pause;
	print cond(A);

	print "\nExponential matrix\n";
	print " exp(A)                    // Exponential function\n";
	pause;
	print exp(A);

	print "\nElement-wise sine\n";
	print "  sin(Array(A))\n";
	pause;
	print sin(Array(A));

	print "\nElement-wise exponential\n";
	print " exp(Array(A))              // Exponential function\n";
	pause;
	print exp(Array(A));

	print "\nEigenvalues\n";
	print "  A = [[1 2 3][4 5 6][7 8 0]];\n";
	print "  d = eigval(A)\n";
	pause;
	A = [[1 2 3][4 5 6][7 8 0]];
	print d = eigval(A);

	print "\nSolve eigenvalue problem: Ax = a x\n";
	print "  A = [[1 2 3][4 5 6][7 8 0]];\n";
	print "  {D, V} = eig(A); V = Re(V); D = Re(D)\n";
	print "  print V, D;\n";
	pause;
	A = [[1 2 3][4 5 6][7 8 0]];
	{D, V} = eig(A); D = Re(D); V = Re(V);
	print V, D;

	print "\nSolve generalized eigenvalue problem: Ax = aBx\n";
	print "  A = [[1 2 3][4 5 6][7 8 0]];\n";
	print "  B = [[8 1 6][3 5 7][4 9 2]];\n";
	print "  {D, V} = eig(A, B);\n";
	print "  print V, D;\n";
	pause;
	A = [[1 2 3][4 5 6][7 8 0]];
	B = [[8 1 6][3 5 7][4 9 2]];
	{D, V} = eig(A, B);
	print V, D;

	print "\nSingular value decomposition\n\n";
	print "  {U,D,V} = svd(A);\n";
	print "  print U,D,V;\n";
	pause;
	{U,D,V} = svd(A);
	print U,D,V;

	print "\nCharacteristic polynomial\n";
	print "\ns = Polynomial(\"s\");\n";
	print "\nphi = det(s*I(A) - A)\n";
	pause;
	print s = Polynomial("s");
	print phi = det(s*I(A) - A);

	print "\nThe roots of this polynomial are, of course, ";
	print "the eigenvalues of A:\n";
	print "  roots(phi)\n";
	print "  eigval(A)\n\n";
	pause;

	print roots(phi), eigval(A);
	pause;
}

Func void demo_symbolic()
{
	Polynomial s, p, q, r;
	Rational rr;
	CoMatrix ro1, ro2;

	print "\nPolynomial function\n";
	print "\nInput two polynomiasl p(s) and q(s)";
	print "At first, define a polynomial variable 's'\n";
	print "  s = Polynomial(\"s\");\n";
	print "  p = s^2 + 2*s + 3\n";
	print "  q = 4*s + 5\n\n";
	pause;
	s = Polynomial("s");
	print p = s^2 + 2*s + 3;
	print q = 4*s + 5;

	print "\nMultiplication of polynomials\n";
	print "  r = p * q\n";
	pause;
	print r = p * q;

	print "\nDivision of polynomials\n";
	print "  rr = p / q\n";
	pause;
	print rr = p / q;

	print "\nRoots of polynomials\n";
	print "  ro1 = roots(p)\n";
	pause;
	print ro1 = roots(p);

	print "  ro2 = roots(q)\n";
	pause;
	print ro2 = roots(q);

	pause;
}

Func void demo_command()
{
	print "\nUseful command\n";
	print "\nChecking variables\n";
	print "\nTo display names of all variables\n";
	print "  who\n";
	pause;
	who;

	print "\nTo display name and type of all variables\n";
	print "(Type 'q' to quit 'less' and 'more')\n";
	print "  whos\n";
	pause;
	whos;

	print "\nTo save and load variables\n";
	print "\n'save' command saves variables to a file\n";
	print "'load' command loads variables from a file\n";

	print "\nOn-line help\n";
	print "\nTo display the list of functions\n";
	print "(Type 'q' to quit 'less' and 'more')\n";
	print "  help\n";
	pause;
	help;
	
	print "\nTo dipslay the usage of a function 'bode()'\n";
	print "(Type 'q' to quit 'less' and 'more')\n";
	print "  help bode\n";
	pause;
	help bode;

	pause;
}

Func void demo_graph()
{
	Integer i;
	List mm;

	void demo_element_graph(), demo_simple_graph(), demo_interest_graph();

	mm = {"<<<  Graphics  >>>",
		  "Fundamental graphics capabilities", // 1
		  "Simple graph demonstration",        // 2
		  "Interesting graph demonstration",   // 3
		  "Quit"};


	i = 1;
	for (;;) {
		i = menu(mm, i);
		switch (i) {
		  case 1:
			demo_element_graph();
			break;
		  case 2:
			demo_simple_graph();
			break;
		  case 3:
			demo_interest_graph();
			break;
		}
		if (i == length(mm)-1) { break; }
		i++;
	}


}

Func void demo_element_graph()
{
	Integer win1,win2;
	Array x, y, x2, y2;

	win1 = mgplot_cur_win();
	win2 = mgplot_newwindow();

	print "\nGraphics\n";

	print "\nMake a data to draw a sine wave\n";

	print "  x = [0:PI/10:20*PI];\n";
	print "  y = sin(x);\n";
	pause;
	x = [0:PI/10:20*PI];
	y = sin(x);

	print "\nmgplot draws 2D plot\n";
	print "  mgplot(win1,x,y,{\"sin(x)\"})\n";
	pause;
	mgplot_reset(win1);
	mgplot(win1,x,y,{"sin(x)"});

	print "\nChange the range\n";
	print "  mgplot_cmd(win1,\"set xrange [0:20*pi]\")\n";
	print "  mgplot_cmd(win1,\"set yrange [-1:1]\")\n";
	print "  mgreplot(win1);\n";
	pause;
	mgplot_cmd(win1, "set xrange [0:20*pi]");
	mgplot_cmd(win1, "set yrange [-1:1]");
	mgreplot(win1);

	print "\nDraw grid line\n";
	print "  mgplot_grid(win1,1);\n";
	print "  mgreplot(win1);\n";
	pause;
	mgplot_grid(win1,1);
	mgreplot(win1);

	print "\nDraw two kinds of lines\n";
	print "  x = [0:PI/10:20*PI];\n";
	print "  y = sin(x);\n";
	print "  y2 = 0.5*sin(2*x);\n";
	print "  mgplot_cmd(win1,\"set xrange [0:20*pi]\");\n";
	print "  mgplot_cmd(win1,\"set yrange [-1:1]\")\n";
	print "  mgplot_grid(win1,1);\n";
	print "  mgplot(win1, x, [[y][y2]], {\"sin(x)\", \"0.5*sin(2*x)\"});\n";
	pause;
	mgplot_reset(win1);

	x = [0:PI/10:20*PI];
	y = sin(x);
	y2 = 0.5*sin(2*x);
	mgplot_cmd(win1, "set xrange [0:20*pi]");
	mgplot_cmd(win1, "set yrange [-1:1]");
	mgplot_grid(win1, 1);
	mgplot(win1, x, [[y][y2]], {"sin(x)", "0.5*sin(2*x)"});

	print "\nSet the title, x-label, and y-label on the graph\n";
	print "  mgplot_title(win1,\"Sine Plot\");\n";
	print "  mgplot_xlabel(win1,\"x value\");\n";
	print "  mgplot_ylabel(win1,\"y & y2 value\");\n";
	print "  mgreplot(win1);\n";
	pause;
	mgplot_title(win1,"Sine Plot");
	mgplot_xlabel(win1,"x value");
	mgplot_ylabel(win1,"y & y2 value");
	mgreplot(win1);
	
	print "\nDraw an one-side logarithmics plot\n";

	print "  x2 = [PI/100:PI/10:20*PI];\n";
	print "  y2 = sin(x2);\n";
	print "  mgplot_cmd(win1,\"set xrange [pi/100:20*pi]\");\n";
	print "  mgplot_cmd(win1,\"set yrange [-1:1]\");\n";
	print "  mgplot_grid(win1,1);\n";
	print "  mgplot_semilogx(win1, x2, y2, {\"sin(x)\"});\n";
	pause;
	mgplot_reset(1);

	x2 = [PI/100:PI/10:20*PI];
	y2 = sin(x2);

	mgplot_cmd(win1,"set xrange [pi/100:20*pi]");
	mgplot_cmd(win1,"set yrange [-1:1]");
	mgplot_grid(win1,1);
	mgplot_semilogx(win1,x2,y2,{"sin(x)"});

#ifndef VC40
	print "\nDraw multiple lines\n";
	print "  mgplot_cmd(win1,\"set xrange [pi/100:20*pi]\");\n";
	print "  mgplot_cmd(win1,\"set yrange [-1:1]\");\n";
	print "  mgplot_grid(win1,1);\n";
	print "  mgplot(win1,x,y,{\"sin(x)\"});\n";

	print "  mgplot_cmd(win2,\"set xrange [pi/100:20*pi]\");\n";
	print "  mgplot_cmd(win2,\"set yrange [-1:1]\");\n";
	print "  mgplot_grid(win2,1);\n";
	print "  mgplot_semilogx(win2,x2,y2,{\"sin(x)\"});\n";
	pause;
	mgplot_reset(win1);
	mgplot_reset(win2);

	mgplot_cmd(win1,"set xrange [pi/100:20*pi]");
	mgplot_cmd(win1,"set yrange [-1:1]");
	mgplot_grid(win1,1);
	mgplot(win1,x,y,{"sin(x)"});

	mgplot_cmd(win2,"set xrange [pi/100:20*pi]");
	mgplot_cmd(win2,"set yrange [-1:1]");
	mgplot_grid(win2,1);
	mgplot_semilogx(win2,x2,y2,{"sin(x)"});
#endif

	pause;
}

Func void demo_simple_graph()
{
	Integer win;
	Array t,y,x,z;
	Real tt;
	List names, lines;

	win = mgplot_cur_win();
	clear;
	print "\n";
	print "This demo goes through some of the MaTX graphics\n";
	print "capabilities. it runs on its own timer.\n\n";

	pause;

	t = [0:0.3:10];
	y = sin(t);

	mgplot_reset(win);
	mgplot_grid(win,0);
	mgplot_title(win,"A simple X-Y plot");
	mgplot(win,t,y,{""});
	pause(1.0);

	mgplot_title(win,"With a dot, and grid lines");
	mgplot_grid(win,1);
	mgplot_xlabel(win,"labels on x-axis.");
	mgplot_ylabel(win,"Hello, World.");
	mgreplot(win,t,y,{""},{"w dots"});
	pause(1.0);

	mgplot_reset(win);
	mgplot_title(win,"Various line types");
	mgplot(win,t,[[y][2*y][3*y][4*y]],{"","","",""});
	pause(1.0);

	t = [0.0:0.5:10];
	lines = {"w boxes", "w points", "w lines", "w dots", "w linespoints"};
	names = {"", "", "" , "", ""};
	mgplot_reset(win);
	mgplot_title(win,"Various marker types");
	mgplot(win,t,[[t][2*t .+ 3][3*t .+ 6][4*t .+ 9][5*t .+ 12]], names, lines);
	pause(1.0);

	t = [0.1:0.1:3];
	mgplot_reset(win);
	mgplot_title(win,"loglog and semilog plots");
	mgplot_loglog(win,exp(t),exp(t.*t),{""});

	t = [0:.3:30];
	mgplot_reset(win);
	mgplot_hold(win,1);
	mgplot_subplot(win,2,2,1);
	mgplot(win,t,sin(t));
	mgplot_subplot(win,2,2,2);
	mgplot(win,t,t.*sin(t));
	mgplot_subplot(win,2,2,3);
	mgplot(win,t,t.*sin(t).^2);
	mgplot_subplot(win,2,2,4);
	mgplot(win,t,t.^2 .*sin(t).^2);
	mgplot_hold(win,0);
	pause(1.0);

	clear;
}

Func void demo_interest_graph()
{
	Integer win;
	Array t,x,y;
	Matrix dzx,dzy,z,pzx,pzy;

	win = mgplot_cur_win();

	clear;
	print "\n";
	print "Plot a growing cosine wave with points:\n";
	print "\n";
	print "\tt = [0:0.99*PI/2:500];\n";
	print "\tx = t.*cos(t);\n";
	print "\tmgplot(win,x,t,{\"\"},{\"w points\"});\n\n";
	pause "Strike any key for plot.";

	t = [0:0.99*PI/2:500];
	x = t.*cos(t);
	mgplot_reset(win);
	mgplot(win,x,t,{""},{"w points"});

	print "Next, with lines\n\n";
	print "\tmgplot(win,x,t,{\"\"});\n\n";
	pause "Strike any key for plot.";

	mgplot_reset(win);
	mgplot(win,x,t,{""});

	clear;
	print "\n";
	print "Now plot the growing cosine versus a growing sine:\n";
	print "\n";
	print "\ty = t.*sin(t);\n";
	print "\tmgplot(win,x,y,{\"\"});\n\n";
	pause "Strike any key for plot.";

	y = t.*sin(t);
	mgplot_reset(win);
	mgplot(win,x,y,{""});

	clear;
}

Func void demo_function()
{
	Integer demo_facto();
	Matrix demo_mat_add();

	print "\nDefinition of function\n";
	pause;

	print "\nWe now define a function mat_add() to add two matrices\n";
	pause;

	print "\nFunc Matrix mat_add(a, b)\n";
	print "  Matrix a, b;\n";
	print "{\n";
	print "    Matrix c;\n";
	print "\n";
	print "    c = a + b;\n";
	print "    return c;\n";
	print "}\n";
	pause;

	print "\nTo add [[1 2][3 4]] and [[5 6][7 8]]";

	print "\n\nmat_add([[1 2][3 4]], [[5 6][7 8]])\n";
	pause;
	print "\n", demo_mat_add([[1 2][3 4]], [[5 6][7 8]]);

	print "\nTo define a recursive function facto() to calculate factorial\n";
	pause;

	print "\nFunc Integer facto(n)\n";
	print "  Integer n;\n";
	print "{\n";
	print "  if (n == 0) {\n";
	print "    return 1;\n";
	print "  } else {\n";
	print "    return n*facto(n-1);\n";
	print "  }\n";
	print "}\n";
	pause;

	print "\nTo calculate a factorial of 5\n";
	pause;

	print "\nfacto(5)\n";
	pause;
	print "\n", demo_facto(5);
	pause;
}

Func void demo_toolbox()
{
	Integer i;
	List mm;

	void sig_demo(), ctr_demo();
	
	mm = {"<<<  TOOLBOX  >>>",
		  "System Control Toolbox",
		  "Singnal Toolbox",
		  "Quit"};

	i = 1;
	for (;;) {
		i = menu(mm, i);
		switch (i) {
		  case 1:
			ctr_demo();
			break;
		  case 2:
			sig_demo();
			break;
		}
		if (i == length(mm)-1) { break; }
		i++;
	}
}

Func Integer demo_facto(n)
  Integer n;
{
  if (n == 0) {
    return 1;
  } else {
    return n*demo_facto(n-1);
  }
}

Func Matrix demo_mat_add(a, b)
  Matrix a, b;
{
    Matrix c;

    c = a + b;
    return c;
}
