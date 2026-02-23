
/*  -*- MaTX -*-
 *
 *      Program for Simulation and Experiment of Mini-Pendulum
 *
 *  Control Law: u = -f1*(ref-x1) - f2*x2 - f3*x3h - f4*x4h
 *
 *     x1: Position of cart[m],  x3h: Velocity of cart[m/s]
 *     x2: Angle of pend.[rad],  x4h: Ang. Velocity of pend[rad/s]
 *     ref: Reference of position of cart[m]
 *
 *  Initial point of cart:     x1 = 0
 *  Initial point of pendulum: x2 = -PI
 *
 */

#define LOGMAX 1000

Real a32, a33, a34, a35, a42, a43, a44, a45, b3, b4, cc1, cc2, alpha;
Matrix A, B, C, D, Q, R;
Matrix u, y, z, xh;
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
Matrix Ahd_off, Bhd_off, Chd_off, Dhd_off, Jhd_off, F_off;
CoMatrix observer_poles;
Array log_data, TT_old, UY_old;
Real ref, smtime, step_height;
Integer cmd, log_flag, log_count, lc, mlc, design_flag;
Integer any_graph, any_graph2, parameter_update, ident_flag;

// Variables for sensor and actuator
// These variables are used in the file 'hardware.mm'
Matrix mp_data, PtoMR;

// Main function
Func void main()
{
	List main_menu;
	void set_parameter_pend(...), design_pend(), analysis_pend();
	void simulation_pend();
	void show_graph_pend(), modelling_ident_pend(), experiment();

	main_menu = {"< Control of Mini-Pendulum >",
				 "Modelling and Identification",
				 "Analysis of Plant",
				 "Design of Controller",
				 "Simulation of Control System",
				 "Experiment",
				 "Show Graph",
				 "Quit"};

	any_graph = 0;
	ident_flag = 0;
	mgplot();			// load "mgplot.mm"
	set_parameter_pend();

	while (1) {
		switch (menu(main_menu)) {
		  case 1: modelling_ident_pend(); break;
		  case 2: analysis_pend(); break;
		  case 3: design_pend(); break;
		  case 4: simulation_pend(); break;
		  case 5: experiment(); break;
		  case 6: show_graph_pend(); break;
		  case 7: return;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
//  MODELLING AND IDENTIFICATION
/////////////////////////////////////////////////////////////////////////////

Func void modelling_ident_pend()
{
	Integer ii;
	List ident_menu;
	void ident_cart(), ident_pendulum();
	void print_nonlinear_pend(), print_linear_pend();

	ident_menu = {"< Modelling and Identification >",
				  "Mass and friction coefficient of cart",
				  "Inertia and friction coefficient of pendulum",
				  "Print state equation and output equation",
				  "Quit"};
	
	while (1) {
		ii = menu(ident_menu);
		switch (ii) {
		  case 1: ident_cart(1); break;
		  case 2: ident_pendulum(); break;
		  case 3: print_nonlinear_pend(); print_linear_pend(); break;
		  case 4: return;
		  default: return;
	   }
	}
}

// Set plant parameters
Func void set_parameter_pend(flag, para1, para2, ...)
	Integer flag;
	Real para1, para2;
{
	Real m1, m2, Fr, Cr, l, J, a0, g, alpha0;

	if (nargs != 0 && nargs != 3) {
		warning("set_parameter_pend(): Incorrect number of arguments\n");
		return;
	}

	design_flag = 0;

	m1 = 0.16;
	m2 = 0.039;
	Fr = 2.6;
	Cr = 4.210e-4;
	l  = 0.121;
	J  = 4.485e-4;
	a0 = 0.1;
	g  = 9.8;

	// Identified parameters
	if (nargs == 3) {
		if (flag == 1) {
			m1 = para1;
			Fr = para2;
		} else if (flag == 2) {
			J = para1;
			Cr = para2;
		}
	}

	alpha0 = (m1 + m2)*J + m1*m2*l^2;
	alpha = m2^2*l^2/alpha0;

	a32 = -(m2*l)^2*g;
	a33 = -Fr*(J + m2*l^2);
	a34 = m2*l*Cr;
	a35 = (J + m2*l^2)*m2*l;
	a42 = (m1 + m2)*m2*l*g;
	a43 = m2*l*Fr;
	a44 = -(m1 + m2)*Cr;
	a45 = -(m2*l)^2;
	b3  = (J + m2*l^2)*a0;
	b4  = -m2*l*a0;

	a32 = a32/alpha0;
	a33 = a33/alpha0;
	a34 = a34/alpha0;
	a35 = a35/alpha0;
	a42 = a42/alpha0;
	a43 = a43/alpha0;
	a44 = a44/alpha0;
	a45 = a45/alpha0;
	b3  = b3/alpha0;
	b4  = b4/alpha0;

	cc1 = 1.0;
	cc2 = 1.0;

	A = [[0  0   1   0 ]
		 [0  0   0   1 ]
		 [0 a32 a33 a34]
		 [0 a42 a43 a44]];

	B = [[ 0]
		 [ 0]
		 [b3]
		 [b4]];

	C = [[cc1 0 0 0]
		 [0 cc2 0 0]];

	D = [[0]
		 [0]];
}

Func void print_nonlinear_pend()
{
	clear;
	print "\n";
	print "     < Nonlinear State Equation and Output Equation of Pendulum >\n\n\n";
	print "(State vector)                        (Output vector)\n\n";
	print "      [x1]   [         r [m]     ]    y := [y1] = [  cc1*r  ]\n";
	print " x := [x2] = [     theta [rad]   ]         [y2]   [cc2*theta]\n";
	print "      [x3]   [     dr/dt [m/s]   ]\n";
	print "      [x4]   [ dtheta/dt [rad/s] ]\n";
	print "\n\n";
	print "         [                              x3                             ]\n";
	print " dx/dt = [                              x4                             ]\n";
	print "         [   (a32*s2*c2 + a33*x3 + a34*c2*x4 + a35*s2*x4^2 + b3*u)/beta]\n";
	print "         [(a42*s2 + a43*c2*x3 + a44*x4 + a43*s2*c2*x4^2 + b4*c2*u)/beta]\n";
	print "\n";
	print "     y = [ cc1  cc2   0   0 ] x\n\n";
	print "  beta := 1 + alpha*s2^2,  s2 := sin(x2),  c2 := cos(x2)\n";
	print "\n\n";
	pause;

	clear;
	print "\n";
	print "      < Coefficients of Equations and Phisical Parameters >\n\n\n";
	print " [a32 a33 a34 a35 b3] = \n";
	print " [a42 a43 a44 a45 b4]\n\n";
	print "        [ -(m*l)^2*g -F*(J+m*l^2)   c*m*l  (J+m*l^2)*m*l (J+m*l^2)*a]\n";
	print "        [(M+m)*m*l*g    F*m*l     -(M+m)*c    -(m*l)^2     -(m*l)a  ] / alpah0\n\n";
	print "         alpha0 = (M + m)*J + M*m*l^2\n\n";

	printf(" [a32 a33 a34 a35 b4] = [% 8.4g % 8.4g % 8.4g % 8.4g % 8.4g ]\n", a32, a33, a34, a35, b3);
	printf(" [a42 a43 a44 a45 b4]   [% 8.4g % 8.4g % 8.4g % 8.4g % 8.4g ]\n", a42, a43, a44, a45, b4);
	print "\n";
	pause;
}

Func void print_linear_pend()
{
	clear;
	print "\n";

	print "     <Linear State Equation and Output Equation of Pendulum >\n\n\n";
	print "(State vector)                      (Output vector)\n\n";
	print "      [x1]   [         r [m]     ]    y := [y1] = [  cc1*r  ]\n";
	print " x := [x2] = [     theta [rad]   ]         [y2]   [cc2*theta]\n";
	print "      [x3]   [     dr/dt [m/s]   ]\n";
	print "      [x4]   [ dtheta/dt [rad/s] ]\n";
	print "\n";

	print "State equation:\n\n";
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, 0.0, 1.0, 0.0, 0.0);
	printf(" dx/dt = [% 8.4g % 8.4g % 8.4g % 8.4g ] x  +  [% 8.4g ] u\n",
		   0.0, 0.0, 0.0, 1.0, 0.0);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, a32, a33, a34, b3);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, a42, a43, a44, b4);
	print "\n";
	print "Output equation:\n\n";
	printf("     y = [% 8.4g % 8.4g % 8.4g % 8.4g ] x\n",
		   cc1, 0.0, 0.0, 0.0);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]\n",
		   0.0, cc2, 0.0, 0.0);
	print "\n";
	pause;
}

// Identification of cart
Func void ident_cart(for_pend)
	Integer for_pend;
{
	Integer end_i, nn, nn2, yes_no;
	Real end_time, dt, K, T, a0, m1, Fr;
	Array TT, RR, RRR, TT2, RR2;

	void experiment(), verify_ident_cart();
	void set_parameter_pend(...);

	smtime = 0.002;
	print "Sampling interval [s] : ";
	read smtime;
	step_height = 7.0;
	print "Height of step input [N] : ";
	read step_height;

	ident_flag = 1;
	experiment();
	ident_flag = 0;

	if (log_count == 0 || max(abs(log_data(2,1:log_count))) < 1.0E-3) {
		warning("\n\nNo data was measured.\n\n");
		pause;
		return;
	}

	TT = [0:log_count-1]*smtime*mlc;
	RR = log_data(2,1:log_count);

	mgplot_grid(5, 1);
	mgplot_xlabel(5, "time[sec]");
	mgplot_ylabel(5, "position[m]");
	mgplot_title(5, "Position of cart");
	mgplot(5, TT, RR, {"position"});
	pause;
	mgplot_reset(5);

	end_time = 0.4;
	if (max(TT) < end_time) {
		end_time = max(TT);
	}
	print "Spesify the end of time for identification\n";
	read end_time;
	end_i   = max(find(TT <= end_time));
	TT = TT(1:end_i);
	RR = RR(1:end_i);
	nn = Cols(TT);
	RRR = RR(nn/2:nn);	// the last half data
	nn2 = Cols(RRR);
	dt = TT(2) - TT(1);
	K = mean(RRR(2:nn2) - RRR(1:nn2-1))/dt/step_height;
	T = TT(nn) - (RRR(nn2)/(K*step_height));

	TT2 = linspace(T,TT(nn),nn);
	RR2 = (TT2 - T*ONE(TT2))*K*step_height;

	mgplot_grid(5, 1);
	mgplot_xlabel(5, "time[sec]");
	mgplot_ylabel(5, "position[m]");
	mgplot_title(5, "Position of cart");
	mgplot(5, TT, RR, {"position"});
	mgreplot(5, TT2, RR2, {""});
	pause;
	mgplot_reset(5);

	a0 = 0.1;	// known

	Fr = a0/K;
	m1 = T*Fr;

	printf("Transfer function of cart is assumed to be  K/(s*(T*s + 1))\n\n");
	printf("Gain :                    K = %16.8E (identified)\n", K);
	printf("Time constant :           T = %16.8E (identified)\n", T);
	printf("Torqe/Volt coefficient : a0 = %16.8E (known)\n\n", a0);
	printf("Fr = a0/K\n");
	printf("m1 = T*Fr\n\n");
	printf("Mass of cart :                 m1 = %16.8E\n", m1);
	printf("Friction coefficient of cart : Fr = %16.8E\n\n", Fr);
	pause;
	
	verify_ident_cart(TT, RR, m1, Fr);

	yes_no = 1;
	print "Do you accept the parameters ? [Yes=1,No=0] : ";
	read yes_no;
	if (yes_no == 1) {
		if (for_pend) {
			set_parameter_pend(1, m1, Fr);
		}
//		else {
//			set_parameter_cart(m1, Fr);
//		}
	}
}

Func void verify_ident_cart(TT, RR, m1, Fr)
	Array TT, RR;
	Real m1, Fr;
{
	Real a0, K, T, dt;
	Matrix A, B, C, D, x0;
	Array RR2;

	a0 = 0.1;
	K = a0/Fr;
	T = m1/Fr;

	A = [[0,     1]
	     [0,  -1/T]];
	B = [0 K/T]' * step_height;
	C = [1 0];
	D = [0];

	{RR2} = step(A,B,C,D,1,TT);

	mgplot_grid(7, 1);
	mgplot_xlabel(7, "time[s]");
	mgplot_ylabel(7, "position[m]");
	mgplot_title(7, "Measured data and simulation result of the identified linear model");
	mgplot(7, TT, [[RR][RR2]], {"measured data", "identified linear model"});
	pause;
	mgplot_reset(7);
}

// Identification of pendulum
Func void ident_pendulum()
{
	Real m2, l, g, lambda, tau, J, Cr;

	Integer i, start_i, end_i, mm, pp, yes_no;
	Real start_time, end_time;
	Array TT, TH, peak_value, peak_ratio;
	Index idx, peak_idx;

	void experiment(), verify_ident_pendulum();
	void set_parameter_pend(...);
	Index find_peak();

	smtime = 0.002;
	print "Sampling interval [s] : ";
	read smtime;

	ident_flag = 2;
	experiment();
	ident_flag = 0;

	if (log_count == 0 || max(abs(log_data(3,1:log_count))) < 1.0E-3) {
		warning("\n\nNo data was measured.\n\n");
		pause;
		return;
	}

	TT = [0:log_count-1]*smtime*mlc;
	TH = log_data(3,1:log_count);
	TH = TH + PI*ONE(TH);

	mgplot_grid(5, 1);
	mgplot_xlabel(5, "time[sec]");
	mgplot_ylabel(5, "theta[deg]");
	mgplot_title(5, "Angle of pendulum");
	mgplot(5, TT, TH/PI*180, {"theta"});

	start_time = 0.85;
	end_time = 5.5;
	if (max(TT) < end_time) {
		end_time = max(TT);
	}

	print "Spesify the range of time for identification\n";
	read start_time, end_time;
	start_i = min(find(start_time <= TT));
	end_i   = max(find(TT <= end_time));
	TT = TT(start_i:end_i);
	TH = TH(start_i:end_i);
	mm = Cols(TT);

	mgreplot(5, TT, TH/PI*180, {"theta"});
	mgplot_reset(5);

	peak_idx = find_peak(TT, TH);
	peak_value = TH(peak_idx);
	pp = Cols(peak_value);
	peak_ratio = peak_value(1:pp-1)/peak_value(2:pp);
	lambda = mean(log(peak_ratio));
	tau = mean([peak_idx(2:pp) - peak_idx(1:pp-1)])*(TT(2)-TT(1));

	m2 = 0.039;
	l  = 0.121;
	g  = 9.8;

	printf("Period of response :             tau = %16.8E\n", tau);
	printf("Logarithmical damping ratio : lambda = %16.8E\n", lambda);
	printf("Length of pendulum :               l = %16.8E\n", l);
	printf("Mass of pendulum :                m2 = %16.8E\n", m2);
	printf("Acceleration of gravity :          g = %16.8E\n\n", g);
	printf("Inertia of pendulum :   J = tau^2*m2*l*g/(4*PI^2 + lambda^2) - m2*l^2\n");
	printf("Friction Coefficient : Cr = 2*lambda*(J + m2*l^2)/tau\n\n");

	J = tau^2*m2*l*g/(4*PI^2 + lambda^2) - m2*l^2;
	Cr = 2*lambda*(J + m2*l^2)/tau;

	printf("Identified inertia :               J = %16.8E\n", J);
	printf("Identified friction coefficient : Cr = %16.8E\n\n", Cr);
	pause;
	
	verify_ident_pendulum(TT, TH, J, Cr);

	yes_no = 1;
	print "Do you accept the parameters ? [Yes=1,No=0] : ";
	read yes_no;
	if (yes_no == 1) {
		set_parameter_pend(2, J, Cr);
	}
}

Func void verify_ident_pendulum(TT, TH, J, Cr)
	Array TT, TH;
	Real J, Cr;
{
	Real m2, l, g, dt, th0, dth0;
	Matrix A, B, C, D, x0;
	Array TH2;

	m2 = 0.039;
	l  = 0.121;
	g  = 9.8;

	dt = TT(2) - TT(1);
	th0 = TH(2);
	dth0 = (TH(3) - TH(1))/dt/2;
	x0 = [th0 dth0]';
	TT = TT(2:*);
	TH = TH(2:*);

	A = [[          0                      1      ]
	     [-(m2*l*g)/(J + m2*l^2),  -Cr/(J + m2*l^2)]];
	B = [0 0]';
	C = [1 0];
	D = [0];

	// Simulation with identified linearlized model
	{TH2} = lsim(A,B,C,D,Z(TT),TT,x0);

	mgplot_grid(7, 1);
	mgplot_xlabel(7, "time[s]");
	mgplot_ylabel(7, "theta[deg]");
	mgplot_title(7, "Measured data and simulation result of the identified model");
	mgplot(7, TT, [[TH][TH2]]/PI*180,
		 {"measured data", "identified linearlized model" });
	pause;
	mgplot_reset(7);
}

Func Index find_peak(t, th0)
	Array t, th0;
{
	Array t2, tt, th, th2;
	Real tmpr;
	Integer n, i0, i1, i2, i3, tmpi;
	Index idx, peak_idx;

	peak_idx = [];

	th = th0;
	n = Cols(th);
	tt = Z(1,n);

	idx = find(th <= 0.0);
	if (length(idx) == 0) {
		return peak_idx;
	}
	i0 = min(idx);
	th(1:i0) = -ONE(1,i0);

	while (1) {
		idx = find(th >= 0.0);
		if (length(idx) == 0) {
			break;
		}
		i1 = min(idx);
		if (i1 == n) {
			break;
		}
		th(1:i1) = ONE(1,i1);
		idx = find(th <= 0.0);
		if (length(idx) == 0) {
			break;
		}
		i2 = min(idx);
		if (i2 == n) {
			break;
		}
		{tmpr, tmpi, i3} = maximum(th(i1+1:i2));
		th(1:i2) = -ONE(1,i2);
		tt(i1+i3) = 1.0;
		peak_idx = [peak_idx, [i1+i3]];

//		tt((i1+i2)/2) = 1.0;
//		peak_idx = [peak_idx, [(i1+i2)/2]];
	}
	th2 = th0 * tt;
	t2 = t(find(tt));
	th2 = th2(find(th2));

	mgplot_grid(8, 1);
	mgplot_xlabel(8, "time[s]");
	mgplot_xlabel(8, "theta[deg]");
	mgplot_title(8, "Peak points of free response of pendulum");
	mgplot_cmd(8, "set data style points");
	mgplot(8, t, th0, {"theta"});
	mgreplot(8, t2, th2, {"peak"});
	mgplot_reset(8);

	return peak_idx;
}
/////////////////////////////////////////////////////////////////////////////
//  END OF IDENTIFICATION
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  ANALYSIS
/////////////////////////////////////////////////////////////////////////////
Func void analysis_pend()
{
	Integer ii;
	List analysis_menu;
	void tfunc_pole_pend(), ctr_obs_pend();
	
	analysis_menu = {"< Analysis of Plant >",
					 "Transfer function matrix and poles",
					 "Controllability and observability",
					 "Quit"};
	
	while (1) {
		ii = menu(analysis_menu);

		switch (ii) {
		  case 1: tfunc_pole_pend(); break;
		  case 2: ctr_obs_pend(); break;
		  case 3: return;
		  default: return;
		}
	}
}

Func void tfunc_pole_pend()
{
	RaMatrix G;
	Rational g1, g2;
	Polynomial nu1, nu2, de1, de2;
	CoMatrix poles_of_plant;

	G = ss2tfm(A,B,C,Z(Rows(C),Cols(B)));
	g1 = G(1,1);
	g2 = G(2,1);
	nu1 = Nu(g1);
	nu2 = Nu(g2);
	de1 = De(g1);
	de2 = De(g2);
	nu1(3) = 0;
	nu2(3) = 0;
	nu2(1) = 0;
	g1 = nu1/de1;
	g2 = nu2/de2;

	clear;
	print "\n";
	print "Transfer function matrix: G = [ g1 ]\n";
	print "                              [ g2 ]\n\n";
	print g1, "\n", g2;

	poles_of_plant = eigval(A);

	print "\n";
	print "Poles of the system :\n\n";
	print poles_of_plant;
	print "\n";
	if (max(Re(poles_of_plant)) < 0.0) {
		print "    ---> The system is stable.\n";
	} else {
		print "    ---> The system is unstable.\n";
	}		

	print "\n";
	pause;
}

Func void ctr_obs_pend()
{
	Integer i;
	Matrix V, N;

	V = ctrb(A, B);
	N = obsv(A, C);

	clear;
	print "\n";
	print "Rank of controllability matrix(=[B";
	for (i = 2; i <= Rows(A); i++) {
		if (i == 2) {
			print " AB";
		} else {
			printf(" A^%dB", i-1);
		}
	}
	printf("]) = %d\n\n", rank(V));

	if (rank(V) == Rows(A)) {
		print "    ---> The system is controllable.\n\n";
	} else {
		print "    ---> The system is uncontrollable.\n\n";
	}

	print "Rank of observability matrix(=[[C]";
	for (i = 2; i <= Rows(A); i++) {
		if (i == 2) {
			print "[CA]";
		} else {
			printf("[CA^%d]", i-1);
		}
	}
	printf("]) = %d\n\n", rank(N));

	if (rank(N) == Rows(A)) {
		print " ---> The system is observable.\n";
	} else {
		print " ---> The system is unobservable.\n";
	}

	print "\n";
	pause;
}

/////////////////////////////////////////////////////////////////////////////
//  END OF ANALYSIS
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  DESIGN
/////////////////////////////////////////////////////////////////////////////
Func void design_pend()
{
	Integer ii;
	List design_menu;

	void design_pend_lq_obs();

	design_menu = {"< Design of Controller >",
				   "LQ optimal and minimum observer",
				   "Quit"};
	
	while (1) {
		ii = menu(design_menu);
		switch (ii) {
		  case 1: design_pend_lq_obs(); break;
		  case 2: return;
		  default: return;
	   }
	}
}

Func void design_pend_lq_obs()
{
	Matrix Ah, Bh, Ch, Dh, Jh;
	Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
	Matrix Phi, Gamma, P;
	CoMatrix closed_loop_poles;
	Integer m, n, p, yes_no;
	RaMatrix GC;
	Rational gc1, gc2;
	Polynomial nu1, nu2, de1, de2;

	void plot_poles();

	m = Cols(B);
	p = Rows(C);
	n = Cols(A);

	if (design_flag == 0) {
		design_flag = 1;
		Q = diag(1.0E5, 1.0E5, 1.0, 1.0);
		R = I(m);
		observer_poles = (-20*ONE(n-p,1),*);
		smtime = 0.002;
	}

	// LQ Optimal feedback gain
	clear;
	print "\n";
	print "<  LQ Optimal Feedback >\n\n\n";
	pause "Input weighting matrices Q and R";
	edit Q, R;
	P = Riccati(A, B, Q, R);
	F = R~*B'*P;
	closed_loop_poles = eigval(A - B*F);

	clear;
	print "\n";
	print "< LQ Optimal Feedback >\n\n\n";
	print "LQ Optimal Feedback Gain:\n\n";
 	print F;
	print "\n";
	print "Closed-loop poles:\n\n";
	print closed_loop_poles;
	print "\n";
	pause;

	GC = ss2tfm(A-B*F,B,C,D);
	gc1 = GC(1,1);
	gc2 = GC(2,1);
	nu1 = Nu(gc1);
	de1 = De(gc1);
	nu2 = Nu(gc2);
	de2 = De(gc2);
	if (degree(nu1) >= 3) {
		nu1(3) = 0;
	}
	if (degree(nu2) >= 3) {
		nu2(3) = 0;
	}
	if (degree(nu2) >= 1) {
		nu2(1) = 0;
	}
	nu2(0) = 0;
	gc1 = nu1/de1;
	gc2 = nu2/de2;

	clear;
	print "\n";
	print "< LQ Optimal Feedback >\n\n\n";
	print "Transfer function matrix of closed-loop system: Gc = [ gc1 ]\n";
	print "                                                     [ gc2 ]\n\n\n";
	print gc1, "\n", gc2;
	print "\n";
	pause;

	// Plot bodeplot of closed-loop system
	yes_no = 0;
	print "\n\nPlot bodeplot of closed-loop system ?\n\n";
	print "[Yes=1, No=0] : ";
	read yes_no;

	if (yes_no == 1) {
		bodeplot(A-B*F,B,C,D,1);
	}

	// Minimal order observer
	clear;
	print "\n";
	print "<  Minimal Order Observer >\n\n\n";
	pause "Input poles of observer";
	edit observer_poles;
	{Ah, Bh, Ch, Dh, Jh} = Gopinath(A, B, C, observer_poles);

	// Discretize the observer
	clear;
	print "\n";
	print "< Discretization of Observer >\n\n\n";
	print "Input sampling interval [s] : ";
	read smtime;
	{Phi, Gamma} = Discretize(Ah, [Bh Jh], smtime);
	Ahd = Phi;
	Bhd = Gamma(*,1:p);
	Chd = Ch;
	Dhd = Dh;
	Jhd = Gamma(*,p+1:p+m);

	// Plot closed-loop poles an observer poles
	yes_no = 0;
	print "\n\nPlot closed-loop poles and observer poles ?\n\n";
	print "[Yes=1, No=0] : ";
	read yes_no;
	if (yes_no == 1) {
		plot_poles(closed_loop_poles, observer_poles);
	}

	// Set parameer of controller
	Ahd_off = Ahd;
	Bhd_off = Bhd;
	Chd_off = Chd;
	Dhd_off = Dhd;
	Jhd_off = Jhd;
	F_off = F;
	parameter_update = 1;
}

Func void plot_poles(cpole, opole)
	CoMatrix cpole, opole;
{
	CoArray cp, op;
	Real xmax, xmin, ymax, ymin;
	Integer yes_no;

	mgplot();		// load "mgplot.mm"

	cp = trans(cpole);
	op = trans(opole);
	xmax = max([Re(cp), Re(op)]);
	xmin = min([Re(cp), Re(op)]);
	ymax = max([Im(cp), Im(op)]);
	ymin = min([Im(cp), Im(op)]);
	if (xmax < 0.0) {
		xmax = - xmin/4;
	}
	if (xmin > 0.0) {
		xmin = - xmax/4;
	}

	if (any_graph2 == 1) {
		yes_no = 1;
		print "    Reset the graph ? [Yes=1, No=0] : ";
		read yes_no;
		if (yes_no == 1) {
			any_graph2 = 0;
			mgplot_reset(4);
		}
	}

	if (any_graph2 == 0) {
		mgplot_cmd(4, "set data style points");
		mgplot_xlabel(4, "Re");
		mgplot_ylabel(4, "Im");
		mgplot_title(4, "Closed-loop poles and observer poles");
		mgplot_cmd(4, sprintf("set xrange [%g:%g]", 1.5*xmin, 1.5*xmax));
		mgplot_cmd(4, sprintf("set yrange [%g:%g]", 1.5*ymin, 1.5*ymax));
		mgplot(4, Re(cp), Im(cp), {"closed-loop poles"});
		mgreplot(4, Re(op), Im(op), {"observer poles"});
	} else {
		mgreplot(4, Re(cp), Im(cp), {"closed-loop poles"});
		mgreplot(4, Re(op), Im(op), {"observer poles"});
	}
	pause;
	any_graph2 = 1;
}
/////////////////////////////////////////////////////////////////////////////
//  END OF DESIGN
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  SIMULATION
/////////////////////////////////////////////////////////////////////////////
Func void simulation_pend()
{
	Real r0, th0, tf, dt;
	Matrix x0;
	Array TT, XX, UY;

	void diff_eqs_pend(), link_eqs_pend(), draw_graph_pend();

	tf = 3.0;	// [sec]
	r0 = 0.0;	// [m]
	th0 = 10.0;	// [deg]
	dt = smtime;

	clear;
	print "\n";
	print "< Simulation of Pendulum >\n\n\n";
	print "Initial position of cart [m]    : "; read r0;
	print "Initial angle of pendulum [deg] : "; read th0;
	print "Simulation time [sec]           : "; read tf;

	x0 = [r0 th0/180.0*PI 0 0]';
	z = Z(2,1);

	print "\n";
	{TT, XX, UY} = Ode45HybridAuto(0.0, tf, dt, x0,
					diff_eqs_pend, link_eqs_pend, 1.0E-6, tf/400);
	print "\n\n";

	draw_graph_pend(TT, UY);
}

Func void show_graph_pend()
{
	if (any_graph == 0) {
		warning("No graph is available\n");
		return;
	}
	
	mgplot_replot(1);
	mgplot_replot(2);
	mgplot_replot(3);
	mgplot_replot(4);
}

Func void draw_graph_pend(TT, UY)
	Array TT, UY;
{
	Integer yes_no;

	if (any_graph == 1) {
		yes_no = 1;
		print "    Reset the graph ? [Yes=1, No=0] : ";
		read yes_no;
		if (yes_no == 1) {
			any_graph = 0;
			mgplot_reset(1);
			mgplot_reset(2);
			mgplot_reset(3);
		}
	}

	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "r[m]");
	mgplot_title(1, "Position of cart");
	if (any_graph == 0) {
		mgplot(1, TT, UY(Index([2,4]),*), 
			{"position", "reference"});
	} else {
		mgreplot(1, TT, UY(Index([2,4]),*), 
			{"position", "reference"});
	}

	mgplot_grid(2, 1);
	mgplot_xlabel(2, "time[sec]");
	mgplot_ylabel(2, "theta[deg]");
	mgplot_title(2, "Angle of pendulum");
	if (any_graph == 0) {
		mgplot(2, TT, UY(3,*)/PI*180, {"theta"});
	} else {
		mgreplot(2, TT, UY(3,*)/PI*180, {"theta"});
	}

	mgplot_grid(3, 1);
	mgplot_xlabel(3, "time[sec]");
	mgplot_ylabel(3, "input[N]");
	mgplot_title(3, "Control input");
	if (any_graph == 0) {
		mgplot(3, TT, UY(1,*), {"input"});
	} else {
		mgreplot(3, TT, UY(1,*), {"input"});
	}
	pause;

	any_graph = 1;
}

// Differential equations
Func void diff_eqs_pend(dx, t, x, uy)
	Matrix dx, x, uy;
	Real t;
{
	Real x1, x2, x3, x4, u, c2, s2, determ;

	x1 = x(1);
	x2 = x(2);
	x3 = x(3);
	x4 = x(4);
	u = uy(1);

	c2 = cos(x2);
	s2 = sin(x2);
	determ = (1 + alpha*s2^2);

	dx = Z(4,1);
	dx(1) = x(3);
	dx(2) = x(4);
	dx(3) = (a32*s2*c2 + a33*x3 + a34*c2*x4 + a35*s2*x4^2 + b3*u)/determ;
	dx(4) = (a42*s2 + a43*c2*x3 + a44*x4 + a45*s2*c2*x4^2 + b4*c2*u)/determ;
}

// Relation between input- and output- signals
Func void link_eqs_pend(uy, t, x)
	Matrix uy, x;
	Real t;
{
	Real u_max;
	u_max = 20.0;

	if (parameter_update) {
		parameter_update = 0;
		Ahd = Ahd_off;
		Bhd = Bhd_off;
		Chd = Chd_off;
		Dhd = Dhd_off;
		Jhd = Jhd_off;
		F   = F_off;
	}

	y = C*x;                     // output of plant
	xh = Chd*z + Dhd*y;          // estimated states
	u = - F*xh;                  // control input
	z = Ahd*z + Bhd*y + Jhd*u;   // update the state of observer
	
	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}

	uy = [[u][y][ref]];

	printf("t = %7.3f[s]: position = %8.4f[m], angle = %8.4f[deg], u = %8.4f[N]\r",
		   t, y(1), y(2)/PI*180, u(1));
}
/////////////////////////////////////////////////////////////////////////////
//  END OF SIMULATION
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  EXPERIMENT
/////////////////////////////////////////////////////////////////////////////
Func void experiment()
{
	Integer yes_no;
	Array TT, UY;

	void var_init_pend(), off_task_loop(), on_task_pend(), break_task();
	void machine_ready_pend(), machine_stop(), draw_graph_pend();
	void on_task_ident();

	machine_ready_pend();   // Set machine ready
	var_init_pend();        // Initialization of variables(after machine_ready)
	rtSetClock(smtime);     // Set sampling interval
	if (ident_flag) {
		rtSetTask(on_task_ident);	// Set real-time function
	} else {
		rtSetTask(on_task_pend);	// Set real-time function
	}
	rtSetBreak(break_task); // Set interruput function to Ctrl-C

	rtStart();              // Start real-time task
	off_task_loop();        // Command input, display of variables
	rtStop();               // Stop real-time task

	machine_stop();         // Set machine stop

	if (ident_flag == 0 && log_count > 1) {
		yes_no = 1;
		print "\n\n    Draw graph ? [Yes=1,No=0] ";
		read yes_no;
		if (yes_no == 1) {
			TT = [0:log_count-1]*smtime*mlc;
			UY = log_data(*,1:log_count);
			draw_graph_pend(TT, UY);
		}
	}
}

// Initilization of variables
Func void var_init_pend()
{
	ref = 0.0;
	cmd = 0;
	log_flag = 0;
	log_count = 0;
	lc = 0;
	mlc = 10;

	z = Z(2,1);             // Initial states of observer
	xh = Z(4,1);            // Initial estimated states
	log_data = Z(4,LOGMAX); // Logging data
}

// Set machine ready
Func void machine_ready_pend()
{
	void sensor_init(), actuator_init();

	sensor_init();                  // Initialize sensors
	actuator_init();                // Initializa actuators

	gotoxy(5,6);
	print "Initial point of cart:     Center of rail";
	gotoxy(5,7);
	print "Initial point of pendulum: DOWN, theta = PI";
	gotoxy(5,9);
	pause "Move cart and pendulum to the initial point, then HIT RETURN";
	gotoxy(5,9);
	printf("                                                            ");
	gotoxy(5,9);
	pause "HIT RETURN to start control";
	clear;
}

// Set machine stop
Func void machine_stop()
{
	void actuator_stop();

	actuator_stop();
}

// On-line function for calculation of control law
Func void on_task_pend()
{
	Real u_max;
	Matrix sensor();
	void actuator();

	u_max = 20.0;

	// Update parameter of controller
	if (parameter_update && ident_flag == 0) {
		parameter_update = 0;
		Ahd = Ahd_off;
		Bhd = Bhd_off;
		Chd = Chd_off;
		Dhd = Dhd_off;
		Jhd = Jhd_off;
		F   = F_off;
	}

	if (ident_flag) {
		y = sensor();			// Input from sensor
		u = Z(1);
	} else {
		y = sensor();			// Input from sensor
		xh = Chd*z + Dhd*y;		// Estimated state
		xh(1) = xh(1) - ref;
		u = - F*xh;
		z = Ahd*z + Bhd*y + Jhd*u;	// Update observer state
	}

	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}
	
	if (cmd == 1 && !rtIsTesting()) {
		actuator(u(1));			// Output to actuator
	}

	// Loggin data
	if (log_flag == 1) {
		if (log_count < LOGMAX && rem(lc,mlc) == 0) {
			log_count++;
			log_data(1:1, log_count) = u;
			log_data(2:3, log_count) = y;
			log_data(4, log_count)   = ref;
		}
		lc++;
	}
}

// On-line function for identification
Func void on_task_ident()
{
	Real t, step_height2;
	Matrix sensor();
	void actuator();

	y = sensor();			// Input from sensor

	if (ident_flag == 1) {
		u = [step_height];	// cart
	} else 	{
		step_height2 = 9.0;
		t = log_count*mlc*smtime;
		if (0.0 < t && t <= 0.3) {
			u = [step_height2];	// pendulum
		} else if (0.3 < t && t <= 0.51) {
			u = [-step_height2];
		} else {
			u = [0];
		}
	}
	
	if (( ! rtIsTesting()) && (cmd == 1 || ident_flag != 0)) {
		actuator(u(1));		// Output to actuator
	}

	// Loggin data
	if (log_flag == 1 || ( (! rtIsTesting()) && ident_flag != 0)) {
		if (log_count < LOGMAX && rem(lc,mlc) == 0) {
			log_count++;
			log_data(1:1, log_count) = u;
			log_data(2:3, log_count) = y;
			log_data(4, log_count)   = ref;
		}
		lc++;
	}
}

// Command input, Display of variables
Func void off_task_loop()
{
	Integer end_flag;

	end_flag = 0;

	gotoxy(5, 6);
	print "'c': Start control";
	gotoxy(5, 7);
	print "ESC: Stop control";
	gotoxy(5, 8);
	print "'l': Start and stop loggin data";
	gotoxy(5, 9);
	print "'r': Change reference of cart";

	do {
		gotoxy(5, 11);
		printf("position = %8.4f[m], angle = %8.4f[deg]",
			   y(1), y(2)/PI*180);
		gotoxy(5, 12);
		printf("refernce = %8.4f[m], input = %10.4f[N]", ref, u(1));

		if (log_flag || ident_flag != 0) {
			gotoxy(5, 14);
			printf("Now logging, number of data = %4d, time = %7.3f [s]", log_count, log_count*mlc*smtime);
		}
		if (rtIsTimeOut()) {
			gotoxy(5, 18);
			warning("\nTime Out !\n");
			break;
		}

		if (ident_flag == 1) {
			if (1.5 <= log_count*mlc*smtime) {
				end_flag = 1;
			}
		} else if (ident_flag == 2) {
			if (7.0 <= log_count*mlc*smtime) {
				end_flag = 1;
			}
		}

		if (kbhit()) {
			switch (getch()) {
			  case 0x1b:            /* ESC */
				end_flag = 1;
				break;
		/* 'R' */  case 0x52:
		/* 'r' */  case 0x72:
				gotoxy(5, 16);
				print "Reference of cart [m] : ";
				read ref;
				gotoxy(5, 16);
	printf("                                                           ");
				break;
		/* 'L' */  case 0x4c: // Start loggin
		/* 'l' */  case 0x6c:
				if (log_flag == 0) {
					lc = 0;
					log_count = 0;
					log_flag = 1;
				} else {
					log_flag = 0;
				}
				break;
		/* 'c' */  case 0x43: // Output to actuator
		/* 'C' */  case 0x63: // If 'c' or 'C' is 
				      // pressed, start motor
				cmd = 1;
				break;
//		/* 'd' */  case 0x44:
//		/* 'D' */  case 0x64:
//				design();
//				break;
			  default:
				break;
			}
		}
    } while ( ! end_flag);  // If end_flag != 0, END
}

// Interrupt function for Ctrl-C
Func void break_task()
{
	void machine_stop();

	rtStop();
	machine_stop(); // Set machine stop
}

// Save logging data to file
Func void log_data_save(f_name, dt)
	String f_name;
	Real dt;
{
	Array TT;

	if (log_count > 1) {
		TT = [0:log_count-1]*dt;
		print [[TT][log_data(*,1:log_count)]] >> f_name + ".log";
	}
}

/////////////////////////////////////////////////////////////////////////////
//  END OF EXPERIMENT
/////////////////////////////////////////////////////////////////////////////

/*  crane

	a32 = -(m2*l)^2*g;
	a33 = -Fr*(J + m2*l^2);
	a34 = -m2*l*Cr;
	a35 = -(J + m2*l^2)*m2*l;
	a42 = -(m1 + m2)*m2*l*g;
	a43 = -m2*l*Fr;
	a44 = -(m1 + m2)*Cr;
	a45 = -(m2*l)^2;
	b3  = (J + m2*l^2)*a0;
	b4  = m2*l*a0;

*/

