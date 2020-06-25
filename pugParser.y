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
char aux [2048];
int inicio = 1;
char ** holderForVariables;
char ** holderForValues;
Etiqueta ** etiquetas;
int ia=0;
int ig=0;
Etiquetas* grupos[2048];
int numEtiquetas=0;
BD * mybd=NULL;
char * tipoAux;

void printAtributos(int i,Etiqueta ** ets)
{
  char ** type= malloc(sizeof(char *));
for(int a=0;a<ets[i]->atributos->size;a++)
    {
      if (ets[i]->atributos->values[a][0]=='\"')
        printf(" %s=%s",ets[i]->atributos->variables[a],ets[i]->atributos->values[a]);
      else
      {
          char * value = getValorAndType(mybd,ets[i]->atributos->values[a],type);
          if (!strcmp(*type,strdup("string")))
          {
            printf(" %s=%s",ets[i]->atributos->variables[a],strdup(value));
          }
      }
    }
}
void writeNormalLine(int i,Etiqueta ** ets)
{

}

int writeSons(int i,int idxg,int ixg,Etiqueta * * ets)
{
  int j;
  j=i-1;
  if (!strcmp(ets[i]->nome,strdup("if")))
  {
      char ** type= malloc(sizeof(char *));
      int * value = getValorAndType(mybd,ets[i]->condicao,type);
      if (value!=NULL && *value==1)
      {
        j=writeSons(j,idxg,ixg,ets);
      }
      else
      {
        for(;j>=0;j--)
        {
          if (ets[j]->identacao <= ets[i]->identacao) break;
        }
        if (!strcmp(ets[j]->nome,strdup("else")))
        {
          j--;
        }
      }
  }
  else {
  j=i-1;
  if(i!=ixg || idxg!=ig-1)
    putchar('\n');
    printf("%s<%s",ets[i]->espacos,ets[i]->nome);  
    if (strcmp(ets[i]->id,""))
    {
      printf(" id=\"%s\"",ets[i]->id);
    }
    if (strcmp(ets[i]->classe,""))
    {
      printf(" class=\"%s\"",ets[i]->classe);
    }
    printAtributos(i,ets);
    printf(">%s",ets[i]->conteudo);
    for (;j>=0;j--)
    {
      if (ets[j]->identacao > ets[i]->identacao)
      {
              j = writeSons(j,idxg,ixg,ets)+1;
      }
      else break;
    }
  if(i==ixg)
    putchar('\n');
  printf("</%s>",ets[i]->nome);}
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

%token<i> BOOL
%token <s> STR TABS TXT ID CLASS ATRIB PONTO NEW VAR SVALUE IF COND
%type <s> Conteudo Nome Id Classe Espacos Condicao
%type <i> Ponto
%type <e> Etiqueta SubEtiqueta Etiquetas Atribuicoes

%%
ToPrint: Pug {
  Etiquetas * grupo;   
  for (int i=ig-1;i>=0;i--)
   {
     grupo=grupos[i];
     for (int j=grupo->size-1;j>=0;j--)
        j=writeSons(j,i,grupo->size-1,grupo->tags)+1;
   }
     }
Pug:                
   | Etiquetas Pug { 
     Etiquetas * aux = (Etiquetas *) $1;
     grupos[ig++]=aux;
      }
   | NEW VAR SVALUE Pug {if (mybd==NULL)
                        {
                          mybd=malloc(sizeof(struct mybd));
                        }
                          char * value = $3;
                          addValor(mybd,strdup($2),value,strdup("string"));
                        }
   | NEW VAR BOOL Pug   {
                        if (mybd==NULL)
                        {
                          mybd=malloc(sizeof(struct mybd));
                        }
                        int * a = malloc(sizeof(int));
                               *a = $3;
                               addValor(mybd,strdup($2),a,strdup("bool"));
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
Etiqueta:Espacos Nome Id Classe Atribuicoes Ponto Conteudo Condicao{
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
                                                           eti->condicao=strdup($8);
                                                           eti->identacao=strlen(eti->espacos);
                                                           $$=eti;
                                                           }                                              
                                                           ;
SubEtiqueta:TABS Nome Id Classe Atribuicoes Ponto Conteudo Condicao{
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
                                                           eti->condicao=strdup($8);
                                                           eti->identacao=strlen(eti->espacos);
                                                           $$=eti;
                                                           }
                                                           ;                                                           
Atribuicoes: VAR ATRIB Atributos {char ** variables;
                                  char ** values;
                              if (holderForVariables==NULL)
                              {
                                  holderForVariables=malloc(sizeof(char *)*2048);
                                  holderForValues=malloc(sizeof(char *)*2048);
                              } 
                              sprintf(aux,"%s=%s",strdup($1),strdup($2));
                              holderForVariables[ia]=strdup($1);
                              holderForValues[ia++]=strdup($2);
                              variables=holderForVariables;
                              values=holderForValues;
                              Atributos * atribs = malloc(sizeof(struct atributos));
                              atribs->variables=variables;
                              atribs->values=values;
                              atribs->size=ia;
                              $$=atribs;
                              ia=0;
                              holderForVariables=NULL;}
           | {Atributos * atribs = malloc(sizeof(struct atributos));
                              atribs->variables=atribs->values=NULL;
                              atribs->size=0;
                              $$=atribs;}
           ;
Espacos:TABS {$$=strdup($1);}
       |  {$$="";}
       ;                       
Ponto: PONTO {$$=1;}
     |  {$$=0;}
     ;                       
Atributos : VAR ATRIB Atributos {if (holderForVariables==NULL)
                              {
                                  holderForVariables=malloc(sizeof(char *)*2048);
                                  holderForValues=malloc(sizeof(char *)*2048);
                              } 
                              sprintf(aux,"%s=%s",strdup($1),strdup($2));
                              holderForVariables[ia]=strdup($1);
                              holderForValues[ia++]=strdup($2);}
          | 
          ;
Conteudo:TXT {$$=strdup($1);}
        |    {$$=strdup("");}
        ;
Nome: STR {$$=$1;}
    | {$$="div";}
    ;  
Id : ID {$$=strdup($1);}
   | {$$="";}
   ;
Classe : CLASS {$$=strdup($1);}   
       | {$$="";}
       ;
Condicao : COND {$$=strdup($1);}
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