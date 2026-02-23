#!/bin/sh
# Tricycle and Trailer Simulator execute script
# written by Shigeki Nakaura on Tue Dec  5 12:09:21 2000
# rewritten by Napoleon on Tue Sep 25 15:50:13 2001
# rewritten by Shigeki Nakaura on Mon Sep 13 00:14:22 2004

# check file
if [ ! -f Simulator.jar ]; then
    echo "Simulator.jar does not exist."
    exit 3
fi

# check directory
if [ ! -d images ]; then
    echo "Images directory does not exist."
    exit 3
fi

# check OS
KNAME=`/bin/uname -s`
if [ $KNAME = Linux ]; then
    OS=Linux
elif [ $KNAME = SunOS ]; then
    if [ `/bin/uname -p` = i386 ]; then
	OS="Solaris/X86"
    elif [ `/bin/uname -p` = sparc ]; then
	OS="Solaris/Sparc"
    fi
else
    echo "Your operating system are not known."
    exit 3
fi

# export java environment
JAVA_PATH=$OS/jre1.5.0_04
PATH=$PATH:$JAVA_PATH/bin
export JAVA_PATH PATH

# execute simulator
$JAVA_PATH/bin/java -jar Simulator.jar
