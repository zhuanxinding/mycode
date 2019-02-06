/*
   Append a prefix or postfix to a macro variable
   &flag=0 prefix
   &flag=1 postfix

The following one line code does the same thing:

%let &prefix.&base. = &prefix.%sysfunc(tranwrd(%sysfunc(compbl(&base.)),%bquote( ),%bquote( &prefix.)));
%let &base.&postfix. = %sysfunc(tranwrd(%sysfunc(compbl(&base.)),%bquote( ),%bquote(&postfix. )))&postfix.;

*/

%macro makename(base, prefix, flag);

  %local cntbase tmpvar newvar;
  %local count word i;

  %let count=1;
  %let word=%qscan(&base,&count,%str( ));
  %do %while (&word ne);
    %let count=%eval(&count+1);
    %let word=%qscan(&base,&count,%str( ));
  %end;
  %let cntbase = %eval(&count-1);

  %let newvar=;

  %if &flag=0 or &flag=prefix %then %do;
  	%do i = 1 %to &cntbase;
    	%let tmpvar = %scan(&base,&i,%str( ));
    	%if %index(&tmpvar,-)>0 %then %let newvar = &newvar &prefix%scan(&tmpvar,1,-)%str(-)&prefix%scan(&tmpvar,2,-);
    	%else %let newvar = &newvar &prefix&tmpvar;
  	%end;
  %end;
  %else %do;
  	%do i = 1 %to &cntbase;
    	%let tmpvar = %scan(&base,&i,%str( ));
    	%if %index(&tmpvar,-)>0 %then %let newvar = &newvar %scan(&tmpvar,1,-)&prefix%str(-)%scan(&tmpvar,2,-)&prefix;
    	%else %let newvar = &newvar &tmpvar&prefix;
 	 %end;
  %end;

  &newvar

%mend;

/* add comment */





