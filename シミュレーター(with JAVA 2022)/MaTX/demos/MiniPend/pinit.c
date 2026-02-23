#include <stdio.h>
#include <dos.h>
#ifdef __DJGPP__
#include <go32.h>
#include <sys/farptr.h>
#endif

#define DEFAULT_BASEL 0x78
#define DEFAULT_BASEH 0x3

#ifdef TEST
int pport_out_adr, pport_in_adr, pport_con_adr;

void main()
{
	void pport_init();

	pport_init();
}
#endif

/* プリンターポートの初期化 */
#ifndef PC9801
void pport_init()
{
#ifndef MSVC
	union REGS regs;
#endif
#if __MSC__ || __TURBOC__
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
#ifdef TEST
	printf("basel = %x\n", basel);
	printf("baseh = %x\n", baseh);
#endif
/*
	dosmemget(0x40 * 16 + 0x08, 1, &basel);
	dosmemget(0x40 * 16 + 0x09, 1, &baseh);
*/
#endif
#ifdef MSVC
/*
	basel = *((unsigned char *)(0x40*16 + 0x08));
	baseh = *((unsigned char *)(0x40*16 + 0x09));
*/
	basel = DEFAULT_BASEL;
	baseh = DEFAULT_BASEH;
#endif
#if __MSC__ || __TURBOC__
	bioswork = (unsigned char far *)MK_FP(0x40, 0x08);
	basel = *bioswork;
	baseh = *(bioswork + 1);
#endif
	pport_base = basel + baseh * 256;

	pport_out_adr = pport_base;
	pport_in_adr  = pport_base + 1;
	pport_con_adr = pport_base + 2;
	
	/* プリンタポートの初期化 */
#ifndef MSVC
	regs.h.ah = 0x01;
	int86(0x17, &regs, &regs);
#endif
}
#endif
