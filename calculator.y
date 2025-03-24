
%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
void yyerror(const char *s);
int yylex();
int error_flag = 0;  
%}

/* veri türü tanımlama */
%union {
  double dval;
}

/* tokenlerin veri türünü belirtme */
%token <dval> NUMBER FLOAT
%token PLUS MINUS TIMES DIVIDE EXP
%token LPAREN RPAREN

/* nonterminal semboller için veri türü */
%type <dval> expr line

/*operatör öncelik sırası */

%left PLUS MINUS
%left TIMES DIVIDE
%right EXP
%nonassoc UMINUS

%%
input:
      | input line
      ;

line:
      '\n' { $$ = 0; }
    | expr '\n' { 
          if(!error_flag) {
              /* eğer sonuç tam sayı ise ondalık kısmı göstermiyor */
              if($1 == (double)(int)$1)
                  printf("Result: %d\n", (int)$1);
              else
                  printf("Result: %lf\n", $1);
          }
          error_flag = 0;  
          $$ = $1; 
      }
    ;

/* aritmetik işlemler */
expr:
      expr PLUS expr   { $$ = $1 + $3; }
    | expr MINUS expr  { $$ = $1 - $3; }
    | expr TIMES expr  { $$ = $1 * $3; }
    | expr DIVIDE expr { 
                           if($3 == 0) {
                             yyerror("Division by zero");
                             error_flag = 1;
                             $$ = 0;
                           } else {
                             $$ = $1 / $3;
                           }
                        }
    | expr EXP expr    { $$ = pow($1, $3); }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | LPAREN expr RPAREN { $$ = $2; }
    | NUMBER           { $$ = $1; }
    | FLOAT            { $$ = $1; }
    ;
%%

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
  printf("Enter an expression (press Ctrl+D to exit):\n");
  return yyparse();
}
