%{
#include <stdio.h>
#include <math.h>
#include <stdbool.h>

#define MAX_ELEM_NR 100
#define ERROR_CODE 0

int yylex();
int yywrap();

int ptr = -1;
int stack[MAX_ELEM_NR];
int err = false;
int a, b;

void push(int num)
{
    if(ptr >= MAX_ELEM_NR)
	{
		printf("\nError: stack overflow \n");
		err = true;
		return;
    }
	ptr++;
	stack[ptr] = num;
}


int pop()
{
    if(ptr < 0)
	{
		err = true;
		return ERROR_CODE;
    }

	int returnin = stack[ptr];
	ptr--;
	return returnin;
}

%}

%x CODE_RED

%%
-?[0-9]+ 	{push(atoi(yytext));}

\+			{
				int a = pop();
				int b = pop();

				push(a + b);
			}
\-			{
				int a = pop();
				int b = pop();

				push(b - a);
			}
\*			{
				int a = pop();
				int b = pop();

				push(a * b);
			}
\/			{
				int a = pop();
				int b = pop();

				if(a == 0)
				{
					printf("\nError: DIVIDING BY ZERRO \n");
					BEGIN(CODE_RED);
				}
				else
				{
					push(b / a);
				}
			}
\%			{
				int a = pop();
				int b = pop();

				if(a == 0)
				{
					printf("\nError: REMINDING BY ZERRO \n");
					BEGIN(CODE_RED);
				}
				else
				{
					push(b % a);
				}

			}
\^			{
				int a = pop();
				int b = pop();

				push((int)pow((double)b, (double)a));
			}

[ \t]		;
\n			{
				if(ptr != 0)
				{
						printf("\nError: to few operators %d\n", ptr);
                        ptr = -1;
                        err = false;
                        BEGIN(INITIAL);
                }
				else
				{
                    int res = pop();
                    if(!err)
					{
                        printf("= %d\n", res);
                    }
					else
					{
                        fprintf(stderr, "\nError: to few arguments\n");
                    }
                    err = false;
                    ptr = -1;
                    BEGIN(INITIAL);
                }

			}

<CODE_RED>{
    .          ;
    \n         {ptr = -1; BEGIN(INITIAL);}
}

%%


int yywrap() {
    return 1;
}

int main() {
    return yylex();
}
