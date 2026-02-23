//
//  混合感度問題  (1996.6.7) (1999.11.23) (2001.11.29)
//
Func void main()
{
	Matrix A,B1,B2,C1,C2,D11,D12,D21,D22,An,Bn,Cn,Dn;
	Matrix As,Bs,Cs,Ds,Ad,Bd,Cd,Dd,Ak,Bk,Ck,Dk,Atmp,Btmp,Ctmp;
	Matrix G,K,Ac,Bc,Cc,Aal,Bal,Cal,Dal;
	Integer p,q,r,m,n,ii,Case;
	Rational Ws,Wd,alpha;
	Real gamma_s,gamma_d;

	print "\n";
	
	gamma_s = 1.0;
	gamma_d = 1.0;

	read An,Bn,Cn <- "plant.mx";
	Dn = Z(Rows(Cn),Cols(Bn));

	ii = 2;
	do {
        print "Servo controller or not? (servo: ii=1, not: ii=2)\n\n";
        read ii;
	} while (ii != 1 && ii != 2);

	print "\n";

	if (ii == 1) {
		Case = 1;
		do {
			print "Case 1  or Case 2?\n\n";
			read Case;
		} while (Case != 1 && Case != 2);

		if (Case == 1) {
			read Ws,Wd,alpha <- "Wsdal.mx";
		} else {
			read Ws,Wd,alpha <- "Wsdal2.mx";
		}
		
		{As,Bs,Cs,Ds} = tfn2ss(Ws);
		{Ad,Bd,Cd,Dd} = tfn2ss(Wd);
		{Aal,Bal,Cal,Dal} = tfn2ss(alpha~);
		
		n = Cols(An);
		p = Cols(As);
		q = Cols(Ad);
		r = Cols(Aal);
		
		Cs = Cs / gamma_s;
		Ds = Ds / gamma_s;
		Cd = Cd / gamma_d;
		Dd = Dd / gamma_d;
		
		A = diag(An,As,Ad,Aal);
		A(n+1:n+p,1:n) = Bs*Dal*Cn;
		A(n+1:n+p,n+p+q+1:n+p+q+r) = Bs*Cal;
		A(n+p+q+1:n+p+q+r,1:n) = Bal*Cn;
		
		B1 = Z(n+p+q+r,1);
		B1(n+1:n+p,1) = -Bs*Dal;
		B1(n+p+q+1:n+p+q+r,1) = -Bal;
		
		B2 = [[     Bn ]
			  [ Bs*Dal*Dn ]
			  [     Bd ]
			  [ Bal*Dn ]];
		
		C1 = Z(2,n+p+q+r);
		C1(1,1:n) = Ds*Dal*Cn;
		C1(1,n+1:n+p) = Cs;
		C1(1,n+p+q+1:n+p+q+r) = Ds*Cal;
		C1(2,n+p+1:n+p+q) = Cd;
		
		C2 = [[ Dal*Cn , Z(1,p), Z(1,q), Cal ]];
		D11 = [[ -Ds*Dal ]
			   [   0 ]];
		D12 = [[ Ds*Dal*Dn ]
			   [  Dd ]];
		D21 = [[ -Dal ]];
		D22 = Dal*Dn;
		
		G = [[  A,  B1,  B2 ]
			 [ C1, D11, D12 ]
			 [ C2, D21, D22 ]];

		K = hinf(G,n+p+q+r,Cols(B1),Rows(C1),1.0);

		Atmp = K(1:n+p+q+r,1:n+p+q+r);
		Btmp = K(1:n+p+q+r,n+p+q+r+1:n+p+q+r+1);
		Ctmp = K(n+p+q+r+1,1:n+p+q+r);
		
		Ac = [[ Atmp, Btmp*Cal ]
			  [ Z(Rows(Aal),Cols(Atmp)), Aal ]];
		Bc = [[ Btmp*Dal ]
			  [ Bal ]];
		Cc = [[ Ctmp , Z(1,Cols(Aal))]];
		{Ak,Bk,Ck,Dk} = minreal(Ac,Bc,Cc,Z(Rows(Cc),Cols(Bc)));
		
		print "\nController's eigenvalue are ...\n\n";
		print eigval(Ac);
		if (Case == 1) {
			print Ak,Bk,Ck,gamma_s,gamma_d -> "K_sv.mx";
		} else if (Case == 2) {
			print Ak,Bk,Ck,gamma_s,gamma_d -> "K_sv2.mx";
		}
	} else {
		Case = 1;
		do {
			print "Case 1 or Case 2?\n\n";
			read Case;
		} while (Case != 1 && Case != 2);

		if (Case == 1) {
			read Ws <- "Ws.mx";
			read Wd <- "Wd.mx";     
		} else {
			read Ws <- "Ws2.mx";
			read Wd <- "Wd2.mx";
		}
		
//      read gamma_s;
//      read gamma_d;
		
		{As,Bs,Cs,Ds} = tfn2ss(Ws);
		{Ad,Bd,Cd,Dd} = tfn2ss(Wd);
		
		n = Cols(An);
		p = Cols(As);
		q = Cols(Ad);
		
		Cs = Cs / gamma_s;
		Ds = Ds / gamma_s;
		Cd = Cd / gamma_d;
		Dd = Dd / gamma_d;
		
		A = diag(An,As,Ad);
		A(n+1:n+p,1) = Bs;
		
		B1 = Z(n+p+q,1);
		B1(n+1:n+p,1) = -Bs;
		B2 = [[     Bn ]
			  [ Z(p,1) ]
			  [     Bd ]];
		
		C1 = Z(2,n+p+q);
		C1(1,1) = Ds(1,1);
		C1(1,2+1:2+p) = Cs;
		C1(2,2+p+1:2+p+q) = Cd;
		
		C2 = [[ Cn, Z(Rows(Cn),p), Z(Rows(Cn),q) ]];
		D11 = [[ -Ds ]
			   [   0 ]];
		D12 = [[   0 ]
			   [  Dd ]];
		D21 = [[ -1 ]];
		D22 = Z(1);
		
		G = [[  A,  B1,  B2 ]
			 [ C1, D11, D12 ]
			 [ C2, D21, D22 ]];

		K = hinf(G,n+p+q,Cols(B1),Rows(C1),1.0);
		Ac = K(1:n+p+q,1:n+p+q);
		Bc = K(1:n+p+q,n+p+q+1:n+p+q+1);
		Cc = K(n+p+q+1,1:n+p+q);

		if (Case == 1) {
			print Ac,Bc,Cc,gamma_s,gamma_d -> "K.mx";
		} else {
			print Ac,Bc,Cc,gamma_s,gamma_d -> "K2.mx";
		}	   
	}
}
