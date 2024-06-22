%option noyywrap
%option reentrant
%option yylineno
%option caseless
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "lppLexer.hpp"
#include "lppAst.hpp"

#define YY_DECL Token lppLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)
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
[ \t\n]	        { }
[\r\n]          { }
"//"[^\n]*\n    { }
"/*"            { BEGIN(comment); } // Me lleva a la zona de regex de comentario
\"              { BEGIN(str); }     // Me lleva a la zona de regex de string
\'[^\n]\'       { *lval = new CharExpr(yytext[1]); return Token::Caracter; }
"Entero"        { *lval = new StrExpr(std::string(yytext)); return Token::DefEntero; }
"Caracter"      { *lval = new StrExpr(std::string(yytext)); return Token::DefCaracter; }
"Booleano"      { *lval = new StrExpr(std::string(yytext)); return Token::DefBooleano; }
"Arreglo"       { return Token::DefArreglo; }
"de"            { return Token::De; }
"Funcion"       { return Token::DefFuncion; }
"Procedimiento" { return Token::DefProcedimiento; }
"var"           { return Token::Variable; }
"Inicio"        { return Token::Inicio; }
"Fin"           { return Token::Fin; }
"Si"            { return Token::Si; }
"Entonces"      { return Token::Entonces; }
"Sino"          { return Token::Sino; }
"Para"          { return Token::Para; }
"Mientras"      { return Token::Mientras; }
"Haga"          { return Token::Haga; }
"Escriba"       { return Token::Escriba; }
"verdadero"     { *lval = new BoolExpr(1); return Token::Verdadero; }
"falso"         { *lval = new BoolExpr(0); return Token::Falso; }
"Hasta"         { return Token::Hasta; }
"Tipo"          { return Token::Tipo; }
"Es"            { return Token::Es; }
"Lea"           { return Token::Lea; }
"Sino Si"       { return Token::SinoSi; }
"Y"             { return Token::Y; }
"O"             { return Token::O; }
"Llamar"        { return Token::Llamar; }
":"             { return Token::DosPuntos; }
"Retorne"       { return Token::Retorne; }
"+"		        { return Token::Suma; }
"-"		        { return Token::Resta; }
"*"		        { return Token::Multiplicacion; }
"div"		    { return Token::Division; }
"mod"		    { return Token::Modulo; }
"("		        { return Token::ParentesisAbierto; }
")"		        { return Token::ParentesisCerrado; }
"["             { return Token::CorcheteAbierto; }
"]"             { return Token::CorcheteCerrado; }
"="             { return Token::Igual; }
"<-"            { return Token::Asignacion; }
"=="            { return Token::ComparacionIgual; }
"<>"            { return Token::ComparacionDiferente; }
"<"             { return Token::MenorQue; }
"<="            { return Token::MenorOIgualQue; }
">"             { return Token::MayorQue; }
">="            { return Token::MayorOIgualQue; }
","             { return Token::Coma; }
"0x"([0-9a-fA-F])+  { return Token::Hexadecimal; }
"0b"[0-1]+          { return Token::Binario; }
[0-9]+(\.[0-9]+)?	{ *lval = new NumExpr(std::atof(yytext)); return Token::Numero; }
[a-zA-Z_][a-zA-Z0-9_]*	{ *lval = new IdExpr(std::string(yytext)); return Token::Identificador; }
.		{ std::cerr << "Símbolo inválido: " << yytext[0] << '\n'; return Token::Error; }

<str>[^"]* { *lval = new StrExpr(yytext); }
<str>\" { BEGIN(INITIAL); return Token::Cadena; }


<comment>"*/" { BEGIN(INITIAL); } // Salida de las regex del comentario
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%
