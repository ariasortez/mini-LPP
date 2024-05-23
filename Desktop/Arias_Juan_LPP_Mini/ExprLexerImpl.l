%option noyywrap
%option reentrant
%option yylineno
%option caseless
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "ExprLexer.hpp"

#define YY_DECL Token ExprLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)
#define yyterminate() return Token::Eof

#define YY_INPUT(buf, result, max_size) \
    { \
        auto *in = yyget_extra(yyscanner); \
        in->read(buf, max_size); \
        result = in->gcount(); \
    }
%}

%x comment
%x str

%%
[ \t\n]	{  }
[\r\n] {    }
"//"[^\n]*\n { }
"/*"        { BEGIN(comment); }
\"          { BEGIN(str); }
\'[^\n]\'   { return Token::Caracter; }
"Entero"    { return Token::DefEntero; }
"Real"      { return Token::DefReal; }
"Cadena"    { return Token::DefCadena; }
"Caracter"  { return Token::DefCaracter; }
"Booleano"  { return Token::DefBooleano; }
"Arreglo"   { return Token::DefArreglo; }
"de"        { return Token::De; }
"Funcion"   { return Token::DefFuncion; }
"Procedimiento" { return Token::DefProcedimiento; }
"var"       { return Token::Variable; }
"Inicio"    { return Token::Inicio; }
"Fin"       { return Token::Fin; }
"Final"     { return Token::Final; }
"Si"        { return Token::Si; }
"Entonces"  { return Token::Entonces; }
"Sino"      { return Token::Sino; }
"Para"      { return Token::Para; }
"Mientras"  { return Token::Mientras; }
"Haga"      { return Token::Haga; }
"Escriba"   { return Token::Escriba; }
"Leer"      { return Token::Leer; }
"verdadero" { return Token::Verdadero; }
"falso"     { return Token::Falso; }
"repita"    { return Token::Repita; }
"Hasta"     { return Token::Hasta; }
"Tipo"      { return Token::Tipo; }
"Es"        { return Token::Es; }
"Lea"       { return Token::Lea; }
"Y"         { return Token::Y; }
"O"         { return Token::O; }
"Llamar"    { return Token::Llamar; }
":"         { return Token::DosPuntos; }
"Retorne"   { return Token::Retorne; }
"+"		    { return Token::Suma; }
"-"		    { return Token::Resta; }
"*"		    { return Token::Multiplicacion; }
"div"		{ return Token::Division; }
"mod"		{ return Token::Modulo; }
"("		    { return Token::ParentesisAbierto; }
")"		    { return Token::ParentesisCerrado; }
"["         { return Token::CorcheteAbierto; }
"]"         { return Token::CorcheteCerrado; }
"="         { return Token::Igual; }
"<-"        { return Token::Asignacion; }
"=="        { return Token::ComparacionIgual; }
"<>"        { return Token::ComparacionDiferente; }
"<"         { return Token::MenorQue; }
"<="        { return Token::MenorOIgualQue; }
">"         { return Token::MayorQue; }
">="        { return Token::MayorOIgualQue; }
";"         { return Token::PuntoYComa; }
","         { return Token::Coma; }
"0x"([0-9a-fA-F])+  { return Token::Hexadecimal; }
"0b"[0-1]+          { return Token::Binario; }
[0-9]+(\.[0-9]+)?	{ *lval = std::atof(yytext); return Token::Numero; }
[a-zA-Z_][a-zA-Z0-9_]*	{ *lval = std::string(yytext); return Token::Identificador; }
.		{ std::cerr << "Símbolo inválido: " << yytext[0] << '\n'; return Token::Error; }

<str>[^"]* {  }
<str>\" { BEGIN(INITIAL); return Token::Cadena; }


<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%
