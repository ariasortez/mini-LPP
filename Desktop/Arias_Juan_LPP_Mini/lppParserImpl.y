
%define parse.error verbose
%define api.pure full

%parse-param {lppParser& parser}

%code top {

#include <iostream>
#include <stdexcept>
#include "lppLexer.hpp"
#include "lppParser.hpp"


#define yylex(v) static_cast<int>(parser.getLexer().nextToken(v))

void yyerror(const lppParser& parser, const char *msg)
{
      std::cout << "Error en la linea numero " << (const_cast<lppParser&>(parser)).getLexer().getLine() << std::endl;
      throw std::runtime_error(msg);
}

}

%code requires {
#include <string>
#include <variant>
#include "lppAst.hpp"

class lppParser; // Forward declaration

using ParserValueType = Nodo *;

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
%token DefCaracter "caracter"
%token DefBooleano "booleano"
%token DefArreglo "arreglo"
%token De "de"
%token DefFuncion "funcion"
%token DefProcedimiento "procedimiento"
%token Variable "var"
%token Inicio "inicio"
%token Fin "fin"
%token Si "si"
%token Entonces "entonces"
%token Sino "sino"
%token Para "para"
%token Mientras "mientras"
%token Haga "haga"
%token Hasta "Hasta"
%token Llamar "Llamar"
%token Retorne "Retorne"
%token Cadena "StringConstant"
%token Caracter "constantCharacter"
%token Verdadero "Verdadero"
%token Falso "Falso"
%token Escriba "Escriba"
%token Tipo "Tipo"
%token Es "Es"
%token Lea "Lea"
%token SinoSi "Sino Si"

%%

inicio: programa { parser.generarArchivo($1->generarCodigo()); }
;

programa: tipoBloque Inicio bloqueCodigo Fin
      | tipoBloque bloqueDef Inicio bloqueCodigo Fin
      | tipoBloque bloqueDef funcsYProcs Inicio bloqueCodigo Fin
      | tipoBloque funcsYProcs Inicio bloqueCodigo Fin
      | Inicio bloqueCodigo Fin { $$ = new Programa((StmtBloqueDef*)nullptr, (Stmt*)$2); } // Consume la regla de bloque de codigo
      | bloqueDef Inicio bloqueCodigo Fin { $$ = new Programa((StmtBloqueDef*)$1, (Stmt*)$3); } // Consume la regla de bloque de variables y bloque de codigo
      | bloqueDef funcsYProcs Inicio bloqueCodigo Fin
      | funcsYProcs Inicio bloqueCodigo Fin
;

bloqueCodigo: bloqueCodigo linea { $$ = new StmtBloque($1, $2); }
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
      | Escriba Cadena { $$ = new StmtImprimirStr((Expr*)$2); }
      | Escriba expresion { $$ = new StmtImprimirExpr((Expr*)$2); }
      | Escriba Caracter { $$ = new StmtImprimirChar((Expr*)$2); }
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

listaVariables: listaVariables Coma Identificador { $$ = new ListaDef((ListaDef*)$1, new VarDef((IdExpr*)$3)); }
      | Identificador { $$ = new VarDef((IdExpr*)$1); }
;
def: tipoVar listaVariables { $$ = new StmtDef((StrExpr*)$1, (ListaDef*)$2); }
      | DefArreglo CorcheteAbierto expresion CorcheteCerrado De tipoVar Identificador
;
bloqueDef: bloqueDef def { $$ = new StmtBloqueDef((StmtBloqueDef*)$1, (StmtDef*)$2); }
      | def
;


asignacionSimple: Identificador Asignacion expresion { $$ = new StmtAsignar((IdExpr*)$1, (Expr*)$3); }
      | Identificador Asignacion valorBool { $$ = new StmtAsignar((IdExpr*)$1, (Expr*)$3); }
      | Identificador Asignacion Caracter { $$ = new StmtAsignar((IdExpr*)$1, (Expr*)$3); }
;
asignacionArreglo: idArreglo Asignacion expresion
      | idArreglo Asignacion Caracter
      | idArreglo Asignacion valorBool
;
todasAsignaciones: asignacionSimple
      | asignacionArreglo
;

expresion: expresion Suma termino { $$ = new ExprSuma((Expr*)$1, (Expr*)$3); }
      | expresion Resta termino { $$ = new ExprResta((Expr*)$1, (Expr*)$3); }
      | termino
;
termino: termino Multiplicacion factor { }
      | termino Division factor { }
      | termino Modulo factor { }
      | factor
;
factor: ParentesisAbierto expresion ParentesisCerrado { $$ = $2; }
      | Numero
      | Hexadecimal
      | Binario
      | id
;
expresionBooleana: expresionBooleana O terminoBooleana { }
      | terminoBooleana { $$ = $1; }
;
terminoBooleana: terminoBooleana Y factorBooleana { }
      | factorBooleana { $$ = $1; }
;
factorBooleana: ParentesisAbierto expresionBooleana ParentesisCerrado { $$ = $2; }
      | operacionBooleana { $$ = $1; }
;
operacionBooleana: expresion ComparacionIgual expresion { $$ = new ExprIgual((Expr*)$1, (Expr*)$3); }
      | expresion Igual expresion { $$ = new ExprIgual((Expr*)$1, (Expr*)$3); }
      | expresion ComparacionDiferente expresion { $$ = new ExprNIgual((Expr*)$1, (Expr*)$3); }
      | expresion MenorQue expresion { $$ = new ExprMenor((Expr*)$1, (Expr*)$3); }
      | expresion MenorOIgualQue expresion { $$ = new ExprMenorI((Expr*)$1, (Expr*)$3); }
      | expresion MayorQue expresion { $$ = new ExprMayor((Expr*)$1, (Expr*)$3); }
      | expresion MayorOIgualQue expresion { $$ = new ExprMayorI((Expr*)$1, (Expr*)$3); }
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


mientras: Mientras expresionBooleana Haga bloqueCodigo Fin Mientras { $$ = new StmtMientras((Expr*)$2, (Stmt*)$4); }
;
para: Para asignacionSimple Hasta expresion Haga bloqueCodigo Fin Para { $$ = new StmtPara((StmtAsignar*)$2, (Expr*)$4, (Stmt*)$6); }
;

si: Si expresionBooleana Entonces bloqueCodigo Fin Si { $$ = new StmtSi((Expr*)$2, (Stmt*)$4, (Stmt*)nullptr); }
      | Si expresionBooleana Entonces bloqueCodigo sino Fin Si { $$ = new StmtSi((Expr*)$2, (Stmt*)$4, (Stmt*)$5); }
      | Si expresionBooleana Entonces bloqueCodigo bloqueSino Fin Si { $$ = new StmtSi((Expr*)$2, (Stmt*)$4, (Stmt*)$5); }
;
sino: Sino bloqueCodigo { $$ = $2; }
;
sinoSi: SinoSi expresionBooleana Entonces bloqueCodigo { $$ = new StmtSinoSi((Expr*)$2, (Stmt*)$4); }
;
bloqueSino: bloqueSino sinoSi { $$ = new StmtBloque((Stmt*)$1, (Stmt*)$2); }
      | sinoSi { $$ = $1; }
;

estructuras: mientras
      | para
      | si
;
