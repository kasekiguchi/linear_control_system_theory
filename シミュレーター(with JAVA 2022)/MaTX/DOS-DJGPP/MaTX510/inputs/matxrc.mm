
/*  -*- MaTX -*-
 *
 *	Copyright (C) 1989-1995  Masanobu Koga
 *            All Rights Reserved.
 *
 *	No part of this software may be used, copied, modified, and distributed
 *	in any form or by any means, electronic, mechanical, manual, optical or
 *	otherwise, without prior permission of Masanobu Koga.
 */

/* ------------------------------ Demo ------------------------------ */

// bench.mm
void bench() require "bench.mm";

// demo.mm
void demo() require "demo.mm";

// ctr_demo.mm
void ctr_demo() require "control/ctr_demo.mm" ;

// mat_demo.mm
void mat_demo() require "matrix/mat_demo.mm";

// sig_demo.mm
void sig_demo() require "signal/sig_demo.mm";

// rob_demo.mm
void rob_demo() require "robust/rob_demo.mm";

// idx_demo.mm
void idx_demo() require "ident/idx_demo.mm";

/* ------------------------------ Matrix ------------------------------ */

// angle.mm
Array angle() require "matrix/angle.mm";

// bar.mm
List bar(...) require "matrix/bar.mm";
void barp(...) require "matrix/bar.mm";

// cdf2rdf.mm
List cdf2rdf() require "matrix/cdf2rdf.mm";

// chol.mm
Matrix chol() require "matrix/chol.mm";

// cond.mm
Real cond() require "matrix/cond.mm";

// conv.mm
Array conv() require "matrix/conv.mm";

// corrcoef.mm
Array corrcoef_col(...) require "matrix/corrcoef.mm";
Array corrcoef_row(...) require "matrix/corrcoef.mm";

// cov.mm
Real cov(...) require "matrix/cov.mm";
Matrix cov_col(...) require "matrix/cov.mm";
Matrix cov_row(...) require "matrix/cov.mm";

// ccpair.mm
CoMatrix ccpair(...) require "matrix/ccpair.mm";

// dec2hex.mm
String dec2hex() require "matrix/dec2hex.mm";

// deconv.mm
List deconv() require "matrix/deconv.mm";

// dft.mm
Array dft(...) require "matrix/dft.mm";
void dft_plot(...) require "matrix/dft.mm";

// diag_vec.mm
Matrix diag_vec(...) require "matrix/diag_vec.mm";

// diff.mm
Matrix diff(...) require "matrix/diff.mm";
Matrix diff_col(...) require "matrix/diff.mm";
Matrix diff_row(...) require "matrix/diff.mm";

// funm.mm
Matrix funm(...) require "matrix/funm.mm";

// givens.mm
CoMatrix givens() require "matrix/givens.mm";

// hadamard.mm
Matrix hadamard() require "matrix/hadamard.mm";

// hankel.mm
Matrix hankel(...) require "matrix/hankel.mm";

// hex2dec.mm
Integer hex2dec() require "matrix/hex2dec.mm";

// hex2num.mm
Real hex2num() require "matrix/hex2num.mm";

// hilbert.mm
Matrix hilbert() require "matrix/hilbert.mm";

// hist.mm
List hist(...) require "matrix/hist.mm";
List hist_col(...) require "matrix/hist.mm";
List hist_row(...) require "matrix/hist.mm";

// idft.mm
Array idft(...) require "matrix/idft.mm";
void idft_plot(...) require "matrix/idft.mm";

// ihilbert.mm
Matrix ihilbert() require "matrix/ihilbert.mm";

// isempty.mm
Integer isempty() require "matrix/isempty.mm";

// kronprod.mm
Matrix kronprod() require "matrix/kronprod.mm";

// kronsum.mm
Matrix kronsum() require "matrix/kronsum.mm";

// linspace.mm
Array linspace(...) require "matrix/linspace.mm";

// logspace.mm
Array logspace(...) require "matrix/logspace.mm";

// magicsq.mm
Matrix magicsq() require "matrix/magicsq.mm";

// makecolv.mm
Matrix makecolv() require "matrix/makecolv.mm";

// makerowv.mm
Matrix makerowv() require "matrix/makerowv.mm";

// makepoly.mm
Polynomial makepoly() require "matrix/makepoly.mm";

// matlabio.mm
List matlab_read() require "matrix/matlabio.mm";
void matlab_write(...) require "matrix/matlabio.mm";

// mat2tex.mm
void mat2tex(...) require "matrix/mat2tex.mm";
String mat2texf(...) require "matrix/mat2tex.mm";

// median.mm
Real median() require "matrix/median.mm";
Matrix median_col() require "matrix/median.mm";
Matrix median_row() require "matrix/median.mm";

// mseq.mm
Array mseq(...) require "matrix/mseq.mm";

// nargchk.mm
String nargchk(...) require "matrix/nargchk.mm";

// orth.mm
Matrix orth(...) require "matrix/orth.mm";

// poly2tex.mm
void poly2tex(...) require "matrix/poly2tex.mm";
String poly2texf(...) require "matrix/poly2tex.mm";

// rat2tex.mm
void rat2tex(...) require "matrix/rat2tex.mm";
String rat2texf(...) require "matrix/rat2tex.mm";

// rot90.mm
Matrix rot90(...) require "matrix/rot90.mm";

// rsf2csf.mm
List rsf2csf() require "matrix/rsf2csf.mm";

// schord.mm
List schord() require "matrix/schord.mm";

// simplify.mm
RaMatrix simplify(...) require "matrix/simplify.mm";

// toeplitz.mm
Matrix toeplitz(...) require "matrix/toeplitz.mm";

// triu.mm
Matrix triu(...) require "matrix/triu.mm";

// tril.mm
Matrix tril(...) require "matrix/tril.mm";

// unwrap.mm
Array unwrap(...) require "matrix/unwrap.mm";
Array unwrap_col(...) require "matrix/unwrap.mm";
Array unwrap_row(...) require "matrix/unwrap.mm";

// vander.mm
Matrix vander() require "matrix/vander.mm";

// vchop.mm
List vchop() require "matrix/vchop.mm";
List VecChop() require "matrix/vchop.mm";

// vconnect.mm
List vconnect() require "matrix/vconnect.mm";
List VecCont() require "matrix/vconnect.mm";


/* ------------------------------ Signal ------------------------------ */

// bartlett.mm
Array bartlett() require "signal/bartlett.mm";

// bilinear.mm
List bilinear(...) require "signal/bilinear.mm";

// blackman.mm
Array blackman() require "signal/blackman.mm";

// boxcar.mm
Array boxcar() require "signal/boxcar.mm";

// cceps.mm
Array cceps() require "signal/cceps.mm";

// detrend.mm
Array detrend(...) require "signal/detrend.mm";
Array detrend_col(...) require "signal/detrend.mm";
Array detrend_row(...) require "signal/detrend.mm";

// filer.mm
List filter(...) require "signal/filter.mm";

// freqs.mm
CoArray freqs() require "signal/freqs.mm";
void freqsp(...) require "signal/freqs.mm";

// freqz.mm
List freqz() require "signal/freqz.mm";
void freqzp() require "signal/freqz.mm";

// freqzw.mm
List freqzw() require "signal/freqzw.mm";

// hamming.mm
Array hamming() require "signal/hamming.mm";

// hanning.mm
Array hanning() require "signal/hanning.mm";

// rceps.mm
List rceps() require "signal/rceps.mm";

// sawtooth.mm
Array sawtooth() require "signal/sawtooth.mm";

// square.mm
Array square(...) require "signal/square.mm";

// triang.mm
Array triang() require "signal/triang.mm";

// xcorr.mm
Array xcorr(...) require "signal/xcorr.mm";

// xcov.mm
Array xcov(...) require "signal/xcov.mm";

/* ------------------------------ Control ------------------------------ */

// TFadd.mm
List TFadd() require "control/TFadd.mm";

// TFsub.mm
List TFsub() require "control/TFsub.mm";

// TFmul.mm
List TFmul() require "control/TFmul.mm";

// TFinv.mm
List TFinv() require "control/TFinv.mm";

// TFtrans.mm
List TFtrans() require "control/TFtrans.mm";

// TFnegate.mm
List TFnegate() require "control/TFnegate.mm";

// abcdchk.mm
String abcdchk(...) require "control/abcdchk.mm";

// are.mm
Matrix are(...) require "control/are.mm";

// augment.mm
List augment() require "control/augment.mm";

// balreal.mm
List balreal() require "control/balreal.mm";

// bode.mm
List bode_ss(...)       require "control/bode.mm";
List bode_tf(...)       require "control/bode.mm";
List bode_tfn(...)      require "control/bode.mm";
List bode_tfm(...)      require "control/bode.mm";
void bode_plot_ss(...)  require "control/bode.mm";
void bode_plot_tf(...)  require "control/bode.mm";
void bode_plot_tfn(...) require "control/bode.mm";
void bode_plot_tfm(...) require "control/bode.mm";
List bode(...)          require "control/bode.mm";
List Bode_tf(...)       require "control/bode.mm";
List Bode_tfm(...)      require "control/bode.mm";
void bodeplot(...)      require "control/bode.mm";
void BodePlot_tf(...)   require "control/bode.mm";

// ccmat.mm
Matrix ccmat() require "control/ccmat.mm";
Matrix CoCanMat() require "control/ccmat.mm";

// charpoly.mm
Polynomial charpoly() require "control/charpoly.mm";

// ctrm.mm
Matrix ctrm() require "control/ctrm.mm";
Matrix ConMat() require "control/ctrm.mm";

// ctrf.mm
List ctrf(...) require "control/ctrf.mm";

// c2d.mm
List c2d() require "control/c2d.mm";
List Discretize() require "control/c2d.mm";

// canon.mm
List canon(...) require "control/canon.mm";
List CoCanTrans() require "control/canon.mm";

// d2c.mm
List d2c() require "control/d2c.mm";

// d2ce.mm
List d2ce() require "control/d2ce.mm";

// dbalreal.mm
List dbalreal() require "control/dbalreal.mm";

// dbode.mm
List dbode_ss(...)     require "control/dbode.mm";
void dbode_plot_ss(...) require "control/dbode.mm";

// dgramian.mm
Matrix dgramian() require "control/dgramian.mm";

// dhinf.mm
Matrix dhinf(...) require "control/dhinf.mm";
Matrix DHinf(...) require "control/dhinf.mm";

// dimpulse.mm
List dimpulse() require "control/dimpulse.mm";

// dlyap.mm
Matrix dlyap() require "control/dlyap.mm";

// dlqe.mm
List dlqe() require "control/dlqe.mm";

// dlqr.mm
List dlqr(...) require "control/dlqr.mm";
Matrix DOptimal(...) require "control/dlqr.mm";

// dlsim.mm
List dlsim(...) require "control/dlsim.mm";

// dric.mm
Matrix dric(...) require "control/dric.mm";
Matrix DRic(...) require "control/dric.mm";

// dstep.mm
List dstep() require "control/dstep.mm";

// faddeev.mm
List faddeev() require "control/faddeev.mm";

// feedback.mm
List feedback() require "control/feedback.mm";

// feedbk.mm
List feedbk(...) require "control/feedbk.mm";

// gmargin.mm
List gmargin(...) require "control/gmargin.mm";

// gramian.mm
Matrix gramian() require "control/gramian.mm";

// hinf.mm
Matrix hinf() require "control/hinf.mm";
Matrix Hinf() require "control/hinf.mm";

// impulse.mm
List impulse() require "control/impulse.mm";

// lqe.mm
List lqe() require "control/lqe.mm";

// lqr.mm
List lqr(...) require "control/lqr.mm";
Matrix Optimal(...) require "control/lqr.mm";

// lqrs.mm
List lqrs(...) require "control/lqrs.mm";

// lqry.mm
List lqry(...) require "control/lqry.mm";

// lsim.mm
List lsim(...) require "control/lsim.mm";

// ltifr.mm
CoMatrix ltifr() require "control/ltifr.mm";

// ltitr.mm
Matrix ltitr(...) require "control/ltitr.mm";

// lyap.mm
Matrix lyap(...) require "control/lyap.mm";
Matrix Lyapunov() require "control/lyap.mm";

// margin.mm
List margin() require "control/margin.mm";

// minreal.mm
List minreal(...) require "control/minreal.mm";

// mseqfr.mm
List mseqfr() require "control/mseqfr.mm";

// nicholsp.mm
void nicholsp(...) require "control/nicholsp.mm";

// nyquist.mm
List nyquist_ss(...)       require "control/nyquist.mm";
List nyquist_tf(...)       require "control/nyquist.mm";
List nyquist_tfn(...)      require "control/nyquist.mm";
List nyquist_tfm(...)      require "control/nyquist.mm";
void nyquist_plot_ss(...)  require "control/nyquist.mm";
void nyquist_plot_tf(...)  require "control/nyquist.mm";
void nyquist_plot_tfn(...) require "control/nyquist.mm";
void nyquist_plot_tfm(...) require "control/nyquist.mm";
List nyquist(...)          require "control/nyquist.mm";
List Nyquist_tf(...)       require "control/nyquist.mm";
List Nyquist_tfm(...)      require "control/nyquist.mm";
void NyquitPlot(...)       require "control/nyquist.mm";
void nyqplot(...)          require "control/nyquist.mm";

// obsg.mm
List obsg(...) require "control/obsg.mm";

// obsf.mm
List obsf(...) require "control/obsf.mm";

// obsm.mm
Matrix obsm() require "control/obsm.mm";

// parallel.mm
List parallel() require "control/parallel.mm";

// pmargin.mm
List pmargin(...) require "control/pmargin.mm";

// pplace.mm
Matrix pplace(...) require "control/pplace.mm";
Matrix PoleAssign(...) require "control/pplace.mm";

// resolven.mm
List resolvent() require "control/resolven.mm";

// ric.mm
Matrix Ric(...)  require "control/ric.mm";
Matrix ric(...)  require "control/ric.mm";

// riccati.mm
Matrix riccati() require "control/riccati.mm";
Matrix Riccati() require "control/riccati.mm";

// rlocus.mm
CoArray rlocus_ss(...)    require "control/rlocus.mm";
CoArray rlocus_tf(...)    require "control/rlocus.mm";
CoArray rlocus_tfn(...)   require "control/rlocus.mm";
CoArray rlocus_tfm(...)   require "control/rlocus.mm";
void rlocus_plot_ss(...)  require "control/rlocus.mm";
void rlocus_plot_tf(...)  require "control/rlocus.mm";
void rlocus_plot_tfn(...) require "control/rlocus.mm";
void rlocus_plot_tfm(...) require "control/rlocus.mm";
CoArray rlocus(...) require "control/rlocus.mm";
void rlocusp(...) require "control/rlocus.mm";

// series.mm
List series() require "control/series.mm";

// ss2tf.mm
List ss2tf(...) require "control/ss2tf.mm";

// ss2tfn.mm
Rational ss2tfn(...) require "control/ss2tfn.mm";

// ss2tfm.mm
RaMatrix ss2tfm(...) require "control/ss2tfm.mm";
Rational TransFunc() require "control/ss2tfm.mm";
RaMatrix TransFuncMat() require "control/ss2tfm.mm";

// ss2zp.mm
List ss2zp(...) require "control/ss2zp.mm";

// step.mm
List step_ss()  require "control/step.mm";
List step_tf()  require "control/step.mm";
List step_tfn() require "control/step.mm";
List step_tfm() require "control/step.mm";
List step()     require "control/step.mm";
List Step_tf()  require "control/step.mm";
List Step_tfm() require "control/step.mm";

// svfr.mm
Array svfr() require "control/svfr.mm";

// tf2ss.mm
List tf2ss() require "control/tf2ss.mm";

// tf2tfn.mm
Rational tf2tfn() require "control/tf2tfn.mm";

// tf2tfm.mm
RaMatrix tf2tfm() require "control/tf2tfm.mm";

// tf2zp.mm
List tf2zp() require "control/tf2zp.mm";

// tfm2ss.mm
List tfm2ss(...) require "control/tfm2ss.mm";

// tfm2tf.mm
List tfm2tf(...) require "control/tfm2tf.mm";

// tfm2tfn.mm
Rational tfm2tfn(...) require "control/tfm2tfn.mm";

// tfm2zp.mm
List tfm2zp(...) require "control/tfm2zp.mm";

// tfn2ss.mm
List tfn2ss() require "control/tfn2ss.mm";

// tfn2tf.mm
List tfn2tf() require "control/tfn2tf.mm";

// tfn2tfm.mm
RaMatrix tfn2tfm() require "control/tfn2tfm.mm";

// tfn2zp.mm
List tfn2zp() require "control/tfn2zp.mm";

// tzero.mm
CoMatrix tzero() require "control/tzero.mm";

// zp2ss.mm
List zp2ss() require "control/zp2ss.mm";

// zp2tf.mm
List zp2tf() require "control/zp2tf.mm";

// zp2tfn.mm
Rational zp2tfn() require "control/zp2tfn.mm";

// zp2tfm.mm
RaMatrix zp2tfm() require "control/zp2tfm.mm";

/* ------------------------------ Graph ------------------------------ */

// gcls.mm
void gcls() require "graph/gcls.mm";

// gplot.mm
void gplot(...) require "graph/gplot.mm";
void greplot(...) require "graph/gplot.mm";
void gplot_clear() require "graph/gplot.mm";
void gplot_reset() require "graph/gplot.mm";
void gplot_replot() require "graph/gplot.mm";
void gplot_cmd() require "graph/gplot.mm";
void gplot_quit() require "graph/gplot.mm";
void gplot_grid(...) require "graph/gplot.mm";
void gplot_key(...) require "graph/gplot.mm";
void gplot_loglog(...) require "graph/gplot.mm";
void greplot_loglog(...) require "graph/gplot.mm";
void gplot_options() require "graph/gplot.mm";
void gplot_psout(...) require "graph/gplot.mm";
void gplot_psplus(...) require "graph/gplot.mm";
void gplot_figcode(...) require "graph/gplot.mm";
void gplot_range(...) require "graph/gplot.mm";
void gplot_semilogx(...) require "graph/gplot.mm";
void greplot_semilogx(...) require "graph/gplot.mm";
void gplot_semilogy(...) require "graph/gplot.mm";
void greplot_semilogy(...) require "graph/gplot.mm";
void gplot_text(...) require "graph/gplot.mm";
void gplot_title()  require "graph/gplot.mm";
void gplot_xlabel(...) require "graph/gplot.mm";
void gplot_ylabel(...) require "graph/gplot.mm";
void gplot_subplot(...) require "graph/gplot.mm";

// mgplot.mm
void mgplot(...) require "graph/mgplot.mm";
void mgreplot(...) require "graph/mgplot.mm";
void mgplot_clear() require "graph/mgplot.mm";
void mgplot_reset() require "graph/mgplot.mm";
void mgplot_replot() require "graph/mgplot.mm";
void mgplot_cmd() require "graph/mgplot.mm";
void mgplot_quit(...) require "graph/mgplot.mm";
void mgplot_grid(...) require "graph/mgplot.mm";
void mgplot_key(...) require "graph/mgplot.mm";
void mgplot_loglog(...) require "graph/mgplot.mm";
void mgreplot_loglog(...) require "graph/mgplot.mm";
void mgplot_options() require "graph/mgplot.mm";
void mgplot_psout(...) require "graph/mgplot.mm";
void mgplot_figcode(...) require "graph/mgplot.mm";
void mgplot_range(...) require "graph/mgplot.mm";
void mgplot_semilogx(...) require "graph/mgplot.mm";
void mgreplot_semilogx(...) require "graph/mgplot.mm";
void mgplot_semilogy(...) require "graph/mgplot.mm";
void mgreplot_semilogy(...) require "graph/mgplot.mm";
void mgplot_text(...) require "graph/mgplot.mm";
void mgplot_title() require "graph/mgplot.mm";
void mgplot_xlabel(...) require "graph/mgplot.mm";
void mgplot_ylabel(...) require "graph/mgplot.mm";
Integer mgplot_cur_win(...) require "graph/mgplot.mm";
Integer mgplot_newwindow() require "graph/mgplot.mm";
Integer mgplot_hold(...) require "graph/mgplot.mm";
void mgplot_subplot(...) require "graph/mgplot.mm";

// xplot.mm
void xplot(...) require "graph/xplot.mm";
void xplot_grid(...) require "graph/xplot.mm";
void xplot_semilogx(...) require "graph/xplot.mm";
void xplot_title() require "graph/xplot.mm";
void xplot_xlabel() require "graph/xplot.mm";
void xplot_xsplit() require "graph/xplot.mm";
void xplot_ylabel() require "graph/xplot.mm";
void xplot_ysplit() require "graph/xplot.mm";
