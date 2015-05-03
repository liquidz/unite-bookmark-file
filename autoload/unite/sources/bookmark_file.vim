let s:save_cpo = &cpo
set cpo&vim

let s:unite_sources = {
    \ 'name': 'bookmark/file',
    \ 'default_kind': 'directory',
    \ 'syntax': 'uniteSource__Bookmark',
    \ }

let s:V = vital#of('unite_bookmark_file')
let s:Filepath = s:V.import('System.Filepath')
let s:_  = s:V.import('Underscore').import()

""
" @var
" Bookmark file path.
" Default value is '~/.bookmark'
"
if !exists('g:unite_bookmark_file')
  let g:unite_bookmark_file = '~/.bookmark'
endif

""
" Add basename as a title.
"
function! unite#sources#bookmark_file#add_title(path) abort
  let name = s:Filepath.basename(a:path)
  return '[' . name . '] ' . a:path
endfunction

""
" Return directory array that defined in book mark file.
"
function! unite#sources#bookmark_file#load(file) abort
  let file = expand(a:file)
  if filereadable(file)
    return s:_.chain(readfile(file))
        \.filter('isdirectory(v:val)')
        \.value()
  endif
  return []
endfunction

function! s:unite_sources.gather_candidates(args, context) abort
  let dirs = unite#sources#bookmark_file#load(
      \ expand(g:unite_bookmark_file))
  return map(dirs, '{
      \ "word": unite#sources#bookmark_file#add_title(v:val),
      \ "action__directory": fnamemodify(v:val, ":p:h"),
      \ "action__path": v:val
      \ }')
endfunction

function! unite#sources#bookmark_file#define() abort
  return s:unite_sources
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

