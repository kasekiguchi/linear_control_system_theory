%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　不可制御なシステムの分解
%　不可制御なA,B,C行列を指定し，可制御な部分と不可制御な部分に分解する
%　mファイルの使い方
%　　　まず A 行列を定義する
%　　　固有ベクトル整数とするために p1, p2を試行錯誤で修正
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A,B,Cの定義：不可制御なものを指定
% ★可制御性行列の独立なものが[0;1]と独立であるものを指定

A=[0 3;1 -2]
B=[1;-1]
C=[1 1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Co=ctrb(A,B)

T=cat(2,B,[0;1])

TI=inv(T)

bA= TI*A*T
bB= TI*B
bC= C*T

%-------------------------------
%%%latex用出力
%-------------------------------

delete '055_def_file.txt'
fileID = fopen('055_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrB',    latex(sym(B)));
fprintf(fileID,'\\def\\%s{%s}\n','chrC',    latex(sym(C)));
fprintf(fileID,'\\def\\%s{%s}\n','chrCo',   latex(sym(Co)));
fprintf(fileID,'\\def\\%s{%s}\n','chrT',    latex(sym(T)));
fprintf(fileID,'\\def\\%s{%s}\n','chrTI',   latex(sym(TI)));
fprintf(fileID,'\\def\\%s{%s}\n','chrbA',    latex(sym(bA)));
fprintf(fileID,'\\def\\%s{%s}\n','chrbB',   latex(sym(bB)));
fprintf(fileID,'\\def\\%s{%s}\n','chrbC',    latex(sym(bC)));

fclose('all');