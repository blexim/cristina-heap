%{
#include <string>
#include "heapliteral.h"
#include "parser.hpp"

#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
#define TOKEN(t) (yylval.token = t)

extern "C" int yywrap() { }
%}

%%

[ \t\n]                      ;
"new"                        return TNEW;
"free"                       return TFREE;
"path"                       return TPATH;
"onpath"                     return TONPATH;
";"                          return TSEMI;
","                          return TCOMMA;
"->"                         return TARROW;
":="                         return TASSIGN;
"("                          return TLPAR;
")"                          return TRPAR;
"="                          return TEQ;
"!="                         return TNEQ;
"!"                          return TNOT;
[a-zA-Z][a-zA_Z0-9_]*        SAVE_TOKEN; return TID;
.                            printf("Unknown token!\n"); yyterminate();

%%
