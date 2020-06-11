%{
 int yylex();
 void yyerror(char*);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nodo.h"

int id=0;
char * spaces [2048];
char * conteudo [2048];
char * names [2048];
char aux [2048];
int inicio = 1;

int writeSons(int i)
{
  char * delim = strdup(" ");
  printf("\n%s<%s>%s",spaces[i],names[i],conteudo[i]);
  int j=i+1;
  int found=0;
  for (;j<=id;j++)
  {
    if (strlen(spaces[j])>strlen(spaces[i]))
      j = writeSons(j)-1;
    else {
        char *ptr = strtok(names[i], delim);  
      printf("\n%s</%s>",spaces[i],ptr);
      found=1;
      break;
    }  
  }
    char *ptr = strtok(names[i], delim);
  if (!found) printf("\n%s</%s>",spaces[i],ptr);
  return j;
}

%}

%union{ 
        double n;
		    char v;
        double (*f)(double);
        char * s;
	  }

%token <s> STR TABS TXT ID CLASS
%type <s> Etiqueta Conteudo PrimeiraEtiqueta Nome Id Classe Extra

%%
Pug:
   | Etiquetas Pug
   ;
Etiquetas:PrimeiraEtiqueta Outros {
  for (int i=inicio;i<=id;i++)
  {
      i=writeSons(i)-1;
  }
  inicio = id+1;
  }
Outros:  
      |  Etiqueta Outros 
Etiqueta:TABS Nome Conteudo  { id++;spaces[id]=strdup($1);conteudo[id]=strdup($3);names[id]=strdup($2);}
PrimeiraEtiqueta:Nome Conteudo {id++;conteudo[id]=strdup($2);spaces[id]="";names[id]=strdup($1);}
Conteudo:TXT {$$=strdup($1);}
        |    {$$=strdup("");}
        ;
Nome: STR Extra {sprintf(aux,"%s%s",$1,$2);$$=strdup(aux);}
    | Id Classe {sprintf(aux,"div%s%s",$1,$2);$$=strdup(aux);}
    | Classe {sprintf(aux,"div%s",$1);$$=strdup(aux);}
    ;
Extra: Id Extra {sprintf(aux,"%s%s",$1,$2);$$=strdup(aux);}
     | Classe {$$=$1;}
     | {$$="";}
     ;    
Id : ID {sprintf(aux," id=\"%s\"",$1);$$=strdup(aux);}
Classe : CLASS {sprintf(aux," class=\"%s\"",$1);$$=strdup(aux);}              
%%

int main(){
    yyparse();
    return 0;
}

void yyerror(char* s){
   extern int yylineno;
   extern char* yytext;
   fprintf(stderr, "Linha %d: %s (%s)\n",yylineno,s,yytext);
}