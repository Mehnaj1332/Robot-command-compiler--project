%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%

[Mm][Oo][Vv][Ee]         { return MOVE; }
[Tt][Uu][Rr][Nn]         { return TURN; }
[Ll][Ee][Ff][Tt]         { return LEFT; }
[Rr][Ii][Gg][Hh][Tt]     { return RIGHT; }
[Rr][Oo][Tt][Aa][Tt][Ee] { return ROTATE; }
[Rr][Ee][Pp][Ee][Aa][Tt] { return REPEAT; }
[Ss][Tt][Oo][Pp]         { return STOP; }

"{" { return LBRACE; }
"}" { return RBRACE; }

[0-9]+ {
    yylval.num = atoi(yytext);
    return NUMBER;
}

[ \t\r\n]+ ;

. {
    printf("Lexical Error: %s\n", yytext);
}

%%

int yywrap(void){
    return 1;
}
