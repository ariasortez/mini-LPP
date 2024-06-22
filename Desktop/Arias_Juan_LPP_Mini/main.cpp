#include <iostream>
#include <fstream>
#include "lppLexer.hpp"
#include "lppParser.hpp"

int main(int argc, char *argv[]) 
{
    if (argc != 3) {
        std::cerr << "Faltan argumentos\n";
        return 1;
    }
    std::ifstream in(argv[1], std::ios::in);

    if (!in.is_open()) {
        std::cerr << "No se puede abrir el archivo\n";
        return 1;
    }

    lppLexer lexer(in);
    lppParser parser(lexer, argv[2]);

    try {
        parser.parse();
        std::cout << "Compilado Correctamente"'\n';
        return 0;
    }
    catch (const std::runtime_error& ex) {
        std::cerr << ex.what() << '\n';
        return 1;
    }
}
