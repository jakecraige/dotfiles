" Setup {{{
  set nocompatible
  filetype off
  call plug#begin('~/.vim/plugged')

  if filereadable(expand("~/.vimrc.bundles"))
    source ~/.vimrc.bundles
  endif

  call plug#end()

  filetype on
  filetype plugin indent on
" }}}
" Language Specific {{{
    " Javascript {{{
        augroup ft_javascript
          au!
          au Filetype javascript setlocal foldmethod=syntax
        augroup END
        augroup ft_json
          au!
          au Filetype json setlocal foldmethod=syntax
        augroup END
    " }}}
    " Ruby {{{
        augroup ft_ruby
          au!
          au Filetype ruby setlocal foldmethod=syntax
        augroup END
    " }}}
    " Vim {{{
      augroup ft_vim
          au!

          au FileType vim setlocal foldmethod=marker
          au FileType help setlocal textwidth=78
          au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
      augroup END
    " }}}
    " Ruby {{{
        augroup ft_objcpp
          au!
          au Filetype ruby setlocal foldmethod=syntax
        augroup END
    " }}}
" }}}
" General make life easy settings {{{
      let mapleader = ","
      " TODO: this may need linux vs wsl2 rules 
      " set clipboard=unnamedplus      " Makes tmux c/p work
      set noesckeys
      set mouse=""
      set mousehide
      set nocompatible
      set autoindent
      set modelines=0
      set scrolljump=5
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmode=list:longest
      set visualbell
      set ttyfast               " fast scrolling...
      set list
      set relativenumber
      set number " show current line number at the left of current line
      set foldenable             " enable code folding
      set virtualedit=onemore    " Allow cursor beyondlast character
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
      set colorcolumn=+1
      set linebreak
      set title
      set shiftround
      set splitbelow
      set splitright
      set undofile
      set undoreload=10000
      set history=1000
      set laststatus=2
      set matchtime=3
      set exrc "local vimrc

      command! Q q " Bind :Q to :q
      command! Qall qall

    " Disable Ex mode
      map Q <nop>

" }}}
" Make Life Easy Bindings {{{
    " S in normal mode to split line, sister to J
    nnoremap S i<cr><esc><right>
    "For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null
    "0 now goes to first char in line instead of blank"
    nnoremap 0 0^
    " duplicate selected content {{{
    map <Leader>d y'>p
" }}}
" Folding {{{
    set foldlevelstart=20
    autocmd Syntax * normal zR

    " Space to toggle folds.
    nnoremap <Space> za
    vnoremap <Space> za

    " Make zO recursively open whatever top level fold we're in, no matter where the
    " cursor happens to be.
    nnoremap zO zCzO

    function! MyFoldText() "
        let line = getline(v:foldstart)

        let nucolwidth = &fdc + &number * &numberwidth
        let windowwidth = winwidth(0) - nucolwidth - 3
        let foldedlinecount = v:foldend - v:foldstart

        " expand tabs into spaces
        let onetab = strpart('          ', 0, &tabstop)
        let line = substitute(line, '\t', onetab, 'g')

        let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
        let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
        return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
    endfunction "
    set foldtext=MyFoldText()

" }}}
" Colorscheme, Gui, Font {{{
    set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
    set t_Co=256

    " Font , Text, Tabs {{{
        " Auto format comment blocks
        set comments=sl:/*,mb:*,elx:*/

        "Set tabs to 2 spaces instead of the default 4
          set tabstop=2
          set shiftwidth=2
          set softtabstop=2
          set expandtab
        "Text wrapping
          set nowrap
          set textwidth=80
          set formatoptions=qrn1
          set colorcolumn=+1
    " }}}
" }}}
" File Editing {{{
  " Edit another file in the same directory as the current file
  " uses expression to extract path from current file's path
    map <Leader>e :e <C-R>=expand("%:p:h") . '/'<CR>
    map <leader><tab> :Scratch<CR>

  " RENAME CURRENT FILE (thanks Gary Bernhardt)
  function! RenameFile()
      let old_name = expand('%')
      let new_name = input('New file name: ', expand('%'), 'file')
      if new_name != '' && new_name != old_name
          exec ':saveas ' . new_name
          exec ':silent !rm ' . old_name
          redraw!
      endif
  endfunction
  map <Leader>n :call RenameFile()<cr>

  " Make sure Vim returns to the same line when you reopen a file.
  " Thanks, Amit
  augroup line_return
      au!
      au BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \     execute 'normal! g`"zvzz' |
          \ endif
  augroup END
" }}}
" Navigation {{{
  "Visual shifting (does not exit Visual mode on tab)
    vnoremap < <gv
    vnoremap > >gv

  "Movement - better Navigation
    nnoremap j gj
    nnoremap k gk
    nnoremap k gk

  "Split Window Navigation mapping
    nnoremap <leader>w <C-w>v<C-w>l
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    "Split window size mapping
    nnoremap <S-Up> :resize +5<CR>
    nnoremap <S-Down> :resize -5<CR>
    nnoremap <S-Right> :vertical resize -5<CR>
    nnoremap <S-Left> :vertical resize +5<CR>

    " This if is to make these bindings work inside tmux
    if &term =~ '^screen'
        " tmux will send xterm-style keys when its xterm-keys option is on
        execute "set <xUp>=\e[1;*A"
        execute "set <xDown>=\e[1;*B"
        execute "set <xRight>=\e[1;*C"
        execute "set <xLeft>=\e[1;*D"
    endif
" }}}
" Searching {{{
      set ignorecase
      set smartcase
      set gdefault " assume the /g flag on :s substitutions to replace all matches in a line
      set hlsearch
      set wildignore+=*/.hg/*,*/.svn/*,*/Assets/*

      "Undo highlignted searches
      nnoremap <leader><space> :noh<cr>

      " Keep search matches in the middle of the window.
      nnoremap n nzzzv
      nnoremap N Nzzzv

      " Same when jumping around
      nnoremap g; g;zz
      nnoremap g, g,zz
      nnoremap <c-o> <c-o>zz

      " Don't move on *
      nnoremap * *<c-o>

      " Grep with ag and hit K on a word to search
      nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
      set grepprg=ag\ --nogroup\ --nocolor
" }}}
" duplicate selected content {{{
  map <Leader>d y'>p
" }}}
" Backups {{{
  set backup                        " enable backups
  set noswapfile                    " it's 2013, Vim. (LOL at this comment in 2021)

  set undodir=~/.vim/tmp/undo//     " undo files
  set backupdir=~/.vim/tmp/backup// " backups
  set directory=~/.vim/tmp/swap//   " swap files

  " Make those folders automatically if they don't already exist.
  if !isdirectory(expand(&undodir))
      call mkdir(expand(&undodir), "p")
  endif
  if !isdirectory(expand(&backupdir))
      call mkdir(expand(&backupdir), "p")
  endif
  if !isdirectory(expand(&directory))
      call mkdir(expand(&directory), "p")
  endif

" }}}
" Plugins {{{
    " Fzf {{{
      let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'relative': v:true, 'yoffset': 1 } }
      " Map Ctrl + p to open fuzzy find (FZF)
      nnoremap <C-p> :FZF<cr>
    " }}}
    " NERDTree {{{
        map <C-e> :NERDTreeToggle<CR>
        let NERDTreeHighlightCursorline = 1
        let NERDTreeIgnore = ['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index',
                            \ 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json',
                            \ '.*\.o$', 'db.db', 'tags.bak', '.*\.pdf$', '.*\.mid$',
                            \ '.*\.midi$']

        let NERDTreeMinimalUI = 1
        let NERDTreeDirArrows = 1
        let NERDChristmasTree = 1
        let NERDTreeChDirMode = 2
        let NERDTreeMapJumpFirstChild = 'gK'
        " Add space when commenting
        let g:NERDSpaceDelims = 1
    " }}}
    " Ag {{{
      let g:ag_prg="ag --column --smart-case --ignore tmp --ignore node_modules --ignore cordova --ignore dist --ignore vendor --ignore bower_components --ignore log --ignore coverage"
    " }}}
    " vim-rspec {{{
      autocmd Filetype ruby map <Leader>t :call RunCurrentSpecFile()<CR>
      autocmd Filetype ruby map <Leader>s :call RunNearestSpec()<CR>
      autocmd Filetype ruby map <Leader>l :call RunLastSpec()<CR>
      autocmd Filetype ruby map <Leader>a :call RunAllSpecs()<CR>
      let g:rspec_command = "Dispatch bundle exec rspec {spec}"
    " }}}
    " Airline {{{
      let g:airline_theme="base16"
      let g:airline_left_sep=""
      let g:airline_right_sep=""
      let g:airline_section_b = ""
      let g:airline_section_x = ""
      let g:airline_section_z = "%l:%v"
      let g:airline_section_y = ""
    " }}}
" }}}
" Uncategorized {{{

  " Panic Button, haha..
  nnoremap <f9> mzggg?G`z

  " Trim whitespace on save
  function! StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
  endfunction

  autocmd BufWritePre *.py,*.js,*.rb,Gemfile,*.haml,*.erb,*.swift :call StripTrailingWhitespaces()
" }}}

" Spelling Mistakes {{{
  iab teh the
  iab rials rails
  iab reuqire require
  iab availbility availability
  iab resposne response
  iab reponse response
  iab functino function
  iab retreive retrieve
  iab reutrn return
  iab guaranto guarantor
  iab encryped encrypted
  iab relatinoship relationship
  iab relatnoship relationship
  iab desposit deposit
  iab desposits deposits
  iab Blurbird Bluebird
" }}}

colorscheme seoul256
set background=dark
" colorscheme bubblegum-256-light
" set background=light

function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

" turn <h5 class="helper">There are no posts on the wall.</h5>
" into:
"  <h5 class="helper">
"    There are no posts on the wall.
"  </h5>
nnoremap <leader>f cit<cr><esc>O<esc>pj=2k

let maplocalleader = "\\"

" This temporarily highlights the selection when you press next, since it uses
" sleep you want to keep the time pretty low
nnoremap <silent> n n:call HLNext(0.15)<cr>
nnoremap <silent> N n:call HLNext(0.15)<cr>
function! HLNext (blinktime)
  set invcursorline
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  set invcursorline
  redraw
endfunction

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.mm set filetype=objcpp

autocmd FileType markdown setlocal textwidth=80

nmap <Leader>D :Dispatch

set tags=.git/tags,./tags

let g:runfile_by_name    = {
  \   'Gemfile$': '!bundle',
  \   'Spec\.hs$': '!echo :main | cabal exec -- ghci -Wall %',
  \   '.*_spec\.rb': '!bundle exec rspec %',
  \   '.*\.cabal': '!cabal install --dependencies-only --enable-tests',
  \   '\.md$': '!opandoc %',
  \   '\.tex$': '!pdflatex %'
  \ }
let g:runfile_by_type    = {
  \ 'haskell': '!cabal exec -- ghci -Wall %',
  \ 'lhaskell': '!cabal exec -- ghci -Wall %'
  \ }

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END

    set clipboard=unnamed
endif

" Wayland (Linux KDE) Copy Support
let s:wlCopy = '/usr/bin/wl-copy'
if executable(s:wlCopy)
    augroup WLCopy
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:wlCopy, @0) | endif
    augroup END

    set clipboard=unnamed
endif
