NETTIS_KERNEL=nettis

CC=gcc
CR=shards

LIBS=-ltesseract -llept
INC=-I/usr/include/tesseract/ -I/usr/include/leptonica

BINDIR=bin

OCR_MODULE=src/nettis/record/nocr/libs/ocr.c -o $(BINDIR)/ocr

all:
	$(CC) $(LIBS) $(INC) $(OCR_MODULE)
	$(CR) build

clean:
	rm -rf bin/*
