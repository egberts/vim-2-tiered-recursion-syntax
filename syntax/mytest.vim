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
hi link xyz_AML_Nested_Semicolon Operator
hi link xyz_Semicolon Todo
hi link xyz_Number    Special
hi link xyz_ACLIdent  Include
hi link xyz_Keywords  Statement
hi link xyz_AML  Error

syn match xyz_Semicolon contained /;/ 

syn match xyz_AML_Nested_Semicolon contained /;/ skipwhite skipempty 
\ nextgroup=
\    xyz_AML_Placeholder

syn match xyz_Number "\<\d\{1,10}\>" skipwhite skipempty
\ nextgroup=
\    xyz_AML_Nested_Semicolon

syn region xyz_AML_Placeholder contained start=+{+ end=+}+ keepend extend
\ contains=
\    xyz_Number,
\    xyz_AML_Nested_Semicolon
\ nextgroup=
\    xyz_AML_Nested_Semicolon

" acl <acl_name> { ... } ;
syn region xyz_AML contained start=+{+ end=+}+  skipwhite skipempty
\ contains=
\    xyz_Number,
\    xyz_AML_Nested_Semicolon
\ nextgroup=
\    xyz_Semicolon

" acl <acl_name> { ... } 
syn match xyz_ACLIdent contained /\<[0-9a-zA-Z\-_]\{1,63}\>/ skipwhite skipempty
\ nextgroup=
\    xyz_AML

" acl <acl_name> ...
syn match xyz_Keywords /acl/ skipwhite skipempty
\ nextgroup=xyz_ACLIdent

syn match xyz_Keywords /test/ skipwhite skipempty
\ nextgroup=xyz_Number

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
