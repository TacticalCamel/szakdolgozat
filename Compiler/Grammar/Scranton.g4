grammar Scranton;

// ⣀⣠⣤⣤⣤⣤⢤⣤⣄⣀⣀⣀⣀⡀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
// ⠄⠉⠹⣾⣿⣛⣿⣿⣞⣿⣛⣺⣻⢾⣾⣿⣿⣿⣶⣶⣶⣄⡀⠄⠄⠄
// ⠄⠄⠠⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣆⠄⠄
// ⠄⠄⠘⠛⠛⠛⠛⠋⠿⣷⣿⣿⡿⣿⢿⠟⠟⠟⠻⠻⣿⣿⣿⣿⡀⠄
// ⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⢛⣿⣁⠄⠄⠒⠂⠄⠄⣀⣰⣿⣿⣿⣿⡀
// ⠄⠉⠛⠺⢶⣷⡶⠃⠄⠄⠨⣿⣿⡇⠄⡺⣾⣾⣾⣿⣿⣿⣿⣽⣿⣿
// ⠄⠄⠄⠄⠄⠛⠁⠄⠄⠄⢀⣿⣿⣧⡀⠄⠹⣿⣿⣿⣿⣿⡿⣿⣻⣿
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠉⠛⠟⠇⢀⢰⣿⣿⣿⣏⠉⢿⣽⢿⡏
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠠⠤⣤⣴⣾⣿⣿⣾⣿⣿⣦⠄⢹⡿⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠒⣳⣶⣤⣤⣄⣀⣀⡈⣀⢁⢁⢁⣈⣄⢐⠃⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⣰⣿⣛⣻⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡯⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⣬⣽⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⢘⣿⣿⣻⣛⣿⡿⣟⣻⣿⣿⣿⣿⡟⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠛⢛⢿⣿⣿⣿⣿⣿⣿⣷⡿⠁⠄⠄⠄
// ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠉⠉⠉⠉⠈⠄⠄⠄⠄⠄⠄
// Nyilván számít a sorrend
import SraKeywords, SraLiterals, SraSeparators, SraOperators, SraCommon;

// Egy program felépítése
program
	: Header=programHeader Body=programBody EOF
	;

// 1 Program fejléc
programHeader
	: moduleSegment importSegment parameterSegment
	;

// 1.1 Modul szegmens
moduleSegment
	: moduleStatement?
	;

moduleStatement
    : KW_MODULE Name=id
    ;

// 1.2 Import szegmens
importSegment
	: importStatement*
	;

importStatement
	: KW_IMPORT Name=KW_AUTO #AutoImport
	| KW_IMPORT Name=id #ManualImport
	;

// 1.3 Paraméter szegmens
parameterSegment
	: InParameters=inParameters? OutParameters=outParameters?
	;

scriptParameterList
	: (varWithType PARAM_SEP)* varWithType
	;

// 1.3.1 Bemeneti paraméterek
inParameters
	: KW_IN (KW_VOID | ParameterList=scriptParameterList)
	;

// 1.3.2 Kimeneti paraméterek
outParameters
	: KW_OUT (KW_VOID | ParameterList=scriptParameterList)
	;

// 2 Program test
programBody
	: (functionDefinition | typeDefinition | statement)*
	;

// 2.1 Függvény definíció
functionDefinition
	: Modifiers=modifierList ReturnType=returnType Name=id HEAD_START ParameterList=parameterList HEAD_END Body=block
	;

// 2.2 Típus definíció
typeDefinition
	: Header=classHeader BLOCK_START Body=classBody BLOCK_END
	;

classHeader
	: Modifiers=modifierList KW_CLASS Name=id (COLON inheritanceList)?
	;

inheritanceList
	: ((typeName PARAM_SEP)* typeName)?
	;

classBody
	: classMember*
	;

classMember
	: functionDefinition
	| propertyDefinition
	| constructorDefinition
	;

propertyDefinition
	: Modifiers=modifierList Type=typeName Name=id STATEMENT_SEP
	;
	
constructorDefinition
	: KW_NEW HEAD_START ParameterList=parameterList HEAD_END Body=block
	;

// 2.3 Utasítás
statement
	: regularStatement STATEMENT_SEP
	| controlStatement STATEMENT_SEP
	| blockStatement
	;

// 2.3.1 Általános utasítás
regularStatement
	: variableDeclaration
	| expression
	;

// 2.3.1.1 Változó deklaráció
variableDeclaration
	: varWithType (OP_ASSIGN Expression=expression)?
	;

// 2.3.2 Vezérlési utasítás
controlStatement
	: KW_RETURN Value=expression? #ReturnStatement
	| KW_BREAK #BreakStatement
	| KW_CONTINUE #ContinueStatement
	;

// 2.3.3 Blokk utasítás
blockStatement
	: block
    | ifBlock
    | forBlock
    | whileBlock
    | tryBlock
	;

// 2.3.3.1 Blokk
block
	: BLOCK_START statement* BLOCK_END
	;

// 2.3.3.2 If blokk
ifBlock
	: KW_IF HEAD_START expression HEAD_END statement (KW_ELSE KW_IF HEAD_START expression HEAD_END statement)* (KW_ELSE statement)?
	;

// 2.3.3.3 For block
forBlock
	: KW_FOR HEAD_START variableDeclaration? STATEMENT_SEP expression? STATEMENT_SEP expression? HEAD_END statement (KW_ELSE statement)?
	| KW_FOR HEAD_START varWithType KW_IN id HEAD_END statement (KW_ELSE statement)?
	;

// 2.3.3.4 While block
whileBlock
	: KW_WHILE HEAD_START expression HEAD_END statement (KW_ELSE statement)?
	;

// 2.3.3.5 Try block
tryBlock
	: KW_TRY statement KW_CATCH HEAD_START varWithType HEAD_END statement
	;
	
// Kifejezés
expression
	: Constant=constant #ConstantExpression
	| FunctionCall=functionCall #FunctionCallExpression
	| Lambda=lambda #LambdaExpression
	| ObjectConstructor=objectConstructor #ObjectConstructorExpression
	| CollectionConstructor=collectionConstructor #CollectionConstructorExpression
	| Identifier=id #IdentifierExpression
	| HEAD_START expression HEAD_END #NestedExpression
	| Left=expression OP_MEMBER_ACCESS Right=expression  #MemberAccessOperatorExpression
	| LeftUnaryOperator=opLeftUnary Expression=expression #LeftUnaryOperatorExpression
	| Left=expression RightUnaryOperator=opRightUnary #RightUnaryOperatorExpression
	| Left=expression MultiplicativeOperator=opMultiplicative Right=expression #MultiplicativeOperatorExpression
	| Left=expression AdditiveOperator=opAdditive Right=expression #AdditiveOperatorExpression
	| Left=expression ShiftOperator=opShift Right=expression #ShiftOperatorExpression
	| Left=expression ComparisonOperator=opComparison Right=expression #ComparisonOperatorExpression
	| Left=expression LogicalOperator=opLogical Right=expression #LogicalOperatorExpression
	| Left=expression AssigmentOperator=opAssignment Right=expression #AssigmentOperatorExpression
	;

constant
	: FLOAT_LIT #FloatLiteral
	| DEC_LIT #DecimalLiteral
	| HEX_LIT #HexadecimalLiteral
	| BIN_LIT #BinaryLiteral
	| STRING_LIT #StringLiteral
	| CHAR_LIT #CharLiteral
	| KW_NULL #NullKeyword
	| KW_TRUE #TrueKeyword
	| KW_FALSE #FalseKeyword
	;

functionCall
	: id HEAD_START expressionList HEAD_END
	;

expressionList
	: ((expression PARAM_SEP)* expression)?
	;

objectConstructor
	: id BLOCK_START ((id OP_ASSIGN expression PARAM_SEP)* (id OP_ASSIGN expression))? BLOCK_END
	;

collectionConstructor
	: INDEX_START expressionList INDEX_END
	;

lambda
	: HEAD_START parameterList HEAD_END OP_POINTER (block | expression) 
	;

opLeftUnary
	: OP_PLUS
	| OP_MINUS
	| OP_NOT
	;

opRightUnary
	: OP_INCREMENT
	| OP_DECREMENT
	;

opMultiplicative
	: OP_MULTIPLY
	| OP_DIVIDE
	| OP_MODULUS
	;

opAdditive
	: OP_PLUS
    | OP_MINUS
	;

opShift
	: OP_SHIFT_LEFT
	| OP_SHIFT_RIGHT
	;

opComparison
	: OP_EQ
	| OP_NOT_EQ
	| OP_LESS
	| OP_GREATER
	| OP_LESS_EQ
	| OP_GREATER_EQ
	;

opLogical
	: OP_AND
	| OP_XOR
	| OP_OR
	;

opAssignment
	: OP_ASSIGN
	| OP_MULTIPLY_ASSIGN
	| OP_DIVIDE_ASSIGN
	| OP_MODULUS_ASSIGN
	| OP_PLUS_ASSIGN
	| OP_MINUS_ASSIGN
	| OP_SHIFT_LEFT_ASSIGN
	| OP_SHIFT_RIGHT_ASSIGN
	| OP_AND_ASSIGN
	| OP_XOR_ASSIGN
	| OP_OR_ASSIGN
	;

// Közös szabály
varWithType
	: Type=typeName Name=id
	;

typeName
	: Name=id #SimpleType
	| Name=id OP_LESS (typeName PARAM_SEP)* typeName OP_GREATER #GenericType
	;

returnType
	: typeName
	| KW_VOID
	;

parameterList
	: ((varWithType PARAM_SEP)* varWithType)?
	;

modifierList
	: modifier*
	;

modifier
	: KW_PUBLIC
	| KW_PRIVATE
	;

id
	: ID
	| contextual_keyword
	;

contextual_keyword
	: KW_MODULE
	| KW_IMPORT
	| KW_IN
	| KW_OUT
	| KW_CLASS
	| KW_PUBLIC
	| KW_PRIVATE
	;