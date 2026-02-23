Func void main()
{
  Real dt;
  Matrix x0;
  Array TC, XC, UC, TH, XH, UH;
  void diff_eqs(), link_eqs();

  dt = 0.1;

  x0 = [1 1 1]';
  {TC, XC, UC} = Ode45Auto(0.0, 5.0, x0, diff_eqs, link_eqs);
  x0 = [1 1 1]';
  {TH, XH, UH} = Ode45HybridAuto(0.0, 5.0, dt, x0, diff_eqs, link_eqs);

  plot(TC, XC);
  plot(TH, XH);
}

Func void diff_eqs(dx, t, x, u)
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

Func void link_eqs(u, t, x)
  Real t;
  Matrix u, x;
{
  Matrix f;

  f = [-1, -1, -1];  /* State feedback control-law */
  u = f * x;
}

