#include <iostream>
#include <fstream>
#include "lppLexer.hpp"
#include "lppParser.hpp"

int main(int argc, char *argv[]) 
{
    if (argc != 3) {
        std::cerr << "Not enough CLI arguments\n";
        return 1;
    }
    std::ifstream in(argv[1], std::ios::in);

    if (!in.is_open()) {
        std::cerr << "Cannot open file\n";
        return 1;
    }

    lppLexer lexer(in);
    lppParser parser(lexer, argv[2]);

    try {
        parser.parse();
        std::cout << "Expression value = " << parser.getValue() << '\n';
    }
    catch (const std::runtime_error& ex) {
        std::cerr << ex.what() << '\n';
    }
}