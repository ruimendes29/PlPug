typedef struct atributos
{
    int size;
    char ** variables;
    char ** values;
}Atributos;

typedef struct etiqueta
{
    char * nome;
    char * classe;
    char * id;
    Atributos * atributos;
    char * espacos;
    char * conteudo;
    int identacao;
    int hasPoint;
    char * condicao;
    int atribuicaoTag;
}Etiqueta;

typedef struct etiquetas
{
    int size;
    Etiqueta ** tags;
}Etiquetas;

typedef struct variavel
{
char * nome;
char * tipo;
void * valor;
}Variavel;

typedef struct listaVar
{
    Variavel* lista;
    int tamanho;
}* ListaVar;

typedef struct mybd
{
    ListaVar variaveis [26][127][127];
}BD;

void * getValorAndType(BD * bd,char * nome,char ** type);
void addValor(BD * bd,char * nome,void * valor,char * tipo);