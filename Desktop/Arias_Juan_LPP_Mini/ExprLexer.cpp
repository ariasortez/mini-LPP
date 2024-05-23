#include <fstream>
#include "ExprLexer.hpp"
#include "ExprLexerImpl.h"

ExprLexer::ExprLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

ExprLexer::~ExprLexer()
{
    yylex_destroy(yyscanner);
}

const int ExprLexer::getLine() const
{
    return yyget_lineno(yyscanner);
}

const int ExprLexer::getColumn() const
{
    return yyget_column(yyscanner);
}

std::string ExprLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

const char *ExprLexer::tokenString(Token tk)
{
    return "Unknown";
}
