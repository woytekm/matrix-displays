all:
	gcc matrixlib.c -g -c -o matrixlib.o
	gcc matrixtest.c -g -c -o matrixtest.o
	gcc matrixlib.o matrixtest.o -g -o matrixtest -lbcm2835

matrixtest2:
	gcc matrixlib.c -g -c -o matrixlib.o
	gcc matrixtest2.c -g -c -o matrixtest2.o
	gcc matrixlib.o matrixtest2.o -g -o matrixtest2 -lbcm2835

clean: 
	rm -f *.o matrixtest matrixtest2
