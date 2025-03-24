%{
#include "y.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+\.[0-9]+   { 
                      yylval.dval = atof(yytext);
                      return FLOAT;
                  }

[0-9]+           { 
                      yylval.dval = atof(yytext);
                      return NUMBER;
                  }
"**"             { return EXP; }
"^"              { return EXP; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return TIMES; }
"/"              { return DIVIDE; }
"("              { return LPAREN; }
")"              { return RPAREN; }
[ \t]+           { /* Ignore white space */ }
\n               { return '\n'; }
.                { printf("Unknown character: %s\n", yytext); }
%%
int yywrap(void) {
    return 1;
}


