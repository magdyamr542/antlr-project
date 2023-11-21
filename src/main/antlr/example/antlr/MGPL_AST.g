grammar MGPL_AST;

options {
   backtrack = false;
   k = 1;
   output = AST;
}

// These are the imaginary token used to construct the AST.
tokens {
  VAR;
  GAME;
  BLOCKS;
  STATEMENT_BLOCK;
  DECLARATIONS;
}

@parser::header {
package example.antlr;
}

@lexer::header {
package example.antlr;
}

// Override the error handnlers. We want to exit with an exception directly when we find a problem.
@parser::members {
  @Override
    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
        String hdr = getErrorHeader(e);
        String msg = getErrorMessage(e, tokenNames);
        throw new RuntimeException("Parser error:\n" + hdr+" "+msg);
    }
}

@lexer::members {
  @Override
    public void displayRecognitionError(String[] tokenNames, RecognitionException e) {
        String hdr = getErrorHeader(e);
        String msg = getErrorMessage(e, tokenNames);
        throw new RuntimeException("Parser error:\n" + hdr+" "+msg);
    }
}

/*------------------------------------------------------------------
 * PARSER RULES
 *------------------------------------------------------------------*/

prog: 'game' Idf '(' attrAssList? ')' decl* stmtBlock block* 
-> ^(GAME ^(DECLARATIONS decl*) ^(STATEMENT_BLOCK stmtBlock) ^(BLOCKS block*)) ;

decl: varDecl ';'! | objDecl ';'!;

varDecl: 'int' Idf varDecl2 -> ^(VAR Idf varDecl2?);

varDecl2: init? | '[' Number ']' ;

init: '=' expr;

objDecl: objType Idf objDecl2;

objDecl2: '(' attrAssList ')' | '[' Number ']';

objType: 'rectangle' | 'triangle' | 'circle';

attrAssList: attrAss attrAssList2; 

attrAssList2: ',' attrAssList | /* epsilon */;

attrAss: Idf '=' expr;

block: animBlock | eventBlock;

animBlock: 'animation' Idf '(' objType Idf ')' stmtBlock;

eventBlock: 'on' keyStroke stmtBlock;

keyStroke: 'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

stmtBlock: '{' stmt* '}';

stmt: ifStmt | forStmt | assStmt ';';

ifStmt: 'if' '(' expr ')' stmtBlock ('else' stmtBlock)?;

forStmt: 'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock;

assStmt: var '=' expr;

var: Idf var2 ;

var2: '[' expr ']' var3 | '.' Idf | /* epsilon */ ;

var3: '.' Idf | /* epsilon */ ;

// expr: Number | Var | Var touches Var | - Expr | ! Expr | ( Expr ) | Expr Op Expr 
// ▪ Unäre Operatoren: - und !
// ▪ Multiplikative Operatoren: * und /
// ▪ Additive Operatoren: + und –
// ▪ Relationale Operatoren: ==, <= und <
// ▪ Konjunktion: &&
// ▪ Disjunktion: ||

expr:  orexpr;
orexpr: andexpr ('||' andexpr)*;
andexpr: relexpr ('&&' relexpr)*;
relexpr: addexpr (relop addexpr)*;
addexpr: multexpr (addop multexpr)*;
multexpr: unexpr (multop unexpr)*;
unexpr: unop? basicexpr;
basicexpr: Number | '(' expr ')' | var basicexpr2;
basicexpr2: 'touches' var | /* epsilon */ ;

op: '||' | '&&' | '==' | '<' | '<=' | '+' | '-' | '*' | '/';

relop: '==' | '<=' | '<';
addop: '+' | '-';
multop: '*' | '/';
unop: '!' | '-';


/*------------------------------------------------------------------
 * LEXER RULES
 *------------------------------------------------------------------*/


fragment DIGIT  : '0'..'9' ;

fragment LETTER :   ('a'..'z'|'A'..'Z');

Number: DIGIT+;

Idf: LETTER (LETTER | DIGIT | '_')*;

WHITESPACE : ( '\t' | ' ' | '\r' | '\n'| '\u000C' )+    { $channel = HIDDEN; } ;

LINE_COMMENT : '//' ~('\n'|'\r')* '\r'? '\n' {$channel=HIDDEN;} ;