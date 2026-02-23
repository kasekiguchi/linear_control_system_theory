%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　サーボ系
%　MATLAB mファイルでA,B,C行列（1次元）と指定極（重根）を指定して
% フィードバック（u=Fx+K eta）を求める
%
%　mファイルの使い方
%　　　まず A,B,C行列とpを定義する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix A, B, C
    A=3
    B=1 %正の値
    C=1 %正の値
% 指定極（重根）
    p=-3
    mp=-p
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------
syms F K s
%-------------------------------

%-------------------------------
% 拡大系A,B行列

    eA=[A 0;-C 0]
    eB=[B;0]

%-------------------------------
% A+BF

    ABF=A+B*F

%-------------------------------
% BK
    
    BK=B*K

%-------------------------------
% 閉ループA行列

    clA=eA+[B;0]*[F K]

%-------------------------------
% 特性多項式

    sIA=s*eye(2) - clA
    sIAa=sIA(1,1)
    sIAb=sIA(1,2)
    sIAc=sIA(2,1)
    sIAd=sIA(2,2)

    detsIA=collect(expand(sIAa*sIAd - sIAb*sIAc))

    coefa=1
    coefb=-ABF
    coefc=BK*C


%-------------------------------
% 望ましい特性多項式

    coefad=1
    coefbd=2*(-p)
    coefcd=(-p)*(-p)

%-------------------------------
% F,Kの求解

    sF=solve(coefb==coefbd,F)
    sK=solve(coefc==coefcd,K)



delete '095_def_file.txt'
fileID = fopen('095_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrB',    latex(sym(B)));
fprintf(fileID,'\\def\\%s{%s}\n','chrC',    latex(sym(C)));
fprintf(fileID,'\\def\\%s{%s}\n','chrp',    latex(sym(p)));
fprintf(fileID,'\\def\\%s{%s}\n','chrmp',    latex(sym(mp)));

fprintf(fileID,'\\def\\%s{%s}\n','chreA',    latex(sym(eA)));
fprintf(fileID,'\\def\\%s{%s}\n','chreB',    latex(sym(eB)));

fprintf(fileID,'\\def\\%s{%s}\n','chrABF',    latex(sym(ABF)));
fprintf(fileID,'\\def\\%s{%s}\n','chrBK',    latex(sym(BK)));

fprintf(fileID,'\\def\\%s{%s}\n','chrclA',    latex(sym(clA)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIA',    latex(sym(sIA)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAa',    latex(sym(sIAa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAb',    latex(sym(sIAb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAc',    latex(sym(sIAc)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIAd',    latex(sym(sIAd)));
fprintf(fileID,'\\def\\%s{%s}\n','chrdetsIA',    latex(sym(detsIA)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcoefa',    latex(sym(coefa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefb',    latex(sym(coefb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefc',    latex(sym(coefc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcoefad',    latex(sym(coefad)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefbd',    latex(sym(coefbd)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefcd',    latex(sym(coefcd)));

fprintf(fileID,'\\def\\%s{%s}\n','chrsF',    latex(sym(sF)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsK',    latex(sym(sK)));


fclose('all');