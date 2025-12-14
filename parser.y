%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(const char *s);
int yylex(void);

int x = 0, y = 0;
int angle = 0;

void do_move(int n){
    double r = angle * M_PI / 180.0;
    x += (int)round(n * sin(r));
    y += (int)round(n * cos(r));
    printf("MOVE %d -> (%d,%d)\n", n, x, y);
}
%}

%union { int num; }

%token MOVE TURN LEFT RIGHT ROTATE STOP REPEAT
%token LBRACE RBRACE
%token <num> NUMBER

%%

program:
      program command
    | command
    ;

command:
      MOVE NUMBER
        { do_move($2); }

    | TURN LEFT NUMBER
        { angle = (angle + $3) % 360; }

    | TURN RIGHT NUMBER
        { angle = (angle - $3 + 360) % 360; }

    | ROTATE NUMBER
        { angle = (angle + $2) % 360; }

    | REPEAT NUMBER LBRACE MOVE NUMBER RBRACE
        {
            for(int i=0;i<$2;i++)
                do_move($5);
        }

    | STOP
        {
            printf("STOP\nFINAL: (%d,%d) angle=%d\n", x, y, angle);
            exit(0);
        }
    ;

%%

void yyerror(const char *s){
    printf("Syntax Error\n");
}

int main(){
    printf("Mini Robot Simulator (with LOOP)\n");
    printf("-------------------------------\n");
    yyparse();
    return 0;
}
