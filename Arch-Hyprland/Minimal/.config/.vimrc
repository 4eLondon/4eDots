" ============================================
"                Vim Config
" ============================================

" --- Essentials --------------------------------
set nocompatible
set encoding=utf-8
set backspace=indent,eol,start
set hidden
set autoread
set clipboard=unnamedplus
set mouse=a
set ttyfast
set lazyredraw

" --- Appearance --------------------------------
set notermguicolors
syntax enable
set number
set laststatus=2
set showcmd
set showmode
set ruler
set wildmenu
set wildmode=longest:full,full
set scrolloff=5
set sidescrolloff=5
set wrap
set linebreak
set breakindent

" --- Indentation -------------------------------
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set smarttab

" --- Search ------------------------------------
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan

" --- Bells -------------------------------------
set noerrorbells
set novisualbell
set t_vb=

" --- Backup/Swap -------------------------------
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vim/undo

" --- Split behavior ----------------------------
set splitbelow
set splitright

" --- Folding -----------------------------------
set foldmethod=indent
set foldlevel=99
set foldnestmax=3

" --- Netrw File Explorer -------------
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_winsize=25

" --- Key Mappings ------------------------------
let mapleader = "/"

" Quick save/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>Q :qa!<CR>

" Clear search highlight
nnoremap <silent> <leader>h :nohlsearch<CR>

" Quick buffer switching
nnoremap <leader>b :buffers<CR>:buffer<Space>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>d :bdelete<CR>

" Window management
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>e <C-w>=
nnoremap <leader>c <C-w>c
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize windows
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" File explorer
nnoremap <leader>f :Explore<CR>
nnoremap <leader>t :Vexplore<CR>

" Quick config edit
nnoremap <leader>rc :e $MYVIMRC<CR>
nnoremap <leader>so :source $MYVIMRC<CR>

" Move lines in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Indent in visual mode stays in visual mode
vnoremap > >gv
vnoremap < <gv

" Quick substitute
nnoremap <leader>r :%s///g<Left><Left>
vnoremap <leader>r :s///g<Left><Left>

" Clipboard shortcutsd
nnoremap <C-c> "+yy
vnoremap <C-c> "+y
inoremap <C-c> <Esc>"+yygi
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+
nnoremap <C-a> gg0vG$
inoremap <C-a> <Esc>gg0vG$

" Toggle settings
nnoremap <leader>sp :set spell!<CR>
nnoremap <leader>wr :set wrap!<CR>
nnoremap <leader>nu :set number! relativenumber!<CR>
nnoremap <leader>cc :set cursorcolumn!<CR>

" --- Auto-close Brackets & Quotes ----------------
function! SmartPair(open, close)
    let line = getline('.')
    let col = col('.')
    if col >= len(line) || line[col-1] =~ '\s\|)\|]\|}\|>\|,\|;\|:'
        return a:open . a:close . "\<Left>"
    else
        return a:open
    endif
endfunction

" Auto-close brackets (smart)
inoremap <expr> ( SmartPair('(', ')')
inoremap <expr> [ SmartPair('[', ']')
inoremap <expr> { SmartPair('{', '}')
inoremap <expr> < SmartPair('<', '>')

" Auto-close quotes
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left>

" Skip closing char if already there
function! SkipClosingChar(char)
    let line = getline('.')
    let col = col('.')
    if col <= len(line) && line[col-1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

inoremap <expr> ) SkipClosingChar(')')
inoremap <expr> ] SkipClosingChar(']')
inoremap <expr> } SkipClosingChar('}')
inoremap <expr> > SkipClosingChar('>')
inoremap <expr> " SkipClosingChar('"')
inoremap <expr> ' SkipClosingChar("'")
inoremap <expr> ` SkipClosingChar('`')

" Smart backspace: delete pair if between empty brackets
function! SmartBackspace()
    let line = getline('.')
    let col = col('.')
    if col > 1 && col <= len(line)
        let pairs = ['()', '[]', '{}', '<>', '""', "''", '``']
        let before_after = line[col-2:col-1]
        if index(pairs, before_after) >= 0
            return "\<Del>\<BS>"
        endif
    endif
    return "\<BS>"
endfunction

inoremap <expr> <BS> SmartBackspace()

" Smart enter: add newline between empty brackets
function! SmartEnter()
    let line = getline('.')
    let col = col('.')
    if col > 1 && col <= len(line)
        let before_after = line[col-2:col-1]
        if before_after == '()' || before_after == '[]' || before_after == '{}' || before_after == '<>'
            return "\<CR>\<Esc>O"
        endif
    endif
    return "\<CR>"
endfunction

inoremap <expr> <CR> SmartEnter()

" --- Status Line (Builtin) ---------------------
set statusline=
set statusline+=\ %<%F
set statusline+=\ %m%r%h%w
set statusline+=\ %{&filetype}
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %=
set statusline+=\ %02l:%02v
set statusline+=\ /%L
set statusline+=\ (%3p%%)
