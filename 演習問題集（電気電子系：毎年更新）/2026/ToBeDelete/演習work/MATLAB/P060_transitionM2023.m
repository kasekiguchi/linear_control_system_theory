%-definitions-------------------

% matrix A
A=[3 2;0 1]

%固有ベクトルの調整パラメータ
p1=1
p2=1

%-------------------------------
syms lambda e t
ebarA=sym('ebarA',[2:2]);
eA=sym('eA',[2:2]);

% M0= lambda I - A
M0= lambda*eye(2)-A

% caA=特性多項式の係数
cpA=charpoly(A);

% eqn: 特性多項式
eqno= (M0(1,1)*M0(2,2)-M0(2,1)*M0(2,2))
eqn= expand(eqno)

% lambdaA: 固有値（列ベクトル）
lambdaA=solve(eqn, lambda)

%%%第１固有値固有ベクトル

% lambda I - A
M1= double(lambdaA(1) *eye(2) -A)

% 固有値固有ベクトル（絶対値の大きい順）
% 第２固有ベクトルがzeroであることを確認
Vn1=null(M1)

% 固有ベクトル
V1=(Vn1(:,1)/Vn1(1,1)) *p1


%%%第２固有値固有ベクトル

% lambda I - A
M2= double(lambdaA(2) *eye(2) -A)

% 固有値固有ベクトル（絶対値の大きい順）
% 第２固有ベクトルがzeroであることを確認
Vn2=null(M2)

% 固有ベクトル
V2=(Vn2(:,1)/Vn2(1,1)) *p2

%%%座標変換行列
T=[V1 V2]
TI=inv(T)

%%%座標変換
barA = TI*A*T

%%%座標変換前の遷移行列
ebarA=[e^(barA(1,1)*t) 0;0 e^(barA(2,2)*t)]

%%%遷移行列
eA= T * ebarA * TI

%%%latex用出力

chrA=latex(sym(A))
chrMo=latex(sym(M0))
chrMoa=latex(sym(M0(1,1)))
chrMob=latex(sym(M0(1,2)))
chrMoc=latex(sym(M0(2,1)))
chrMod=latex(sym(M0(2,2)))
chrlambdaa=latex(sym(lambdaA(1)))
chrlambdab=latex(sym(lambdaA(2)))
chreqno=latex(sym(eqno))
chreqn=latex(sym(eqn))
chrMa=latex(sym(M1))
chrVa=latex(sym(V1))
chrMb=latex(sym(M2))
chrVb=latex(sym(V2))
chrT=latex(sym(T))
chrTI=latex(sym(TI))
chrbarA=latex(sym(barA))
chrebarA=latex(sym(ebarA))
chreA=latex(sym(eA))

