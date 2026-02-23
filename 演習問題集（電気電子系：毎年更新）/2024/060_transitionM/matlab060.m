%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　遷移行列を求める問題
%　MATLAB mファイルでA行列を指定して e^At を求める
%
%　mファイルの使い方
%　　　まず A 行列を定義する
%　　　固有ベクトル整数とするために p1, p2を試行錯誤で修正
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix A
    A=[3 2;0 1]

%固有ベクトルを整数にするための調整パラメータ
%p1は第１固有ベクトルに，p2は第２固有ベクトルに乗ずる定数
    p1=1
    p2=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------
syms lambda e t
ebarA=sym('ebarA',[2:2]);
eA=sym('eA',[2:2]);

%-------------------------------
% M0= lambda I - A

    M0= lambda*eye(2)-A

%-------------------------------
% caA=特性多項式の係数

    cpA=charpoly(A);

%-------------------------------
% eqn: 特性多項式

    eqno= (M0(1,1)*M0(2,2)-M0(1,2)*M0(2,1))
    eqn= expand(eqno)

%-------------------------------
% lambdaA: 固有値（列ベクトル）

    lambdaA=solve(eqn, lambda)

%-------------------------------
%%%第１固有値固有ベクトル

% lambda I - A

    M1= double(lambdaA(1) *eye(2) -A)

% 固有値固有ベクトル（絶対値の大きい順）
% 第２固有ベクトルがzeroであることを確認

    Vn1=null(M1)

% 固有ベクトル

    V1=(Vn1(:,1)/Vn1(1,1)) *p1


%-------------------------------
%%%第２固有値固有ベクトル

% lambda I - A

    M2= double(lambdaA(2) *eye(2) -A)

% 固有値固有ベクトル（絶対値の大きい順）
% 第２固有ベクトルがzeroであることを確認

    Vn2=null(M2)

% 固有ベクトル

    V2=(Vn2(:,1)/Vn2(1,1)) *p2

%-------------------------------
%%%座標変換行列

    T=[V1 V2]
    TI=inv(T)

%-------------------------------
%%%座標変換

    barA = TI*A*T

%-------------------------------
%%%座標変換前の遷移行列

    ebarA=[e^(barA(1,1)*t) 0;0 e^(barA(2,2)*t)]

%-------------------------------
%%%遷移行列

    eA= T * ebarA * TI

%-------------------------------
%%%latex用出力
%-------------------------------

delete '065_def_file.txt'
fileID = fopen('065_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrMo',   latex(sym(M0)));
fprintf(fileID,'\\def\\%s{%s}\n','chrMoa',  latex(sym(M0(1,1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrMob',  latex(sym(M0(1,2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrMoc',  latex(sym(M0(2,1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrMod',  latex(sym(M0(2,2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrlambdaa',latex(sym(lambdaA(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrlambdab',latex(sym(lambdaA(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chreqno', latex(sym(eqno)));
fprintf(fileID,'\\def\\%s{%s}\n','chreqn',  latex(sym(eqn)));
fprintf(fileID,'\\def\\%s{%s}\n','chrMa',   latex(sym(M1)));
fprintf(fileID,'\\def\\%s{%s}\n','chrVa',   latex(sym(V1)));
fprintf(fileID,'\\def\\%s{%s}\n','chrMb',   latex(sym(M2)));
fprintf(fileID,'\\def\\%s{%s}\n','chrVb',   latex(sym(V2)));
fprintf(fileID,'\\def\\%s{%s}\n','chrT',    latex(sym(T)));
fprintf(fileID,'\\def\\%s{%s}\n','chrTI',   latex(sym(TI)));
fprintf(fileID,'\\def\\%s{%s}\n','chrbarA', latex(sym(barA)));
fprintf(fileID,'\\def\\%s{%s}\n','chrebarA',latex(sym(ebarA)));
fprintf(fileID,'\\def\\%s{%s}\n','chreA',   latex(sym(eA)));

fclose('all');