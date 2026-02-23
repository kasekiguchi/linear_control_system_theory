//
//  プラント (1996.6.4) (1999.11.23)
//
Func void main()
{
	Matrix An,Bn,Cn;
	Matrix Ap,Bp,Cp;
	Real m1,k1,c1,m2,k2,c2,mn1,kn1,cn1;
	
	mn1 = 10.0;
	kn1 = 1.0;
	cn1 = 3.0;
	m1 = 0.1;
	k1 = 1.0;
	c1 =  3.0;
	m2 = 10.0;  
	k2 = 100.0; 
	c2 = 0.01;
//     read mn1, kn1, cn1;
	read m1, k1, c1;
	read m2, k2, c2;
	
	An = [[      0,          1 ]
		  [ -kn1/mn1, -cn1/mn1 ]];
	Bn = [[      0 ]
		  [   1/mn1 ]];
	Cn =  [      1,      0 ];
	
	print An;
	pause;
	print Bn;
	pause;
	print Cn;
	pause;
	
	print An,Bn,Cn -> "plant.mx";
	
	Ap = [[             0,             1,      0,      0 ]
		  [ -(k1+k2) / m1, -(c1+c2) / m1,  k2/m1,  c2/m1 ]
		  [             0,             0,      0,      1 ]
		  [       k2 / m2,       c2 / m2, -k2/m2, -c2/m2 ]];
	
	Bp = [[    0 ]
		  [ 1/m1 ]
		  [    0 ]
		  [    0 ]];
	
	Cp = [[ 1, 0, 0, 0 ]];
	
	print Ap;
	pause;
	print Bp;
	pause;
	print Cp;
	pause;

	print "\n";
	
	if (m1==0.1 && m2==10.0 && k1==1.0 && k2==100.0 && c1==3.0 && c2==0.01) {
		print "Case 1\n\n";
		print Ap,Bp,Cp -> "jitupla.mx";
	} else {
		print "Case 2\n\n";
		print Ap,Bp,Cp -> "jitu2.mx";
	}
}
     
	  
