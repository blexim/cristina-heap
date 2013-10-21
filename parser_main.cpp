#include <iostream>
#include <string.h>

#include "heapliteral.h"
#include "heaptesting.h"

extern int yyparse();
extern heaptesting *solver;

int main(int argc, char *argv[]) {
  transformerRefinementResult::s expected = transformerRefinementResult::NotBottom;

  if (argc > 1) {
    if (!strcmp(argv[1], "fail")) {
      expected = transformerRefinementResult::Bottom;
    }
  }

  yyparse();
  solver->run(expected);

  return 0;
}
