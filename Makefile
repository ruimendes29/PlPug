SHELL=bash
a=pugParser

$a : $a.y $a.fl
	flex $a.fl
	yacc -d $a.y
	cc -o $a y.tab.c lex.yy.c nodo.h -lm

teste: $a exemplo
	paste -d: exemplo <($a  < exemplo ) | column -t -s:

install: $a
	cp $a /usr/local/bin/

clean:
	rm -f lex.yy.c y.tab.*