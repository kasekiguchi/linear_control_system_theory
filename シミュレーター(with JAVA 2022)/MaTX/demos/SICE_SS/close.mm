
//
//  ÊÄ¥ë¡¼¥×·Ï¤Î¼þÇÈ¿ô±þÅú (1996.6.4) (1999.11.23) (2001.11.29)
//
//  Gur = (I + KP)~ K
//  Gyr = (I + PK)~

Func void main()
{
	Matrix An,Bn,Cn,Dn;
	Matrix Ac,Bc,Cc,Dc;
	Matrix A1,B1,C1,D1;
	Matrix A2,B2,C2,D2;
	Matrix A3,B3,C3,D3;
	Matrix Ay,By,Cy,Dy;
	Matrix Au,Bu,Cu,Du,z,ii;
	Integer q;
	
	Polynomial s;
	Rational Ws,Wd,alpha;
	Array w,Gws,Gwd,gain_y,gain_u,Pw,res_y,res_u,gc,pc;
	Real gamma_s,gamma_d;
	
	print "\n";

	q = 2;
	do {
		print"Servo controller or not? (servo: q=1, not: q=2)\n\n";
		read q;
	} while (q != 1 && q != 2);

	if (q == 1) {
		read Ac,Bc,Cc,gamma_s,gamma_d <- "K_sv.mx";              
		read Ws,Wd,alpha <- "Wsdal.mx";
		Ws = Ws / alpha;
	} else if (q == 2) {
		read Ac,Bc,Cc,gamma_s,gamma_d <- "K.mx";                        
		read Ws <- "Ws.mx";
		read Wd <- "Wd.mx";     
	}
	
	read An,Bn,Cn <- "plant.mx";
	
	s = Polynomial("s");
	w = logspace(0.001,1000.0);
	
	Dn = Z(Rows(Cn),1);
	Dc = Z(1,Rows(Dn));
	
	z = Z(1);
	ii= I(1);
	
	{A1,B1,C1,D1} = TFmul({An,Bn,Cn,Dn},{Ac,Bc,Cc,Dc});	      // PK
	{A2,B2,C2,D2} = TFadd({z,z,z,ii},{A1,B1,C1,D1});	      // I + PK
	{Ay,By,Cy,Dy} = TFinv({A2,B2,C2,D2});				      // (I + PK)~
	{A1,B1,C1,D1} = TFmul({Ac,Bc,Cc,Dc},{An,Bn,Cn,Dn});		  // KP
	{A2,B2,C2,D2} = TFadd({[0],[0],[0],[1]},{A1,B1,C1,D1});   // I + KP
	{A3,B3,C3,D3} = TFinv({A2,B2,C2,D2});					  // (I + KP)~
	{Au,Bu,Cu,Du} = TFmul({A3,B3,C3,D3},{Ac,Bc,Cc,Dc});		  // (I + KP)~ K

	{Gws,Pw} = bode_tfn(Ws~*gamma_s,w);
	{Gwd,Pw} = bode_tfn(Wd~*gamma_d,w);
	{gain_y,Pw} = bode_ss(Ay,By,Cy,Dy,1,w);
	{gain_u,Pw} = bode_ss(Au,Bu,Cu,Du,1,w);

	res_y = [[Gws][gain_y]];
	res_u = [[Gwd][gain_u]];
	{gc,pc} = bode_ss(Ac,Bc,Cc,[0],1,w);
	
	print "Bodeplot of 1/Ws and Ger\n\n";
	res_y = 20*log10(res_y);
	mgplot_subplot(1,2,1,1);
	mgplot_grid(1,1);
	mgplot_semilogx(1,w,res_y,{"1/Ws","Ger"});

	print "Bodeplot of 1/Wd and Gu\n\n";
	res_u = 20*log10(res_u);
	mgplot_subplot(1,2,1,2);
	mgplot_grid(1,1);
	mgplot_semilogx(1,w,res_u,{"1/Wd","Gur"});
	pause;

	print "Bodeplot of Controller\n\n";
	gc = 20*log10(gc);
	mgplot_title(2,"Bodeplot of Controller");
	mgplot_grid(2,1);
	mgplot_semilogx(2,w,gc,{"Controller"});

	mgplot_reset(1);
	mgplot_reset(2);
	
//	print [[w][res_y][res_u][gc]] >> "seikei.mat";
}




