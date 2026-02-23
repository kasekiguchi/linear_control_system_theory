#include <dos.h>
#ifdef __DJGPP__
#include <go32.h>
#include <sys/farptr.h>
#endif

/* プリンターポートの初期化 */
#ifndef PC9801
void pport_init()
{
	union REGS regs;
#ifndef __DJGPP__
	unsigned char far *bioswork;
#endif
	unsigned char basel, baseh;
	unsigned int pport_base;

	extern int pport_out_adr, pport_in_adr, pport_con_adr;

	/*
	 *  BIOSワークエリアに書き込まれている
	 *  パラレルポートのI/Oベースアドレスの取得
	 */
	/* BIOSワークエリア */
#ifdef __DJGPP__
	basel = _farpeekb(_dos_ds, 0x40*16 + 0x08);
	baseh = _farpeekb(_dos_ds, 0x40*16 + 0x09);
/*
	dosmemget(0x40 * 16 + 0x08, 1, &basel);
	dosmemget(0x40 * 16 + 0x09, 1, &baseh);
*/
#else
	bioswork = (unsigned char far *)MK_FP(0x40, 0x08);
	basel = *bioswork;
	baseh = *(bioswork + 1);
#endif
	pport_base = basel + baseh * 256;

	pport_out_adr = pport_base;
	pport_in_adr  = pport_base + 1;
	pport_con_adr = pport_base + 2;
	
	/* プリンタポートの初期化 */
	regs.h.ah = 0x01;
	int86(0x17, &regs, &regs);
}
#endif
