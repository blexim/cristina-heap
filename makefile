CXX = g++
FLAGS1 = -ggdb -Wall 
FLAGS2 = -ggdb -Wall -c

heap : main.o heapliteral.o heapabstraction.o heaptransformer.o
	${CXX} ${FLAGS1} main.o heapliteral.o heapabstraction.o heaptransformer.o -o heap

main.o : main.cpp heapliteral.h heaptransformer.h heapabstraction.h heaprefine.h heapheuristics.h heaptesting.h heapwatches.h
	${CXX} ${FLAGS2} main.cpp

heapliteral.o: heapliteral.cpp heapliteral.h
	${CXX} ${FLAGS2} heapliteral.cpp

heapabstraction.o: heapabstraction.cpp heapabstraction.h
	${CXX} ${FLAGS2} heapabstraction.cpp

heaptransformer.o: heaptransformer.cpp heaptransformer.h
	${CXX} ${FLAGS2} heaptransformer.cpp

parser.cpp:
	bison -d -o parser.cpp parser.y

lexer.cpp: parser.cpp
	flex lexer.l

parser: parser.cpp lexer.cpp heapliteral.o heapabstraction.o heaptransformer.o
	${CXX} -o parser parser_main.cpp parser.cpp lexer.cpp heapliteral.o heapabstraction.o heaptransformer.o

clean:
	rm -f *o


