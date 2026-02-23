
/*  -*- MaTX -*-
 *
 *     台車と倒立振子の制御系設計プログラム
 *
 *     制御則(台車):      u = -f1*(ref-x1) - f2*((x1 - x1_old)/dt)
 *     制御則(倒立振子):  u = -f1*(ref-x1) - f2*x2 - f3*x3h - f4*x4h
 *
 *     x1: 台車の位置[m],   x3h: 台車の速度(観測器の推定値)[m/s]
 *     x2: 振子の角度[rad], x4h: 振子の角速度(観測器の推定値)[rad/s]
 *     ref: 台車の目標値[m]
 *
 *  台車の初期位置: x1 = 0
 *  振子の初期位置: x2 = -PI
 *
 *  実行方法: matx rtpend.mm -e main
 *
 */

#define LOGMAX 1000

Integer log_flag, disturb_flag, ident_flag, servo_flag;
Integer pend_lq_flag, pend_lq_servo_flag, pend_obs_flag;
Integer cart_poleassign_flag, cart_damp_nat_flag;
Integer cmd, log_count, lc, mlc, any_graph, any_graph2, parameter_update;
Real a32, a33, a34, a35, a42, a43, a44, a45, b3, b4, cc1, cc2, alpha;
Real sf_p, sf_n, u_sf_p, u_sf_n, err_sum;
Real ref, smtime, step_height, closed_loop_damp, closed_loop_nat;
Matrix A, B, C, D, Q, R, QQe, RRe;
Matrix u, y, z, xh, y_old;
Matrix Ahd, Bhd, Chd, Dhd, Jhd, F, F2;
Matrix Ahd_off, Bhd_off, Chd_off, Dhd_off, Jhd_off, F_off, F2_off;
CoMatrix observer_poles, closed_loop_poles;
Array log_data, TT_old, UY_old;

// センサとアクチュエータ関連の変数
// これらの変数は hardware.mm で使用される。
Matrix mp_data, PtoMR;

// hardware.mm で定義された関数
void sensor_init(), actuator_init(), actuator();
Matrix sensor();

Func void main()
{
	List main_menu;
	void main_cart(), main_pend();

	main_menu = {"《台車の制御と倒立振子の制御》",
				 "台 車 の 位 置 制 御",
				 "倒立振子の安定化制御",
				 "終  了"};
				 
	while (1) {
		switch (menu(main_menu)) {
		  case 1: main_cart(); break;
		  case 2: main_pend(); break;
		  case 3: return;
		  default: return;
		}
	}
}

// 倒立振子の制御メイン関数
Func void main_pend()
{
	List main_menu;
	void set_parameter_pend(...), design_pend(), analysis_pend();
	void simulation_pend(), show_graph_pend(), modelling_ident_pend();
	void experiment_pend();

	main_menu = {"《倒立振子(静止摩擦有り)の安定化制御》",
				 "モデリングと同定",
				 "制 御 系 解 析",
				 "制 御 系 設 計",
				 "シミュレーション",
				 "制  御  実  験",
				 "データプロット",
				 "終  了"};

	any_graph = 0;
	ident_flag = 0;
	set_parameter_pend(); // パラメータの設定

	while (1) {
		switch (menu(main_menu)) {
		  case 1: modelling_ident_pend(); break;
		  case 2: analysis_pend(); break;
		  case 3: design_pend(); break;
		  case 4: simulation_pend(); break;
		  case 5: experiment_pend(); break;
		  case 6: show_graph_pend(); break;
		  case 7: return;
		}
	}
}

/////////////////////////////////////////////////////////////////////////////
//  モデリングと同定
/////////////////////////////////////////////////////////////////////////////
Func void modelling_ident_pend()
{
	List ident_menu;
	void ident_cart(), ident_pendulum(), ident_static_friction();
	void print_nonlinear_pend(), print_linear_pend();

	ident_menu = {"《モ デ リ ン グ と 同 定》",
				  "台車の静止摩擦の同定",
				  "台車系の質量と粘性摩擦係数の同定",
				  "振子の慣性モーメントと粘性摩擦係数の同定",
				  "状態方程式と出力方程式",
				  "終  了"};
	
	while (1) {
		switch (menu(ident_menu)) {
		  case 1: ident_static_friction(); break;
		  case 2: ident_cart(1); break;
		  case 3: ident_pendulum(); break;
		  case 4: print_nonlinear_pend(); print_linear_pend(); break;
		  case 5: return;
		  default: return;
	   }
	}
}

// 制御対象(倒立振子)(静止摩擦有り)のパラメータを設定
Func void set_parameter_pend(flag, para1, para2, ...)
	Integer flag;
	Real para1, para2;
{
	Real m1, m2, Fr, Cr, l, J, a0, g, alpha0;
	void design_pend_lq(...), design_pend_lq_servo(...);
	void design_pend_obs(...), design_static_friction(...);

	if (nargs != 0 && nargs != 3) {
		warning("set_parameter_pend(): 引数の数が正しくありません。\n");
		return;
	}

	pend_lq_flag = 0;
	pend_lq_servo_flag = 0;
	pend_obs_flag = 0;

	// ノーミナルパラメータ
	m1 = 0.16;
	m2 = 0.039;
	Fr = 2.6;
	Cr = 4.210e-4;
	l  = 0.121;
	J  = 4.485e-4;
	a0 = 0.1;
	g  = 9.8;
	sf_p = 4.0; // 正方向の静止摩擦
	sf_n = 4.0; // 負方向の静止摩擦

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

	// 状態方程式の係数行列
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


	// デフォルトのコントローラ
	// (LQ 最適レギュレータ + 最小次元オブザーバ)の設計
	design_pend_lq_servo(1);
	design_pend_lq(1);
	design_pend_obs(1);
	design_static_friction(1);
}

Func void print_nonlinear_pend()
{
	clear;
	print "\n";
	print "            《倒立振子の非線形状態方程式と出力方程式》\n\n\n";
	print "(状態ベクトル)                        (出力ベクトル)\n\n";
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
	print "                《方程式の係数と物理パラメータの関係》\n\n\n";
	print " [a32 a33 a34 a35 b3] = \n";
	print " [a42 a43 a44 a45 b4]\n\n";
	print "        [ -(m*l)^2*g -Fr*(J+m*l^2)  c*m*l  (J+m*l^2)*m*l (J+m*l^2)*a]\n";
	print "        [(M+m)*m*l*g    Fr*m*l    -(M+m)*c    -(m*l)^2     -(m*l)a  ] / alpah0\n\n";
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

	print "            《倒立振子の線形状態方程式と出力方程式》\n\n\n";
	print "(状態ベクトル)                        (出力ベクトル)\n\n";
	print "      [x1]   [         r [m]     ]    y := [y1] = [  cc1*r  ]\n";
	print " x := [x2] = [     theta [rad]   ]         [y2]   [cc2*theta]\n";
	print "      [x3]   [     dr/dt [m/s]   ]\n";
	print "      [x4]   [ dtheta/dt [rad/s] ]\n";
	print "\n";

	print "状態方程式:\n\n";
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, 0.0, 1.0, 0.0, 0.0);
	printf(" dx/dt = [% 8.4g % 8.4g % 8.4g % 8.4g ] x  +  [% 8.4g ] u\n",
		   0.0, 0.0, 0.0, 1.0, 0.0);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, a32, a33, a34, b3);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]       [% 8.4g ]\n",
		   0.0, a42, a43, a44, b4);
	print "\n";
	print "出力方程式:\n\n";
	printf("     y = [% 8.4g % 8.4g % 8.4g % 8.4g ] x\n",
		   cc1, 0.0, 0.0, 0.0);
	printf("         [% 8.4g % 8.4g % 8.4g % 8.4g ]\n",
		   0.0, cc2, 0.0, 0.0);
	print "\n";
	pause;
}

// 台車の静止摩擦の同定
Func void ident_static_friction()
{
	Integer i, j, yes_no;
	Real uu, duu, uu_sf_p, uu_sf_n;
	Matrix yy0, yy;

	void machine_ready_cart();

	machine_ready_cart();   // 実験装置の準備

	clear;
	gotoxy(5,5); print "台車の静止摩擦の同定";
	gotoxy(5,7); print "ESC: 同定を終了";

	duu = 0.1;  // 静止摩擦の精度

	// 正方向の静止摩擦の同定
	uu = 0.0;
	actuator(0.0);
	yy = yy0 = sensor();
	i = j = 0;
	do {
		gotoxy(5,10);
		printf("台車位置 = %8.4f[m], 入力(正方向) = %8.4f[N]", yy(1), uu);

		uu = i*duu;
		actuator(uu);
		yy = sensor();
		if (abs(yy0(1) - yy(1)) > 0.0) {
			actuator(0.0);
			uu_sf_p = uu;
			break;
		}
		if (j == 10) {
			i++;
			j = 0;
		} else {
			j++;
		}
    } while ( ! (kbhit() && getch() == 0x1b));

	pause 1; // １秒停止

	// 負方向の静止摩擦の同定
	uu = 0.0;
	actuator(0.0);
	yy = yy0 = sensor();
	i = j = 0;
	do {
		gotoxy(5,10);
		printf("台車位置 = %8.4f[m], 入力(負方向) = %8.4f[N]", yy(1), uu);

		uu = i*duu;
		actuator(-uu);
		yy = sensor();
		if (abs(yy0(1) - yy(1)) > 0.0) {
			actuator(0.0);
			uu_sf_n = uu;
			break;
		}
		if (j == 10) {
			i++;
			j = 0;
		} else {
			j++;
		}
    } while ( ! (kbhit() && getch() == 0x1b));

	gotoxy(5,13); printf("正方向の静止摩擦 sf_p = %8.4f [N]", uu_sf_p);
	gotoxy(5,14); printf("負方向の静止摩擦 sf_n = %8.4f [N]", uu_sf_n);
	print "\n\n";
	pause;

	yes_no = 1;
	print "同定されたパラメタ－を採用しますか？ [はい=1,いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		sf_p = uu_sf_p;
		sf_n = uu_sf_n;
	}
}

// 台車の質量と粘性摩擦係数を同定する
Func void ident_cart(for_pend)
	Integer for_pend;
{
	Integer end_i, nn, nn2, yes_no;
	Real end_time, dt, K, T, a0, m1, Fr;
	Array TT, RR, RRR, TT2, RR2;

	void experiment_pend(), verify_ident_cart();
	void set_parameter_pend(...), set_parameter_cart(...);

	smtime = 0.002;
	print "サンプリング周期 [s] :        ";
	read smtime;
	step_height = 7.0;
	print "ステップ入力の高さ [N] : ";
	read step_height;

	ident_flag = 1;
	experiment_pend();
	ident_flag = 0;

	if (log_count == 0 || max(abs(log_data(2,1:log_count))) < 1.0E-3) {
		warning("\n\nデータを測定できませんでした。\n\n");
		pause;
		return;
	}

	TT = [0:log_count-1]*smtime*mlc;
	RR = log_data(2,1:log_count);

	mgplot_reset(1);
	mgplot_subplot(1, 2, 2, 1);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "position[m]");
	mgplot_title(1, "Position of cart");
	mgplot(1, TT, RR, {"position"});
	pause;

	end_time = 0.4;
	if (max(TT) < end_time) {
		end_time = max(TT);
	}
	print "同定に使うデータの終端時間を指定して下さい。\n";
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

	mgplot_subplot(1, 2, 2, 3);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "position[m]");
	mgplot_title(1, "Position of cart");
	mgplot(1, TT, RR, {"position"});
	mgreplot(1, TT2, RR2, {""});
	pause;

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
	printf("台車の粘性摩擦係数 :   Fr = %16.8E\n\n", Fr);
	pause;
	
	verify_ident_cart(TT, RR, m1, Fr);

	yes_no = 1;
	print "同定されたパラメタ－を採用しますか？ [はい=1,いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		if (for_pend) {
			set_parameter_pend(1, m1, Fr);
		} else {
			set_parameter_cart(m1, Fr);
		}
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

	{RR2} = step_ss(A,B,C,D,1,TT);

	mgplot_subplot(1, 2, 2, 2);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[s]");
	mgplot_ylabel(1, "position[m]");
	mgplot_title(1, "Measured data & simulation result");
	mgplot(1, TT, [[RR][RR2]], {"measured data", "identified linear model"});
	pause;
}

Func void ident_pendulum()
{
	Real m2, l, g, lambda, tau, J, Cr, start_time, end_time;
	Integer i, start_i, end_i, mm, pp, yes_no;
	Array TT, TH, peak_value, peak_ratio;
	Index idx, peak_idx;

	void experiment_pend(), verify_ident_pendulum(), set_parameter_pend(...);
	Index find_peak();

	smtime = 0.002;
	print "サンプリング周期 [s] : ";
	read smtime;

	ident_flag = 2;
	experiment_pend();
	ident_flag = 0;

	if (log_count == 0 || max(abs(log_data(3,1:log_count))) < 1.0E-3) {
		warning("\n\nデータを測定できませんでした。\n\n");
		pause;
		return;
	}

	TT = [0:log_count-1]*smtime*mlc;
	TH = log_data(3,1:log_count);
	TH = TH .+ PI;

	mgplot_reset(1);
	mgplot_subplot(1, 2, 2, 1);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "theta[deg]");
	mgplot_title(1, "Angle of pendulum");
	mgplot(1, TT, TH/PI*180, {"theta"});

	start_time = 0.85;
	end_time = 5.5;
	if (max(TT) < end_time) {
		end_time = max(TT);
	}

	print "同定に使用するデータの時間を指定して下さい。\n";
	read start_time, end_time;
	start_i = min(find(start_time <= TT));
	end_i   = max(find(TT <= end_time));
	TT = TT(start_i:end_i);
	TH = TH(start_i:end_i);
	mm = Cols(TT);

	mgreplot(1, TT, TH/PI*180, {"theta"});

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
	printf("粘性摩擦係数 :   Cr = 2*lambda*(J + m2*l^2)/tau\n\n");

	J = tau^2*m2*l*g/(4*PI^2 + lambda^2) - m2*l^2;
	Cr = 2*lambda*(J + m2*l^2)/tau;

	printf("慣性モーメント(同定値) :   J = %16.8E\n", J);
	printf("粘性摩擦係数  (同定値) :  Cr = %16.8E\n\n", Cr);
	pause;
	
	verify_ident_pendulum(TT, TH, J, Cr);

	yes_no = 1;
	print "同定されたパラメタ－を採用しますか？ [はい=1,いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		set_parameter_pend(2, J, Cr);
	}
}

// 同定パラメタの確認
Func void verify_ident_pendulum(TT, TH, J, Cr)
	Array TT, TH;
	Real J, Cr;
{
	Real m2, l, g, dt, th0, dth0;
	Matrix A, B, C, D, x0;
	Array TH2;

	// 既知のパラメータ
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

	mgplot_subplot(1, 2, 2, 2);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[s]");
	mgplot_ylabel(1, "theta[deg]");
	mgplot_title(1, "Measured data & simulation result");
	mgplot(1, TT, [[TH][TH2]]/PI*180,
		   {"measured data", "identified linearlized model" });
	pause;
}

// 振動波形のピークを探す
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
		{tmpr, i3} = maximum(th(i1+1:i2));
		th(1:i2) = -ONE(1,i2);
		tt(i1+i3) = 1.0;
		peak_idx = [peak_idx, [i1+i3]];

//		tt((i1+i2)/2) = 1.0;
//		peak_idx = [peak_idx, [(i1+i2)/2]];
	}
	th2 = th0 * tt;
	t2 = t(find(tt));
	th2 = th2(find(th2));

	mgplot_subplot(1, 2, 2, 3);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[s]");
	mgplot_xlabel(1, "theta[deg]");
	mgplot_title(1, "Peak points of free response of pendulum");
	mgplot_cmd(1, "set data style points");
	mgplot(1, t, th0, {"theta"});
	mgreplot(1, t2, th2, {"peak"});
	mgplot_cmd(1, "set data style points");

	return peak_idx;
}
/////////////////////////////////////////////////////////////////////////////
//  モデリングと同定終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  解  析
/////////////////////////////////////////////////////////////////////////////
Func void analysis_pend()
{
	List analysis_menu;
	void tfunc_pole_pend(), ctr_obs();
	
	analysis_menu = {"《制 御 系 解 析》",
					 "伝達関数行列と極",
					 "可制御性と可観測性",
					 "終  了"};
	
	while (1) {
		switch (menu(analysis_menu)) {
		  case 1: tfunc_pole_pend(); break;
		  case 2: ctr_obs(); break;
		  case 3: return;
		  default: return;
		}
	}
}

// 伝達関数行列と極
Func void tfunc_pole_pend()
{
	RaMatrix G;
	Rational g1, g2;
	Polynomial nu1, nu2, de1, de2;
	CoMatrix poles_of_plant;

	G = ss2tfm(A,B,C,D);
	g1 = G(1,1);
	g2 = G(2,1);
	nu1 = Nu(g1);
	nu2 = Nu(g2);
	de1 = De(g1);
	de2 = De(g2);
	if (degree(nu1) >= 3) {
		nu1(3) = 0;
	}
	if (degree(nu2) >= 3) {
		nu2(3) = 0;
	}
	if (degree(nu2) >= 1) {
		nu2(1) = 0;
	}
	g1 = nu1/de1;
	g2 = nu2/de2;

	clear;
	print "\n";
	print "伝達関数行列: G = [ g1 ]\n";
	print "                  [ g2 ]\n\n";
	print g1, "\n", g2;

	poles_of_plant = eigval(A);

	print "\nシステムの極 :\n\n";
	print poles_of_plant;

	if (max(Re(poles_of_plant)) < 0.0) {
		print "\n ---> システムは安定です。\n\n";
	} else {
		print "\n ---> システムは不安定です。\n\n";
	}

	pause;
}

Func void ctr_obs()
{
	 Integer i;
	 Matrix V, N;

	 V = ctrm(A, B);
	 N = obsm(A, C);

	 clear;
	 print "\n";
	 print "         《 可制御性と可観測性 》\n\n\n";
	
	 print "可制御性行列 V = [B";
	 for (i = 2; i <= Rows(A); i++) {
		  if (i == 2) {
			   print " AB";
		  } else {
			   printf(" A^%dB", i-1);
		  }
	 }
	 printf("] のランク = %d\n\n", rank(V));
	 
	 if (rank(V) == Rows(A)) {
		  printf("    ---> システムは可制御です。\n\n");
	 } else {
		  printf("    ---> システムは不可制御です。\n\n");
	 }
	 
	 print "可観測性行列 N = [[C]";
	 for (i = 2; i <= Rows(A); i++) {
		  if (i == 2) {
			   print "[CA]";
		  } else {
			   printf("[CA^%d]", i-1);
		  }
	 }
	 printf("] のランク = %d\n\n", rank(N));
	 
	 if (rank(N) == Rows(A)) {
		  print "    ---> システムは可観測です。\n\n";
	 } else {
		  print "    ---> システムは不可観測です。\n\n";
	 }
	 
	 pause;
}

/////////////////////////////////////////////////////////////////////////////
//  解析終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  設  計
/////////////////////////////////////////////////////////////////////////////
Func void design_pend()
{
	List design_menu;
	void design_pend_lq(...), design_pend_lq_servo(...);
	void design_pend_obs(...), design_static_friction(...);

	design_menu = {"《制 御 系 設 計》", 
				   "LQ 最適レギュレータ",
				   "LQ 最適サーボ系",
				   "最小次元オブザーバ",
				   "静止摩擦の補償",
				   "終  了"};
	
	while (1) {
		switch (menu(design_menu)) {
		  case 1: design_pend_lq(0); servo_flag = 0; break;
		  case 2: design_pend_lq_servo(0); servo_flag = 1; break;
		  case 3: design_pend_obs(0); break;
		  case 4: design_static_friction(0); break;
		  case 5: return;
		  default: return;
	   }
	}
}

Func void design_static_friction(batch, ...)
	Integer batch;
{
	if (nargs < 1 || 2 < nargs) {
		error("design_static_friction(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}
	
	if (batch == 1) {
		u_sf_p = 0.0;
		u_sf_n = 0.0;
		return;
	}

	clear;
	print "\n";
	print "《 静止摩擦の補償 》\n\n\n";
	pause "静止摩擦をを入力して下さい。";
	print "正方向の静止摩擦補償 [N] : "; read u_sf_p;
	print "\n";
	print "負方向の静止摩擦補償 [N] : "; read u_sf_n;
	print "\n";
	pause;
}

// LQ 最適レギュレータの設計
Func void design_pend_lq(batch, ...)
	Integer batch;
{
	CoMatrix closed_loop_poles;
	Integer m, n, p, yes_no;
	RaMatrix GC;
	Rational gc1, gc2;
	Polynomial nu1, nu2, de1, de2;

	void plot_poles();
	
	if (nargs < 1 || 2 < nargs) {
		error("design_pend_lq(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}

	m = Cols(B);
	p = Rows(C);
	n = Cols(A);

	if (pend_lq_flag == 0) {
		pend_lq_flag = 1;
		Q = diag(1.0E4, 1.0E4, 1.0, 1.0);
		R = I(m);
		observer_poles = (-20*ONE(n-p,1),*);
		smtime = 0.002;
	}

	if (batch == 1) {
		{F_off} = lqr(A, B, Q, R);
		parameter_update = 1;
		return;
	}
	
	clear;
	print "\n";
	print "《LQ 最適レギュレータ》\n\n\n";
	pause "重み行列 Q と R を入力して下さい。";
	edit Q, R;
	{F} = lqr(A, B, Q, R);
	closed_loop_poles = eigval(A - B*F);
	
	clear;
	print "\n";
	print "《LQ 最適レギュレータ》\n\n\n";
	print "最適フィードバックゲイン:\n\n";
	print F;
	print "\n";
	print "閉ループ系の極:\n\n";
	print closed_loop_poles;
	print "\n";
	pause;

	// 閉ループ系の伝達関数を計算
	GC = ss2tfm(A - B*F, B, C, D);
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
	print "《LQ 最適レギュレータ》\n\n";
	print "閉ループ系の伝達関数行列: Gc = [ gc1 ]\n";
	print "                               [ gc2 ]\n\n\n";
	print gc1, "\n", gc2;
	print "\n";

	// 閉ループ系のボード線図をプロットする
	yes_no = 0;
	print "\n\n閉ループ系のボード線図をプロットしますか？\n\n";
	print "[はい=1, いいえ=0] : ";
	read yes_no;

	if (yes_no == 1) {
		mgplot_cur_win(3);
		bode_plot_ss(A-B*F,B,C,D,1);
	}

	// 閉ループ系の極とオブザーバの極をプロットする
	yes_no = 0;
	print "\n\n閉ループ系とオブザーバの極をプロットしますか？\n\n";
	print "[はい=1, いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		plot_poles(closed_loop_poles, observer_poles,
				   "closed-loop poles", "observer poles");
	}

	// コントローラのパラメータを設定する
	F_off = F;
	parameter_update = 1;
}

// 最小次元オブザーバの設計
Func void design_pend_obs(batch, ...)
	Integer batch;
{
	Matrix Ah, Bh, Ch, Dh, Jh, Ahd, Bhd, Chd, Dhd, Jhd, Phi, Gamma;
	CoMatrix closed_loop_poles;
	Integer m, n, p, yes_no;

	void plot_poles();

	if (nargs < 1 || 2 < nargs) {
		error("design_pend_obs(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}

	m = Cols(B);
	p = Rows(C);
	n = Cols(A);

	if (pend_obs_flag == 0) {
		pend_obs_flag = 1;
		observer_poles = (-20*ONE(n-p,1),*);
		smtime = 0.002;
	}
	
	if (batch == 1) {
                {Ah, Bh, Ch, Dh, Jh} = obsg(A, B, C, observer_poles);
                {Phi, Gamma} = c2d(Ah, [Bh Jh], smtime);
		Ahd_off = Phi;
		Bhd_off = Gamma(:,1:p);
		Chd_off = Ch;
		Dhd_off = Dh;
		Jhd_off = Gamma(:,p+1:p+m);
		parameter_update = 1;
		return;
	}

	clear;
	print "\n";
	print "《最小次元オブザーバ》\n\n\n";
	pause "オブザーバの極を入力して下さい。";
	edit observer_poles;
        {Ah, Bh, Ch, Dh, Jh} = obsg(A, B, C, observer_poles);

	// オブザーバの離散化
	clear;
	print "\n";
	print "《オブザーバの離散化》\n\n\n";
	print "サンプリング周期 [s] : ";
	read smtime;
        {Phi, Gamma} = c2d(Ah, [Bh Jh], smtime);
	Ahd = Phi;
	Bhd = Gamma(*,1:p);
	Chd = Ch;
	Dhd = Dh;
	Jhd = Gamma(*,p+1:p+m);

	// 閉ループ系の極とオブザーバの極をプロットする
	yes_no = 0;
	print "\n\n閉ループ系とオブザーバの極をプロットしますか？\n\n";
	print "[はい=1, いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		closed_loop_poles = eigval(A - B*F);
		plot_poles(closed_loop_poles, observer_poles,
				   "closed-loop poles", "observer poles");
	}

	// コントローラのパラメータを設定する
	Ahd_off = Ahd;
	Bhd_off = Bhd;
	Chd_off = Chd;
	Dhd_off = Dhd;
	Jhd_off = Jhd;
	parameter_update = 1;
}

// LQ 最適サーボ系の設計
Func void design_pend_lq_servo(batch, ...)
	Integer batch;
{
	Matrix Ae, Be, Pe, Fe, F, F2;
	CoMatrix closed_loop_poles;
	Integer m, n, p, yes_no;

	void plot_poles();

	if (nargs < 1 || 2 < nargs) {
		error("design_pend_lq_servo(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}

	m = Cols(B);
	p = Rows(C);
	n = Cols(A);

	Ae = [[  A   , Z(n,1)]
		  [C(1,:), Z(1,1)]];
	Be = [[ B  ]
		  [Z(1)]];

	if (pend_lq_servo_flag == 0) {
		pend_lq_servo_flag = 1;
		Q = diag(1.0E5, 1.0E4, 1.0E2, 1.0);
		R = I(m);
		QQe = diag(Q, [1.0E3]);
		RRe = R;
		observer_poles = (-30*ONE(n-p,1),*);
		smtime = 0.002;
	}
	
	if (batch == 1) {
		Pe = Riccati(Ae, Be, QQe, RRe);
		Fe = RRe~*Be'*Pe;
		F_off = Fe(1,1:n);
		F2_off = Fe(1,n+1:n+1);
		parameter_update = 1;
		return;
	}

	clear;
	print "\n";
	print "《 LQ 最適サーボ系 》\n\n\n";
	pause "重み行列 QQe と RRe を入力して下さい。";
	edit QQe, RRe;
	Pe = Riccati(Ae, Be, QQe, RRe);
	Fe = RRe~*Be'*Pe;
	F = Fe(1,1:n);
	F2 = Fe(1,n+1:n+1);

	clear;
	print "\n";
	print "《LQ 最適サーボ系》\n\n\n";
	print "最適フィードバックゲイン:\n\n";
 	print F, "\n";
 	print F2, "\n";
	pause;

	// コントローラのパラメータを設定する
	F_off = F;
	F2_off = F2;
	parameter_update = 1;
}

Func void plot_poles(pole1, pole2, name1, name2)
	CoMatrix pole1, pole2;
	String name1, name2;
{
	CoArray po1, po2;
	Real xmax, xmin, ymax, ymin;
	Integer yes_no;

	mgplot();		// "mgplot.mm"を読み込む

	po1 = trans(pole1);
	po2 = trans(pole2);
	xmax = max([Re(po1), Re(po2)]);
	xmin = min([Re(po1), Re(po2)]);
	ymax = max([Im(po1), Im(po2)]);
	ymin = min([Im(po1), Im(po2)]);
	if (xmax <= 0.0) {
		xmax = - xmin/4;
	}
	if (xmin >= 0.0) {
		xmin = - xmax/4;
	}

	if (abs(ymin - ymax) < 1.0E-6) {
		ymax = 1.0;
		ymin = -1.0;
	}

	if (any_graph2 == 1) {
		yes_no = 1;
		print "    グラフをリセットしますか？ [はい=1, いいえ=0] : ";
		read yes_no;
		if (yes_no == 1) {
			any_graph2 = 0;
			mgplot_reset(2);
		}
	} else {
		mgplot_reset(2);
	}

	if (any_graph2 == 0) {
		mgplot_cmd(2, "set data style points");
		mgplot_xlabel(2, "Re");
		mgplot_ylabel(2, "Im");
		mgplot_title(2, name1 + " and " + name2);
		mgplot_cmd(2, sprintf("set xrange [%g:%g]", 1.5*xmin, 1.5*xmax));
		mgplot_cmd(2, sprintf("set yrange [%g:%g]", 1.5*ymin, 1.5*ymax));
		mgplot(2, Re(po1), Im(po1), {name1});
		mgreplot(2, Re(po2), Im(po2), {name2});
	} else {
		mgplot_cmd(2, sprintf("set xrange [%g:%g]", 1.5*xmin, 1.5*xmax));
		mgplot_cmd(2, sprintf("set yrange [%g:%g]", 1.5*ymin, 1.5*ymax));
		mgreplot(2, Re(po1), Im(po1), {name1});
		mgreplot(2, Re(po2), Im(po2), {name2});
	}

	print "\n";
	pause;
	any_graph2 = 1;
}
/////////////////////////////////////////////////////////////////////////////
//  設計終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  シミュレーション
/////////////////////////////////////////////////////////////////////////////
Func void simulation_pend()
{
	Integer yes_no;
	String filename;
	Real r0, th0, tf, dt;
	Matrix x0;
	Array TT, XX, UY;

	void diff_eqs_pend(), link_eqs_pend(), draw_graph_pend(...);

	r0 = 0.0;	// 台車の初期位置 [m]
	th0 = 10.0;	// 振子の初期角度 [deg]
	tf = 3.0;	// シミュレーション時間 [sec]
	dt = smtime;

	clear;
	print "\n";
	print "《倒立振子のシミュレーション》\n\n\n";
	print "台車の初期位置 [m]         :  "; read r0;
	print "振子の初期角度 [deg]       : "; read th0;
	print "シミュレーション時間 [sec] :  "; read tf;

	x0 = [r0 th0/180.0*PI 0 0]';  // 初期状態
	z = Z(2,1);                   // オブザーバの初期状態
	y_old = C*x0;                 // 出力の初期値
	if (servo_flag) {
		err_sum = 0;
	}

	print "\n";
	{TT, XX, UY} = Ode45HybridAuto(0.0, tf, dt, x0,
					diff_eqs_pend, link_eqs_pend, 1.0E-6, tf/400);
	print "\n\n";

	draw_graph_pend(TT, UY, XX);

	print "\n\n";
	yes_no = 0;
	print "データを保存しますか？ [はい=1, いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		read filename;
		print [[TT][UY][XX]] >> filename;
	}
}

Func void show_graph_pend()
{
	if (any_graph == 0) {
		warning("グラフは 1 個も存在しません。\n\n");
		pause;
		return;
	}
	
	mgplot_replot(1);
}

Func void draw_graph_pend(TT, UY, XX, ...)
	Array TT, UY, XX;
{
	Integer yes_no;
	
	if (nargs < 2 || 3 < nargs) {
		error("draw_graph_pend(): 引数の数が正しくありません\n");
	}

	if (any_graph == 1) {
		yes_no = 1;
		print "    グラフをリセットしますか？ [はい=1, いいえ=0] : ";
		read yes_no;
		if (yes_no == 1) {
			any_graph = 0;
			mgplot_reset(1);
		}
	} else {
		mgplot_reset(1);
	}

	mgplot_subplot(1, 2, 2, 1);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "r[m]");
	mgplot_title(1, "Position of cart");
	if (any_graph == 0) {
		mgplot(1, TT, UY(Index([2,4]),:), {"position", "reference"});
	} else {
		mgreplot(1, TT, UY(Index([2,4]),:),	{"position", "reference"});
	}

	mgplot_subplot(1, 2, 2, 2);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "theta[deg]");
	mgplot_title(1, "Angle of pendulum");
	if (any_graph == 0) {
		mgplot(1, TT, UY(3,:)/PI*180, {"theta"});
	} else {
		mgreplot(1, TT, UY(3,:)/PI*180, {"theta"});
	}

	mgplot_subplot(1, 2, 2, 3);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "input[N]");
	mgplot_title(1, "Control input");
	if (any_graph == 0) {
		mgplot(1, TT, UY(1,:), {"input"});
	} else {
		mgreplot(1, TT, UY(1,:), {"input"});
	}

	if (nargs == 3) {
		mgplot_subplot(2, 1, 2, 1);
		mgplot_grid(2, 1);
		mgplot_xlabel(2, "time[sec]");
		mgplot_ylabel(2, "dr[m/sec]");
		mgplot_title(2, "Velocity of cart");
		if (any_graph == 0) {
			mgplot(2, TT, XX(3,:), {"velocity"});
		} else {
			mgreplot(2, TT, XX(3,:), {"velocity"});
		}

		mgplot_subplot(2, 1, 2, 2);
		mgplot_grid(2, 1);
		mgplot_xlabel(2, "time[sec]");
		mgplot_ylabel(2, "d_theta[deg/sec]");
		mgplot_title(2, "Angular velocity of pendulum");
		if (any_graph == 0) {
			mgplot(2, TT, XX(4,:), {"angular velocity"});
		} else {
			mgreplot(2, TT, XX(4,:), {"angular velocity"});
		}
	}

	pause;

	any_graph = 1;
}

// 倒立振子の状態方程式
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

	// 静止摩擦の影響
	if (abs(x(3)) < 0.05) {
		if (0 < u && u < sf_p) {
			u = 0;
		} else if (- sf_n < u && u < 0) {
			u = 0;
		}
	}

	c2 = cos(x2);
	s2 = sin(x2);
	determ = (1 + alpha*s2^2);

	dx = Z(4,1);
	dx(1) = x(3);
	dx(2) = x(4);
	dx(3) = (a32*s2*c2 + a33*x3 + a34*c2*x4 + a35*s2*x4^2 + b3*u)/determ;
	dx(4) = (a42*s2 + a43*c2*x3 + a44*x4 + a45*s2*c2*x4^2 + b4*c2*u)/determ;


	// 静止摩擦の影響
	if (u == 0) {
		if (abs(dx(3)) < 0.05 && abs(x(3)) < 0.05) {
			dx(1) = 0;
			dx(3) = 0;
		}
	}
	if (abs(dx(4)) < 0.05 && abs(x(4)) < 0.05) {
		dx(2) = 0;
		dx(4) = 0;
	}
}

// 倒立振子の入出力関係
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
		if (servo_flag) {
			F2  = F2_off;
		}
	}

	y = C*x;                     // 制御対象の出力
	xh = Chd*z + Dhd*y;          // 状態の推定値
	if (servo_flag) {
		err_sum = err_sum + y(1)*smtime;
		u = - F*xh - F2*err_sum; // 制御入力
	} else {
		u = - F*xh;              // 制御入力
	}

	// 静止摩擦補償
	if (abs(y(1) - y_old(1)) < 1.0E-6) {
		if (u(1) > 0) {
			u(1) = u(1) + u_sf_p;
		} else if (u(1) < 0) {
			u(1) = u(1) - u_sf_n;
		}
	}

	y_old = y;

	z = Ahd*z + Bhd*y + Jhd*u;   // 観測器の状態を更新

	// 最大入力 = u_max
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
Func void experiment_pend()
{
	String filename;
	Integer yes_no;
	Array TT, UY;

	void var_init_pend(), off_task_loop(), on_task_pend(), break_task();
	void machine_ready_pend(), machine_stop(), draw_graph_pend(...);
	void on_task_ident();

	machine_ready_pend();   // 実験装置の準備
	var_init_pend();        // 変数の初期化(machine_ready()のあと)
	rtSetClock(smtime);     // サンプリング周期の設定
	if (ident_flag) {
		rtSetTask(on_task_ident);	// オンライン関数の設定(同定)
	} else {
		rtSetTask(on_task_pend);	// オンライン関数の設定(制御)
	}
	rtSetBreak(break_task); // 割り込みキーに対応する関数の設定

	rtStart();              // リアルタイム制御開始
	off_task_loop();        // オフライン関数
	rtStop();               // リアルタイム制御終了

	machine_stop();         // 実験装置を停止

	if (ident_flag == 0 && log_count > 1) {
		print "\n\n";
		print "    グラフを描画しますか？ [はい=1, いいえ=0] ";
		yes_no = 1;
		read yes_no;
		if (yes_no == 1) {
			TT = [0:log_count-1]*smtime*mlc;
			UY = log_data(:,1:log_count);
			draw_graph_pend(TT, UY);
		}

		print "\n\n";
		print "    データを保存しますか？ [はい=1, いいえ=0] : ";
		yes_no = 0;
		read yes_no;
		if (yes_no == 1) {
			read filename;
			TT = [0:log_count-1]*smtime*mlc;
			UY = log_data(:,1:log_count);
			print [[TT][UY]] >> filename;
		}
	}
}

// 変数の初期化
Func void var_init_pend()
{
	ref = 0.0;
	cmd = 0;
	log_flag = 0;
	disturb_flag = 0;
	log_count = 0;
	lc = 0;
	mlc = 10;

	z = Z(2,1);             // オブザーバのの初期状態
	xh = Z(4,1);            // 状態の推定値の初期値
	y_old = sensor();       // 台車の位置の初期値
	if (servo_flag) {
		err_sum = 0;
	}
	log_data = Z(4,LOGMAX); // ロギングデータ
}

// 実験装置の準備
Func void machine_ready_pend()
{
	sensor_init();     // センサの初期化
	actuator_init();   // アクチュエータの初期化

	gotoxy(5,5); print "台車の初期位置 : レールの中央";
	gotoxy(5,6); print "振子の初期位置 : 真下";

	gotoxy(5,9);
	pause "台車と振子を初期位置に移動し，リターンキーを入力して下さい。";
	gotoxy(5,9);
	print "　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　";
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

// 倒立振子の制御のオンライン関数
Func void on_task_pend()
{
	Real u_max;

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
		if (servo_flag) {
			F2 = F2_off;
		}
	}

	if (ident_flag) {
		y = sensor();			// センサから入力
		u = Z(1);
	} else {
		y = sensor();			// センサから入力
		xh = Chd*z + Dhd*y;		// 状態を推定
		xh(1) = xh(1) - ref;
		if (servo_flag) {
			err_sum = err_sum + (y(1) - ref)*smtime;
			u = - F*xh - F2*err_sum; // LQ 最適サーボ系制御入力
		} else {
			u = - F*xh;              // LQ 最適レギュレータ制御入力
		}

		if (disturb_flag) {
			u = u + [10];
		}

		// 静止摩擦補償
		if (y(1) == y_old(1)) {
			if (u(1) > 0) {
				u(1) = u(1) + u_sf_p;
			} else if (u(1) < 0) {
				u(1) = u(1) - u_sf_n;
			}
		}

		// オブザーバを更新
		z = Ahd*z + Bhd*y + Jhd*u;

		y_old = y;
	}

	// 最大入力 = u_max
	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}
	
	if (cmd == 1 && ! rtIsRehearsal()) {
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

// 同定用のオンライン関数
Func void on_task_ident()
{
	Real t, step_height2;

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
	
	if (( ! rtIsRehearsal()) && (cmd == 1 || ident_flag != 0)) {
		actuator(u(1));		// アクチュエータへ出力
	}

	// ロギングデータ
	if (log_flag == 1 || ( (! rtIsRehearsal()) && ident_flag != 0)) {
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

	gotoxy(5, 5); print "'d': ステップ外乱";
	gotoxy(5, 6); print "'c': アクチュエータへ出力開始";
	gotoxy(5, 7); print "ESC: アクチュエータへ出力停止";
	gotoxy(5, 8); print "'l': ロギング開始と停止";
	gotoxy(5, 9); print "'r': 台車の目標値を変更";

	do {
		gotoxy(5, 11);
		printf("  台車位置 = %8.4f[m], 振子角度 = %8.4f[deg]",
			   y(1), y(2)/PI*180);
		gotoxy(5, 12);
		printf("台車目標値 = %8.4f[m],     入力 = %10.4f[N]", ref, u(1));

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
		/* ESC */  case 0x1b:
				end_flag = 1;
				break;
		/* 'R' */  case 0x52:
		/* 'r' */  case 0x72:
				gotoxy(5, 16);
				print "台車の目標値 [m] : "; read ref;
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
		/* 'd' */  case 0x44:
		/* 'D' */  case 0x64:
				if (disturb_flag) {
					disturb_flag = 0;
				} else {
					disturb_flag = 1;
				}
				break;
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

// 台車の位置制御(メイン関数)
Func void main_cart()
{
	List main_menu;
	void set_parameter_cart(...), design_cart(), analysis_cart();
	void simulation_cart(), modelling_ident_cart(), experiment_cart();
	void show_graph_cart();

	main_menu = {"《台 車 の 制 御》",
				 "モデリングと同定",
				 "制 御 系 解 析",
				 "制 御 系 設 計",
				 "シミュレーション",
				 "制  御  実  験",
				 "データプロット",
				 "終  了"};

	any_graph = 0;
	ident_flag = 0;
	mgplot();			// "mgplot.mm"を読み込む
	set_parameter_cart();

	while (1) {
		switch (menu(main_menu)) {
		  case 1: modelling_ident_cart(); break;
		  case 2: analysis_cart(); break;
		  case 3: design_cart(); break;
		  case 4: simulation_cart(); break;
		  case 5: experiment_cart(); break;
		  case 6: show_graph_cart(); break;
		  case 7: return;
		}
	}
}


/////////////////////////////////////////////////////////////////////////////
//  モデリングと同定
/////////////////////////////////////////////////////////////////////////////
Func void modelling_ident_cart()
{
	List ident_menu;
	void ident_cart(), print_linear_cart(), ident_static_friction();

	ident_menu = {"《モ デ リ ン グ と 同 定》",
				  "台車の静止摩擦の同定",
				  "台車系の質量と粘性摩擦係数の同定",
				  "状態方程式と出力方程式",
				  "終  了"};
	
	while (1) {
		switch (menu(ident_menu)) {
		  case 1: ident_static_friction(); break;
		  case 2: ident_cart(0); break;
		  case 3: print_linear_cart(); break;
		  case 4: return;
		  default: return;
	   }
	}
}

// 制御対象(台車)のパラメータを設定
Func void set_parameter_cart(para1, para2, ...)
	Real para1, para2;
{
	Real m1, Fr, a0;
	void design_cart_poleassign(...), design_cart_damp_nat(...);
	void desgin_static_friction(...);

	if (nargs != 0 && nargs != 2) {
		warning("set_parameter_cart(): 引数の数が正しくありません。\n");
		return;
	}

	cart_poleassign_flag = 0;
	cart_damp_nat_flag = 0;

	m1 = 0.16;
	Fr = 2.6;
	a0 = 0.1;

	// 同定されたパラメータ
	if (nargs == 2) {
		m1 = para1;
		Fr = para2;
	}

	cc1 = 1.0;

	A = [[ 0,    1  ]
		 [ 0, -Fr/m1]];

	B = [[ 0   ]
		 [a0/m1]];

	C = [cc1 0];

	D = [0];

	// デフォルトのコントローラの設計
	design_cart_poleassign(1);
	design_cart_damp_nat(1);
	design_static_friction(1);
}

Func void print_linear_cart()
{
	clear;
	print "\n";

	print "            《台車の状態方程式と出力方程式》\n\n\n";
	print "(状態ベクトル)                    (出力ベクトル)\n\n";
	print "      [x1] := [     r [m]   ]     y := [y1] = [ cc1*r ]\n";
	print "      [x2]    [ dr/dt [m/s] ]\n";
	print "\n";

	print "状態方程式:\n\n";
	printf(" dx/dt = [% 8.4g % 8.4g ] x  +  [% 8.4g ] u\n", 0.0, 1.0, 0.0);
	printf("         [% 8.4g % 8.4g ]       [% 8.4g ]\n", 0.0, A(2,2), B(2,1));

	print "\n";
	print "出力方程式:\n\n";
	printf("     y = [% 8.4g % 8.4g ] x\n", C(1,1), 0.0);
	print "\n";
	pause;
}
/////////////////////////////////////////////////////////////////////////////
//  モデリングと同定終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  解  析
/////////////////////////////////////////////////////////////////////////////
Func void analysis_cart()
{
	List analysis_menu;
	void tfunc_pole_cart(), ctr_obs(), bode_plot_cart();
	
	analysis_menu = {"《制 御 系 解 析》",
					 "伝達関数行列と極",
					 "可制御性と可観測性",
					 "ボード線図",
					 "終  了"};
	
	while (1) {
		switch (menu(analysis_menu)) {
		  case 1: tfunc_pole_cart(); break;
		  case 2: ctr_obs(); break;
		  case 3: bode_plot_cart(); break;
		  case 4: return;
		  default: return;
		}
	}
}

Func void tfunc_pole_cart()
{
	RaMatrix G;
	Rational g;
	CoMatrix poles_of_plant;

	G = ss2tfm(A, B, C, D);
	g = G(1,1);

	clear;
	print "\n";
	print "伝達関数:\n\n";
	print g, "\n";

	poles_of_plant = eigval(A);

	print "\n";
	print "システムの極 :\n\n";
	print poles_of_plant;
	print "\n";
	if (max(Re(poles_of_plant)) < 0.0) {
		print " ---> システムは安定である。\n";
	} else {
		print " ---> システムは不安定である。\n";
	}

	print "\n";
	pause;
}

Func void bode_plot_cart()
{
	bode_plot_ss(A, B, C, D, 1);

	clear;
	print "\n";
	print "       《 ボード線図 》\n\n\n";
	pause;
}

/////////////////////////////////////////////////////////////////////////////
//  解析終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  設  計
/////////////////////////////////////////////////////////////////////////////
Func void design_cart()
{
	List design_menu;
	void design_cart_poleassign(...), design_cart_damp_nat(...);
	void desgin_static_friction(...);

	design_menu = {"《制 御 系 設 計》", 
				   "極  指  定",
				   "減衰係数/自然角周波数指定",
				   "静 止 摩 擦 の 補 償",
				   "終  了"};
	
	while (1) {
		switch (menu(design_menu)) {
		  case 1: design_cart_poleassign(0); break;
		  case 2: design_cart_damp_nat(0); break;
		  case 3: design_static_friction(0); break;
		  case 4: return;
		  default: return;
	   }
	}
}

Func void design_cart_poleassign(batch, ...)
	Integer batch;
{
	Integer yes_no;
	Real wn, xi;
	Matrix F;
	CoMatrix open_loop_poles;
	RaMatrix GC;
	Rational Gc;

	void plot_poles();

	if (nargs < 1 || 2 < nargs) {
		error("design_cart_poleassign(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}

	if (cart_poleassign_flag == 0) {
		cart_poleassign_flag = 1;
		closed_loop_poles = [[(-3.0,  10.0)]
							 [(-3.0, -10.0)]];
		smtime = 0.002;
	}
	
	if (batch == 1) {
		F_off = PoleAssign(A, B, closed_loop_poles);
		parameter_update = 1;
		return;
	}

	clear;
	print "\n";
	print "《極指定による設計》\n\n\n";

	pause "閉ループ系の極を指定して下さい。";

	open_loop_poles = eigval(A);
	edit closed_loop_poles;
	wn = sqrt(Re(prod(closed_loop_poles)));
	xi = - Re(sum(closed_loop_poles))/wn/2;
	closed_loop_damp = xi;
	closed_loop_nat = wn;

	F = PoleAssign(A, B, closed_loop_poles);
	GC = ss2tfm(A+B*F, B, C, D);
	Gc = GC(1,1);

	clear;
	print "\n";
	print "《極指定による設計》\n\n\n";

	print "閉ループ系の極:\n\n";
	print closed_loop_poles;
	print "\n";

	print "\n閉ループ系の伝達関数:\n\n";
	print Gc;
	print "\n";

	// 閉ループ系のボード線図をプロットする
	yes_no = 0;
	print "閉ループ系のボード線図をプロットしますか？\n\n";
	print "[はい=1, いいえ=0] : ";
	read yes_no;

	if (yes_no == 1) {
		bode_plot_ss(A+B*F, B, C, D, 1);
		print "\n";
		pause;
	}

	// コントローラのパラメータを設定する
	F_off = F;
	parameter_update = 1;
}

Func void design_cart_damp_nat(batch, ...)
	Integer batch;
{
	Integer yes_no;
	Real wn, xi;
	Matrix F;
	CoMatrix open_loop_poles;
	RaMatrix GC;
	Rational Gc;

	void plot_poles();

	if (nargs < 1 || 2 < nargs) {
		error("design_cart_damp_nat(): 引数の数が正しくありません\n");
	}
	if (nargs == 0) {
		batch = 1;
	}

	if (cart_damp_nat_flag == 0) {
		cart_damp_nat_flag = 1;
		closed_loop_damp = 0.3;
		closed_loop_nat  = 10.0;
		smtime = 0.002;
	}
	
	if (batch == 1) {
		xi = closed_loop_damp;
		wn = closed_loop_nat;
		closed_loop_poles = roots($^2 + 2*xi*wn*$ + wn^2);
		F_off = PoleAssign(A, B, closed_loop_poles);
		parameter_update = 1;
		return;
	}

	clear;
	print "\n";
	print "《減衰係数/自然角周波数指定による極配置》\n\n\n";

	open_loop_poles = eigval(A);
	print "減衰係数:    ";
	read closed_loop_damp;
	print "自然角周波数: ";
	read closed_loop_nat;
	xi = closed_loop_damp;
	wn = closed_loop_nat;
	closed_loop_poles = roots($^2 + 2*xi*wn*$ + wn^2);
	F = PoleAssign(A, B, closed_loop_poles);
	GC = ss2tfm(A+B*F, B, C, D);
	Gc = GC(1,1);

	print "\n閉ループ系の伝達関数:\n";
	print Gc;
	print "\n\n";

	// 閉ループ系のボード線図をプロットする
	yes_no = 0;
	print "閉ループ系のボード線図をプロットしますか？\n\n";
	print "[はい=1, いいえ=0] : ";
	read yes_no;

	if (yes_no == 1) {
		bode_plot_ss(A+B*F, B, C, D, 1);
		print "\n";
		pause;
	}

	// コントローラのパラメータを設定する
	F_off = F;
	parameter_update = 1;
}

/////////////////////////////////////////////////////////////////////////////
//  設計終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  シミュレーション
/////////////////////////////////////////////////////////////////////////////
Func void simulation_cart()
{
	Integer yes_no;
	Real r0, tf, dt;
	String filename;
	Matrix x0;
	Array TT, XX, UY;

	void diff_eqs_cart(), link_eqs_cart(), draw_graph_cart(...);

	tf = 3.0;	// [sec]
	r0 = 0.07;	// [m]
	dt = smtime;

	clear;
	print "\n";
	print "《台車のシミュレーション》\n\n\n";
	print "台車の初期位置 [m]         :  "; read r0;
	print "シミュレーション時間 [sec] :  "; read tf;

	x0 = [r0 0]';

	print "\n";
	{TT, XX, UY} = Ode45HybridAuto(0.0, tf, dt, x0,
					diff_eqs_cart, link_eqs_cart, 1.0E-6, tf/400);
	print "\n\n";

	draw_graph_cart(TT, UY, XX);

	print "\n\n";
	yes_no = 0;
	print "データを保存しますか？ [はい=1, いいえ=0] : ";
	read yes_no;
	if (yes_no == 1) {
		read filename;
		print [[TT][UY][XX]] >> filename;
	}
}

// 台車の状態方程式
Func void diff_eqs_cart(dx, t, x, uy)
	Matrix dx, x, uy;
	Real t;
{
	dx = A*x + B*uy(1);
}

// 倒立振子の入出力関係
Func void link_eqs_cart(uy, t, x)
	Matrix uy, x;
	Real t;
{
	Real u_max;
	u_max = 20.0;

	if (parameter_update) {
		parameter_update = 0;
		F   = F_off;
	}

	y = C*x;	// 制御対象の出力
	u = F*x;	// 制御入力
	
	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}

	uy = [[u][y][ref]];

	printf("時間 = %7.3f[s]: 台車 = %8.4f[m], 入力 = %8.4f[N]\r",t,y(1),u(1));
}

Func void show_graph_cart()
{
	if (any_graph == 0) {
		warning("グラフは 1 個も存在しません。\n\n");
		pause;
		return;
	}
	
	mgplot_replot(1);
	mgplot_replot(3);
	mgplot_replot(4);
}

Func void draw_graph_cart(TT, UY, XX, ...)
	Array TT, UY, XX;
{
	Integer yes_no;
	
	if (nargs < 2 || 3 < nargs) {
		error("draw_graph_cart(): 引数の数が正しくありません\n");
	}

	if (any_graph == 1) {
		yes_no = 1;
		print "    グラフをリセットしますか？ [はい=1, いいえ=0] : ";
		read yes_no;
		if (yes_no == 1) {
			any_graph = 0;
			mgplot_reset(1);
		}
	}

	mgplot_subplot(1, 2, 1, 1);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "r[m]");
	mgplot_title(1, "Position of cart");
	if (any_graph == 0) {
		mgplot(1, TT, UY(2,:), {"position", "reference"});
	} else {
		mgreplot(1, TT, UY(2,:), {"position", "reference"});
	}

	mgplot_subplot(1, 2, 1, 2);
	mgplot_grid(1, 1);
	mgplot_xlabel(1, "time[sec]");
	mgplot_ylabel(1, "input[N]");
	mgplot_title(1, "Control input");
	if (any_graph == 0) {
		mgplot(1, TT, UY(1,:), {"input"});
	} else {
		mgreplot(1, TT, UY(1,:), {"input"});
	}
	pause;

	any_graph = 1;
}
/////////////////////////////////////////////////////////////////////////////
//  シミュレーション終り
/////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////
//  実  験
/////////////////////////////////////////////////////////////////////////////
Func void experiment_cart()
{
	Integer yes_no;
	Array TT, UY;

	void var_init_cart(), off_task_loop(), on_task_cart(), break_task();
	void machine_ready_cart(), machine_stop(), draw_graph_pend(...);
	void on_task_ident();

	machine_ready_cart();   // 実験装置の準備
	var_init_cart();        // 変数の初期化(machine_ready()のあと)
	rtSetClock(smtime);     // サンプリング周期の設定
	if (ident_flag) {
		rtSetTask(on_task_ident);	// オンライン関数の設定(同定)
	} else {
		rtSetTask(on_task_cart);	// オンライン関数の設定(制御)
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
			UY = log_data(:,1:log_count);
			draw_graph_pend(TT, UY);
		}
	}
}

// 変数の初期化
Func void var_init_cart()
{
	ref = 0.0;
	cmd = 0;
	log_flag = 0;
	log_count = 0;
	lc = 0;
	mlc = 10;

	y_old = [sensor()](1:1,1);   // 台車の位置の初期値
	log_data = Z(4,LOGMAX);      // ロギングデータ
}

// 実験装置の準備
Func void machine_ready_cart()
{
	sensor_init();                  // センサの初期化
	actuator_init();                // アクチュエータの初期化

	gotoxy(5,5);
	print "台車の初期位置 : レールの中央";
	gotoxy(5,9);
	pause "台車を初期位置に移動し，リターンキーを入力して下さい。";
	gotoxy(5,9);
	print "　　　　　　　　　　　　　　　　　　　　　　　　　　　";
	gotoxy(5,9);
	pause "リターンキーを入力すると，制御が開始されます。";
	clear;
}

// 台車制御のオンライン関数
Func void on_task_cart()
{
	Real u_max;
	Matrix x;
	
	u_max = 20.0;
	
	// コントローラのパラメータを更新
	if (parameter_update && ident_flag == 0) {
		parameter_update = 0;
		F   = F_off;
	}
	
	if (ident_flag) {
		y = sensor();						// センサから入力
		y = y(1:1,1);						// 台車の位置のみを取り出す
		u = Z(1);
	} else {
		y = sensor();						// センサから入力
		x = [[y(1) - ref              ]
			 [(y(1) - y_old(1))/smtime]];	// 台車の状態(位置と速度)
		u = F*x;

		// 静止摩擦補償
		if (y(1) == y_old(1)) {
			if (u(1) > 0) {
				u(1) = u(1) + u_sf_p;
			} else if (u(1) < 0) {
				u(1) = u(1) - u_sf_n;
			}
		}
		y_old = y;
	}

	// 最大入力 = u_max
	if (u(1) > u_max) {
		u(1) = u_max;
	} else if (u(1) < - u_max) {
		u(1) = - u_max;
	}
	
	if (cmd == 1 && ! rtIsRehearsal()) {
		actuator(u(1));			// アクチュエータへ出力
	}
	
	// ロギングデータ
	if (log_flag == 1) {
		if (log_count < LOGMAX && rem(lc,mlc) == 0) {
			log_count++;
			log_data(1:1, log_count) = u;
			log_data(2, log_count) = y(1);
			log_data(3, log_count) = ref;
		}
		lc++;
	}
}

