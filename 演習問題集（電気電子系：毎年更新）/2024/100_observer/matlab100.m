%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　オブザーバ
%　MATLAB mファイルでA,B,C行列（２次元）と指定極を指定して
% オブザーバゲインKを求める
%
%　mファイルの使い方
%　　　まず A,B,C行列とpa,pbを定義する
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix A, B, C
    A=[0 3;1 4]
    B=[1;1]
    C=[0 1]
% 指定極（重根）
    pa=-2
    pb=-3
    mpa=-pa
    mpb=-pb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------
syms s k1 k2
%-------------------------------

%-------------------------------
% Kの定義
    K=[k1;k2]
    KT=transpose(K)

%-------------------------------
% A^T, C^T

    AT=transpose(A)
    CT=transpose(C)

%-------------------------------
% C^T K^T

    CKT=CT*KT

%-------------------------------
% A^T + C^T K^T
    
    ACKT=AT + CKT

%-------------------------------
% sI-(A^T + C^T K^T)

    sIACKT= s*eye(2)-ACKT
    sIACKTa=sIACKT(1,1)
    sIACKTb=sIACKT(1,2)
    sIACKTc=sIACKT(2,1)
    sIACKTd=sIACKT(2,2)

%-------------------------------
% 特性多項式

    detsIACKT=collect(expand(sIACKTa*sIACKTd - sIACKTb*sIACKTc))

    coef=coeffs(detsIACKT,s)
    coefa=coef(3)
    coefb=coef(2)
    coefc=coef(1)

%-------------------------------
% 望ましい特性多項式

    coefad=1
    coefbd=mpa+mpb
    coefcd=(mpa)*(mpb)

%-------------------------------
% Kの求解

    sKT=-place(AT,CT,[pa;pb])

    sK=transpose(sKT)

delete '105_def_file.txt'
fileID = fopen('105_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrB',    latex(sym(B)));
fprintf(fileID,'\\def\\%s{%s}\n','chrC',    latex(sym(C)));
fprintf(fileID,'\\def\\%s{%s}\n','chrpa',    latex(sym(pa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrpb',    latex(sym(pb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrmpa',    latex(sym(mpa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrmpb',    latex(sym(mpb)));

fprintf(fileID,'\\def\\%s{%s}\n','chrAT',    latex(sym(AT)));
fprintf(fileID,'\\def\\%s{%s}\n','chrCT',    latex(sym(CT)));

fprintf(fileID,'\\def\\%s{%s}\n','chrCKT',    latex(sym(CKT)));
fprintf(fileID,'\\def\\%s{%s}\n','chrACKT',    latex(sym(ACKT)));

fprintf(fileID,'\\def\\%s{%s}\n','chrsIACKT',    latex(sym(sIACKT)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIACKTa',    latex(sym(sIACKTa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIACKTb',    latex(sym(sIACKTb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIACKTc',    latex(sym(sIACKTc)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsIACKTd',    latex(sym(sIACKTd)));

fprintf(fileID,'\\def\\%s{%s}\n','chrdetsIACKT',    latex(sym(detsIACKT)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcoefa',    latex(sym(coefa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefb',    latex(sym(coefb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefc',    latex(sym(coefc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrcoefad',    latex(sym(coefad)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefbd',    latex(sym(coefbd)));
fprintf(fileID,'\\def\\%s{%s}\n','chrcoefcd',    latex(sym(coefcd)));

fprintf(fileID,'\\def\\%s{%s}\n','chrsK',    latex(sym(sK)));
fprintf(fileID,'\\def\\%s{%s}\n','chrsKa',    latex(sym(sK(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrsKb',    latex(sym(sK(2))));


fclose('all');