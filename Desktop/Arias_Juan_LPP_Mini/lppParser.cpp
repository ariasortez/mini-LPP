#include <unordered_map>
#include <iostream>
#include "lppParser.hpp"

int lppParser::parse()
{
    return yyparse(*this);
}

double lppParser::constValue(const std::string& cname) const
{
    // Values taken from https://en.wikipedia.org/wiki/List_of_mathematical_constants
    static std::unordered_map<std::string, double> cmap = {
        {"Pi", 3.14159}, // Ratio of a circle's circumference to its diameter
        {"Tau", 6.28319}, // Ratio of a circle's circumference to its radius
        {"SrTwo", 1.41421}, // Square root of 2. Pythagoras constant
        {"SrThree", 1.73205}, // Square root of 3. Theodorus' constant
        {"Phi", 1.61803}, // Golden ratio
        {"E", 2.71828}, // Euler's number
    };

    auto it = cmap.find(cname);

    auto finded = variables.find(cname);

    return (it == cmap.end())? (finded == variables.end())? 0.0 : finded->second : it->second;
}

void lppParser::generarArchivo(const std::string& code) {
    std::ofstream file;
    
    file.open(asmFile, std::ios::out);

    if(!file) {
        std::cerr << "Error al crear el archivo .asm!" << std::endl;
    }

    std::cout << "Archivo .asm creado exitosamente" << std::endl;

    file << code;
    file.close();
}

void lppParser::assign(const std::string name, double _value) {
    variables[name] = _value;
}

void lppParser::print(const std::string& cname) const {
    std::cout << variables.find(cname)->second << "\n";
}