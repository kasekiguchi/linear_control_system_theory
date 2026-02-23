%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　極配置問題
%　MATLAB mファイルでA,B行列と極p1,p2を指定してフィードバック(f1,f2)を求める
%
%　mファイルの使い方
%　　　まず A,B 行列と極p1,p2を定義する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix A, B
    A=[0 1; 2 -1]
    B=[0;1]
% 指定極
    p1=-1
    p2=-2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------
syms s f1 f2
%-------------------------------
% フィードバックFの定義と閉ループ系
    F=[f1 f2]
    BF=B*F
    ABF=A+BF
%-------------------------------
% M0= sI-A

    sIA= s* eye(2) - ABF

%-------------------------------
% eqn: 特性多項式
% cf(3) s^2 + cf(2) s + cf(1)
% cfa s^2 + cfb s + cfc

    eqno= (sIA(1,1)*sIA(2,2)-sIA(2,1)*sIA(1,2))
    eqn= expand(eqno)
    cf= coeffs(eqn,s)

%-------------------------------
% eqnd: 望ましい特性多項式
% cfd(3) s^2 + cfd(2) s + cfd(1)
% cfda s^2 + cfdb s + cfdc

    eqnd= expand((s-p1)*(s-p2))
    cfd= coeffs(eqnd,s)

%-------------------------------
% f1,f2の求解
% fa=f1, fb=f2

    [fa,fb]=solve([cf==cfd],[f1,f2])

%-------------------------------
%%%latex用出力
%-------------------------------

delete '075_def_file.txt'
fileID = fopen('075_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrB',    latex(sym(B)));
fprintf(fileID,'\\def\\%s{%s}\n','chrpa',   latex(sym(p1)));
fprintf(fileID,'\\def\\%s{%s}\n','chrpb',   latex(sym(p2)));

fprintf(fileID,'\\def\\%s{%s}\n','chrF',    latex(sym(F)));
fprintf(fileID,'\\def\\%s{%s}\n','chrBF',   latex(sym(BF)));
fprintf(fileID,'\\def\\%s{%s}\n','chrABF',  latex(sym(ABF)));

fprintf(fileID,'\\def\\%s{%s}\n','chrsIA',  latex(sym(sIA)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAa', latex(sym(sIA(1,1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAb', latex(sym(sIA(1,2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAc', latex(sym(sIA(2,1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAd', latex(sym(sIA(2,2))));

fprintf(fileID,'\\def\\%s{%s}\n','chreqn',  latex(sym(eqn)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcfa',  latex(sym(cf(3))));
fprintf(fileID,'\\def\\%s{%s}\n','chrcfb',  latex(sym(cf(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrcfc',  latex(sym(cf(1))));

fprintf(fileID,'\\def\\%s{%s}\n','chreqnd',  latex(sym(eqnd)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcfda',  latex(sym(cfd(3))));
fprintf(fileID,'\\def\\%s{%s}\n','chrcfdb',  latex(sym(cfd(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrcfdc',  latex(sym(cfd(1))));

fprintf(fileID,'\\def\\%s{%s}\n','chrfa',  latex(sym(fa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrfb',  latex(sym(fb)));

fclose('all');