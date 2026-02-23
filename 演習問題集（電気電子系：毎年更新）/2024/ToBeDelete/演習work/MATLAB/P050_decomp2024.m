A=[0 3;1 -2]
B=[1;-1]
C=[1 1]

Co=ctrb(A,B)

T=cat(2,B,[0;1])

TI=inv(T)

barA= TI*A*T
barB= TI*B
barC= C*T

chrA=latex(sym(A))
chrB=latex(sym(B))
chrC=latex(sym(C))
chrCo=latex(sym(Co))
chrT=latex(sym(T))
chrTI=latex(sym(TI))
chrbA=latex(sym(barA))
chrbB=latex(sym(barB))
chrbC=latex(sym(barC))

