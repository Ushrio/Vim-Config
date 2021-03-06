" Set the program that is called with :make
set makeprg=clang++\ -Wall\ %:p\ -o\ %:r.exe

nnoremap <F8> :update<CR>:silent make<CR>

" Assign F9 to run the current C++ file's executable that Clang created
nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

" Abbreviations
iabbrev main int<Space>main()<Space>{}<Left><CR><CR>return<Space>1;<Up><Tab><C-R>=Eatchar('\s')<CR>
iabbrev #i #include<<i++>><++><Esc>/<i++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev #d #define<<d++>><++><Esc>/<d++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev /* /*<CR><CR>/<Up>
iabbrev for for<Space>(<f++>; <++>; <++>)<space>{<++>}<Esc>ba<CR><Esc>f}i<CR><Esc>/<f++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev struct struct<Space><s++><Space>{<++>};<Esc>ba<CR><Esc>f}i<CR><Esc>/<s++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev class class<Space><c++><Space>{<++>};<Esc>ba<CR><Esc>f}i<CR><Esc>/<c++><CR><Esc>cf><C-R>=Eatchar('\s')<CR>
iabbrev cout cout<Space><<<Space><C-R>=Eatchar('\s')<CR>
iabbrev cin cin<Space>>><Space><C-R>=Eatchar('\s')<CR>
iabbrev namespacestd using<Space>namespace<Space>std;<C-R>=Eatchar('\s')<CR>
