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
char * atribs [2048];
char * auxAtribs [2048];
int comPonto[2048] = {0};
char aux [2048];
int inicio = 1;
int ia=0;

int writeSons(int i)
{
  char * delim = strdup(" ");
  printf("\n%s<%s%s>%s",spaces[i],names[i],atribs[i],conteudo[i]);
  int j=i+1;
  int found=0;
  for (;j<=id;j++)
  {
    if (strlen(spaces[j])>strlen(spaces[i])&&comPonto[i]==0)
      j = writeSons(j)-1;
    else if (strlen(spaces[j])>strlen(spaces[i])&&comPonto[i]==1)
         {
           printf("\n%s%s%s%s",spaces[j],names[j],atribs[j],conteudo[j]);
         }
         else {
         // Talvez melhor depois mudar esta parte para que nao tenhamos de estar a separar o nome outra vez
         // Fazemos logo a separação no parser
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

%token <s> STR TABS TXT ID CLASS ATRIB PONTO
%type <s> Etiqueta Conteudo PrimeiraEtiqueta Nome Id Classe Extra Atribuicoes

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
Etiqueta:TABS Nome Atribuicoes Ponto Conteudo  { id++;spaces[id]=strdup($1);conteudo[id]=strdup($5);names[id]=strdup($2);atribs[id]=strdup($3);}
PrimeiraEtiqueta:Nome Atribuicoes Ponto Conteudo {id++;conteudo[id]=strdup($4);spaces[id]="";names[id]=strdup($1);atribs[id]=strdup($2);}
Atribuicoes: Atributos {sprintf(aux,"");
                        for (int i=0;i<ia;i++)
                        {
                          if (i==0)
                          {
                            strcat(aux,strdup(" "));
                          }
                          strcat(aux,auxAtribs[i]);
                          if (i+1<ia)
                          {
                            strcat(aux,strdup(" "));
                          }
                        }
                        $$=strdup(aux);
                        ia=0;  
                       }
Ponto: PONTO {comPonto[id+1]=1;}
     |
     ;                       
Atributos : ATRIB Atributos {auxAtribs[ia++]=strdup($1);}
          | 
          ;
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