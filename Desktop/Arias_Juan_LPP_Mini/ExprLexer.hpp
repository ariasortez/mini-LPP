#ifndef __ExprLexer_HPP__
#define __ExprLexer_HPP__

#include <iosfwd>
#include <string>
#include "ExprParserImpl.hpp"

enum class Token: int {
    Eof = 0,
    Error = 256,
    Undef = 257,
    Suma=258,
    Resta=259,
    Multiplicacion=260,
    Division=261,
    Modulo=262,
    ParentesisAbierto=263,
    ParentesisCerrado=264,
    Igual=265,
    PuntoYComa=266,
    ComparacionIgual=267,
    ComparacionDiferente=268,
    MenorQue=269,
    MenorOIgualQue=270,
    MayorQue=271,
    MayorOIgualQue=272,
    Coma=273,
    Asignacion=274,
    CorcheteAbierto=275,
    CorcheteCerrado=276,
    DosPuntos=277,
    Y=278,
    O=279,
    Numero=280,
    Hexadecimal=281,
    Binario=282,
    Identificador=283,
    DefEntero=284,
    DefReal=285,
    DefCadena=286,
    DefCaracter=287,
    DefBooleano=288,
    DefArreglo=289,
    De=290,
    DefFuncion=291,
    DefProcedimiento=292,
    Variable=293,
    Inicio=294,
    Fin=295,
    Final=296,
    Si=297,
    Entonces=298,
    Sino=299,
    Para=300,
    Mientras=301,
    Haga=302,
    Repita=303,
    Hasta=304,
    Llamar=305,
    Retorne=306,
    Cadena=307,
    Caracter=308,
    Verdadero=309,
    Falso=310,
    Escriba=311,
    Leer=312,
    Tipo=313,
    Es=314,
    Lea=315
};

class ExprLexer
{
public:
    using yyscan_t = void*;

public:
    ExprLexer(std::istream& _in);
    ~ExprLexer();

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
