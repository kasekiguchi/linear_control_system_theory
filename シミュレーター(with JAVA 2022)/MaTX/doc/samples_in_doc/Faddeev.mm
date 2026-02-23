Func void main()
{
	Matrix A, B, C, D, G;
	Matrix Faddeev();

	read A, B, C, D;
	G = Faddeev(A, B, C, D);
	print G;
}

Func Matrix Faddeev(A, B, C, D)
	Matrix	A, B, C, D;
{
	Matrix	Gamma, NUM, tmp, G;
	Polynomial s, den;
	Integer	i, n;

	s = $;
	n = Rows(A);
	Gamma = Z(n, 1, A);
	den = Polynomial(Z(1, n+1));

	den(n) = 1.0;

	Gamma(n-1, 0, A) = I(n);
	den(n-1) = - trace(A);

	for (i = n-2; i >= 0; i--) {
		Gamma(i, 0, A) = A*Gamma(i+1, 0, A) + den(i+1)*I(n);
		den(i) = - trace(A*Gamma(i, 0, A)) / (n - i);
	}

	NUM = D * s^n;
	for (i = 0; i < n; i++) {
		tmp = C*Gamma(i, 0, A)*B + den(i)*D;
		NUM = NUM + tmp * s^i;
	}

	G = NUM / den;
	return G;
}


