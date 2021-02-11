""""""""""""""""""""""""""""""""""""""""""
" Greg's Configuration
""""""""""""""""""""""""""""""""""""""""""
" Required to not be forced into vi mode
set nocompatible

" Enable syntax, the mouse, and no line wrapping
syntax on
set mouse=a
set nowrap

" Set rendering option for brighter colors and ligatures
set renderoptions=type:directx
set encoding=utf-8

" Map leader to space
let mapleader = "\<Space>"

" Enable a fuzzy finder esque system for files
set path=.,/usr/include,,.
set path+=**
set wildmenu

" Disable the mode display below statusline
set noshowmode

" OSX backspace fix
set backspace=indent,eol,start

" Languages in which to disable polyglot
" Needs to be before you load polyglot
let g:polyglot_disabled = ['markdown', 'autoindent', 'sensible', 'Python']

" Plugins section
""""""""""""""""""""""""""""""""""""""""""
" START Vim Plug Configuration 
""""""""""""""""""""""""""""""""""""""""""
" Checks if vim-plug is installed and if not automatically installs it
if has('win32') || has ('win64')
    " Chocolatey default install location
	if empty(glob('~/vimfiles/autoload/plug.vim')) 
        silent !curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
elseif has('unix')
    if has('mac') || has('macunix')
        if empty(glob('~/.vim/autoload/plug.vim'))
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    else
        " Linux distributions
        if empty(glob('~/.vim/autoload/plug.vim'))
            silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    endif
endif

" Disable file type for vim plug
filetype off                  " required

" Check for OS system in order to start vim-plug in
if has('win32') || has('win64')
    let g:plugDirectory = '~/vimfiles/plugged'
elseif has('unix')
    if has('macunix') || has('mac')
        let g:plugDirectory = '~/.vim/plugged'
    else
        " Linux distributions
        let g:plugDirectory = '~/.vim/plugged'     
    endif
endif

call plug#begin(plugDirectory)

""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""
" Utility
"""""""""""""""""""""""
" Add indent guides
Plug 'nathanaelkane/vim-indent-guides'
" Auto closing of delimiters such as (), [], and {}
Plug 'jiangmiao/auto-pairs'
" Auto close html and xml tags
Plug 'alvan/vim-closetag', { 'for': ['html', 'phtml', 'xhtml', 'javascript', 'jsx', 'xml'] }
" Easily surround and change quotes
Plug 'tpope/vim-surround'
" Preview Markdown files in browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'], 'on': ['MarkdownPreview'] }
" Better commenting
Plug 'preservim/nerdcommenter'
" Automatically set project directory (Works with Fugitive)
Plug 'airblade/vim-rooter'
" Add snippet support
Plug 'sirver/UltiSnips'

""""""""""""""""""""""" 
" Generic Programming Support 
"""""""""""""""""""""""
" Code completion (Requires Node.js)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Pretty complete language pack for better syntax highlighting
Plug 'sheerun/vim-polyglot'
" Add support for running commands asynchronously
Plug 'skywind3000/asyncrun.vim', { 'on': [ 'AsyncRun' ] }
" Adds LaTeX Utilities
Plug 'lervag/vimtex', { 'for': ['tex'] }

""""""""""""""""""""""" 
" Git Support
"""""""""""""""""""""""
" General git wrapper
Plug 'tpope/vim-fugitive'
" Git icons in gutter
Plug 'airblade/vim-gitgutter'

"""""""""""""""""""""""
" Theme / Interface
"""""""""""""""""""""""
" Side file tree
Plug 'preservim/nerdtree', { 'on': [ 'NERDTree', 'NERDTreeToggle' ] }
" Improved status bar
Plug 'itchyny/lightline.vim'
" Presents tags in a bar to the side (Requires Universal-Ctags)
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" Gruvbox theme"
Plug 'morhetz/gruvbox'
" Seoul-256 Theme"
Plug 'junegunn/seoul256.vim'
" Rainbow brackets and parenthesis
Plug 'junegunn/rainbow_parentheses.vim', { 'on': 'RainbowParentheses' }

call plug#end()            " required
filetype plugin indent on    " required
"""" END Vim Plug Configuration 

"""""""""""""""""""""""""""""""""""""
" Vim Config Settings
"""""""""""""""""""""""""""""""""""""
" Set Font and size
if has('win32') || has('win64')
    if glob("C:/DELL") != ""
        " Set the font for my Dell XPS 13
        set guifont=Fira_Code:h8
    else
        " Set the font for my desktop
        set guifont=Fira_Code:h10
    endif
elseif has('unix')
    if has('macunix') || has('mac')
        set guifont=Fira_Code:h12
    else
        " Linux distributions
        set guifont=firacode    
    endif
endif

" Start Vim fullscreen
if has('win32') || has('win64')
    au GUIEnter * simalt ~x
elseif has('macunix') || has('mac')
    set lines=999 columns=999
endif

" Show linenumbers
set number relativenumber
set ruler

" Set Proper 4 Space Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab

" Always display the status line
set laststatus=2

" Enable highlighting of the current line
set cursorline

" True colors support for terminal
if (has("termguicolors"))
    set termguicolors
else
    " If Vim doesn't support true colors set 256 colors
    set t_Co=256
endif 

" Set color theme
let g:seoul256_background = 234
colorscheme seoul256
set background=dark

" Autorun RainbowParentheses command upon opening a file
autocmd BufRead * RainbowParentheses

" Automatically save Session.vim it one exists
function! SaveSessionIfExistsUponExit()
    if glob('./Session.vim') != ""
        " If Session.vim exists save before exiting
        silent mksession!
    endif
endfunction

autocmd VimLeave * call SaveSessionIfExistsUponExit()

" Sets the default splits to be to the right and below from default
set splitright splitbelow


" Check if the buffer is empty and determine how to open my vimrc
function! CheckHowToOpenVimrc()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1
        " If the buffer is empty open vimrc fullscreen 
        e $MYVIMRC
    else
        " Otherwise open vimrc in a vertical split
        vsp $MYVIMRC
    endif
endfunction

" Autosave autocmd that makes sure the file exists before saving. Stops errors
" from being thrown
function! Autosave()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1 || &readonly || mode() == "c" || pumvisible()
        " If the file has no name, is not readable, doesn't exist, is
        " readonly, is currently in command mode, or the pum is visible don't
        " autosave"
        return
    else
        " Otherwise autosave"
        silent update
    endif
endfunction

" Finds the directory that the .vimrc is in
" Safe for symbolic links
" Needs to be outside of function in order to work correctly
let s:vimrclocation = fnamemodify(resolve(expand('<sfile>:p')), ':h')
function! GitFetchVimrc()
    " Change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation) 
    
    " Execute a git fetch to update the tree
    " Run windows command in cmd and linux in shell
    if has("win32") || has("win64")
        let l:gitFetchJob = job_start("cmd git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
    else
        let l:gitFetchJob = job_start("/bin/sh git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
    endif 
    
    " Grab the status of the job
    let l:gitFetchJobStatus = job_status(gitFetchJob)
    " If unsuccessful let user know and stop job
    if (l:gitFetchJobStatus ==? "fail" || l:gitFetchJobStatus ==? "dead")
        echohl WarningMsg | echom "Vimrc git fetch failed with status " . l:gitFetchJobStatus | echohl None
        call job_stop(gitFetchJob)
    else
        " Otherwise stop job and run CompareUpstreamAndLocalVimrcGitStatus()
        call job_stop(gitFetchJob)
        " Needs to be a timer because we are running a vimscript function
        " https://vi.stackexchange.com/questions/27003/how-to-start-an-async-function-in-vim-8
        let l:compareUpstreamAndLocalTimer = timer_start(0, 'CompareUpstreamAndLocalVimrcGitStatus')
    endif
    return 
endfunction 

" Compare the local and upstream Git status
function! CompareUpstreamAndLocalVimrcGitStatus(timer)
    " change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation)

    " Set an upstream and local variable that is a hash returned by git
    " Upstream is the hash of the upstream commit
    let l:upstream = system("git rev-parse @{u}")
    " Local is the hash of the current local commit
    let l:local = system("git rev-parse @")
    
    " If the hashes match then the vimrc is updated 
    if l:local ==? l:upstream
        echohl title | echom "Vimrc is up to date" | echohl None
    elseif l:local !=? l:upstream 
        " Otherwise you need to update your vimrc
        echohl WarningMsg | echom "You need to update your Vimrc" | echohl None
    else 
        " Otherwise something went wrong
        echohl Error | echom "Unable to confirm whether you need to update your Vimrc" | echohl None
    endif
    
    " Go back to the original startup directory
    silent execute("lcd ~")
    return
endfunction

" Autocmd to check whether vimrc needs to be updated"
" Only runs if vim version >= 8.0 as it uses async features
if v:version >= 80 && has("job") && has("timers")
    autocmd VimEnter * call GitFetchVimrc()
endif

" Call autosave
autocmd CursorHold,InsertLeave,InsertEnter,BufEnter * call Autosave()

" Enable Vim's built in spell check and set the proper spellcheck language
set spell spelllang=en_us

" Stop concealment of characters
set conceallevel=0

"""""""""""""""""""""""""""""""""""""""""
" Custom Keybindings
""""""""""""""""""""""""""""""""""""""""""
" Set keybind for NERDTREE to Ctrl+o
nnoremap <C-o> :NERDTreeToggle<CR>
inoremap <C-o> <Esc>:NERDTreeToggle<CR>

" Tagbar toggle keybinding to F6
nnoremap <F6> :TagbarToggle<CR>
inoremap <F6> <Esc>:TagbarToggle<CR>

" Determine how to open vimrc before opening with F5
nnoremap <F5> :call CheckHowToOpenVimrc()<CR>
inoremap <F5> <Esc>:call CheckHowToOpenVimrc()<CR>

" Assign F8 to run the current Python file
autocmd FileType python nnoremap <F8> :update<CR>:!python %:p<CR>

" Assign F8 to compile the current C++ file with Clang
autocmd FileType cpp nnoremap <F8> :update<CR>:AsyncRun -mode=async -focus=0 -rows=20 -post=execute(ReportCppCompile()) clang++ -Wall % -o "%:r.exe"<CR>

" Set highlight of the finished compiling message
function! ReportCppCompile()
    echohl ModeMsg | echom expand("%:t") . " Finished Compiling. Check Terminal for Errors" | echohl None
    return 
endfunction

" Assign F9 to run the current C++ file's executable that Clang created
autocmd FileType cpp nnoremap <F9> :update<CR>:!%:p:r.exe<CR>

" Assign F8 to compile the current Java file
autocmd FileType java nnoremap <F8> :update<CR>:AsyncRun -mode=async -focus=0 javac ./%<CR>

" Assigns F9 to run the current Java file
autocmd FileType java nnoremap <F9> :update<CR>:!java %:p:r<CR>

" Assign F8 to compile the current LaTeX file
autocmd FileType tex nnoremap <F8> :update<CR>:VimtexCompile<CR>

" Assign F9 to view the current LaTeX file
autocmd FileType tex nnoremap <F9> :update<CR>:VimtexView<CR>

" Assign F12 to reload my vimrc file so I don't have to restart upon making
" changes
nnoremap <F12> :so $MYVIMRC<CR> | redraw
inoremap <F12> <Esc>:so $MYVIMRC<CR> | redraw

" Keybinding for tabbing inside of visual mode selection
vnoremap <Tab> >gv 
vnoremap <S-Tab> <gv

" Change split navigation keys
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k	
nnoremap <C-l> <C-w>l

" Change mappings of buffer commands
" Start with <leader>b for buffer
" buffer next
nnoremap <leader>bn :bn<CR>
" buffer previous
nnoremap <leader>bp :bp<CR>
" buffer delete
nnoremap <leader>bd :bd<CR>
" buffer go to
nnoremap <leader>bg :call GoToSpecifiedBuffer()<CR>
function! GoToSpecifiedBuffer()
    " show list of buffers
    execute("buffers")
    " take in user input for which buffer they would like to go to
    let l:bufferNum = input("Enter Buffer Number: ")
    " go to that buffer
    execute(":buffer " . bufferNum)
endfunction
" buffer list
nnoremap <leader>bl :buffers<CR>

" Local replace all instances of a variable using Vim
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" Auto jump back to the last spelling mistake and fix it
inoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u
nnoremap <silent> <C-s> <c-g>u<Esc>mm[s1z=`m<Esc>:delm m<CR>a<c-g>u

" UltiSnips keybind config
let g:UltiSnipsExpandTrigger = '<c-]>'
let g:UltiSnipsJumpForwardTrigger = '<c-]>'
let g:UltiSnipsJumpBackwardTrigger = '<c-[>'

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Plugin Config Options
""""""""""""""""""""""""""""""""""""""""""""""""""
" Set lightline theme and settings
let g:lightline = {
      \ 'colorscheme' : 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitGutterDiff', 'gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'gitGutterDiff': 'LightlineGitGutter',
      \ },
      \ }
"" Sees what changes have occurred in the current file
function! LightlineGitGutter()
  if !get(g:, 'gitgutter_enabled', 0) || empty(FugitiveHead())
    return ''
  endif
  let [ l:added, l:modified, l:removed ] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', l:added, l:modified, l:removed)
endfunction

" Set the patterns for rooter
let g:rooter_patterns = ['.git', '.idea', 'src']
" Set non-project directories to go to the files current directory
let g:rooter_change_directory_for_non_project_files = 'current'
" Rooter won't echo the current working directory
let g:rooter_silent_chdir = 1
" Rooter won't resolve symbolic links by default
let g:rooter_resolve_links = 1

" automatically set the AsyncRun quickfix window height
let g:asyncrun_open = 10

" Setup fugitive's Gfetch, Gpull, and Gpush commands to use AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Enable vim indent guides at startup
let g:indent_guides_enable_on_vim_startup = 1
" Set the level at which the indent guides start
let g:indent_guides_start_level = 2
" Set the width of the indent guides
let g:indent_guides_guide_size = 1

" Get rid of the banner at the top of netrw
let g:netrw_banner = 0
" Change netrw to be a tree style
let g:netrw_liststyle = 3
" Netrw opens files in previous window
let g:netrw_browse_split = 4


""""""""""""""""""""""""""""""""""""""""""""""""""
" Closetag Config
""""""""""""""""""""""""""""""""""""""""""""""""""
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml,javascript'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx,javascript'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

"""""""""""""""""""""""""""""""""""""""""""""
" VimTex and LaTeX Config
"""""""""""""""""""""""""""""""""""""""""""""
" Set the default Tex flavor
let g:tex_flavor='latex'
" Stop any sort of concealing
let g:tex_conceal = ''
" Set the viewer options for all OS's
if has('win32') || has('win64')
    let g:vimtex_view_general_viewer = 'sumatrapdf'
elseif has('macunix')
    let g:vimtex_view_general_viewer = 'skim'
else
    let g:vimtex_view_general_viewer = 'zathura'
endif

""""""""""""""""""""""""""""""""""""""""""
" COC Config
""""""""""""""""""""""""""""""""""""""""""""""
" Next and previous selection are <C-J> and <C-K> respectively
" For statusline integration with other plugins, checkout `:h coc-status`
" Most keybinds are <leader>l__. The l made sense as in 'L'SP

" COC List of Extensions
let g:coc_global_extensions = [
    \ "coc-python", 
    \ "coc-java", 
    \ "coc-clangd", 
    \ "coc-xml", 
    \ "coc-vimlsp", 
    \ "coc-highlight", 
    \ "coc-tsserver", 
    \ "coc-markdownlint", 
    \ "coc-eslint",
    \ "coc-json",
    \ "coc-vimtex",
    \ ]

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-TAB> <Plug>(coc-range-select)
xmap <silent> <C-TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OrganizeImports   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Use command Prettier for Prettier support
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>lld  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>lle  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>lla  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>llo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>lls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>lln  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>llp  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>llr  :<C-u>CocListResume<CR>

" Diagnostic keybinds
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Goto keybinds
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Documentation keybinds
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Formatting keybinds
" Remap for format selected region
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

" Codeaction keybinds
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>lap  <Plug>(coc-codeaction-selected)
nmap <leader>lap  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>lal  <Plug>(coc-codeaction)

" Quickfix Keybinds
" Fix autofix problem of current line
nmap <leader>lqf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Rename Keybinds
" This rename uses the language server to refactor rather than just grep like
" the vim rename
nmap <leader>lr  <Plug>(coc-rename)
