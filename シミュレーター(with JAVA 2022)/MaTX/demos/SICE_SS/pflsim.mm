//
//	時間応答の シミュレーション  (1996.6.6) (1999.11.23) (2001.11.29)
// 	with lsim

Func void main()
{
	void resp();
	resp();
}			

Func void resp()
{	
	Matrix A,B,C,D,Ac,Bc,Cc,An,Bn,Cn1,Dn1,Cn2,Dn2;
	Matrix Ap,Bp,Cp,Dp,Aj,Bj,Cj1,Dj1,Cj2,Dj2;
	Real r,hour;
	Integer	n,pn,cn;			

	Integer k,ii,Case,para_save;
	Matrix x0;
	Array TC,XC,UC,z0,Yn,Un,Yj,Uj;
	Array res,result,r_array,T,data;
	Real dt;

	print "\n";
	
	hour = 20.0;
	ii = 2;
	Case = 1;
	do {
		print"Is real plant Case 1 or Case 2?\n\n";
		read Case;
	} while (Case != 1 && Case != 2);

	if (Case == 1) {
		read Ap,Bp,Cp <- "jitupla.mx";
		para_save = 1;
	} else {
		read Ap,Bp,Cp <- "jitu2.mx";
		para_save = 2;
	}      

	print "\n";
	
	do {
		print"Servo controller or not? (servo: ii=1, not: ii=2)\n\n";
		read ii;
	} while (ii != 1 && ii != 2);
	do {
		print"Controller is for Case1 or not?\n\n";
		read Case;
	} while (Case != 1 && Case != 2);
	
	if (ii == 2) {
		if (Case == 1) {
			read Ac,Bc,Cc <- "K.mx";                        
		} else {
			read Ac,Bc,Cc <- "K2.mx";                        
		}
	}
	if (ii == 1) {
		if (Case == 1) {
			read Ac,Bc,Cc <- "K_sv.mx";                        
		} else {
			read Ac,Bc,Cc <- "K_sv2.mx";
		}
	}
	read A,B,C <- "plant.mx";
	D = Z(Rows(C),Cols(B));
	Dp= Z(Rows(Cp),Cols(Bp));
	
	n = Cols(A);
	pn = Cols(Ap);
	cn = Cols(Ac);
	x0 = Z(n+pn+2*cn,1);		// 初期状態
	r = 3.0;
//   read r;
	dt = 0.1;
	T = [0:hour/dt]*dt;
	r_array = r * ONE(T);
	
	An = [[ A ,   B*Cc ]
		  [ Bc*C, Ac+Bc*D*Cc ]];
	Bn = [[ Z(Rows(A),1) ]
		  [ -Bc ]];
	Cn1= [[ C , D*Cc ]];
	Dn1= Z(Rows(C),1);
	Cn2= [[ Z(1,Cols(C)), Cc ]];
	Dn2= Z(1);
	
	Aj = [[ Ap ,   Bp*Cc ]
		  [ Bc*Cp, Ac+Bc*Dp*Cc ]];
	Bj = [[ Z(Rows(Ap),1) ]
		  [ -Bc ]];
	Cj1= [[ Cp , Dp*Cc ]];
	Dj1= Z(Rows(Cp),1);
	Cj2= [[ Z(1,Cols(Cp)), Cc ]];
	Dj2= Z(1);
	
	{An,Bn} = c2d(An,Bn,dt);
	{Aj,Bj} = c2d(Aj,Bj,dt);
	
	{Yn} = dlsim(An,Bn,Cn1,Dn1,r_array);
	{Un} = dlsim(An,Bn,Cn2,Dn2,r_array);
	{Yj} = dlsim(Aj,Bj,Cj1,Dj1,r_array);
	{Uj} = dlsim(Aj,Bj,Cj2,Dj2,r_array);

	print "\n";

	print "Time response of nominal plant, real plant, and reference.\n\n";
	mgplot_subplot(1,2,1,1);
	mgplot_title(1,"Output");
	mgplot_grid(1,1);
	mgplot(1,T,[[Yn][Yj][r_array]],{"nominal plant","real plant","reference"});
	
	print"Input to nominal plant and real plant.\n\n";
	mgplot_subplot(1,2,1,2);
	mgplot_grid(1,1);
	mgplot_title(1,"Input");
	mgplot(1,T,[[Un][Uj]],{"nominal plant","real plant"});
	pause;

	mgplot_reset(1);

	data = [[ T ][ Yn ][ Yj ][ Un ][ Uj ][ r_array ]];
	if (para_save == 1) {
		if (Case == 1) {
			if (ii == 1) {
				print data >> "data_11s.mat";
			} else {
				print data >> "data_11.mat";
			}
		} else {
			if (ii == 1) {
				print data >> "data_12s.mat";
			} else {
				print data >> "data_12.mat";
			}
		}
	} else {
		if (Case == 1) {
			if (ii == 1) {
				print data >> "data_21s.mat";
			} else {
				print data >> "data_21.mat";
			}
		} else {
			if (ii == 1) {
				print data >> "data_22s.mat";
			} else {
				print data >> "data_22.mat";
			}
		}
	}
}


