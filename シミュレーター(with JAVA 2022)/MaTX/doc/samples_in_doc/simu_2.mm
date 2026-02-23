Func void main()
{
	Integer i, ii;
	Real dt, t, t1, t2;
	Matrix x, u, controller();
	Array X, U;
	void plant();

	t1 = 0.0;
	t2 = 5.0;
	dt = 0.01;
	ii = Integer((t2 - t1)/dt);

	x = [1 1 1]';
	u = [0];

	X = Z(1, ii, x);
	U = Z(1, ii, u);

	t = t1;
	X(0, 0, x) = x;

	for (i = 1; i < ii; i++) {
		u = controller(t, x);
		x = rngkut4(t, x, plant, u, dt);

		U(0, i-1, u) = u;
		X(0, i, x) = x;
		t = t + dt;
	}
	u = controller(t, x);
	U(0, ii-1, u) = u;
	
	plot(X);
	plot(U);
}

Func void plant(dx, t, x, u)
    Real t;
    Matrix x, dx, u;
{
  Matrix A, b;
                      /* System matrix   */
  A = [[ 0   1   0]
       [ 0   0   1]
       [-2, -3, -4]];

  b = [0 0 1]';      /* Input matrix    */

  dx = A*x + b*u;    /* System equation */
}

Func Matrix controller(t, x)
  Real t;
  Matrix x;
{
  Matrix u, f;

  f = [-1, -1, -1];  /* State feedback control-law */
  u = f * x;
  return u;
}

