typedef struct atributos
{
    int size;
    char ** atribs;
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
}Etiqueta;

typedef struct etiquetas
{
    int size;
    Etiqueta ** tags;
}Etiquetas;
