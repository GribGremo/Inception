#include "stdio.h"
#include "unistd.h"
#include "stdlib.h"
#include "stdbool.h"
void putstring(char* str){
    int i = 0;

    while(str[i] != '\0')
    {
        putchar(str[i]);
        i++;
    }
}
int parsing(int argc, char **argv,char *instr, int *w, int *h, int *i){
    int j = 0;
    int rlimt = 0;

    if (argc != 4)
    {
        putstring("ERROR: Invalid number of arguments.");
        return (1);
    }

    *w = atoi(argv[1]);
    *h = atoi(argv[2]);
    *i = atoi(argv[3]);

    if (*w <= 0 || *h <= 0 ||*i < 0 || *w > 2147483647 ||*w > 2147483647 ||*w > 2147483647)
    {
        putstring("ERROR: Invalid argument.");
        return (1);
    }

    rlimt = read(0,instr,1024);//a voir
    instr[rlimt -1] = '\0';
    while (instr[j] != '\0')
    {
        if (instr[j] != 'w' && instr[j] != 'a' &&instr[j] != 's' &&instr[j] != 'd' &&instr[j] != 'x')
        {
            putstring("ERROR: Invalid entry.");
            return (1);
        }
        j++;
    }

    return (0);
}

void fill_str(char* str, char c, int l){
    int i = 0;

    while (i < l){
        str[i] = c;
        i++;
    }
    str[i] = '\0';
}

void free_array(char **array, int l)
{
    int i = 0;

    while(i < l)
    {
        free(array[i]);
        i++;
    }
}

char** create_desk(char **desk, int h, int w, char c){
    int i = 0;

    desk = malloc((h + 1) * sizeof(char *));
    if (desk == NULL)
    {
        putstring("ERROR: Memory allocation failed.");
        return (NULL);
    }
    
    while(i < h)
    {
        desk[i] = malloc ((w + 1) * sizeof(char));
        if (desk[i] == NULL)
        {
            putstring("ERROR: Memory allocation failed.");
            free_array(desk,i);
            return (NULL);  
        }

        fill_str(desk[i], c, w);
        i++;
    }
    desk[i] = NULL;
    return (desk);
}

void print_array(char** array)
{
    int i = 0;
    while(array[i] != NULL){
        putstring(array[i]);
        putchar('\n');
        i++;
    }

}

void print_desk(char** desk)
{
    int i = 0;
    int j = 0;
    while(desk[i] != NULL){
        while(desk[i][j] != 'X')
            i++;
        desk[i][j] = '\0';
        putstring(&desk[i][1]);
        i++;
    }
}

void paint(char** desk, char* instr, int wl, int hl){
    int i = 0;
    int w = 0;
    int h = 0;
    int draw = -1;

    while(instr[i] != '\0'){

        if (instr[i] == 'w' && h != 0)
            h -= 1;
        else if (instr[i] == 's' && h != hl - 1)
            h += 1;
        else if (instr[i] == 'a' && w != 0)
            w -= 1;
        else if (instr[i] == 'd' && w != wl - 1)
            w += 1;
        else if (instr[i] == 'x')
            draw *= -1;
        if (draw == 1)
            desk[h][w] = 'O';
        
        i++;
    }
}

int ct_neighbour(char** desk, int wl, int hl, int w, int h, int* ct_nb){
    bool top = true;
    bool bot = true;
    bool left = true;
    bool right = true;

    if (h == 0)
        top = false;
    if (h == hl - 1)
        bot = false;
    if (w == 0)
        left = false;
    if (w == wl - 1)
        right = false;
    if (top)
    {
        if (left && desk[h - 1][w - 1] == 'O')
            ct_nb++;
        if (right && desk[h - 1][w + 1] == 'O')
            ct_nb++;
        if (desk[h - 1][w] == 'O')
            ct_nb++;
    }
    if (bot)
    {
        if (left && desk[h + 1][w - 1] == 'O')
            ct_nb++;
        if (right && desk[h + 1][w + 1] == 'O')
            ct_nb++;
        if (desk[h + 1][w] == 'O')
            ct_nb++;
    }
    if (left && desk[h][w - 1] == 'O')
            ct_nb++;
    if (right && desk[h][w + 1] == 'O')
            ct_nb++;
    
    return (ct_nb);
}

int cp_array(char** array, char** cpy)
{
    int i = 0;
    int j = 0;

    
}

void col(char **desk, int iter, int wl, int hl){
    int h = 0;
    int w = 0;
    int ct_nb = 0;
    // bool top = true;
    // bool bot = true;
    // bool left = true;
    // bool right = true;
    (void) iter;

    while(desk[h] != NULL)
    {
        while(desk[h][w] != '\0')
        {
            // if (h == 0)
            //     top = false;
            // if (h == hl - 1)
            //     bot = false;
            // if (w == 0)
            //     left = false;
            // if (w == wl - 1)
            //     right = false;

            // if (top)
            // {
            //     if (left && desk[h - 1][w - 1] == 'O')
            //         ct_nb++;
            //     if (right && desk[h - 1][w + 1] == 'O')
            //         ct_nb++;
            //     if (desk[h - 1][w] == 'O')
            //         ct_nb++;
            // }
            // if (bot)
            // {
            //     if (left && desk[h + 1][w - 1] == 'O')
            //         ct_nb++;
            //     if (right && desk[h + 1][w + 1] == 'O')
            //         ct_nb++;
            //     if (desk[h + 1][w] == 'O')
            //         ct_nb++;
            // }
            // if (left && desk[h][w - 1] == 'O')
            //         ct_nb++;
            // if (right && desk[h][w + 1] == 'O')
            //         ct_nb++;
            ct_neighbour(desk,wl,hl,w,h,&ct_nb);
            printf("H:%d W:%d C:%d \n", h, w, ct_nb);

            ct_nb = 0;
            // top = true;
            // bot = true;
            // left = true;
            // right = true;
            w++;
        }
        w = 0;
        h++;
    }
}

int main(int argc, char **argv){
    int width = 0;
    int height = 0;
    int iter = 0;
    char **desk = NULL;
    char instr[1024];

    if (parsing(argc,argv,instr,&width,&height,&iter))
        return (1);
    
    desk = create_desk(desk,height,width, ' ');
    if (desk == NULL)
        return (1);
    paint(desk, instr, width,height);
    print_array(desk);
    col(desk, iter, width, height);
}