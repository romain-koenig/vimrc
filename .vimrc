
set diffexpr=MyDiff()
function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
                if &sh =~ '\<cmd'
                        let cmd = '""' . $VIMRUNTIME . '\diff"'
                        let eq = '"'
                else
                        let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
                endif
        else
                let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
set nocompatible
" source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" COLORSCHEME

colorscheme desert
"colorscheme nord



" Gestion de mises en forme rapide

" F8 = Cadre
" F7 = Ligne longue (80)
" F6 = ligne précise

map <F8> :call Cadre()<CR>
function! Cadre()
        :s/^.*$/| & |
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


map <F7> :call Line80()<CR>
function! Line80()
        normal o
        normal 80i-
        normal o
        normal j
endfunction

map <F6> :call Line()<CR>
function! Line()
        normal yyp
        s/./-/g
endfunction


" Quand un fichier est changé en dehors de Vim, il est relu automatiquement
" set autoread



" allow backspacing over everything in insert mode
set backspace=indent,eol,start

:set dir=$HOME\vim

if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
                                \    if &omnifunc == "" |
                                \        setlocal omnifunc=syntaxcomplete#Complete |
                                \    endif
endif

"set ic
set ignorecase smartcase

set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch        " do incremental searching




augroup filetypedetect
        au BufRead,BufNewFile *.todo setfiletype todo
augroup END

augroup filetypedetect
        "au BufRead,BufNewFile *.pl setfiletype plsql
        au BufRead,BufNewFile *.pl setfiletype sql
augroup END

augroup filetypedetect
        " log files such as catalina.out or log4j files.
        au! BufRead,BufNewFile catalina.out,*.out,*.out.*,*.log,*.log.* setf log
augroup END


" http://nvie.com/posts/how-i-boosted-my-vim/

" One particularly useful setting is hidden.
" Its name isn’t too descriptive, though.
" It hides buffers instead of closing them.
" This means that you can have unwritten changes to a file and open a new file using :e,
" without being forced to write or undo your changes first.
" Also, undo buffers and marks are preserved while the buffer is open.
" This is an absolute must-have.

set hidden

set number        " always show line numbers


if getline(1) =~? '^#\?TODO\>'
        setfiletype todo
endif

" Ouverture vimrc
:nnoremap <F9> :e C:\Program Files\Vim\_vimrc<CR>

" Ouverture TODO.TODO
":nnoremap <F9> :e C:\Users\Koenig\Desktop\TODO.TODO<CR>

" Suppression des espaces superflus en fin de ligne
:noremap <F4> :%s/\s\+$//<CR>:nohlsearch<CR>

" Modification de dates : format AAAAMMJJ vers JJ/MM/AAAA
" :noremap <F2> :%s/^\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)$/\3\/\2\/\1<CR>:nohlsearch<CR>

map <F2> :call OrdreDate()<CR>
function! OrdreDate()
        :%s/^\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)$/\3\/\2\/\1
        :%s/^0$//g
        :nohlsearch
endfunction

"set nowrap
set lbr

"make open directory use current directory
set browsedir=buffer

" Activation de la syntaxe
if has("syntax")
        syntax on
endif

filetype plugin on




" Clears search highlighting by just hitting a return.
" The <BS> clears the command line.
" (From Zdenek Sekera [zs@sgi.com]  on the vim list.)
" I added the final <cr> to restore the standard behaviour of
" <cr> to go to the next line
:nnoremap <CR> :nohlsearch<CR>/<BS><CR>


" Gestion des onglets identique à Firefox
" Navigation avec Ctrl-Tab
" Next
:nnoremap <C-Tab> gt
" Previous
:nnoremap <C-S-Tab> gT
" New
:nnoremap <C-t> :tabnew<CR>
" Fermeture (annulé car entre en conflit avec la bascule multi-fenetres)
" :nnoremap <C-w> :q<CR>

" Mode sans perturbations
map <F11> :set guioptions-=m<CR>:set guioptions-=T<CR>
" Retour au mode normal
map <F12> :set guioptions+=m<CR>:set guioptions+=T<CR>


" Mise en évidence des espaces en fin de ligne
"set list
"set lcs:tab:>-,trail:X

"File Encoding (dans l'ordre)
set fileencodings=utf-8,latin1,ucs-bom
"set fileencodings=utf-8



" Police par défaut
set guifont=consolas

"au GUIEnter * simalt ~n %1

"Démarrage plein écran
"au GUIEnter * simalt ~n %

"Démarrage fenêtré
"au GUIEnter * winsize 80 50
au GUIEnter * winsize 120 50

"Gestion de l'ouverture de fichier par rapport à l'extension
let ext = expand("%:e")

if ext == 'sql'
        " au GUIEnter * winsize 68 50
        set shiftwidth=4
        set textwidth=67
        " Alignement permettant d'avoir les bonnes ruptures pour copier coller les
        " requetes dans IKOS
        :noremap <F5> :call IndentSQL()<CR>
        :noremap <F10> :call SQLSelectToUpdate()<CR>

endif

function! IndentSQL()
"        :s/(\s*/(/g
"        :s/\s*)/)/g
        :s/\s\+/ /g
        :normal ^^gU$<CR>
" PLUGIN ChangeSqlCase http://www.vim.org/scripts/script.php?script_id=869
"        :normal ^^v$
"        :call ChangeSqlCase()
        :normal ^^v$gq<CR>

endfunction



" Tabulations en espaces
set expandtab

" cwbundbs

"set backup
set history=100

" Gestion du backup
set backup
"set nobackup
set writebackup
"set nowritebackup
set swapfile
"set noswapfile

set backupdir=/home/romain/vim-temporary-files/
set directory=/home/romain/vim-temporary-files/
set dir=/home/romain/vim-temporary-files/





" ----- TIPS ----- "
"
"  Delete lines NOT containing "FOO"
"  :v/FOO/d
"




