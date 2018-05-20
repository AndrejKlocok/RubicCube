# projekt: Rubikova kostka
# autor: Andrej Klocok
# login: xkloco00

#program name
PROGRAM_NAME=flp18-log
#compiler
CC=swipl
#archive
ARCHIVE_NAME=flp-log-xkloco00
#README
README=README.md

all: compile

compile:	
	$(CC) -g start -o flp18-log -c $(PROGRAM_NAME).pl

pack:
	zip $(ARCHIVE_NAME).zip  $(PROGRAM_NAME).pl $(README) Makefile

clean:
	rm -r flp18-log
	rm -f $(ARCHIVE_NAME).zip