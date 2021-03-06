" Custom Vim Functions
"""""""""""""""""""""""""""""""""""""""""""""""""
" Check if the buffer is empty and determine how to open my vimrc
function! functions#CheckHowToOpenVimrc()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1
        e $MYVIMRC " If the buffer is empty open vimrc fullscreen 
    else
        vsp $MYVIMRC " Otherwise open vimrc in a vertical split
    endif
endfunction

" Autosave autocmd that makes sure the file exists before saving. Stops errors
" from being thrown
function! functions#Autosave()
    if @% == "" || filereadable(@%) == 0 || line('$') == 1 && col('$') == 1 || &readonly || mode() == "c" || pumvisible()
        " If the file has no name, is not readable, doesn't exist, is readonly, is currently in command mode, or the pum 
        " is visible don't autosave
        return
    else
        silent update " Otherwise autosave
    endif
endfunction

" Finds the directory that the .vimrc is in
" Safe for symbolic links
" Needs to be outside of function in order to work correctly
let s:vimrclocation = fnamemodify(resolve(expand('<sfile>:p')), ':h')
function! functions#GitFetchVimrc()
    " Make sure git exists on the system
    if !executable("git")
        echohl Error | redraw | echom "Git not found on system. Can't check Vimrc." | echohl None
        finish
    endif 

    " Change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation) 
    
    " Execute a git fetch to update the tree
    if has("win32") || has("win64")
        if !has('nvim')
            let l:gitFetchJob = job_start("cmd git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
        else
            let l:gitFetchJob = jobstart("git fetch")
        endif
    else
        " *nix systems 
        if !has('nvim') 
            let l:gitFetchJob = job_start("/bin/sh git fetch", {"in_io": "null", "out_io": "null", "err_io": "null"})
        else
            let l:gitFetchJob = jobstart("git fetch")
        endif
    endif 
    
    " Grab the status of the job
    if !has('nvim') | let l:gitFetchJobStatus = job_status(gitFetchJob) | endif

    " If unsuccessful let user know and stop job
    if !has('nvim') && (l:gitFetchJobStatus ==? "fail" || l:gitFetchJobStatus ==? "dead")
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJobStatus | echohl None
        call job_stop(l:gitFetchJob)
    elseif has('nvim') && (l:gitFetchJob < 1)
        echohl WarningMsg | redraw | echom "Vimrc git fetch failed with status " . l:gitFetchJob | echohl None
        call jobstop(l:gitFetchJob)
    else
        " Run CompareUpstreamAndLocalVimrcGitStatus()
        " Needs to be a timer because we are running a vimscript function
        " https://vi.stackexchange.com/questions/27003/how-to-start-an-async-function-in-vim-8
        let l:compareUpstreamAndLocalTimer = timer_start(0, 'functions#CompareUpstreamAndLocalVimrcGitStatus')
    endif
    return 
endfunction 

" Compare the local and upstream Git status
function! functions#CompareUpstreamAndLocalVimrcGitStatus(timer)
    " Change to the vimrc git directory
    silent execute("lcd " . s:vimrclocation) 

    " Set an upstream and local variable that is a hash returned by git
    let l:upstream = system("git rev-parse @{u}") " Upstream is the hash of the upstream commit
    let l:local = system("git rev-parse @") " Local is the hash of the current local commit
    
    " If the hashes match then the vimrc is updated 
    if l:local ==? l:upstream
        echohl title | redraw | echom "Vimrc is up to date" | echohl None
    elseif l:local !=? l:upstream 
        " Otherwise you need to update your vimrc
        echohl WarningMsg | redraw | echom "You need to update your Vimrc" | echohl None
    else 
        " Otherwise something went wrong
        echohl Error | redraw | echom "Unable to confirm whether you need to update your Vimrc" | echohl None
    endif
    " Go back to the original startup directory
    silent execute("lcd ~") 
    return
endfunction

function! functions#GoToSpecifiedBuffer()
    " Show list of buffers
    execute("buffers") 
    let l:bufferNum = input("Enter Buffer Number: ") " Take in user input for which buffer they would like to go to
    " Go to that buffer
    execute(":buffer " . bufferNum) 
endfunction

" If in a Git repo, sets the working directory to its root,
" or if not, to the directory of the current file.
function! functions#SetWorkingDirectory()
    " Stops fugitive from throwing error on :Gdiff
    if bufname('fugitive') != ""
        return
    endif

    " Default to the current file's directory (resolving symlinks.)
    let current_file = expand('%:p')
    if getftype(current_file) == 'link'
        let current_file = resolve(current_file)
    endif
    exe ':lcd ' . fnameescape(fnamemodify(current_file, ':h'))

    " Get the path to `.git` if we're inside a Git repo.
    " Works both when inside a worktree, or inside an internal `.git` folder.
    silent let git_dir = system('git rev-parse --git-dir')[:-2]
    " Check whether the command output starts with 'fatal'; if it does, we're not inside a Git repo.
    let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
    " If we're inside a Git repo, change the working directory to its root.
    if empty(is_not_git_dir)
        " Expand path -> Remove trailing slash -> Remove trailing `.git`.
        exe ':lcd ' . fnameescape(fnamemodify(git_dir, ':p:h:h'))
    endif
endfunction

function! functions#UpdateTagsFile()
    " Make sure Ctags exists on the system
    if !executable("ctags")
        echohl WarningMsg | redraw | echom "Could not execute ctags" | echohl None
        finish
    endif 

    " Rename old tags file and set vim to use that
    " While new tags file is being generated
    let s:currentTagsFile=expand("%:p:h") . "/tags"
    call rename(s:currentTagsFile, "old-tags")
    set tags=./old-tags,old-tags
    
    " Create new tags file. Uses ~/.config/ctags/.ctags config file
    if has('win64') || has('win32')
        if !has('nvim')
            let l:createNewTagsJob = job_start("cmd ctags -R")
        else 
            let l:createNewTagsJob = jobstart("ctags -R")
        endif
    else
        " *nix distributions
        if !has('nvim')
            let l:createNewTagsJob = job_start("/bin/sh ctags -R")
        else 
            let l:createNewTagsJob = jobstart("ctags -R")
        endif
    endif

    " Get job status if not using Nvim
    if !has('nvim') | let l:newTagsJobStatus = job_status(l:createNewTagsJob) | endif 

    if !has('nvim') && (l:newTagsJobStatus ==? "fail" || l:newTagsJobStatus ==? "dead")
        echohl WarningMsg | redraw | echom "Tags file failed to be created with status " . l:newTagsJobStatus| echohl None
        call job_stop(l:createNewTagsJob)
    elseif has('nvim') && (l:createNewTagsJob < 1)
        echohl WarningMsg | redraw | echom "Tags file failed to be created with status " . l:createNewTagsJob | echohl None
        call jobstop(l:createNewTagsJob)
    else 
        " If job does not report fail status
        echohl title | redraw | echom "Tags file was updated successfully" | echohl None
    endif 
        
    " Delete old tags file and reset tags
    set tags=./tags,tags
    call delete("./old-tags")
endfunction

" Toggle Netrw window open and close with the same key
function! functions#ToggleNetrw()
    let b:windowpos = winsaveview() " Save current position to go back to
    
    if &filetype != "netrw"
        silent Explore
    else
        silent Rexplore " Return to previous file
        call winrestview(b:windowpos) " Reset view
    endif
endfunction

