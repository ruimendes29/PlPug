%{
 int yylex();
 void yyerror(char*);
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nodo.h"

int id=0;
char * atribs [2048];
char * auxAtribs [2048];
int comPonto[2048] = {0};
char aux [2048];
int inicio = 1;
char ** holderForAtribs;
Etiqueta ** etiquetas;
int ia=0;
int ig=0;
int newGroup=0;
Etiquetas* grupos[2048];
int numEtiquetas=0;

int writeSons(int i,int ixg,Etiqueta * * ets)
{
  int j;
  if (i!=ixg)
  {
    putchar('\n');
  }
    printf("%s<%s%s%s",ets[i]->espacos,ets[i]->nome,ets[i]->id,
                            ets[i]->classe);   
    for(int a=0;a<ets[i]->atributos->size;a++)
    {
      printf(" %s",ets[i]->atributos->atribs[a]);
    }
    printf(">%s",ets[i]->conteudo);
    j=i-1;
    for (;j>=0;j--)
    {
    if (ets[j]->identacao > ets[i]->identacao && ets[i]->hasPoint==0)
    {
              j = writeSons(j,ixg,ets)+1;
    }
    else if (ets[j]->identacao > ets[i]->identacao && ets[i]->hasPoint==1)
         {
           printf("\n%s%s",ets[j]->espacos,ets[j]->nome);
           for(int a=0;a<ets[j]->atributos->size;a++)
           {
              printf(" %s",ets[j]->atributos->atribs[a]);
           }
           printf("%s",ets[j]->conteudo);
         }
         else { 
         break;
        }  
  }
  printf("</%s>",ets[i]->nome);
  if(i==ixg || i==0)
    putchar('\n');
  return j;
}
  

%}

%union{ 
        double n;
		    char v;
        int i;
        double (*f)(double);
        char * s;
        char ** ss;
        void * e;
	  }

%token <s> STR TABS TXT ID CLASS ATRIB PONTO IF BOOL
%type <s> Conteudo Nome Id Classe Espacos
%type <i> Ponto
%type <e> Etiqueta SubEtiqueta Etiquetas Atribuicoes

%%
ToPrint: Pug {
  Etiquetas * grupo;   
  for (int i=ig-1;i>=0;i--)
   {
     grupo=grupos[i];
     for (int j=grupo->size-1;j>=0;j--)
        j=writeSons(j,grupo->size-1,grupo->tags)+1;
   }
     }
Pug:                
   | Etiquetas Pug { 
     Etiquetas * aux = (Etiquetas *) $1;
     grupos[ig++]=aux;
   }
   ;
Etiquetas:Etiqueta Outros{
  Etiquetas * ets = malloc(sizeof(struct etiquetas));
  Etiqueta ** thisEtiq=etiquetas;
  etiquetas[id++]=$1;
  ets->size=id;
  ets->tags=thisEtiq;
  id=0;
  etiquetas=NULL;
  $$=ets;
  }
  ;
Outros:  
      |  SubEtiqueta Outros {etiquetas[id++]=$1;}
      ;
Etiqueta:Espacos Nome Id Classe Atribuicoes Ponto Conteudo  {
                                                           if (etiquetas==NULL)
                                                           {
                                                             etiquetas=malloc(sizeof(struct etiqueta *)*2048);
                                                           }
                                                           Etiqueta * eti = malloc(sizeof(struct etiqueta));
                                                           eti->espacos=strdup($1);
                                                           eti->nome=strdup($2);
                                                           eti->id=strdup($3);
                                                           eti->classe=strdup($4);
                                                           eti->atributos=$5;
                                                           eti->hasPoint=$6;
                                                           eti->conteudo=strdup($7);
                                                           eti->identacao=strlen(eti->espacos);
                                                           $$=eti;
                                                           }
                                                           ;
SubEtiqueta:TABS Nome Id Classe Atribuicoes Ponto Conteudo  {
                                                           if (etiquetas==NULL)
                                                           {
                                                             etiquetas=malloc(sizeof(struct etiqueta *)*2048);
                                                           }
                                                           Etiqueta * eti = malloc(sizeof(struct etiqueta));
                                                           eti->espacos=strdup($1);
                                                           eti->nome=strdup($2);
                                                           eti->id=strdup($3);
                                                           eti->classe=strdup($4);
                                                           eti->atributos=$5;
                                                           eti->hasPoint=$6;
                                                           eti->conteudo=strdup($7);
                                                           eti->identacao=strlen(eti->espacos);
                                                           $$=eti;
                                                           }
                                                           ;                                                           
Atribuicoes: ATRIB Atributos {char ** atributos;
                              if (holderForAtribs==NULL) holderForAtribs=malloc(sizeof(char *)*2048);
                              holderForAtribs[ia++]=strdup($1);
                              atributos=holderForAtribs;
                              Atributos * atribs = malloc(sizeof(struct atributos));
                              atribs->atribs=atributos;
                              atribs->size=ia;
                              $$=atribs;
                              ia=0;
                              holderForAtribs=NULL;}
           | {Atributos * atribs = malloc(sizeof(struct atributos));
                              atribs->atribs=NULL;
                              atribs->size=0;
                              $$=atribs;}
           ;
Espacos:TABS {$$=$1;}
       |  {$$="";}
       ;                       
Ponto: PONTO {$$=1;}
     |  {$$=0;}
     ;                       
Atributos : ATRIB Atributos {if (holderForAtribs==NULL) holderForAtribs=malloc(sizeof(char *)*2048); holderForAtribs[ia++]=strdup($1);}
          | 
          ;
Conteudo:TXT {$$=strdup($1);}
        |    {$$=strdup("");}
        ;
Nome: STR {$$=$1;}
    | {$$="div";}
    ;  
Id : ID {sprintf(aux," id=\"%s\"",$1);$$=strdup(aux);}
   | {$$="";}
   ;
Classe : CLASS {sprintf(aux," class=\"%s\"",$1);$$=strdup(aux);}   
       | {$$="";}
       ;           
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