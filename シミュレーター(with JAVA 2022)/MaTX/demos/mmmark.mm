/*  -*- MaTX -*-
 *
 *  mmmark()  Measure mm-mark of the machine
 *

 *	Copyright (C) 1989-1995  Masanobu Koga
 *            All Rights Reserved.
 *
 *	No part of this software may be used, copied, modified, and distributed
 *	in any form or by any means, electronic, mechanical, manual, optical or
 *	otherwise, without prior permission of Masanobu Koga.
 */


Matrix A,B;

Func void main()
{
	void mmmark();

	mmmark();
}

Func void mmmark()
{
	Real t1,dtsav,h;
	Matrix x0,TC,XC,UC;

	void diff_eqs(), link_eqs();

	h = 1.0E-3;
	dtsav = 1.0E-2;
	t1 = 10.0;

	A = [[0,1,0]
	     [0,0,1]
	     [0,0,0]];
	B = [0,0,1]';

	x0 = [1,0,0]';

	{TC, XC, UC} = Ode(0.0, t1, x0, diff_eqs, link_eqs, h, dtsav);
}

Func void diff_eqs(DX, t, X, UY)
	Real t;
	Matrix X, DX, UY;
{
	Matrix xp, up, dxp;

	xp = X;

	up = UY;

	dxp = A * xp + B * up;

	DX = [dxp];
}

Func void link_eqs(UY, t, X)
	Real t;
	Matrix UY, X;
{
	Matrix xp,up;

	xp = X;

	up = [-1,-2,-3]*xp;

	UY = [up];
}

/*
main();
*/

