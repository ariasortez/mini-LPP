#ifndef __lppLexer_HPP__
#define __lppLexer_HPP__

#include <iosfwd>
#include <string>
#include "lppParserImpl.hpp"

enum class Token: int {
    Eof = 0,
    Error = 256,
    Undef = 257,
    Suma = 258,
    Resta = 259,
    Multiplicacion = 260,
    Division = 261,
    Modulo = 262,
    ParentesisAbierto = 263,
    ParentesisCerrado = 264,
    Igual = 265,
    ComparacionIgual = 266,
    ComparacionDiferente = 267,
    MenorQue = 268,
    MenorOIgualQue = 269,
    MayorQue = 270,
    MayorOIgualQue = 271,
    Coma = 272,
    Asignacion = 273,
    CorcheteAbierto = 274,
    CorcheteCerrado = 275,
    DosPuntos = 276,
    Y = 277,
    O = 278,
    Numero = 279,
    Hexadecimal = 280,
    Binario = 281,
    Identificador = 282,
    DefEntero = 283,
    DefCaracter = 284,
    DefBooleano = 285,
    DefArreglo = 286,
    De = 287,
    DefFuncion = 288,
    DefProcedimiento = 289,
    Variable = 290,
    Inicio = 291,
    Fin = 292,
    Si = 293,
    Entonces = 294,
    Sino = 295,
    Para = 296,
    Mientras = 297,
    Haga = 298,
    Hasta = 299,
    Llamar = 300,
    Retorne = 301,
    Cadena = 302,
    Caracter = 303,
    Verdadero = 304,
    Falso = 305,
    Escriba = 306,
    Tipo = 307,
    Es = 308,
    Lea = 309,
    SinoSi = 310
};

class lppLexer
{
public:
    using yyscan_t = void*;

public:
    lppLexer(std::istream& _in);
    ~lppLexer();

    Token nextToken(ParserValueType *lval)
    { return nextTokenHelper(yyscanner, lval); }

    const int getLine() const;

    const int getColumn() const;

    std::string text() const;

    static const char *tokenString(Token tk);

private:
    Token nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval);

private:
    std::istream& in;
    yyscan_t yyscanner;
};

#endif
