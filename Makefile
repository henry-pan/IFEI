#Makefile for the Java version

JAVASRC    = IFEI.java dLinkedList.java queuePath.java
SOURCES    = ${JAVASRC} Makefile
ALLSOURCES = ${SOURCES}
MAINCLASS  = IFEI
CLASSES    = ${patsubst %.java, %.class, ${JAVASRC}}

all: ${CLASSES}

%.class: %.java
	javac -Xlint $<

clean:
	rm -f *.class

test: all
	java IFEI

.PHONY: clean all test
