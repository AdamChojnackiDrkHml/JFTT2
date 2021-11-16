%{
#include <stdio.h>

int yywrap();
int yylex();

int dox_print = 0;
%}

BCKSLSH ((\\)|(\n))

%x COMMENT_IN_INCLUDE_STR
%x SINGLE_LINE_COMMENT
%x MULTI_LINE_COMMENT
%x SINGLE_LINE_DOC_COMMENT
%x MULTI_LINE_DOC_COMMENT
%x COMMENT_IN_STR

%%

\"                              {BEGIN(COMMENT_IN_STR);  ECHO;}
\/((\\)|(\n))*\/                 {BEGIN(SINGLE_LINE_COMMENT);}
\/((\\)|(\n))*\*                 {BEGIN(MULTI_LINE_COMMENT);}
\/((\\)|(\n))*\/((\\)|(\n))*\/    {BEGIN(SINGLE_LINE_DOC_COMMENT); if(dox_print) ECHO;}
\/((\\)|(\n))*\*((\\)|(\n))*\*    {BEGIN(MULTI_LINE_DOC_COMMENT); if(dox_print) ECHO;}



<COMMENT_IN_STR>{

    \"                          {ECHO; BEGIN(INITIAL);}
}

<SINGLE_LINE_COMMENT>{
    .*\\\n                      ;
    .                           ;
    [^\\]\n                        {printf("\n"); BEGIN(INITIAL);}
}

<MULTI_LINE_COMMENT>{
    .|\n                        ;
    \*{BCKSLSH}*\/             BEGIN(INITIAL);
}

<SINGLE_LINE_DOC_COMMENT>{
    .                           {if(dox_print) ECHO;}
    .*\\\n                      {if(dox_print) ECHO;}
    .?\n                     {if(dox_print) printf("\n"); BEGIN(INITIAL);}
}


<MULTI_LINE_DOC_COMMENT>{
    .|\n                        {if(dox_print) ECHO;}
    \*((\\)|(\n))*\/             {printf("\n"); if(dox_print) ECHO; BEGIN(INITIAL);}
}

%%

int yywrap() {
    return 1;
}

int main() {
    return yylex();
}
