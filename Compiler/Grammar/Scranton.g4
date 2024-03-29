grammar Scranton;

import SraKeywords, SraLiterals, SraSeparators, SraOperators, SraCommon;

program
	: Header=programHeader Body=programBody EOF
	;

programHeader
	: ModuleSegment=moduleSegment ImportSegment=importSegment
	;

moduleSegment
	: ModuleStatement=moduleStatement?
	;

moduleStatement
    : KW_MODULE Name=namespace
    ;

namespace
	: (id '.')* id
	;

importSegment
	: importStatement*
	;

importStatement
	: KW_IMPORT Name=KW_AUTO #AutoImport
	| KW_IMPORT Name=namespace #ManualImport
	;

programBody
	: (functionDefinition | typeDefinition | statement)*
	;

functionDefinition
	: Modifiers=modifierList ReturnType=returnType Name=id HEAD_START ParameterList=parameterList HEAD_END Body=block
	;

typeDefinition
	: Header=classHeader BLOCK_START Body=classBody BLOCK_END
	;

classHeader
	: Modifiers=modifierList KW_CLASS Name=id (COLON inheritanceList)?
	;

inheritanceList
	: ((type PARAM_SEP)* type)?
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
	: Modifiers=modifierList Type=type Name=id STATEMENT_SEP
	;
	
constructorDefinition
	: KW_NEW HEAD_START ParameterList=parameterList HEAD_END Body=block
	;

statement
	: regularStatement STATEMENT_SEP
	| controlStatement STATEMENT_SEP
	| blockStatement
	;

regularStatement
	: variableDeclaration
	| expression
	;

variableDeclaration
	: VariableWithType=variableWithType (OP_ASSIGN Expression=expression)?
	;

controlStatement
	: KW_RETURN Value=expression? #ReturnStatement
	| KW_BREAK #BreakStatement
	| KW_CONTINUE #ContinueStatement
	;

blockStatement
	: block
    | ifBlock
    | forBlock
    | whileBlock
    | tryBlock
	;

block
	: BLOCK_START statement* BLOCK_END
	;

ifBlock
	: KW_IF HEAD_START expression HEAD_END statement (KW_ELSE KW_IF HEAD_START expression HEAD_END statement)* (KW_ELSE statement)?
	;

forBlock
	: KW_FOR HEAD_START variableDeclaration? STATEMENT_SEP expression? STATEMENT_SEP expression? HEAD_END statement (KW_ELSE statement)?
	| KW_FOR HEAD_START variableWithType KW_IN id HEAD_END statement (KW_ELSE statement)?
	;

whileBlock
	: KW_WHILE HEAD_START expression HEAD_END statement (KW_ELSE statement)?
	;

tryBlock
	: KW_TRY statement KW_CATCH HEAD_START variableWithType HEAD_END statement
	;
	
expression
	: Constant=constant #ConstantExpression
//	| Lambda=lambda #LambdaExpression
//	| ObjectConstructor=objectConstructor #ObjectConstructorExpression
//	| CollectionConstructor=collectionConstructor #CollectionConstructorExpression
	| Identifier=id #IdentifierExpression
	| HEAD_START Body=expression HEAD_END #NestedExpression
	| Type=expression OP_MEMBER_ACCESS Member=id  #MemberAccessOperatorExpression
	| Caller=expression HEAD_START ExpressionList=expressionList HEAD_END #FunctionCallExpression
	| HEAD_START Type=type HEAD_END Expression=expression #CastExpression
	| Operator=opLeftUnary Expression=expression #LeftUnaryOperatorExpression
	| Expression=expression Operator=opRightUnary #RightUnaryOperatorExpression
	| Left=expression Operator=opMultiplicative Right=expression #MultiplicativeOperatorExpression
	| Left=expression Operator=opAdditive Right=expression #AdditiveOperatorExpression
	| Left=expression Operator=opShift Right=expression #ShiftOperatorExpression
	| Left=expression Operator=opComparison Right=expression #ComparisonOperatorExpression
	| Left=expression Operator=opLogical Right=expression #LogicalOperatorExpression
	| Left=expression Operator=opAssignment Right=expression #AssigmentOperatorExpression
	;

constant
	: DECIMAL_INTEGER #DecimalLiteral
	| HEXADECIMAL_INTEGER #HexadecimalLiteral
	| BINARY_INTEGER #BinaryLiteral
	| DOUBLE_FLOAT #DoubleFloat
	| SINGLE_FLOAT #SingleFloat
	| HALF_FLOAT #HalfFloat
	| STRING_LITERAL #StringLiteral
	| CHAR_LITERAL #CharLiteral
	| KW_NULL #NullKeyword
	| KW_TRUE #TrueKeyword
	| KW_FALSE #FalseKeyword
	;

expressionList
	: ((expression PARAM_SEP)* expression)?
	;

/*
objectConstructor
	: id BLOCK_START ((id OP_ASSIGN expression PARAM_SEP)* (id OP_ASSIGN expression))? BLOCK_END
	;

collectionConstructor
	: INDEX_START expressionList INDEX_END
	;

lambda
	: HEAD_START parameterList HEAD_END OP_POINTER (block | expression) 
	;
*/

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
	| OP_OR_ASSIGN
	;

variableWithType
	: Type=type Name=id
	;

type
	: Name=id #SimpleType
	| Name=id OP_LESS (type PARAM_SEP)* type OP_GREATER #GenericType
	;

returnType
	: type
	| KW_VOID
	;

parameterList
	: ((variableWithType PARAM_SEP)* variableWithType)?
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
	| contextualKeyword
	;

contextualKeyword
	: KW_MODULE
	| KW_IMPORT
	| KW_IN
	| KW_CLASS
	| KW_PUBLIC
	| KW_PRIVATE
	;