#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Command {
    char type[20];
    int steps;
} Command;

Command commands[100];
int cmd_index = 0;

int main() {
    // Example commands
    strcpy(commands[0].type,"MOVE"); commands[0].steps=5;
    strcpy(commands[1].type,"TURN LEFT"); commands[1].steps=0;
    strcpy(commands[2].type,"MOVE"); commands[2].steps=3;
    strcpy(commands[3].type,"TURN RIGHT"); commands[3].steps=0;
    strcpy(commands[4].type,"MOVE"); commands[4].steps=2;
    strcpy(commands[5].type,"STOP"); commands[5].steps=0;
    cmd_index=6;

    FILE *f = fopen("commands.txt","w");
    for(int i=0;i<cmd_index;i++){
        if(strstr(commands[i].type,"MOVE"))
            fprintf(f,"%s %d\n", commands[i].type, commands[i].steps);
        else if(strstr(commands[i].type,"TURN"))
            fprintf(f,"TURN %s\n", strchr(commands[i].type,' ')+1);
        else
            fprintf(f,"%s\n", commands[i].type);
    }
    fclose(f);
    printf("commands.txt generated.\n");
    return 0;
}
