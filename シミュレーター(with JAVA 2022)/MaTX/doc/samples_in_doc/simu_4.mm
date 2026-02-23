Matrix Ap, Bp, Cp;
Matrix Ad, Bd, Cd;
Matrix Ac, Bc, Cc;
Matrix Af, Bf, Cf;
List state_idx;
List input_idx;

Func void main()
{
	Matrix xp0, xd0, xc0, xf0, x0;
	Matrix up0, ud0, uc0, uf0, u0;
	Array TC, XC, UC;
	void diff_eqs(), link_eqs();

	read Ap, Bp, Cp <- "plant";
	read Ad, Bd, Cd <- "uncertainty";
	read Ac, Bc, Cc <- "controller-1";
	read Af, Bf, Cf <- "controller-2";
	read xp0, xd0, xc0, xf0 <- "init-states";
	read up0, ud0, uc0, uf0 <- "init-inputs";

	{x0, state_idx} = VectorConnect({xp0, xd0, xc0, xf0});
	{u0, input_idx} = VectorConnect({up0, ud0, uc0, uf0});

	{TC, XC, UC} = Ode45Auto(0.0, 10.0, x0, diff_eqs, link_eqs);
	plot(TC, XC);
}

Func void diff_eqs(DX, t, X, U)
	Real t;
	Matrix X, DX, U;
{
	Matrix xp, xd, xc, xf;
	Matrix dxp, dxd, dxc, dxf;
	Matrix up, ud, uc, uf;

	{xp, xd, xc, xf} = VectorChop(X, state_idx);
	{up, ud, uc, uf} = VectorChop(U, input_idx);

	dxp = Ap*xp + Bp*up;
	dxd = Ad*xd + Bd*ud;
	dxc = Ac*xc + Bc*uc;
	dxf = Af*xf + Bf*uf;
	DX = [[dxp][dxd][dxc][dxf]];
}

Func void link_eqs(U, t, X)
	Real t;
	Matrix U, X;
{
	Matrix xp, xd, xc, xf;
	Matrix up, ud, uc, uf, u;
	Matrix yp, yd, yc, yf;

	{xp, xd, xc, xf} = VectorChop(X, state_idx);
	u = I(xc);

	yp = Cp * xp;
	yd = Cd * xd;
	yc = Cc * xc;
	yf = Cf * xf;

	up = yc - yf;
	ud = up;
	uc = u;
	uf = yp + yd;
	U = [[up][ud][uc][uf]];
}

