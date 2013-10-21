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

parser.cpp: parser.y
	bison -d -o parser.cpp parser.y

parser.o: parser.cpp
	${CXX} ${FLAGS2} parser.cpp -o parser.o

lexer.cpp: parser.cpp
	flex lexer.l

lexer.o: lexer.cpp
	${CXX} ${FLAGS2} lexer.cpp -o lexer.o

parser_main.o: parser_main.cpp
	${CXX} ${FLAGS2} parser_main.cpp

parser: parser_main.o parser.o lexer.o heapliteral.o heapabstraction.o heaptransformer.o
	${CXX} ${FLAGS1} -o parser parser_main.cpp parser.o lexer.o heapliteral.o heapabstraction.o heaptransformer.o

clean:
	rm -f *o


