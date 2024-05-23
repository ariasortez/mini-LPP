
%define parse.error verbose
%define api.pure full

%parse-param {ExprParser& parser}

%code top {

#include <iostream>
#include <stdexcept>
#include "ExprLexer.hpp"
#include "ExprParser.hpp"


#define yylex(v) static_cast<int>(parser.getLexer().nextToken(v))

void yyerror(const ExprParser& parser, const char *msg)
{
      std::cout << "Error en la linea numero " << (const_cast<ExprParser&>(parser)).getLexer().getLine() << std::endl;
      throw std::runtime_error(msg);
}

}

%code requires {
#include <string>
#include <variant>

class ExprParser; // Forward declaration

using ParserValueType = std::variant<std::string, double>;

#define YYSTYPE ParserValueType
#define YYSTYPE_IS_DECLARED 1

}

%token Suma "+"
%token Resta "-"
%token Multiplicacion "*"
%token Division "div"
%token Modulo "mod"
%token ParentesisAbierto "("
%token ParentesisCerrado ")"
%token Igual "="
%token PuntoYComa ";"
%token ComparacionIgual "=="
%token ComparacionDiferente "<>"
%token MenorQue "<"
%token MenorOIgualQue "<="
%token MayorQue ">"
%token MayorOIgualQue ">="
%token Coma ","
%token Asignacion "<-"
%token CorcheteAbierto "["
%token CorcheteCerrado "]"
%token DosPuntos ":"
%token Y "Y"
%token O "O"
%token Numero "numero"
%token Hexadecimal "Hexa"
%token Binario "Binary"
%token Identificador "identificador"
%token DefEntero "entero"
%token DefReal "real"
%token DefCadena "cadena"
%token DefCaracter "caracter"
%token DefBooleano "booleano"
%token DefArreglo "arreglo"
%token De "de"
%token DefFuncion "funcion"
%token DefProcedimiento "procedimiento"
%token Variable "var"
%token Inicio "inicio"
%token Fin "fin"
%token Final "final"
%token Si "si"
%token Entonces "entonces"
%token Sino "sino"
%token Para "para"
%token Mientras "mientras"
%token Haga "haga"
%token Repita "Repita"
%token Hasta "Hasta"
%token Llamar "Llamar"
%token Retorne "Retorne"
%token Cadena "StringConstant"
%token Caracter "constantCharacter"
%token Verdadero "Verdadero"
%token Falso "Falso"
%token Escriba "Escriba"
%token Leer "Leer"
%token Tipo "Tipo"
%token Es "Es"
%token Lea "Lea"

%%

programa: Inicio bloqueCodigo Fin
      | bloqueDef Inicio bloqueCodigo Fin
      | bloqueDef funcsYProcs Inicio bloqueCodigo Fin
      | funcsYProcs Inicio bloqueCodigo Fin
      | tipoBloque Inicio bloqueCodigo Fin
      | tipoBloque bloqueDef Inicio bloqueCodigo Fin
      | tipoBloque bloqueDef funcsYProcs Inicio bloqueCodigo Fin
      | tipoBloque funcsYProcs Inicio bloqueCodigo Fin
;

bloqueCodigo: bloqueCodigo linea
      | linea
;

tipoBloque: tipoBloque defTipo
      | defTipo
;

defTipo: Tipo Identificador Es tipoVar
      | Tipo Identificador Es DefArreglo CorcheteAbierto expresion CorcheteCerrado De tipoVar
;

linea: escribir
      | leer
      | todasAsignaciones
      | estructuras
      | llamadas
      | retornar
;

leer: Lea id
;

retornar: Retorne expresion
;

escribir:  escribir Coma Cadena
      | escribir Coma expresion
      | Escriba Cadena
      | Escriba expresion
      | Escriba Caracter
;

tipoVar: DefEntero
      | DefCaracter
      | DefBooleano
      | Identificador
;
idArreglo: Identificador CorcheteAbierto expresion CorcheteCerrado
;
idSubprg: Identificador ParentesisAbierto ParentesisCerrado
      | Identificador ParentesisAbierto entradaParam ParentesisCerrado
;
id: Identificador
      | idArreglo
      | idSubprg
;


valorBool: Verdadero
      | Falso
;
operadorComp: Igual
      | ComparacionIgual
      | ComparacionDiferente
      | MenorQue
      | MenorOIgualQue
      | MayorQue
      | MayorOIgualQue
;


defSimple: defSimple Coma Identificador
      | tipoVar Identificador
;
def: defSimple
      | DefArreglo CorcheteAbierto expresion CorcheteCerrado De tipoVar Identificador
      | Identificador Identificador
;
bloqueDef: bloqueDef def
      | def
;


asignacion: Identificador Asignacion expresion { parser.assign(std::get<std::string>($1), std::get<double>($3)); }
      | Identificador Asignacion valorBool
      | Identificador Asignacion Caracter
;
asignacionArreglo: idArreglo Asignacion expresion
      | idArreglo Asignacion Caracter
      | idArreglo Asignacion valorBool
;
todasAsignaciones: asignacion
      | asignacionArreglo
;


expresion: expresion Suma termino { $$ = std::get<double>($1) + std::get<double>($3); }
      | expresion Resta termino { $$ = std::get<double>($1) - std::get<double>($3); }
      | termino { $$ = $1; }
;
termino: termino Multiplicacion factor { $$ = std::get<double>($1) * std::get<double>($3);  }
      | termino Division factor { $$ = std::get<double>($1) / std::get<double>($3);  }
      | termino Modulo factor { $$ = std::get<double>($1) / std::get<double>($3);  }
      | factor { $$ = $1; }
;
factor: ParentesisAbierto expresion ParentesisCerrado { $$ = $2; }
      | Numero { $$ = $1; }
      | Hexadecimal { $$ = $1; }
      | Binario { $$ = $1; }
      | id  {
            $$ = parser.constValue(std::get<std::string>($1));
      }
;
expresionBooleana: expresionBooleana O terminoBooleana { $$ = std::get<double>($1) + std::get<double>($3); }
      | terminoBooleana { $$ = $1; }
;
terminoBooleana: terminoBooleana Y factorBooleana { $$ = std::get<double>($1) * std::get<double>($3);  }
      | factorBooleana { $$ = $1; }
;
factorBooleana: ParentesisAbierto expresionBooleana ParentesisCerrado { $$ = $2; }
      | operacionBooleana { $$ = $1; }
;
operacionBooleana: expresion operadorComp expresion
;


tipoParam: Variable tipoVar Identificador
      | Variable DefArreglo CorcheteAbierto Numero CorcheteCerrado De tipoVar Identificador
      | tipoVar Identificador
      | DefArreglo CorcheteAbierto Numero CorcheteCerrado De tipoVar Identificador
;
listaParams: listaParams Coma tipoParam
      | tipoParam
;
entradaParam: entradaParam Coma expresion
      | expresion
;


defProc: DefProcedimiento Identificador ParentesisAbierto listaParams ParentesisCerrado bloqueDef Inicio bloqueCodigo Fin
      | DefProcedimiento Identificador ParentesisAbierto listaParams ParentesisCerrado Inicio bloqueCodigo Fin
      | DefProcedimiento Identificador ParentesisAbierto ParentesisCerrado bloqueDef Inicio bloqueCodigo Fin
      | DefProcedimiento Identificador ParentesisAbierto ParentesisCerrado Inicio bloqueCodigo Fin
      | DefProcedimiento Identificador bloqueDef Inicio bloqueCodigo Fin
      | DefProcedimiento Identificador Inicio bloqueCodigo Fin
;
defFunc: DefFuncion Identificador ParentesisAbierto listaParams ParentesisCerrado DosPuntos tipoVar bloqueDef Inicio bloqueCodigo Fin
      | DefFuncion Identificador ParentesisAbierto listaParams ParentesisCerrado DosPuntos tipoVar Inicio bloqueCodigo Fin
      | DefFuncion Identificador ParentesisAbierto ParentesisCerrado DosPuntos tipoVar bloqueDef Inicio bloqueCodigo Fin
      | DefFuncion Identificador ParentesisAbierto ParentesisCerrado DosPuntos tipoVar Inicio bloqueCodigo Fin
      | DefFuncion Identificador DosPuntos tipoVar bloqueDef Inicio bloqueCodigo Fin
      | DefFuncion Identificador DosPuntos tipoVar Inicio bloqueCodigo Fin
;
funcsYProcs: funcsYProcs defProc
      | funcsYProcs defFunc
      | defProc
      | defFunc
;
llamadas: Llamar idSubprg
      | Llamar Identificador
;

mientras: Mientras expresionBooleana Haga bloqueCodigo Fin Mientras
;
para: Para asignacion Hasta expresion Haga bloqueCodigo Fin Para
;
si: Si expresionBooleana Entonces bloqueCodigo opcionSi Fin Si
;
opcionSi: 
      | bloqueSino
      | Sino bloqueCodigo
;
bloqueSino: bloqueSino sinoSi
      | sinoSi
;
sinoSi: Sino Si expresionBooleana Entonces bloqueCodigo
;
estructuras: mientras
      | para
      | si
;
