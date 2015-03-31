syntax on
"set mouse+=a
"set mouse+=nicr

set incsearch
set hlsearch

set backspace=indent,eol,start

let NERDTreeWinSize=45

set hlsearch
set autoindent
set nocompatible
set smartindent
set number
set cindent
set expandtab
set tabstop=4
set expandtab
retab
set shiftwidth=4
syntax on
set visualbell
set t_vb=

set showmatch
set wildmenu
set wcm=<Tab>

function! MyTabLine()
    let tabline = ''
    for i in range(tabpaGENR('$'))
        if i + 1 == tabpagenr()
            let tabline .= '%#TabLineSel#'
        else
            let tabline .= '%#TabLine#'
        endif

        let tabline .= '%' . (i + 1) . 'T'

        let tabline .= ' %{MyTabLabel(' . (i + 1) . ')} |'
    endfor

    let tabline .= '%#TabLineFill#%T'

    if tabpagenr('$') > 1
        let tabline .= '%=%#TabLine#%999XX'
    endif

    return tabline
endfunction

function! MyTabLabel(n)
    let label = ''
    let buflist = tabpagebuflist(a:n)

    let label = substitute(bufname(buflist[tabpagewinnr(a:n) - 1]), '.*/', '', '')

    if label == ''
      let label = '[No Name]'
    endif

    let label .= ' (' . a:n . ')'

    for i in range(len(buflist))
        if getbufvar(buflist[i], "&modified")
            let label = '[++] ' . label
            break
        endif
    endfor

    return label
endfunction

"set makeprg=make\ -j9
nmap <C-b> :w<CR>:make<CR><CR><CR>:cw<CR>:cc<CR>

nmap <C-e> :Explore<CR>

map <Space> <C-d>
map <BS> <C-u>

inoremap {<CR>  {<CR>}<Esc>O
function! ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "/bin/"
      silent !chmod a+x <afile>
    endif
  endif
endfunction
au BufWritePost * call ModeChange()

highlight BAD_FORMATTING ctermbg=red
highlight BAD_FORMATTING guibg=red

nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr>
nmap <C-X> :tabclose<cr>
imap <C-X> <ESC>:tabclose<cr>
nmap <C-P> :tabprevious<cr>
imap <C-P> <ESC>:tabprevious<cr>
nmap <C-N> :tabnext<cr>
imap <C-N> <ESC>:tabnext<cr>
imap <F7> <C-N><C-P>
imap <C-Space> <C-p>

"noremap <Space> <C-D>
"noremap <BS> <C-U>

"map <F5> :cn<Cr>zvzz:cc<Cr>
"map <F6> :cp<Cr>zvzz:cc<Cr>
nmap <F5>  :edit!<cr>
nmap <F6>  :echo expand('%:p')<cr>
nmap <F7>  :AV<cr>
" Switch window mappings /*{{{*/
"
nnoremap <A-Right> <C-W> <CR><CR>

"autocmd Syntax * syntax match BAD_FORMATTING /\s\+$\|\t\|.\{99\}/ containedin=ALL
autocmd Syntax * syntax match BAD_FORMATTING /(?\s\+$\|\t\|.\{99\}\|\n\n\n)/ containedin=ALL

" Switch window mappings /*{{{*/
nnoremap <A-Up> :normal <c-r>=SwitchWindow('+')<CR><CR>
nnoremap <A-Down> :normal <c-r>=SwitchWindow('-')<CR><CR>
nnoremap <A-Left> :normal <c-r>=SwitchWindow('<')<CR><CR>
nnoremap <A-Right> :normal <c-r>=SwitchWindow('>')<CR><CR>

function! SwitchWindow(dir)
  let this = winnr()
  if '+' == a:dir
    execute "normal \<c-w>k"
    elseif '-' == a:dir
    execute "normal \<c-w>j"
    elseif '>' == a:dir
    execute "normal \<c-w>l"
    elseif '<' == a:dir
    execute "normal \<c-w>h"
  else
    echo "oops. check your ~/.vimrc"
    return ""
  endif
endfunction

" /*}}}*/

" Omni
filetype plugin on
set ofu=syntaxcomplete#Complete
set tags=
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/qt4
set tags+=~/.vim/tags/c++
set tags+=~/.vim/tags/boost
set tags+=~/.vim/tags/tags
set tags+=~/.vim/tags/yandexlibs

"Omni menu colors
hi Pmenu ctermfg=0 ctermbg=7 guibg=#AAAA88
hi PmenuSel ctermfg=7 ctermbg=4 guibg=#555555 guifg=#ffffff

map <F10> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q -f ~/.vim/tags/tags -a .<CR>

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set completeopt=menuone,menu,longest,preview


function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
" inoremap <tab> <c-r>=Smart_TabComplete()<CR>
"
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

":map <Right> :tabnext<CR>
":map <Left> :tabprevious<CR>

":imap <Right> <ESC>:tabnext<CR>
":imap <Left> <ESC>:tabprevious<CR>

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite * :call DeleteTrailingWS()

autocmd FileType python compiler pylint


"cmd.vim: collection of shell commands in vim version
"Author: ypguo<guoyoooping@163.com>
"Date: 2010.4.2
"Base version: 1.0

com! -nargs=* -range=0 -complete=file Shell call Cmd_Shell(<q-args>)
com! -nargs=* -range=0 -complete=file Cmd call Cmd_Shell(<q-args>)

"Build-in functions
if (has("win32"))
    com! -nargs=0 Date call Cmd_Shell("date /t", <q-args>)
else
    com! -nargs=0 Date call Cmd_Shell("date", <q-args>)
endif
com! -nargs=0 Ls call Cmd_Shell("ls", <q-args>)
com! -nargs=* Gcc call Cmd_Shell("gcc", expand("%"), <q-args>)

"Need install by yourself
com! -nargs=* -range=0 -complete=file Sdcv call Cmd_Shell("sdcv", <q-args>)

if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()
Bundle 'gmarik/vundle'
" My Bundles here:
"
" original repos on github
Bundle 'Lokaltog/vim-easymotion'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" Bundle 'SkidanovAlex/CtrlK'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
Bundle 'file:///Users/gmarik/path/to/plugin'
" ...
Bundle 'https://github.com/Valloric/YouCompleteMe'
Bundle 'https://github.com/scrooloose/syntastic'
Bundle 'FSwitch'
Bundle 'https://github.com/tpope/vim-fugitive'
Bundle 'https://github.com/ewiplayer/vim-protodef'
Bundle 'https://github.com/MarcWeber/vim-addon-manager'
Bundle 'lh-cpp'
Bundle 'lh-vim-lib'
Bundle 'lh-brackets'
Bundle 'https://github.com/scrooloose/nerdtree.git'
Bundle 'https://github.com/vim-latex/vim-latex.git'
Bundle 'LaTeX-Box'
Bundle 'rizzatti/dash.vim'
" Bundle 'Igorjan94/codeforces.vim'

let g:ycm_global_ycm_extra_conf="~/.ycm_extra_conf.py"

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
"
"
"

let g:Imap_UsePlaceHolders = 0
