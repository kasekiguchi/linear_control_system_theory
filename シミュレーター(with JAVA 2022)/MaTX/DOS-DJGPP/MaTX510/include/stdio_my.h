#ifdef HAVE_STDIO_MY_H
extern int fflush();
extern int fputs();
extern int fputc();
extern int printf();
extern int fprintf();
extern int vfprintf();
extern int vsprintf();
extern int fclose();
extern int fread();
extern int fwrite();
extern int sscanf();
extern int fscanf();
extern int scanf();
extern int fseek();
extern void setbuf();
#endif

#ifdef SUNOS40
extern int exit();
extern int free();
extern int sprintf();
extern int read();
extern int write();
extern int sleep();
extern int atoi();
extern int abs();
extern int gettimeofday();
#endif
