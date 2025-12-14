%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct Command {
    char type[32];
    int value;
} Command;

Command commands[1000];
int cmd_index = 0;

/* Robot state */
int sim_x = 0;
int sim_y = 0;
int sim_angle = 0; /* 0=NORTH, 90=EAST, 180=SOUTH, 270=WEST */

void yyerror(const char *s);
int yylex(void);
void apply_command(const char* type, int value);
const char* angle_to_dir(int angle);
%}

%union { int num; }

%token MOVE TURN LEFT RIGHT STOP ROTATE
%token <num> NUMBER

%%

program:
    commands_list
    ;

commands_list:
      commands_list command
    | command
    ;

command:
      MOVE NUMBER
        {
            strcpy(commands[cmd_index].type, "MOVE");
            commands[cmd_index].value = $2;
            cmd_index++;
        }

    | TURN LEFT NUMBER
        {
            strcpy(commands[cmd_index].type, "TURN LEFT");
            commands[cmd_index].value = $3;
            cmd_index++;
        }

    | TURN RIGHT NUMBER
        {
            strcpy(commands[cmd_index].type, "TURN RIGHT");
            commands[cmd_index].value = $3;
            cmd_index++;
        }

    | ROTATE NUMBER
        {
            strcpy(commands[cmd_index].type, "ROTATE");
            commands[cmd_index].value = $2;
            cmd_index++;
        }

    | STOP
        {
            strcpy(commands[cmd_index].type, "STOP");
            commands[cmd_index].value = 0;
            cmd_index++;
        }
    ;

%%

void yyerror(const char *s) {
    printf("[Syntax Error]: %s\n", s);
}

/* Map angle to cardinal/diagonal direction */
const char* angle_to_dir(int angle){
    angle = (angle % 360 + 360) % 360; // normalize

    switch(angle){
        case 0:   return "NORTH";
        case 45:  return "NORTH-EAST";
        case 90:  return "EAST";
        case 135: return "SOUTH-EAST";
        case 180: return "SOUTH";
        case 225: return "SOUTH-WEST";
        case 270: return "WEST";
        case 315: return "NORTH-WEST";
        default:  return ""; // unknown angle, numeric only
    }
}

/* Execute commands */
void apply_command(const char* type, int value){

    printf("-> Executing: %-12s %4d\n", type, value);

    if(strcmp(type, "MOVE") == 0){
        double rad = sim_angle * M_PI / 180.0;
        int dx = (int)round(value * sin(rad));
        int dy = (int)round(value * cos(rad));

        sim_x += dx;
        sim_y += dy;

        printf("   Moved to: (%d, %d) | Direction: %s %d°\n",
               sim_x, sim_y, angle_to_dir(sim_angle), sim_angle);
    }

    else if(strcmp(type, "TURN LEFT") == 0){
        sim_angle = (sim_angle + value) % 360;
        if(sim_angle < 0) sim_angle += 360;

        printf("   Turned LEFT  %3d° -> Direction: %s %d°\n",
               value, angle_to_dir(sim_angle), sim_angle);
    }

    else if(strcmp(type, "TURN RIGHT") == 0){
        sim_angle = (sim_angle - value + 360) % 360;

        printf("   Turned RIGHT %3d° -> Direction: %s %d°\n",
               value, angle_to_dir(sim_angle), sim_angle);
    }

    else if(strcmp(type, "ROTATE") == 0){
        sim_angle = (sim_angle + value) % 360;
        if(sim_angle < 0) sim_angle += 360;

        printf("   Rotated      %3d° -> Direction: %s %d°\n",
               value, angle_to_dir(sim_angle), sim_angle);
    }

    else if(strcmp(type, "STOP") == 0){
        printf("   Robot STOPPED.\n");
    }
}

int main(){

    printf("=====================================\n");
    printf("       ADVANCED ROBOT SIMULATOR\n");
    printf("=====================================\n\n");

    printf("Parsing commands...\n\n");

    yyparse();

    printf("\n=====================================\n");
    printf("        ROBOT MOVEMENT REPLAY\n");
    printf("=====================================\n\n");

    for(int i = 0; i < cmd_index; i++){
        apply_command(commands[i].type, commands[i].value);
        printf("-------------------------------------\n");
    }

    printf("\n=====================================\n");
    printf("          FINAL ROBOT STATE\n");
    printf("=====================================\n\n");

    printf("Position : (%d, %d)\n", sim_x, sim_y);
    printf("Direction: %s %d°\n", angle_to_dir(sim_angle), sim_angle);

    printf("\nASCII Map Legend:\n");
    printf("       ^ NORTH\n");
    printf("       |\n");
    printf("WEST <--+--> EAST\n");
    printf("       |\n");
    printf("       v SOUTH\n");

    printf("=====================================\n");

    return 0;
}
