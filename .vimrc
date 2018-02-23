
filetype plugin on
filetype plugin indent on

syntax enable

set nocompatible
set ruler
set number
set wildmenu
set autoread
set ignorecase
set nowrap
set smartcase
set hlsearch
set incsearch
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set hidden
set nobackup
set noswapfile
set expandtab
set tabpagemax=100
set guioptions-=T
set cursorline
"set smarttab
"set autoindent

colorscheme asmanian_blood
set guifont=Monospace\ Bold\ 10

runtime macros/matchit.vim  " Enable xml '%' tag matching

"function XmlSettings()
  "syn spell toplevel
  "set spell
  ""set textwidth=80
  "set wrapmargin=2
  "set colorcolumn=80
  "set fo=aw2qtc
"endfunction

function RubySettings()
  set tabstop=2
  set shiftwidth=2
  set softtabstop=2
endfunction

function CSettings()
  set tabstop=4
  set shiftwidth=4
  set softtabstop=4
endfunction

"autocmd FileType xml call XmlSettings()
autocmd FileType c,cpp,python call CSettings()
autocmd FileType ruby call RubySettings()
autocmd BufNewFile,BufRead *.proto set filetype=proto

if has("cscope")
  "set csprg=/usr/local/bin/cscope
  set csto=0
  set cst
  set nocsverb

  if filereadable("cscope.out")
      cs add cscope.out
  endif

  set csverb
endif

map <C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
map f<C-]> :cs find f <C-R>=expand("<cword>")<CR><CR>
map g<C-]> :silent! !cscope -Rb -s .<CR>
nnoremap <silent> gc :redir @a<CR>:g//<CR>:redir END<CR>:new<CR>:put! a<CR>
nnoremap <CR> :noh<CR><CR>

map <leader>gb :Gblame<CR>
map <leader>gl :Glog<CR>
map <leader>gs :Gstatus<CR>
map <leader>gd :Gdiff<CR>

map <leader>rt :TagbarToggle<CR>

map <silent> <leader>ev :e ~/.vimrc<CR>

command! -nargs=* Find call FindFunc(<f-args>)
function! FindFunc(...)
    if a:0 == 0
        let a:file = expand("<cword>")
    else
        let a:file = a:1
    endif
    execute ":silent! new | only | r! find -name " . a:file . " 2>/dev/null"
endfunction

command! -nargs=* Etag call EtagFunc(<f-args>)
function! EtagFunc(...)
    if a:0 == 0
        let a:regexToFind = expand("<cword>")
    else
        let a:regexToFind = a:1
    endif
    execute "cscope find e " . a:regexToFind
endfunction

set grepprg=grep\ --exclude=tags\ -rsIn\ $*\ /dev/null
let g:ackprg="ack -H --ignore-dir=validation --nocolor --nogroup --column --type=cc --type-add cc=.fml,.mf,.proto $*"
map gV :silent! !dot -Txlib % & <CR>
cabbr %% <C-R>=expand('%:p:h')<CR>

" Strip the newline from the end of a string
function! Chomp(str)
  return substitute(a:str, '\n$', '', '')
endfunction

" Find a file and pass it to cmd
function! DmenuOpen(cmd)
  let fname = Chomp(system("git ls-files | dmenu -i -l 20 -p " . a:cmd))
  if empty(fname)
    return
  endif
  execute a:cmd . " " . fname
endfunction

map t<c-p> :call DmenuOpen("tabe")<cr>
map <c-p> :call DmenuOpen("e")<cr>

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>o :ZoomToggle<CR>

"let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard']
"let g:ctrlp_max_files = 0
