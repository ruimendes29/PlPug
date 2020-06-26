#include "nodo.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void addValor(BD * bd,char * nome,void * valor,char * tipo) 
{
    int c1,c2,c3;
    int tamanho = strlen(nome);
    if (tamanho < 2)
    {
        c2=0;
        c3=0;
    }
    else if (tamanho < 3 && tamanho >= 2)
    {
        c2=nome[1];
        c3=0;
    }
    else if (tamanho>=3) {
        c2=nome[1];
        c3=nome[2];
    }
    c1 = nome[0]%97;
    if (bd->variaveis[c1][c2][c3]==NULL)
    {
        bd->variaveis[c1][c2][c3]=malloc(sizeof(struct listaVar));
        bd->variaveis[c1][c2][c3]->tamanho=1;
        bd->variaveis[c1][c2][c3]->lista=malloc(sizeof(Variavel));
        Variavel v;
        v.nome=nome;
        v.tipo=tipo;
        v.valor=valor;
        bd->variaveis[c1][c2][c3]->lista[0]=v;
    }
    else
    {
        bd->variaveis[c1][c2][c3]->tamanho++;
        bd->variaveis[c1][c2][c3]->lista=realloc(bd->variaveis[c1][c2][c3]->lista, bd->variaveis[c1][c2][c3]->tamanho);
        Variavel v;
        v.nome=nome;
        v.tipo=tipo;
        v.valor=valor;
        bd->variaveis[c1][c2][c3]->lista[tamanho-1]=v;
    }
}

void * getValorAndType(BD * bd,char * nome,char ** type)
{
     int c1,c2,c3;
    int tamanho = strlen(nome);
    void * r=NULL;
    if (tamanho < 2)
    {
        c2=0;
        c3=0;
    }
    else if (tamanho < 3 && tamanho > 2)
    {
        c2=nome[1];
        c3=0;
    }
    else if (tamanho>=3) {
        c2=nome[1];
        c3=nome[2];
    }
    c1 = nome[0]%97;
    if (bd==NULL || bd->variaveis[c1][c2][c3]==NULL)
    {
        return r;
    }
    for(int i=0; i< bd->variaveis[c1][c2][c3]->tamanho;i++)
    {
        if (!strcmp(bd->variaveis[c1][c2][c3]->lista[i].nome,nome))
        {
            (*type)=strdup(bd->variaveis[c1][c2][c3]->lista[i].tipo);
            r=bd->variaveis[c1][c2][c3]->lista[i].valor;
            break;
        }
    }
    return r;
}

/*void main()
{
    BD * mybd = malloc(sizeof(struct mybd));
    int * a = malloc(sizeof(int));
    *a =  5;
    addValor(mybd,strdup("i"),a,strdup("int"));
    char * b = strdup("google.com");
    addValor(mybd,strdup("e"),b,strdup("int"));
    char * type;
    void * valor = getValorAndType(mybd,strdup("i"),&type);
    void * valor2 = getValorAndType(mybd,strdup("e"),&type);
    void * value = getValorAndType(mybd,strdup("abc"),&type);
    printf("VALOR = %d\n",* (int *) valor);
    printf("VALOR = %s\n",(char *) valor2);
    //addValor(mybd,strdup("varsdf"),strdup("value"),strdup("string"));

}*/