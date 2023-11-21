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
  INIT;
  OBJECT;
  TYPE;
  COUNT;
  ATTRLIST;
  ATTR;
  EVENT;
  CONDITION;
  THEN;
  ELSE;
  STMTBLOCK;
  HEADER;
  BODY;
  AFTERITERATION;
  CONDITION;
  INIT;
  ASSIGNMENT;
  VALUE;
  INDEX;
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
-> ^(GAME attrAssList? ^(DECLARATIONS decl*) ^(STATEMENT_BLOCK stmtBlock) ^(BLOCKS block*)) ;

decl: varDecl ';'! | objDecl ';'!;

varDecl: 'int' Idf varDecl2 -> ^(VAR Idf varDecl2?);

varDecl2: init? | '[' Number ']' ;

init: '=' expr -> ^(INIT expr);

objDecl: objType Idf objDecl2 -> ^(OBJECT ^(TYPE objType) Idf objDecl2?);

objDecl2: '(' attrAssList ')' | '[' Number ']' -> ^(COUNT Number);

objType: 'rectangle' | 'triangle' | 'circle';

attrAssList: attrAss (',' attrAss)* -> ^(ATTRLIST attrAss+); 

attrAss: Idf '=' expr -> ^(ATTR Idf ^(VALUE expr));

block: animBlock | eventBlock;

animBlock: 'animation' Idf '(' objType Idf ')' stmtBlock
            -> ^('animation' Idf ^(OBJECT ^(TYPE objType) Idf) stmtBlock) ;

eventBlock: 'on' keyStroke stmtBlock -> ^(EVENT ^('on' keyStroke) stmtBlock);

keyStroke: 'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow';

stmtBlock: '{' stmt* '}' -> ^(STMTBLOCK stmt*);

stmt: ifStmt | forStmt | assStmt ';'!;

ifStmt: 'if' '(' expr ')' s1=stmtBlock ('else' s2=stmtBlock)?
      -> ^('if' ^(CONDITION expr) ^(THEN $s1) ^(ELSE $s2)?);

forStmt: 'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock
		-> ^('for' ^(HEADER ^(INIT assStmt) ^(CONDITION expr) ^(AFTERITERATION assStmt)) ^(BODY stmtBlock));


assStmt: var '=' expr -> ^(ASSIGNMENT var ^(VALUE expr));

var: Idf var2? ->  ^(VAR Idf var2?);

var2: '.' Idf | '[' expr ']' var3? -> ^(INDEX expr) var3? ; 

var3: '.' Idf ;

// expr: Number | Var | Var touches Var | - Expr | ! Expr | ( Expr ) | Expr Op Expr 
// ▪ Unäre Operatoren: - und !
// ▪ Multiplikative Operatoren: * und /
// ▪ Additive Operatoren: + und -
// ▪ Relationale Operatoren: ==, <= und <
// ▪ Konjunktion: &&
// ▪ Disjunktion: ||
// '*' and '/' have higher precedence than '+' and '-'. So we place them closer to the operands.

expr:  orexpr;
orexpr: andexpr ('||'^ andexpr)*;
andexpr: relexpr ('&&'^ relexpr)*;
relexpr: addexpr (relop^ addexpr)*;
addexpr: multexpr (addop^ multexpr)*;
multexpr:unexpr (multop^ unexpr)*;
unexpr: unop? basicexpr;
basicexpr: Number | '('! expr ')'! | var basicexpr2;
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