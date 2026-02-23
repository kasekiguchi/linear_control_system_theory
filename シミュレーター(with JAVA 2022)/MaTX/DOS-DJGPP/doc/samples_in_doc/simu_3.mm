Matrix Ap, bp, cp;
Real ac, bc, cc, dc;

Func void init_params()
{
	/* Plant Parameters */
	Ap = [[0 1]
              [2 1]];
	bp = [0 1]';
	cp = [-1 1];

	/* Controller Parameters */
	ac = 5.0;
	bc = 1.0;
	cc = 54.0;
	dc = 9.0;
}

Func void main()
{
	Matrix x0;
	Real ti, tf, eps, dtsav, dtmin, dtmax;
	Array TC, XC, UC;
	void diff_eqs(), link_eqs(), init_params();

	init_params();

	ti = 0.0;	// Initial time
	tf = 10.0;	// Final time
	x0 = [1 0 0]';	// Initial state

	eps = 1.0E-6;	// Precision
	dtsav = 1.0E-3;	// Minimum data save interval
	dtmin = EPS;	// Minimum stepsize
	dtmax = 2.0;	// Maximum stepsize (tf-ti)/5

	{TC, XC, UC} = Ode45Auto(ti, tf, x0, diff_eqs, link_eqs);
/*
	{TC, XC, UC} = Ode45Auto(ti, tf, x0, diff_eqs, link_eqs,
					eps, dtsav, dtmin, dtmax);
*/
	plot(TC, XC);
}

// dx
// -- = f(x,u,t)
// dt
Func void diff_eqs(DX, t, X, UY)
	Real t;
	Matrix X, DX, UY;
{
	Matrix xp, dxp;
	Real xc, dxc, up, uc;

	xp = X(1:2,1);	// State of plant
	up = UY(1,1);	// Input to plant
	xc = X(3,1);	// State of controller
	uc = UY(2,1);	// Input to controller

	dxp = Ap*xp + bp*up;	// System eq. of plant
	dxc = ac*xc + bc*uc;	// System eq. of controller

	DX = [[dxp]
              [dxc]];
}

//
// y = g(x,u,t)
// 
Func void link_eqs(UY, t, X)
	Real t;
	Matrix UY, X;
{
	Matrix xp;
	Real up, yp, xc, yc, uc;

	xp = X(1:2,1);		// State of plant
	xc = X(3,1);		// State of controller

	yp = Real(cp * xp);	// Output from plant
	uc = yp;		// Link yp to uc

	yc = cc*xc + dc*uc;	// Output from controller
	up = - yc;		// Link yc to up

	UY = [up uc]';
}

