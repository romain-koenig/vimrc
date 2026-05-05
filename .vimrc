" ============================================================
" .vimrc — Romain
" ============================================================

set nocompatible
filetype plugin indent on

source $VIMRUNTIME/mswin.vim
behave mswin

" ---- vim-plug (auto-install) --------------------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
" Ajoute tes plugins ici
" Plug 'arcticicestudio/nord-vim'
call plug#end()


" ============================================================
" APPARENCE
" ============================================================

colorscheme desert
" colorscheme nord

syntax on

set number          " numéros de ligne
set ruler           " position curseur
set showcmd         " commandes incomplètes en bas
set laststatus=2    " barre de statut toujours visible
set cursorline      " surligne la ligne courante
set scrolloff=3     " garde 3 lignes visibles autour du curseur

set guifont=Consolas:h11
au GUIEnter * winsize 120 50


" ============================================================
" COMPORTEMENT GÉNÉRAL
" ============================================================

set hidden          " buffers cachés plutôt que fermés
set backspace=indent,eol,start
set history=100
set autoread        " relit les fichiers modifiés en dehors de Vim
set wildmenu        " complétion améliorée de la ligne de commande
set browsedir=buffer

" Encodages (ordre de priorité)
set fileencodings=utf-8,latin1,ucs-bom

" Retour à la ligne "souple" (pas de coupure dure)
set lbr
" set nowrap


" ============================================================
" RECHERCHE
" ============================================================

set incsearch
set ignorecase
set smartcase
set hlsearch

" Effacer le surlignage de recherche avec Échap
nnoremap <Esc> :nohlsearch<CR>


" ============================================================
" INDENTATION & FORMATAGE
" ============================================================

set expandtab       " tabulations → espaces
set tabstop=4
set shiftwidth=4
set softtabstop=4


" ============================================================
" FICHIERS TEMPORAIRES
" ============================================================

set backup
set writebackup
set swapfile

let s:tmpdir = $HOME . '/vim-temporary-files'
execute 'set backupdir=' . s:tmpdir
execute 'set directory=' . s:tmpdir


" ============================================================
" DÉTECTION DE TYPES DE FICHIERS
" ============================================================

augroup filetypes
  autocmd!
  au BufRead,BufNewFile *.todo               setfiletype todo
  au BufRead,BufNewFile *.pl                 setfiletype sql
  au BufRead,BufNewFile catalina.out,*.out,*.out.*,*.log,*.log.* setfiletype log
augroup END

" Détection todo sur la première ligne
if getline(1) =~? '^#\?TODO\>'
  setfiletype todo
endif


" ============================================================
" AUTOCOMPLÉTION (fallback syntaxique)
" ============================================================

if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
    \ if &omnifunc == "" |
    \   setlocal omnifunc=syntaxcomplete#Complete |
    \ endif
endif


" ============================================================
" RACCOURCIS CLAVIER
" ============================================================

" Ouvrir ce vimrc rapidement
nnoremap <F9> :e $MYVIMRC<CR>

" Suppression des espaces en fin de ligne
noremap <F4> :%s/\s\+$//<CR>:nohlsearch<CR>

" Navigation par onglets (style Firefox)
nnoremap <C-Tab>   gt
nnoremap <C-S-Tab> gT
nnoremap <C-t>     :tabnew<CR>

" Mode sans distractions (gVim)
map <F11> :set guioptions-=m<CR>:set guioptions-=T<CR>
map <F12> :set guioptions+=m<CR>:set guioptions+=T<CR>


" ============================================================
" FONCTIONS DE MISE EN FORME
" ============================================================

" F8 — Encadrement ASCII (+----+)
map <F8> :call Cadre()<CR>
function! Cadre()
  :s/^.*$/| & |/
  normal yyP
  normal yyP
  :s/./-/g
  :s/^./+/g
  :s/.$/+/g
  normal jj
  :s/./-/g
  :s/^./+/g
  :s/.$/+/g
endfunction

" F7 — Séparateur de 80 tirets
map <F7> :call Line80()<CR>
function! Line80()
  normal o
  normal 80i-
  normal o
  normal j
endfunction

" F6 — Souligner la ligne courante avec des tirets
map <F6> :call Line()<CR>
function! Line()
  normal yyp
  s/./-/g
endfunction

" F2 — Conversion date AAAAMMJJ → JJ/MM/AAAA
map <F2> :call OrdreDate()<CR>
function! OrdreDate()
  :%s/^\([0-9]\{4}\)\([0-9]\{2}\)\([0-9]\{2}\)$/\3\/\2\/\1/e
  :%s/^0$//ge
  :nohlsearch
endfunction


" ============================================================
" SQL
" ============================================================

augroup sql_settings
  autocmd!
  autocmd BufRead,BufNewFile *.sql
    \ setlocal shiftwidth=4 textwidth=67 |
    \ noremap <buffer> <F5>  :call IndentSQL()<CR> |
    \ noremap <buffer> <F10> :call SQLSelectToUpdate()<CR>
augroup END

function! IndentSQL()
  :s/\s\+/ /g
  :normal ^^gU$
  :normal ^^v$gq
endfunction

" ============================================================
" Mémoriser la position du curseur à la réouverture
" ============================================================

autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif
" ============================================================
" Afficher les espaces invisibles (trailing, tabs)
" ============================================================
set list
set listchars=tab:→\ ,trail:·,nbsp:␣

" ============================================================
" TIPS
" ============================================================
"
"  Supprimer les lignes NE contenant PAS "FOO" :
"    :v/FOO/d
"
"  Trier les lignes sélectionnées :
"    :'<,'>sort
"