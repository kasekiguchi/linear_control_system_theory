/*
 *      ミニ倒立振子の制御系設計プログラム
 *
 *　制御則:　u = -f1*(ref-x1) - f2*x2 - f3*x3h - f4*x4h
 *
 *     x1: 台車の位置[m],   x3h: 台車の速度(観測器の推定値)[m/s]
 *     x2: 振子の角度[rad], x4h: 振子の角速度(観測器の推定値)[rad/s]
 *     ref: 台車の目標値[m]
 *
 *  台車の初期位置: x1 = 0
 *  振子の初期位置: x2 = -PI
 *
 */

#define LOGMAX 1000

Real a32, a33, a34, a35, a42, a43, a44, a45, b3, b4, cc1, cc2, alpha;
Matrix A, B, C, Q, R;
Matrix u, y, z, xh;
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
Matrix Ahd_off, Bhd_off, Chd_off, Dhd_off, Jhd_off, F_off;
CoMatrix observer_poles;
Array log_data, TT_old, UY_old;
Real ref, smtime, step_height;
Integer cmd, log_flag, log_count, lc, mlc, design_flag;
Integer any_graph, any_graph2, parameter_update, ident_flag;

// センサとアクチュエータ関連の変数
// これらの変数は 'hardware.mm' で使用される。
Matrix mp_data, PtoMR;

// Main function
Func void main()
{
	List main_menu;
	void set_plant_parameter(...), design(), analysis(), simulation();
	void show_graph(), identification(), experiment();

	main_menu = {"《ミニ倒立振子の制御》", "同  定", "解  析", "設  計",
				 "シミュレーション", "実  験", "グラフ", "終  了"};

	any_graph = 0;
	ident_flag = 0;
	mgplot();			// "mgplot.mm"を読み込む
	set_plant_parameter();

	while (1) {
		switch (menu(main_menu)) {
		  case 1: identification(); break;
		  case 2: analysis(); break;
		  case 3: design(); break;
		  case 4: simulation(); break;
		  case 5: experiment(); break;
		  case 6: show_graph(); break;
		  case 7: return;
		}
	}
}

// 制御対象のパラメータを設定
Func void set_plant_parameter(flag, para1, para2, ...)
	Integer flag;
	Real para1, para2;
{
	Real m1, m2, Fr, Cr, l, J, a0, g, alpha0;

	if (nargs != 0 && nargs != 3) {
		warning("set_plant_parameter(): 引数の数が正しくありません。\n");
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

	// 同定されたパラメータ
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
}

/////////////////////////////////////////////////////////////////////////////
//  同  定
/////////////////////////////////////////////////////////////////////////////
Func void identification()
{
	Integer ii;
	List ident_menu;
	void ident_cart(), ident_pendulum();

	ident_menu = {"《同  定》",
			"台車系の質量と摩擦係数の同定",
			"振子の慣性モーメントと摩擦係数の同定",
			"終  了"};
	ii = menu(ident_menu);
	switch (ii) {
		case 1: ident_cart(); break;
		case 2: ident_pendulum(); break;
		case 3: return;
		default: return;
	}
}

Func void ident_cart()
{
	Integer end_i, nn, nn2, yes_no;
	Real end_time, dt;
	Real K, T, a0, m1, Fr;
	Array TT, RR, RRR, TT2, RR2;
	void experiment(), verify_ident_cart();
	void set_plant_parameter(...);

	smtime = 0.002;
	printf("サンプリング周期 [s] :        ");
	read smtime;
	step_height = 7.0;
	printf("ステップ入力の高さ [N] : ");
	read step_height;

	ident_flag = 1;
	experiment();
	ident_flag = 0;

	if (log_count == 0) {
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
	printf("同定に使うデータの終端時間を指定して下さい。\n");
	read end_time;
	end_i   = max(find(TT <= end_time));
	TT = TT(1:end_i);
	RR = RR(1:end_i);
	nn = Cols(TT);
	RRR = RR(nn/2:nn);	// 後半分のデータ
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

	a0 = 0.1;	// 既知

	Fr = a0/K;
	m1 = T*Fr;

	printf("台車の伝達関数を K/(s*(T*s + 1)) と仮定する。\n\n");
	printf("ゲイン :                K = %16.8E (同定値)\n", K);
	printf("時定数 :                T = %16.8E (同定値)\n", T);
	printf("トルク/電圧 変換係数 : a0 = %16.8E (既知)\n\n", a0);
	printf("Fr = a0/K\n");
	printf("m1 = T*Fr\n\n");
	printf("台車系の質量 :         m1 = %16.8E\n", m1);
	printf("台車の摩擦係数 :       Fr = %16.8E\n\n", Fr);
	pause;
	
	verify_ident_cart(TT, RR, m1, Fr);

	yes_no = 1;
	printf("同定されたパラメタ－を採用しますか？ [はい=1,いいえ=0] : ");
	read yes_no;
	if (yes_no == 1) {
		set_plant_parameter(1, m1, Fr);
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
	mgplot(7, TT, Array([[RR][RR2]]),
		 {"measured data", "identified linear model"});
	pause;
	mgplot_reset(7);
}


Func void ident_pendulum()
{
	Real m2, l, g, lambda, tau, J, Cr;

	Integer i, start_i, end_i, mm, pp, yes_no;
	Real start_time, end_time;
	Array TT, TH;
	Array peak_value, peak_ratio;
	Index idx, peak_idx;
	void experiment(), verify_ident_pendulum();
	void set_plant_parameter(...);
	Index find_peak();

	smtime = 0.002;
	printf("サンプリング周期 [s] : ");
	read smtime;

	ident_flag = 2;
	experiment();
	ident_flag = 0;

	if (log_count == 0) {
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

	printf("同定に使用するデータの時間を指定して下さい。\n");
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

	printf("振動の周期 :              tau = %16.8E\n", tau);
	printf("対数減衰率 :           lambda = %16.8E\n", lambda);
	printf("振子の重心距離 :            l = %16.8E\n", l);
	printf("振子の質量 :               m2 = %16.8E\n", m2);
	printf("重力加速度 :                g = %16.8E\n\n", g);
	printf("慣性モーメント :  J = tau^2*m2*l*g/(4*PI^2 + lambda^2) - m2*l^2\n");
	printf("摩擦係数 :       Cr = 2*lambda*(J + m2*l^2)/tau\n\n");

	J = tau^2*m2*l*g/(4*PI^2 + lambda^2) - m2*l^2;
	Cr = 2*lambda*(J + m2*l^2)/tau;

	printf("慣性モーメント(同定値) :   J = %16.8E\n", J);
	printf("摩擦係数      (同定値) :  Cr = %16.8E\n\n", Cr);
	pause;
	
	verify_ident_pendulum(TT, TH, J, Cr);

	yes_no = 1;
	printf("同定されたパラメタ－を採用しますか？ [はい=1,いいえ=0] : ");
	read yes_no;
	if (yes_no == 1) {
		set_plant_parameter(2, J, Cr);
	}
}

Func void verify_ident_pendulum(TT, TH, J, Cr)
	Array TT, TH;
	Real J, Cr;
{
	Real m2, l, g, dt, th0, dth0;
	Matrix A, B, C, D, x0;
	Array TH2;

	void diff_eqs_pend(), link_eqs_pend();

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

	// 同定モデルによるシミュレーション
	{TH2} = lsim(A,B,C,D,Z(TT),TT,x0);

	mgplot_grid(7, 1);
	mgplot_xlabel(7, "time[s]");
	mgplot_ylabel(7, "theta[deg]");
	mgplot_title(7, "Measured data and simulation result of the identified model");
	mgplot(7, TT, Array([[TH][TH2]]/PI*180),
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
//  同定終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  解  析
/////////////////////////////////////////////////////////////////////////////
Func void analysis()
{
	Matrix V, N;
	CoMatrix eigenvalue_of_A;

	eigenvalue_of_A = eigval(A);
	V = ctrb(A, B);
	N = obsv(A, C);

	print "システムの極 :\n\n";
	print eigenvalue_of_A;
	printf("\n                           ");
	if (max(Re(eigenvalue_of_A)) < 0.0) {
		printf("    ---> システムは安定である。\n\n");
	} else {
		printf("    ---> システムは不安定である。\n\n");
	}		

	printf("可制御性行列のランク = %d   ", rank(V));
	if (rank(V) == Rows(A)) {
		printf("    ---> システムは可制御である。\n\n");
	} else {
		printf("    ---> システムは不可制御である。\n\n");
	}

	printf("可観測性行列のランク = %d   ", rank(N));
	if (rank(N) == Rows(A)) {
		printf("    ---> システムは可観測である。\n\n");
	} else {
		printf("    ---> システムは不可観測である。\n\n");
	}

	pause;
}

/////////////////////////////////////////////////////////////////////////////
//  解析終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  設  計
/////////////////////////////////////////////////////////////////////////////
Func void design()
{
	Matrix Ah, Bh, Ch, Dh, Jh;
	Matrix Ahd, Bhd, Chd, Dhd, Jhd, F;
	Matrix Phi, Gamma, P;
	CoMatrix closed_loop_poles;
	Integer m, n, p, yes_no, ii;
	List design_menu;

	void plot_poles();

	design_menu = {"《設  計》", 
				   "ＬＱ最適制御＋最小次元オブザーバ", "終  了"};

	ii = menu(design_menu);
	switch (ii) {
		case 1: break;
		case 2: return;
		default: return;
	}

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

	// ＬＱ最適状態フィードバック
	edit Q, R;
	P = Riccati(A, B, Q, R);
	F = R~*B'*P;
	closed_loop_poles = eigval(A - B*F);
 	print F, closed_loop_poles;
	pause;

	// 最小次元オブザーバ
	edit observer_poles;
	{Ah, Bh, Ch, Dh, Jh} = Gopinath(A, B, C, observer_poles);

	// オブザーバの離散化
	gotoxy(5,5);
	printf("サンプリング周期 [s] : ");
	read smtime;
	{Phi, Gamma} = Discretize(Ah, [Bh Jh], smtime);
	Ahd = Phi;
	Bhd = Gamma(*,1:p);
	Chd = Ch;
	Dhd = Dh;
	Jhd = Gamma(*,p+1:p+m);

	// 閉ループ系の極とオブザーバの極をプロットする
	yes_no = 1;
	gotoxy(5,7);
	printf("閉ループ系とオブザーバの極をプロットしますか？");
	gotoxy(5,8);
	printf("[はい=1, いいえ=0] : ");
	read yes_no;
	if (yes_no == 1) {
		plot_poles(closed_loop_poles, observer_poles);
	}

	// コントローラのパラメータを設定する
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

	mgplot();		// "mgplot.mm"を読み込む

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
		printf("    グラフをリセットしますか？ [はい=1, いいえ=0] : ");
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
//  設計終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  シミュレーション
/////////////////////////////////////////////////////////////////////////////
Func void simulation()
{
	Real r0, th0, tf, dt;
	Matrix x0;
	Array TT, XX, UY;
	void diff_eqs(), link_eqs(), draw_graph();

	tf = 3.0;
	r0 = 0.0;
	th0 = 10.0;
	dt = smtime;

	printf("台車の初期位置 [m]         :  "); read r0;
	printf("振子の初期角度 [deg]       : "); read th0;
	printf("シミュレーション時間 [sec] :  "); read tf;

	x0 = [r0 th0/180.0*PI 0 0]';
	z = Z(2,1);

	printf("\n");
	{TT, XX, UY} = Ode45HybridAuto(0.0, tf, dt, x0,
					diff_eqs, link_eqs, 1.0E-6, tf/400);
	printf("\n\n");

	draw_graph(TT, UY);
}

Func void show_graph()
{
	if (any_graph == 0) {
		warning("グラフは１個も存在しません。\n");
		return;
	}
	
	mgplot_replot(1);
	mgplot_replot(2);
	mgplot_replot(3);
	mgplot_replot(4);
}

Func void draw_graph(TT, UY)
	Array TT, UY;
{
	Integer yes_no;

	if (any_graph == 1) {
		yes_no = 1;
		printf("    グラフをリセットしますか？ [はい=1, いいえ=0] : ");
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

// 状態方程式
Func void diff_eqs(dx, t, x, uy)
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

// 入出力関係
Func void link_eqs(uy, t, x)
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

	y = C*x;                     // 制御対象の出力
	xh = Chd*z + Dhd*y;          // 状態の推定値
	u = - F*xh;                  // 制御入力
	z = Ahd*z + Bhd*y + Jhd*u;   // 観測器の状態を更新
	
	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}

	uy = [[u][y][ref]];

	printf("時間 = %7.3f[s]: 台車 = %8.4f[m], 振子 = %8.4f[deg], 入力 = %8.4f[N]\r",
		   t, y(1), y(2)/PI*180, u(1));
}
/////////////////////////////////////////////////////////////////////////////
//  シミュレーション終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  実  験
/////////////////////////////////////////////////////////////////////////////
Func void experiment()
{
	Integer yes_no;
	Array TT, UY;
	void var_init(), off_task_loop(), on_task(), break_task();
	void machine_ready(), machine_stop(), draw_graph();
	void on_task_ident();

	var_init();             // 変数の初期化
	machine_ready();        // 実験装置の準備
	rtSetClock(smtime);     // サンプリング周期の設定
	if (ident_flag) {
		rtSetTask(on_task_ident);	// オンライン関数の設定(同定)
	} else {
		rtSetTask(on_task);		// オンライン関数の設定(制御)
	}
	rtSetBreak(break_task); // 割り込みキーに対応する関数の設定

	rtStart();              // リアルタイム制御開始
	off_task_loop();        // オフライン関数
	rtStop();               // リアルタイム制御終了

	machine_stop();         // 実験装置を停止

	if (ident_flag == 0 && log_count > 1) {
		yes_no = 1;
		print "\n\n    グラフを描画しますか？ [はい=1, いいえ=0] ";
		read yes_no;
		if (yes_no == 1) {
			TT = [0:log_count-1]*smtime*mlc;
			UY = log_data(*,1:log_count);
			draw_graph(TT, UY);
		}
	}
}

// 変数の初期化
Func void var_init()
{
	ref = 0.0;
	cmd = 0;
	log_flag = 0;
	log_count = 0;
	lc = 0;
	mlc = 10;

	z = Z(2,1);             // オブザーバのの初期状態
	xh = Z(4,1);            // 状態の推定値の初期値
	log_data = Z(4,LOGMAX); // ロギングデータ
}

// 実験装置の準備
Func void machine_ready()
{
	void sensor_init(), actuator_init();

	sensor_init();                  // センサの初期化
	actuator_init();                // アクチュエータの初期化

	gotoxy(5,5);
	printf("台車の初期位置 : レールの中央");
	gotoxy(5,6);
	printf("振子の初期位置 : 真下");
	gotoxy(5,9);
	pause "台車と振子を初期位置に移動し，リターンキーを入力して下さい。";
	gotoxy(5,9);
	printf("                                                            ");
	gotoxy(5,9);
	pause "リターンキーを入力すると，制御が開始されます。";
	clear;
}

// 実験装置停止
Func void machine_stop()
{
	void actuator_stop();

	actuator_stop();
}

// 制御のためのオンライン関数
Func void on_task()
{
	Real u_max;
	Matrix sensor();
	void actuator();

	u_max = 20.0;

	// コントローラのパラメータを更新
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
		y = sensor();			// センサから入力
		u = Z(1);
	} else {
		y = sensor();			// センサから入力
		xh = Chd*z + Dhd*y;		// 状態を推定
		xh(1) = xh(1) - ref;
		u = - F*xh;
		z = Ahd*z + Bhd*y + Jhd*u;	// オブザーバを更新
	}

	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}
	
	if (cmd == 1 && !rtIsTesting()) {
		actuator(u(1));			// アクチュエータへ出力
	}

	// ロギングデータ
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

// 同定のためのオンライン関数
Func void on_task_ident()
{
	Real t, step_height2;
	Matrix sensor();
	void actuator();

	y = sensor();			// センサから入力

	if (ident_flag == 1) {
		u = [step_height];	// 台車のステップ応答
	} else 	{
		step_height2 = 9.0;
		t = log_count*mlc*smtime;
		if (0.0 < t && t <= 0.3) {
			u = [step_height2];	// 振子の自由振動
		} else if (0.3 < t && t <= 0.51) {
			u = [-step_height2];
		} else {
			u = [0];
		}
	}
	
	if (( ! rtIsTesting()) && (cmd == 1 || ident_flag != 0)) {
		actuator(u(1));		// アクチュエータへ出力
	}

	// ロギングデータ
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

// オフライン関数
Func void off_task_loop()
{
	Integer end_flag;

	end_flag = 0;

	gotoxy(5, 6);
	printf("'c': アクチュエータへ出力開始");
	gotoxy(5, 7);
	printf("ESC: アクチュエータへ出力停止");
	gotoxy(5, 8);
	printf("'l': ロギング開始と停止");
	gotoxy(5, 9);
	printf("'r': 台車の目標値を変更");

	do {
		gotoxy(5, 11);
		printf("  台車位置 = %8.4f[m], 振子角度 = %8.4f[deg]",
			y(1), y(2)/PI*180);
		gotoxy(5, 12);
		printf("台車目標値 = %8.4f[m],     入力 = %10.4f[N]",
			ref, u(1));

		if (log_flag || ident_flag != 0) {
			gotoxy(5, 14);
			printf("ロギング中, データ数 = %4d, 時間 = %7.3f [s]", log_count, log_count*mlc*smtime);
		}
		if (rtIsTimeOut()) {
			gotoxy(5, 18);
			warning("\n時間切れ !\n");
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
				printf("台車の目標値 [m] : ");
				read ref;
				gotoxy(5, 16);
	printf("                                                           ");
				break;
		/* 'L' */  case 0x4c: // ロギンング開始と停止
		/* 'l' */  case 0x6c:
				if (log_flag == 0) {
					lc = 0;
					log_count = 0;
					log_flag = 1;
				} else {
					log_flag = 0;
				}
				break;
		/* 'c' */  case 0x43: // アクチュエータへ出力開始
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

// 割り込みキーに対応する関数
Func void break_task()
{
	void machine_stop();

	rtStop();
	machine_stop(); // 実験装置停止
}

// ロギングデータをファイルへ保存
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
//  実験終り
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
