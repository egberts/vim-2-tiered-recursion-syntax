if !exists('main_syntax')
  if exists('b:current_syntax')
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
hi link namedA_Semicolon Todo

hi link namedA_AML_Nested_Not_Operator Type
hi link namedA_AML_Nested_Semicolon DiffChange

hi link namedA_AML_Not_Operator Operator
hi link namedA_AML_Number    Special
hi link namedA_AML_ACLIdent  Include
hi link namedA_AML_Keywords  Statement
" hi link namedA_AML  Error

syn match namedA_Semicolon contained /;/ 

syn match namedA_AML_Nested_Semicolon contained /;/ skipwhite skipempty 
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Nested_Not_Operator

hi link namedE_NotSemicolon Error
syn match namedE_NotSemicolon contained /[^;]\+/he=e-1 skipwhite skipempty
hi link namedE_PrematureRBrace Error
syn match namedE_PrematureRBrace contained /[^;]\+{/he=e-1 skipwhite skipempty



syn match namedA_AML_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedA_AML

syn match namedA_AML_Nested_Not_Operator contained /!/ skipwhite skipempty
\ nextgroup=
\    namedA_AML_Recursive,
\    namedA_AML_Number,
\    namedA_AML_Name

syn match namedA_AML_Name "\<[a-zA-Z\.\-_]\{1,63}\>" skipwhite skipempty
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_NotSemicolon,

syn match namedA_AML_Number "\<\d\{1,10}\>" skipwhite skipempty
\ nextgroup=namedA_AML_Nested_Semicolon



syn region namedA_AML_Recursive contained start=+{+ end=+}+ keepend extend
\ contains=
\    namedA_AML_Name,
\    namedA_AML_Number,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_AML_Nested_Semicolon,
\    namedE_NotSemicolon,

" acl <acl_name> { ... } ;
syn region namedA_AML contained start=+{+ end=+}+  skipwhite skipempty
\ contains=
\    namedA_AML_Name,
\    namedA_AML_Number,
\    namedA_AML_Nested_Semicolon,
\    namedA_AML_Nested_Not_Operator
\ nextgroup=
\    namedA_Semicolon,
\    namedE_NotSemicolon

" acl <acl_name> { ... } 
syn match namedA_AML_ACLIdent contained /\<[0-9a-zA-Z\-_]\{1,63}\>/ skipwhite skipempty
\ nextgroup=
\    namedA_AML,
\    namedA_AML_Not_Operator

" acl <acl_name> ...
syn keyword namedA_AML_Keywords skipwhite skipempty
\ acl
\ test2
\ nextgroup=namedA_AML_ACLIdent

syn match namedA_AML_Keywords /test/ skipwhite skipempty
\ nextgroup=namedA_AML_Number

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
