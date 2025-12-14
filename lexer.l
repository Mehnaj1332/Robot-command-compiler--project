%option noyywrap

%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[Mm][Oo][Vv][Ee]            { return MOVE; }
[Tt][Uu][Rr][Nn]            { return TURN; }
[Ll][Ee][Ff][Tt]            { return LEFT; }
[Rr][Ii][Gg][Hh][Tt]        { return RIGHT; }
[Rr][Oo][Tt][Aa][Tt][Ee]    { return ROTATE; }
[Ss][Tt][Oo][Pp]            { return STOP; }

[0-9]+                      { yylval.num = atoi(yytext); return NUMBER; }

[ \t\r\n]+                  { /* skip whitespace */ }

.                           { /* ignore other chars */ }

%%
