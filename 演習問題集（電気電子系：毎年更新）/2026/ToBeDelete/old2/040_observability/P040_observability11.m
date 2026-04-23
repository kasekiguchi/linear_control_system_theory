m0=1
m1=1
m2=1
k1=1
k2=1


A=[0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 1;
   -k1/m0-k2/m0 k1/m0 k2/m0 0 0 0;
   k1/m1 -k1/m1 0 0 0 0;
   k2/m2 0 -k2/m2 0 0 0]

B=[0;0;0;1/m0;0;0]

C=[1 0 0 0 0 0]

Ob=obsv(A,C)

chrA=latex(sym(A))
chrB=latex(sym(B))
chrOb=latex(sym(Ob))



