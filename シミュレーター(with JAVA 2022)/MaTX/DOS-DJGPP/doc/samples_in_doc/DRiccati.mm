Func void main()
{
	Matrix A, B, C, Q, R, P, PP;
	Matrix DRiccati();

	A = [[0 1][-3, 4]];
	B = [0 1]';
	C = [-2 1];
	Q = C'*C;
	R = [1];

	P = DRiccati(A, B, Q, R);
	print P;
}

Func Matrix DRiccati(A, B, Q, R)
	Matrix A, B, Q, R;
{
	Matrix P, PP;
	Real eps;

	PP = Z(A);
	P = I(A);
	eps = 1.0E-7;

	while (frobnorm(P - PP) > eps) {
		PP = P;
		P = Q + A'*P*A - A'*P*B*(R + B'*P*B)~ * B'*P*A;
		P = (P' + P)/2;
	}
	return P;
}

