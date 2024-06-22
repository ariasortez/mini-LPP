#include <fstream>
#include "lppLexer.hpp"
#include "lppLexerImpl.h"

lppLexer::lppLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

lppLexer::~lppLexer()
{
    yylex_destroy(yyscanner);
}

const int lppLexer::getLine() const
{
    return yyget_lineno(yyscanner);
}

const int lppLexer::getColumn() const
{
    return yyget_column(yyscanner);
}

std::string lppLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

const char *lppLexer::tokenString(Token tk)
{
    return "Unknown";
}
