#ifndef __EXPR_PARSER_HPP__
#define __EXPR_PARSER_HPP__

#include "ExprParserImpl.hpp"
#include "ExprLexer.hpp"
#include <unordered_map>

class ExprParser
{
public:
    ExprParser(ExprLexer& lexer)
      : lexer(lexer)
    {}

    int parse();

    void assign(const std::string name, double _value);
    
    void print(const std::string& cname) const ;

    void setValue(double _value)
    { value = _value; }

    double getValue() const
    { return value; }

    ExprLexer& getLexer()
    { return lexer; }

    double constValue(const std::string& cname) const;

private:
    std::unordered_map<std::string, double> variables;
    double value;
    ExprLexer& lexer;
};

#endif
