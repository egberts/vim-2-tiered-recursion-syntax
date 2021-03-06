

if !exists('main_syntax')
  if exists('b:current_syntax')
    echomsg 'FINISH, we got no main_syntax, but we got current_syntax'
    finish
  endif
  let main_syntax='mytest'
endif
syn case match
setlocal iskeyword=.,-,48-58,A-Z,a-z
setlocal isident=.,-,48-58,A-Z,a-z,_
syn sync fromstart
let s:save_cpo = &cpoptions
set cpoptions-=C

"     IGNORE... vt100, vt102 maps and settings ...

hi link namedComment Comment
hi link namedA_Semicolon Todo

hi link namedA_AML_Nested_Not_Operator Type
hi link namedA_AML_Nested_Semicolon DiffChange

hi link namedA_AML_Not_Operator Operator
hi def link namedA_AML_Number    Number
hi link namedA_AML_Name      String
hi link namedA_ACLIdentifier  Identifier
hi link namedA_AML_Keywords  Statement
"
hi link namedComment namedHL_Comment
syn match namedComment "//.*" contains=named_ToDo
syn match namedComment "#.*" contains=named_ToDo
syn region namedComment start="/\*" end="\*/" contains=named_ToDo

hi link namedE_UnexpectedSemicolon Error
syn match namedE_UnexpectedSemicolon contained /;\+/ skipwhite skipempty

hi link namedE_MissingSemicolon Error
syn match namedE_MissingSemicolon contained /[ \n\r]*\zs[^;]*/he=s+1|

" Keep this 'uncontained' EOF search shallow and short
hi link namedE_MissingLastSemicolon Error
syn match namedE_MissingLastSemicolon /[^; \n\r][ \n\r]\{0,10}\ze\%$/rs=s,he=s+1 skipwhite skipnl skipempty

syn match namedA_Semicolon contained /;/ skipwhite skipempty

syn match namedA_AML_Nested_Semicolon contained /;/ skipwhite skipempty 
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Nested_Not_Operator,
\    namedA_AML_Nested_Semicolon


syn match namedA_AML_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedA_AML,
\    namedE_UnexpectedSemicolon

syn match namedA_AML_Nested_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Number,
\    namedA_AML_Name,
\    namedE_UnexpectedSemicolon

syn match namedA_AML_Name contained "\<\(\w\|\.\|\-\)\{1,63}\ze[^;]*" 
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon

" Keep skipnl/skipempty for Number/Name!!!
syn match namedA_AML_Number contained "\<\d\{1,10}\>\ze[^;]*"
\ skipwhite skipnl skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon


" Keep keepend/extend on AML_Recursive!!!
syn region namedA_AML_Recursive contained start=+{+ end=+}+ keepend extend
\ skipnl skipwhite skipempty
\ contains=
\    namedA_AML_Name,
\    namedA_AML_Number,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_MissingSemicolon

" acl <acl_name> { ... } ;
syn region namedA_AML contained start=+{+ end=+}+  
\ skipwhite skipnl skipempty
\ contains=
\    namedA_AML_Name,
\    namedA_AML_Number,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_Semicolon,
\    namedE_MissingSemicolon

" acl <acl_name> { ... } 
syn match namedA_ACLIdentifier contained /\<[0-9a-zA-Z\-_]\{1,63}\>/ skipwhite skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator,
\    namedE_UnexpectedSemicolon

" acl <acl_name> ...
syn keyword namedA_AML_Keywords skipwhite skipempty
\ acl
\ nextgroup=
\    namedA_ACLIdentifier,
\    namedE_UnexpectedSemicolon


let &cpoptions = s:save_cpo
unlet s:save_cpo
let b:current_syntax = 'mytest'
if main_syntax ==# 'mytest'
  unlet main_syntax
endif
" Note: AML == address_match_list
"
" AML = ( <number> | <AML> ) ; ...
" acl <acl_name> { <AML> ; ... } ;
" Google Vimscript style guide
" vim: ts=2 sts=2 ts=80
