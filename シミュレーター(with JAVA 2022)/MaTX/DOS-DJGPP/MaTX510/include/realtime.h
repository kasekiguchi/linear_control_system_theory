
void *rtSetTask();
void *rtSetBreak();
void *rtResetTask();
double rtSetClock();
void rtStart();
void rtStop();
void rtStartRehearsal();
void rtStopRehearsal();
void rtOnceTry();
int rtIsTimeOut();
int rtIsOnline();
int rtIsRunning();
int rtIsRehearsal();


#ifdef VC40
void rtInitializeCriticalSection();
void rtDeleteCriticalSection();
void rtEnterCriticalSection();
void rtLeaveCriticalSection();
#endif
