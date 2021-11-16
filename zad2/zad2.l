%{
#include <stdio.h>

int yylex();
int yywrap();
%}

%x COM
%x TAG

%%
\<!--			  	BEGIN(COM);
\<		  	{ECHO; BEGIN(TAG);}



<COM>{
	.						  ;
	\n						  ;
	--\>		BEGIN(INITIAL);
}

<TAG>{
	.>	{ECHO; BEGIN(INITIAL);}
}

%%

int yywrap() {
}


int main() {
  yylex();
  return 0;
}
