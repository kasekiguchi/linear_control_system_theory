Func void main()
{
	Matrix A, B, Q, R, P;
	Matrix CRiccati();

	read A, B, Q, R;
	P = CRiccati(A, B, Q, R);
	print P;
}

Func Matrix CRiccati(A, B, Q, R)
	Matrix A, B, Q, R;
{
	Matrix H, U, V, T, P;

	H = [[ A, -B*R~*B#]
         [-Q, -A#     ]];

	T = eigvec(H);
	U = T(0, 1, A);
	V = T(1, 1, A);

	P = V * U~;

	if (isreal(A) && isreal(B) && isreal(Q) && isreal(R)) {
		P = Re(P);
	} else {
		P = (P# + P)/2;
	}
	return P;
}

