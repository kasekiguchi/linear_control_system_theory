%-------------------------------
clearvars
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%　3mass系の可観測性を調べる問題
%     m0,m1,m2,k1,k2を指定して可観測性を調べる
%     パラメータは２種類でベクトルで定める
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% パラメータ ２種類

m0=[1 1]
m1=[1 1]
m2=[1 1]
k1=[1 3]
k2=[1 1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-------------------------------
% 第１パラメータの場合

Aa=[0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1;
   -k1(1)/m0(1)-k2(1)/m0(1) k1(1)/m0(1) k2(1)/m0(1) 0 0 0;
   k1(1)/m1(1) -k1(1)/m1(1) 0 0 0 0;
   k2(1)/m2(1) 0 -k2(1)/m2(1) 0 0 0]

Ba=[0;0;0;1/m0(1);0;0]

Ca=[1 0 0 0 0 0]

Oba=obsv(Aa,Ca)


%-------------------------------
% パラメータp2の場合

Ab=[0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1;
   -k1(2)/m0(2)-k2(2)/m0(2) k1(2)/m0(2) k2(2)/m0(2) 0 0 0;
   k1(2)/m1(2) -k1(2)/m1(2) 0 0 0 0;
   k2(2)/m2(2) 0 -k2(2)/m2(2) 0 0 0]

Bb=[0;0;0;1/m0(2);0;0]

Cb=[1 0 0 0 0 0]

Obb=obsv(Ab,Cb)

%-------------------------------
%%%latex用出力
%-------------------------------

delete '040_def_file.txt'
fileID = fopen('040_def_file.txt','a');

fprintf(fileID,'\\def\\%s{%s}\n','chrmaa',  latex(sym(m0(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrmba',  latex(sym(m1(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrmca',  latex(sym(m2(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrkaa',  latex(sym(k1(1))));
fprintf(fileID,'\\def\\%s{%s}\n','chrkba',  latex(sym(k2(1))));

fprintf(fileID,'\\def\\%s{%s}\n','chrAa',   latex(sym(Aa)));
fprintf(fileID,'\\def\\%s{%s}\n','chrBa',   latex(sym(Ba)));
fprintf(fileID,'\\def\\%s{%s}\n','chrCa',   latex(sym(Ca)));
fprintf(fileID,'\\def\\%s{%s}\n','chrOba',  latex(sym(Oba)));

%---

fprintf(fileID,'\\def\\%s{%s}\n','chrmab',  latex(sym(m0(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrmbb',  latex(sym(m1(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrmcb',  latex(sym(m2(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrkab',  latex(sym(k1(2))));
fprintf(fileID,'\\def\\%s{%s}\n','chrkbb',  latex(sym(k2(2))));

fprintf(fileID,'\\def\\%s{%s}\n','chrAb',   latex(sym(Ab)));
fprintf(fileID,'\\def\\%s{%s}\n','chrBb',   latex(sym(Bb)));
fprintf(fileID,'\\def\\%s{%s}\n','chrCb',   latex(sym(Ca)));
fprintf(fileID,'\\def\\%s{%s}\n','chrObb',  latex(sym(Obb)));

fclose('all');


