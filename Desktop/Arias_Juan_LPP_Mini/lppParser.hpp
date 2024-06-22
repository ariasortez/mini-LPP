#ifndef __LPP_PARSER_HPP__
#define __LPP_PARSER_HPP__

#include "lppParserImpl.hpp"
#include "lppLexer.hpp"
#include <unordered_map>
#include <fstream>

class lppParser
{
public:
    lppParser(lppLexer& lexer, const std::string& asmFile)
      : lexer(lexer), asmFile(asmFile)
    {}

    int parse();

    void generarArchivo(const std::string& code);

    void assign(const std::string name, double _value);
    
    void print(const std::string& cname) const ;

    void setValue(double _value)
    { value = _value; }

    double getValue() const
    { return value; }

    lppLexer& getLexer()
    { return lexer; }

    double constValue(const std::string& cname) const;

private:
    std::unordered_map<std::string, double> variables;
    double value;
    lppLexer& lexer;
    const std::string& asmFile;
};

#endif
