

#ifndef MATX_CONFIG
#define MATX_CONFIG			1

/* For MinMaTX */
#define MATX_SMALL			1
#undef MATX_SMALL

#define OBJECT_FUNC			1
#define MATRIX_EDITOR		1
#define GARBAGE_TABLE		1
#define USE_INPLINE			1
#define DEFAULT_PAGER		"more"
#define MATX_HELP_FILE		"matx.hlp"
#define MATX_FUNC_FILE		"matx.fnc"
#define MATX_LOGFILE		"MaTX.log"

/* #define MACINTOSH 1 */

#ifdef BSD42
#define HAVE_NO_MEMCPY 1
#define HAVE_NO_STRPBRK 1
#define HAVE_NO_ISNAN 1
#define HAVE_INDEX 1
#define HAVE_STRINGS 1
#define HAVE_PIPE 1
#define HAVE_STDIO_MY_H 1
#define	KBHIT_SELECT 1
#endif /* BSD42 */
#ifdef BSD43
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define HAVE_STDIO_MY_H 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_NO_SIGNED 1
#define volatile 
#endif /* BSD43 */
#ifdef BSD44
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_SYS_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#endif /* BSD44 */

#ifdef DEC
#define HAVE_NO_ISINF 1
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_SYS_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#endif /* DEC */

#ifdef SOLARIS
#define HAVE_NO_ISINF 1
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_IEEEFP_H 1
#endif /* SOLARIS */

#ifdef IRIX
#define HAVE_NO_ISINF 1
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_IEEEFP_H 1
#endif /* IRIX */

#ifdef SYSV
#define HAVE_TERMIOS_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#endif /* SYSV */

#ifdef MIPS
#define HAVE_TERMIOS_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#endif /* MIPS */

#ifdef HP_UX
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#endif /* HP_UP */

#ifdef LINUX
#define HAVE_MEMORY_H 1
#define HAVE_TERMIOS_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_STDARG 1
#endif /* LINUX */

#ifdef NEWS
#define HAVE_SYS_IOCTL_H 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define	KBHIT_SELECT 1
#endif /* NEWS */

#ifdef NEWS_OS_421
#define HAVE_NO_ISINF 1
#define HAVE_NO_ISNAN 1
#endif /* NEWS_OS_421 */

#ifdef MACINTOSH
#define HAVE_NO_SIGQUIT 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_UNISTD_H 1
#define HAVE_NO_SLEEP 1
#define HAVE_NO_ACCESS 1
#define HAVE_NO_DIR 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_PID 1
#define HAVE_NO_GETTIMEOFDAY 1
#define HAVE_TIME_H 1
#define HAVE_STDARG 1
#define HAVE_TIME_T  1
#endif /* MACINTOSH */

#ifdef X68K
#define HAVE_NO_SLEEP 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_PID 1
#define HAVE_GETCH 1
#define HAVE_MALLOC_H 1
#endif /* X68K */

#ifdef VXWORKS
#define HAVE_NO_SLEEP 1
#define HAVE_NO_VFPRINTF 1
#define HAVE_NO_SETJMP_H 1
#define HAVE_PIPE 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#endif /* VXWORKS */

#ifdef WATCOM
#define HAVE_NO_PID 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_ISINF 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_SIGQUIT 1
#define HAVE_NO_SIGHUP 1
#define HAVE_NO_GETTIMEOFDAY 1
#define HAVE_DOS_ARROW_KEY 1
#define HAVE_DOS_MORE 1
#define HAVE_DOSFILE 1
#define HAVE_GETCH 1
#define	HAVE_KBHIT 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define HAVE_SHORT_FILENAME 1
#define HAVE_STDARG 1
#define HAVE_TIME_H 1
#undef	MSDOS
#undef  DEFAULT_PAGER
#define DEFAULT_PAGER		"less"
#endif /* WATCOM */

#ifdef VC40
#define HAVE_NO_UNISTD_H 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_SIGQUIT 1
#define HAVE_NO_SIGHUP 1
#define HAVE_NO_GETTIMEOFDAY 1
#define HAVE_NO_DIR 1
#define HAVE_NO_SLEEP 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_ISINF 1
#define HAVE_CLOCK 1
#define HAVE_DOSFILE 1
#define HAVE_DOS_ARROW_KEY 1
#define HAVE_DOS_MORE 1
#define HAVE_GETCH 1
#define HAVE_MALLOC_H 1
#define HAVE_PIPE 1
#define HAVE_SHORT_FILENAME 1
#define HAVE_TIME_H 1
#define HAVE_TIME_T 1
#define _ANSI_SOURCE 1
#endif /* VC40 */

#ifdef __DJGPP__
#define HAVE_NO_SIGTSTP 1
#define HAVE_MEMORY_H 1
#define HAVE_MALLOC_H 1
#define HAVE_GETCH 1
#define HAVE_CONIO_H 1
#define HAVE_SHORT_FILENAME 1
#define HAVE_DOSFILE 1
#define	HAVE_KBHIT 1
#define HAVE_RESOURCE_H 1
#define HAVE_GETRUSAGE 1
#define HAVE_DOS_ARROW_KEY 1
#define HAVE_DOS_MORE 1
#undef	MSDOS
#define IBMPC 1
#undef  PC9801
#endif /* __DJGPP__ */

#ifdef DOS4GW
#define HAVE_NO_PID 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_ISINF 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_SIGQUIT 1
#define HAVE_NO_SIGHUP 1
#define HAVE_NO_GETTIMEOFDAY 1
#define HAVE_MALLOC_H 1
#define HAVE_GETCH 1
#define HAVE_SHORT_FILENAME 1
#define HAVE_STDARG 1
#define HAVE_TIME_H 1
#define HAVE_DOS_MORE 1
#define HAVE_DOSFILE 1
#define	HAVE_KBHIT 1
#undef	MSDOS
#undef  DEFAULT_PAGER
#define DEFAULT_PAGER		"less"
#endif /* DOS4GW */

#ifdef MSDOS
#define HAVE_NO_PID 1
#define HAVE_NO_ISNAN 1
#define HAVE_NO_SIGNAL
#define HAVE_NO_SIGTERM 1
#define HAVE_NO_SIGFPE 1
#define HAVE_NO_UNISTD_H 1
#define HAVE_NO_GETTIMEOFDAY 1
#define HAVE_NO_SIGTSTP 1
#define HAVE_NO_DIR 1
#define HAVE_SMALL_MEMORY 1
#define HAVE_SHORT_FILENAME 1
#define HAVE_DOSFILE 1
#define HAVE_DOS_MORE 1
#define HAVE_TIME_H 1
#define HAVE_STDIO_MY_H 1
#define HAVE_GETCH 1
#define	HAVE_KBHIT 1
#define HAVE_DOS_ARROW_KEY 1

#ifdef MSC40
#define HAVE_MEMORY_H 1
#define HAVE_MALLOC_H 1
#endif /* MSC40 */
#ifdef MSC60
#define HAVE_MALLOC_H 1
#define HAVE_NO_SLEEP 1
#endif /* MSC60 */
#ifdef TRC15
#define HAVE_ALLOC_H 1
#define HAVE_MEM_H 1
#define HAVE_NO_SIGINT 1
#endif /* TRC15 */
#ifdef BRC20
#define HAVE_ALLOC_H 1
#endif /* BRC20 */
#endif /* MSDOS */

#ifdef IRIX
#define	DEFAULT_MATXDIR		"/home/edadmin/cr/myamakit/local/MaTX"
#define	DEFAULT_MFILE_PATH	"/home/edadmin/cr/myamakit/local/MaTX/inputs"
#else /* IRIX */
#ifdef DEC
#define	DEFAULT_MATXDIR		"/usr/usr8/mkoga/MaTX"
#define	DEFAULT_MFILE_PATH	"/usr/usr8/mkoga/MaTX/inputs"
#else /* DEC */
#ifdef X68K
#define	DEFAULT_MATXDIR		"f:/MaTX"
#define	DEFAULT_MFILE_PATH	"f:/MaTX/inputs"
#else /* X68K */
#ifdef NEWS_OS_421
#define	DEFAULT_MATXDIR		"/home/edadmin/cr0/MaTX"
#define	DEFAULT_MFILE_PATH	"/home/edadmin/cr0/MaTX/inputs"
#else /* NEWS_OS_421 */
#ifdef __DJGPP__
#define	DEFAULT_MATXDIR		"c:/MaTX-DJ"
#define	DEFAULT_MFILE_PATH	"c:/MaTX-DJ/inputs"
#else /* __DJGPP__ */
#ifdef WATCOM
#define	DEFAULT_MATXDIR		"c:/win32app/MaTX"
#define	DEFAULT_MFILE_PATH	"c:/win32app/MaTX/inputs"
#else /* WATCOM */
#ifdef VC40
#define	DEFAULT_MATXDIR		"c:/Program Files/TITECH/MaTX-VC"
#define	DEFAULT_MFILE_PATH	"c:/Program Files/TITECH/MaTX-VC/inputs"
#define DEFAULT_MSVCDIR		"c:/Program Files/DevStudio/VC"
#define DEFAULT_MSDEVDIR	"c:/Program Files/DevStudio/SharedIDE"
#else /* VC40 */
#ifdef DOS4GW
#define	DEFAULT_MATXDIR		"c:/app/MaTX"
#define	DEFAULT_MFILE_PATH	"c:/app/MaTX/inputs"
#else /* DOS4GW */
#ifdef MACINTOSH
#define	DEFAULT_MATXDIR		"Macintosh HD:Application:MaTX"
#define	DEFAULT_MFILE_PATH	"Macintosh HD:Application:MaTX:inputs"
#define	MATXINPUTS			"Macintosh HD:Application:MaTX:inputs;Macintosh HD:Application:MaTX:inputs:control;Macintosh HD:Application:MaTX:inputs:graph"
#else /* MACINTOSH */
#define	DEFAULT_MATXDIR		"/usr/local/MaTX"
#define	DEFAULT_MFILE_PATH	"/usr/local/MaTX/inputs"
#endif /* MACINTOSH */
#endif /* DOS4GW */
#endif /* VC40 */
#endif /* WATCOM */
#endif /* __DJGPP__ */
#endif /* NEWS_OS_421 */
#endif /* X68K */
#endif /* DEC */
#endif /* IRIX */

/** MATX_SMALL **/
#ifndef MATX_SMALL
#define POLY      1
#define RAT       1
#define P_MAT     1
#define R_MAT     1
#define LST       1
#define HAVE_MENU 1
#define MXSTR     1
#else
#undef POLY
#undef RAT
#undef P_MAT
#undef R_MAT
#define LST       1
#define HAVE_MENU 1
#define MXSTR 1
#endif
/** MATX_SMALL **/

#ifdef BRC20
#undef	HAVE_IEEE_MATH
#else
#ifdef MSC60
#undef	HAVE_IEEE_MATH
#else
#ifdef X68K
#undef	HAVE_IEEE_MATH
#else
#ifdef MACINTOSH
#undef	HAVE_IEEE_MATH
#else
#ifdef WATCOM
#undef	HAVE_IEEE_MATH
#else
#define HAVE_IEEE_MATH
#endif
#endif
#endif
#endif
#endif

#ifdef VC40
#ifdef MATX_RT
/* For multithread */
#define _MT 1
#endif
#endif

#endif
