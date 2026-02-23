Func void main()
{
	Polynomial s;
	Rational G;
	Array w, ga, ph;
	List CBode();

	s = $;
	G = (s^2 + 3*s + 4)/(s^3 + 5*s^2 + 6*s + 7);
	w = logspace(0.01, 100.0);
	{ga, ph} = CBode(G, w);
	splot(w, ga);
	splot(w, ph);
}

Func List CBode(G, w)
	Rational G;
	Array w;
{
	Complex j;
	Array data, gain, phase;

	j = (0,1);
	data = eval(G, j*w);
	gain = 20.0 * log10(abs(data));
	phase = arg(data) * 180.0/PI;
	return {gain, phase};
}


