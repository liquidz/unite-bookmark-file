let s:suite  = themis#suite('foo')
let s:assert = themis#helper('assert')

let s:V = vital#of('unite_bookmark_file')
let s:Filepath = s:V.import('System.Filepath')

function! s:suite.bookmark_file_add_title_test() abort
  let path = '/foo/bar'
  let ret = unite#sources#bookmark_file#add_title(path)
  call s:assert.equals(ret, '[bar] ' . path)
endfunction

function! s:suite.bookmark_file_load_test() abort
  let file = s:Filepath.join(getcwd(), 'test', 'files', 'bookmark.txt')
  let ret  = unite#sources#bookmark_file#load(file)
  call s:assert.equals(ret, ['./autoload'])
endfunction
