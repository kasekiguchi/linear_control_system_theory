%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　最適制御問題
%　MATLAB mファイルでA,B,Q行列を指定してフィードバック(f1,f2)を求める
%  A=A（不安定極），A=-A（安定極）の両方を求める
%
%　mファイルの使い方
%　　　まず A,B,Q,R 行列を定義する
%　　　R=rは変数とする
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix A, B, Q
    A=9 %不安定根を指定
    B=3 %正の値を指定
    Q=1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------
syms r p
%-------------------------------
% リカッチ方程式

    Reqn= A*p + p*A - p*B*inv(r)*B*p + Q 

%-------------------------------
% リカッチ方程式の簡略化１
% Reqn= Reqna p^2 + Reqnb p + Reqnc

    Reqna=-B*inv(r)*B
    Reqnb=2*A
    Reqnc=Q

%-------------------------------
% リカッチ方程式の簡略化１
%   Reqns = Reqn/Reqn = p^2 - Reqnb p - Reqnc
% 係数の符号に注意

    Reqnsb= - Reqnb/Reqna
    Reqnsc= - Reqnc/Reqna

%-------------------------------
% リカッチ方程式の解
%   SR= SRa +- sqr(SRb+SRc)
% 係数の符号に注意

    SRa= Reqnsb/2
    SRb= (Reqnsb/2)^2
    SRc= Reqnsc

%-------------------------------
% 入力u
%   u= (Ua - sqr(Ub+Uc)) x
% 係数の符号に注意

    Ua=-inv(r)*B*SRa
    Ub=(inv(r)*B)^2 *SRb
    Uc=(inv(r)*B)^2 *SRc

    Usq=sqrt(Ub+Uc)
    Usqs=sqrt(Ub+Uc)   %A=-Aのとき
%-------------------------------
% 閉ループ系
%   A+BF=ABFa-sqr(ABFb)

    ABFa=A+B*Ua
    ABFb=(Ub+Uc)*B^2

    ABF=ABFa-sqrt(ABFb)
    ABFs=-ABFa-sqrt(ABFb)  %A=-Aのとき
%-------------------------------
% r->inftyの場合の入力と極
%   A+BF=ABFa-sqr(ABFb)

    Ui=Ua-sqrt(Ub)
    ABFi=A+B*Ua-sqrt(B^2*Ub)
    Uis=-Ua-sqrt(Ub)   %A=-Aのとき


delete '085_def_file.txt'
fileID = fopen('085_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrA',    latex(sym(A)));
fprintf(fileID,'\\def\\%s{%s}\n','chrB',    latex(sym(B)));
fprintf(fileID,'\\def\\%s{%s}\n','chrQ',    latex(sym(Q)));

fprintf(fileID,'\\def\\%s{%s}\n','chrReqn',     latex(sym(Reqn)));
fprintf(fileID,'\\def\\%s{%s}\n','chrReqna',    latex(sym(Reqna)));
fprintf(fileID,'\\def\\%s{%s}\n','chrReqnb',    latex(sym(Reqnb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrReqnc',    latex(sym(Reqnc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrReqnsb',    latex(sym(Reqnsb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrReqnsc',    latex(sym(Reqnsc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrSRa',    latex(sym(SRa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrSRb',    latex(sym(SRb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrSRc',    latex(sym(SRc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrUa',    latex(sym(Ua)));
fprintf(fileID,'\\def\\%s{%s}\n','chrUas',   latex(sym(-Ua))); %A=-Aの時
fprintf(fileID,'\\def\\%s{%s}\n','chrUb',    latex(sym(Ub)));
fprintf(fileID,'\\def\\%s{%s}\n','chrUc',    latex(sym(Uc)));

fprintf(fileID,'\\def\\%s{%s}\n','chrUsq',    latex(sym(Usq)));
fprintf(fileID,'\\def\\%s{%s}\n','chrUsqs',    latex(sym(Usqs)));

fprintf(fileID,'\\def\\%s{%s}\n','chrABFa',    latex(sym(ABFa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrABFb',    latex(sym(ABFb)));

fprintf(fileID,'\\def\\%s{%s}\n','chrABF',    latex(sym(ABF)));

fprintf(fileID,'\\def\\%s{%s}\n','chrUi',    latex(sym(Ui)));
fprintf(fileID,'\\def\\%s{%s}\n','chrUis',    latex(sym(Uis)));   %A=-Aの時
fprintf(fileID,'\\def\\%s{%s}\n','chrABFi',    latex(sym(ABFi)));


fclose('all');