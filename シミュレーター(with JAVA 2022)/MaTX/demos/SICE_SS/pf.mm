//
//	時間応答の シミュレーション   (1999.11.23) (2001.11.29)
//
Matrix	A,B,C,Ac,Bc,Cc;
Matrix  Ap,Bp,Cp;
Real	r;
Integer	n,pn,cn;			// プラントの次元

Func void main()
{
	void resp();
	resp();
}			

Func void resp()
{	
	Integer k;				// データ数
	Matrix x0;
	Array TC,XC,UC,z0;
	Array res,result;
	Matrix diff_eqs(), link_eqs();
	
	read A,B,C <- "plant.mx";
	read Ap,Bp,Cp <- "jitupla.mx";
	read Ac,Bc,Cc <- "K.mx";                        
	
	n = Cols(A);
	pn = Cols(Ap);
	cn = Cols(Ac);
	x0 = Z(n+pn+2*cn,1);	// 初期状態
	r = 3.0;
	read r;

	{TC, XC, UC} = Ode45Auto(0.0,10.0,x0,diff_eqs,link_eqs,0.04,0.01,EPS,0.01);
	k = Cols(TC);
	z0 = r * ONE(1,k);
	
	res = [[ UC(3:4,:) ]	
		   [ z0	       ]];

	print "\n";
	print "Time response of nominal plant and real plant\n\n";
	mgplot_subplot(1,2,1,1);
	mgplot_grid(1,1);
	mgplot_title(1,"Output");
	mgplot(1,TC,res,{"nominal plant","real plant"});

	print "Input response of nominal plant and real plant\n\n";
	mgplot_subplot(1,2,1,2);
	mgplot_grid(1,1);
	mgplot_title(1,"Input");
	mgplot(1,TC,UC(1:2,:),{"nomial plant","real plant"});
	pause;
	
//	result = [[ TC ]
//			  [ res ]];
//   print result >> "hinf_n.mat";		
}

Func Matrix diff_eqs(t,x,UY)
	Real	t;
	Matrix	x,UY;
{	
	Real 	un,up,yn,yp,en,ep;
	Matrix  dx,dxn,dxp,dxcn,dxcp,xn,xp,xcn,xcp;
	
	un = UY(1,1);
	up = UY(2,1);
	yn = UY(3,1);
	yp = UY(4,1);
	en = yn - r;
	ep = yp - r;
	xn = x(1:n,1);
	xp = x(n+1:n+pn,1);
	xcn = x(n+pn+1:n+pn+cn,1);
	xcp = x(n+pn+cn+1:n+pn+2*cn,1);
	dxn = A * xn + B * un;     	// ノミナルの状態方程式
	dxp = Ap* xp + Bp* up;		// 実プラントの状態方程式
	dxcn = Ac * xcn + Bc * en;  // コントローラの状態方程式
	dxcp = Ac * xcp + Bc * ep;
	dx = [[ dxn ][ dxp ][ dxcn ][ dxcp ]];
	return dx;
}

Func Matrix link_eqs(t,x)
	Real	t;
	Matrix	x;
{
	Matrix	un,up,yn,yp,xn,xp,xcn,xcp,UY;
	
	xn = x(1:n,1);
	xp = x(n+1:n+pn,1);
	xcn = x(n+pn+1:n+pn+cn,1);
	xcp = x(n+pn+cn+1:n+pn+2*cn,1);
	un = Cc*xcn;			// feedback law(nominal)
	up = Cc*xcp;			// feedback law(real)
	yn = C * xn;
	yp = Cp * xp;
	UY = [ [un]',[up]',[yn]',[yp]']';
	return UY;
}
