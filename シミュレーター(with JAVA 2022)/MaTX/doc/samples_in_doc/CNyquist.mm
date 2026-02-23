Func void main()
{
	Polynomial s;
	Rational G;
	Array w, re, im;
	List CNyquist();

	s = $;
	G = (s^2 + 3*s + 4)/(s^3 + 5*s^2 + 6*s + 7);
	w = logspace(0.01, 100.0);
	{re, im} = CNyquist(G, w);
	plot(re, im);
}

Func List CNyquist(G, w)
	Rational G;
	Array w;
{
	Complex j;
	Array data;

	j = (0,1);
	data = eval(G, j*w);
	return {Re(data), Im(data)};
}
