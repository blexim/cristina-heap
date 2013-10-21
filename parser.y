%{
#include <stdio.h>

#include "heapliteral.h"
#include "heaptesting.h"

extern int yylex();
void yyerror(const char *s) { printf("ERROR %s\n", s); }

heaptesting *solver = new heaptesting();

heapvar *mem = new heapvar("m0");
int memcnt = 0;

heapvar *incmem() {
  memcnt++;
  std::string varname = "m" + memcnt;

  printf("New mem var: %s\n", varname.c_str());

  return new heapvar(varname);
}

%}

%union {
  heaplitp lit;
  heapelemp elem;
  heapexpr *expr;
  heapvar *var;
  std::string *string;
  int token;
}

%token <string> TID;
%token <token> TPATH TONPATH TDANGLING TASSERT TNEW TFREE TDISJ;
%token <token> TLPAR TRPAR TARROW TEQ TNEQ TASSIGN;
%token <token> TNOT TSEMI TCOMMA;

%type <void> stmts stmt
%type <expr> expr
%type <var> var

%start stmts

%%

stmts : stmt TSEMI {
        printf("hai!\n");
        fflush(stdout);
      }
      | stmt TSEMI stmts;

var : TID
      {
        $$ = new heapvar(*$1);
      }
    ;

expr : var { $$ = new heapexpr(*$1); }
     | var TARROW var { $$ = new heapexpr(*$1, *mem, *$3); }
     ;

stmt :
  var TARROW var TASSIGN var {
    heapvar *newmem = incmem();
    solver->add_literal(new store_lit(*newmem, *mem, *$1, *$3, *$5, stateTrue));

    std::cout << "Assigning " << mem << ":" << newmem << std::endl;

    delete mem;
    mem = newmem;
  }
     |
  TNEW TLPAR var TRPAR {
    heapvar *newmem = incmem();
    solver->add_literal(new new_lit(*newmem, *mem, *$3, stateTrue));
    delete mem;
    mem = newmem;
  }
    |
  TFREE TLPAR var TRPAR {
    heapvar *newmem = incmem();
    solver->add_literal(new free_lit(*newmem, *mem, *$3, stateTrue));
    delete mem;
    mem = newmem;
  }
    |
  var TEQ expr {
    solver->add_literal(new eq_lit(*$1, *$3, stateTrue));
  }
    |
  var TNEQ expr {
    solver->add_literal(new eq_lit(*$1, *$3, stateFalse));
  }
    |
  TPATH TLPAR var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new path_lit(*mem, *$3, *$5, *$7, stateTrue));
  }
    |
  TNOT TPATH TLPAR var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new path_lit(*mem, *$4, *$6, *$8, stateFalse));
  }
    |
  TONPATH TLPAR var TCOMMA var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new onpath_lit(*mem, *$3, *$5, *$7, *$9, stateTrue));
  }
    |
  TNOT TONPATH TLPAR var TCOMMA var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new onpath_lit(*mem, *$4, *$6, *$8, *$10, stateFalse));
  }
    |
  TDANGLING TLPAR var TRPAR {
    solver->add_literal(new dangling_lit(*mem, *$3, stateTrue));
  }
    |
  TNOT TDANGLING TLPAR var TRPAR {
    solver->add_literal(new dangling_lit(*mem, *$4, stateFalse));
  }
    |
  TDISJ TLPAR var TCOMMA var TCOMMA var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new disj_lit(*mem, *$3, *$5, *$7, *$9, *$11, stateTrue));
  }
    |
  TNOT TDISJ TLPAR var TCOMMA var TCOMMA var TCOMMA var TCOMMA var TRPAR {
    solver->add_literal(new disj_lit(*mem, *$4, *$6, *$8, *$10, *$12, stateFalse));
  }

  ;

%%
