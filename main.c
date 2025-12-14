#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Command {
    char type[20];
    int value;
} Command;

Command commands[100];
int cmd_index = 0;

void add_command(const char* type, int value) {
    strcpy(commands[cmd_index].type, type);
    commands[cmd_index].value = value;
    cmd_index++;
}

int main() {
    int choice;
    printf("=== Robot Command Generator ===\n");
    printf("1. MOVE\n2. TURN LEFT\n3. TURN RIGHT\n4. ROTATE\n5. REPEAT MOVE\n6. STOP\n7. Finish & Generate File\n");

    while(1){
        printf("\nEnter command option (1-7): ");
        scanf("%d", &choice);

        if(choice == 1){ // MOVE
            int n; printf("Enter steps to MOVE: "); scanf("%d", &n);
            add_command("MOVE", n);
        }
        else if(choice == 2){ // TURN LEFT
            int deg; printf("Enter degrees to TURN LEFT: "); scanf("%d", &deg);
            add_command("TURN LEFT", deg);
        }
        else if(choice == 3){ // TURN RIGHT
            int deg; printf("Enter degrees to TURN RIGHT: "); scanf("%d", &deg);
            add_command("TURN RIGHT", deg);
        }
        else if(choice == 4){ // ROTATE
            int deg; printf("Enter degrees to ROTATE: "); scanf("%d", &deg);
            add_command("ROTATE", deg);
        }
        else if(choice == 5){ // REPEAT MOVE
            int times, steps;
            printf("Enter number of times to REPEAT MOVE: "); scanf("%d", &times);
            printf("Enter steps per MOVE: "); scanf("%d", &steps);
            for(int i=0;i<times;i++)
                add_command("MOVE", steps);
        }
        else if(choice == 6){ // STOP
            add_command("STOP", 0);
        }
        else if(choice == 7){ // Finish & Generate file
            break;
        }
        else{
            printf("Invalid option. Try again.\n");
        }
    }

    FILE *f = fopen("commands.txt","w");
    if(!f){ printf("File error!\n"); return 1; }

    for(int i=0;i<cmd_index;i++){
        if(strstr(commands[i].type,"MOVE") || strstr(commands[i].type,"ROTATE"))
            fprintf(f,"%s %d\n", commands[i].type, commands[i].value);
        else if(strstr(commands[i].type,"TURN"))
            fprintf(f,"%s %d\n", commands[i].type, commands[i].value);
        else
            fprintf(f,"%s\n", commands[i].type);
    }
    fclose(f);
    printf("\ncommands.txt generated successfully!\n");
    return 0;
}
