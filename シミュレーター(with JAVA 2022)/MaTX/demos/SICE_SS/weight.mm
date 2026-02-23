
//
//	周波数応答 (1996.6.4) (1999.11.23) (2001.11.29)
//
Func void main()
{
	Array w;
	Array Gw1,Pw1,Gw2,Pw2,GG,Gw,Gw1inv,Gw2inv,g_delta,ph_n;
	Matrix Ap,Bp,Cp,An,Bn,Cn;
	Matrix del_a,del_b,del_c,del_d;

	Matrix result,z;
	Array gain,gain1,gain2,gain3;
	Array ph_p,gain_n,gain_p;
	Integer	n1,n2,Case;
	Polynomial s;

	List weight_set1(), weight_set2();
	
	s = Polynomial("s");
	w = logspace(0.001,1000.0);
	read An,Bn,Cn <- "plant.mx";
	Case = 1;

	print "\n";

	do {
		print"Case 1 or Case 2 ? \n\n";
		read Case;
	} while (Case != 1 && Case != 2);

	print "\n";

	if (Case == 1) {
		read Ap,Bp,Cp <- "jitupla.mx";
		{Gw1,Gw2,Gw1inv,Gw2inv} = weight_set1(Ap,Bp,Cp,An,Bn,Cn);
		print "Case 1 \n\n";
	} else {
		read Ap,Bp,Cp <- "jitu2.mx";
		{Gw1,Gw2,Gw1inv,Gw2inv} = weight_set2(Ap,Bp,Cp,An,Bn,Cn);
		print "Case 2 \n\n";
	}      

	{del_a,del_b,del_c} = TFsub({Ap,Bp,Cp,[0]},{An,Bn,Cn,[0]});
	n1 = Rows(Cn);
	n2 = Rows(Cp);
	z = Z(n1,1);
	{gain_n,ph_n} = bode_ss(An,Bn,Cn,z,1,w);	
	z = Z(n2,1);
	{gain_p,ph_p} = bode_ss(Ap,Bp,Cp,z,1,w);
	{g_delta,ph_n} = bode_ss(del_a,del_b,del_c,z,1,w);
	
	print "1/Ws(red) and 1/Wd(green)\n\n";
	Gw = [[ Gw1inv ][ Gw2inv ]];
	Gw = 20*log10(Gw);
	mgplot_grid(1,1);
	mgplot_semilogx(1,w,Gw,{"1/Ws","1/Wd"});
	pause;
	
	print "Nominal(red) and real plant(green)\n\n";
	gain = [[ gain_n ][ gain_p ]];
	gain = 20*log10(gain);
	mgplot_subplot(2,2,1,1);
	mgplot_grid(2,1);
	mgplot_semilogx(2,w,gain,{"nominal", "plant"});
	
	print "Delta(red) and Wd(green)\n\n";
	gain2 = [[ g_delta ][ Gw1 ]];
	gain2 = 20*log10(gain2);
	mgplot_subplot(2,2,1,2);
	mgplot_grid(2,1);
	mgplot_semilogx(2,w,gain2,{"Delta", "Wd"});

	mgplot_reset(1);
	mgplot_reset(2);
	
//   result = [[ w ][ Gw ][ gain ][ gain2 ]];
//   print result >> "gain_w.mat";	
}

//
//  重みの設定 1 (1996.6.4) (1999.11.23)
//
Func List weight_set1(Ap,Bp,Cp,An,Bn,Cn)
	Matrix Ap,Bp,Cp,An,Bn,Cn;
{	
	Polynomial	s;
	Rational Wd,Ws,alpha,Ws2;
	Matrix 	ad,bd,cd,dd;
	Integer q;
	Array w,Gw1,Pw1,Gw2,Pw2,Gw1inv,Gw2inv;

	print "\n";

	s = Polynomial("s");
	w = logspace(0.001,1000.0);

	q = 2;
	do {
		print "Servo controller or not? (servo: q=1, not: q=2)\n\n";
		read q;
	} while (q != 1 && q != 2);

	print "\n";

	Wd = 1.4*(s)^2 / (1.0 + 7.0*s)^2;      // Wd of Case1

	if (q == 1) {
		Ws2 = 1.0 / (s+0.001);
		alpha = s / (s+0.001);
		print alpha, Ws2, Wd;
		print Ws2, Wd, alpha -> "Wsdal.mx";
		Ws = Ws2 / alpha;
	} else if (q == 2) {
		Ws = 1.0 / ( s + 0.01 );
		print Wd -> "Wd.mx";
		print Ws -> "Ws.mx";		
		print Ws, Wd;
	}

	{Gw1,Pw1} = bode_tfn(Wd,w);
	{Gw2,Pw2} = bode_tfn(Ws,w);
	{Gw1inv,Pw2} = bode_tfn(Ws~,w);
	{Gw2inv,Pw1} = bode_tfn(Wd~,w);

	return {Gw1,Gw2,Gw1inv,Gw2inv};
}

//
//  重みの設定 2  (1996.6.4) (1999.11.23)
//
Func List weight_set2(Ap,Bp,Cp,An,Bn,Cn)
	Matrix Ap,Bp,Cp,An,Bn,Cn;
{	
	Polynomial s;
	Rational Wd,Ws,alpha,Ws2;
	Matrix ad,bd,cd,dd;
	Real T,Kd,Ks;
	Integer q,yorno;

	Array w,Gw1,Pw1,Gw2,Pw2,Gw1inv,Gw2inv;
	Array g_delta,ph_n,gain2;
	Matrix del_a,del_b,del_c,del_d;

	print "\n";

	s = Polynomial("s");
	w = logspace(0.001,1000.0);
	
	T = 7.0;
	Kd = 1.4;
	Ks = 1.0;
	q = 2;
	do {
		print "Servo controller or not? (servo: q=1, not: q=2)\n\n";
		read q;
	} while (q != 1 && q != 2);

	print "\n";
	
	do {
		read T, Kd, Ks;
		Wd = Kd*(s)^2 / (1.0 + T*s)^2;    // Wd of Case2
		
		if (q == 1) {
			Ws2 = Ks / (s + 0.001);
			alpha = s / (s + 0.001);
			print Ws2, Wd, alpha -> "Wsdal2.mx";
			print alpha, Ws2, Wd;
			Ws = Ws2 / alpha;
		} else if (q == 2) {
			Ws = Ks / ( s + 0.01 );
			print Wd -> "Wd2.mx";
			print Ws -> "Ws2.mx";		
			print Ws, Wd;
		}
		
		{Gw1,Pw1} = bode_tfn(Wd,w);
		{Gw2,Pw2} = bode_tfn(Ws,w);
		{Gw2inv,Pw1} = bode_tfn(Wd~,w);
		{Gw1inv,Pw2} = bode_tfn(Ws~,w);
		{del_a,del_b,del_c,del_d} = TFsub({Ap,Bp,Cp,[0]},{An,Bn,Cn,[0]});
		{g_delta,ph_n} = bode_ss(del_a,del_b,del_c,del_d,1,w);

		gain2 = [[ g_delta ][ Gw1 ]];
		gain2 = 20*log10(gain2);
		print "Delta and Wd\n\n";
		mgplot_grid(1,1);
		mgplot_semilogx(1, w, gain2, {"Delta", "Wd"});

		do {
			print "Is Wd ok? (yes: 1 or no:2)\n";
			yorno = 1;
			read yorno;
		} while (yorno != 1 && yorno != 2);
	} while (yorno != 1);

	return {Gw1,Gw2,Gw1inv,Gw2inv};
}


