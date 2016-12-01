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

  call dirsettings#Install()

" }}}
" Language Specific {{{
    " keep you honest and without tabs
    " autocmd BufWritePre * :retab
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
      set clipboard=unnamed      " Makes tmux c/p work
      set noesckeys
      set mouse=a
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

      "Adjust viewports to the same size
        map <Leader>= <C-w>=

      "Rehighlight pasted text
        nnoremap <leader>v V`]

      "0 now goes to first char in line instead of blank"
        nnoremap 0 0^

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

    "Status line with fugitive git integration
    set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

    if has('gui_running')
      " removes scrollbar and toolbar"
      set guioptions+=lrb
      set guioptions-=lrb           " Remove the toolbar
      set guioptions-=T
      set lines=40                " 40 lines of text instead of 24
    else
      set t_Co=256
    endif

    " Font , Text, Tabs {{{

        " Auto format comment blocks
        set comments=sl:/*,mb:*,elx:*/

        "Set tabs to 2 spaces instead of the default 4
          set tabstop=2
          set shiftwidth=2
          set softtabstop=2
          set expandtab
        "Text wrapping
          set wrap
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

    if has('nvim')
      tnoremap <C-h> <C-\><C-n><C-w>h
      tnoremap <C-j> <C-\><C-n><C-w>j
      tnoremap <C-k> <C-\><C-n><C-w>k
      tnoremap <C-l> <C-\><C-n><C-w>l
      tnoremap <Esc> <C-\><C-n>
    endif

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

      "Fix broken searching by enabling regular regex I think?
      nnoremap / /\v
      vnoremap / /\v
      set ignorecase
      set smartcase
      set gdefault " assume the /g flag on :s substitutions to replace all matches in a line
      set hlsearch

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

      " Visual Mode */# from Scrooloose
      " Lets you use * in visual mode

      function! s:VSetSearch()
        let temp = @@
        norm! gvy
        let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
        let @@ = temp
      endfunction

      vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
      vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o>

" }}}
" Git Setup {{{

    map <Leader>gac :Gcommit -m -a ""<LEFT>
    map <Leader>gc :Gcommit -m ""<LEFT>
    map <Leader>gs :Gstatus<CR>
    map <Leader>gw :!git add . && git commit -m 'WIP' && git push<cr>

" }}}
" duplicate selected content {{{

  map <Leader>d y'>p

" }}}
" Backups {{{

  set backup                        " enable backups
  set noswapfile                    " it's 2013, Vim.

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
    " CtrlP {{{
      set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/Assets/*
      nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
      set grepprg=ag\ --nogroup\ --nocolor

      let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn))|(Assets|node_modules|dist|tmp|platforms|bower_components|cassettes|coverage)$'
      let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
      let g:ctrlp_use_caching = 0
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
    " }}}
    " Sparkup {{{
      let g:sparkupExecuteMapping = '<leader>h'
    " }}}
    " Ag {{{
      let g:ag_prg="ag --column --smart-case --ignore tmp --ignore node_modules --ignore cordova --ignore dist --ignore vendor --ignore bower_components --ignore log --ignore coverage"
    " }}}
    " TagBar {{{
        let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
    " }}}
    " Neomake {{{
        " https://github.com/eslint/eslint/issues/1238#issuecomment-139471958
        let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint'
        if matchstr(local_eslint, "^\/\\w") == ''
          let local_eslint = getcwd() . "/" . local_eslint
        endif
        if executable(local_eslint)
          let g:neomake_javascript_eslint_exe = local_eslint
        endif
        let g:neomake_javascript_enabled_makers = ['eslint']
        autocmd! BufReadPost * Neomake
        autocmd! BufWritePost * Neomake
    " }}}
    " Mustache/Handlebars {{{
      let g:mustache_abbreviations = 1
    " }}}
    " vim-rspec {{{
      map <Leader>t :call RunCurrentSpecFile()<CR>
      map <Leader>s :call RunNearestSpec()<CR>
      map <Leader>l :call RunLastSpec()<CR>
      map <Leader>a :call RunAllSpecs()<CR>
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
    " Xcodebuild {{{
      let g:xcode_runner_command = 'Dispatch {cmd}'
    " }}}
    " Deoplete {{{
      let g:deoplete#enable_at_startup = 1
    " }}}
    " NeoSnippet {{{
      imap <C-k> <Plug>(neosnippet_expand_or_jump)
      smap <C-k> <Plug>(neosnippet_expand_or_jump)
      xmap <C-k> <Plug>(neosnippet_expand_target)
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
  iab reponse response
  iab guaranto guarantor
  iab encryped encrypted
" }}}

colorscheme seoul256
set background=dark

vmap <Leader>e :call EvalClojure()<CR>
function! EvalClojure()
  let selection = s:get_visual_selection()
  call VimuxRunCommand(selection)
endfunction

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

nmap cpl cp<S-V><CR>
nmap cpf ggcpG<C-o><C-o>

au FileType clojure let b:loaded_delimitMate = 0

nnoremap <silent> n n:call HLNext(0.15)<cr>
nnoremap <silent> N n:call HLNext(0.15)<cr>

function! HLNext (blinktime)
  set invcursorline
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  set invcursorline
  redraw
endfunction

" Add space when commenting
let g:NERDSpaceDelims = 1

nmap <Leader>hn <Plug>GitGutterNextHunk
nmap <Leader>hp <Plug>GitGutterPrevHun
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterRevertHunk
" hunk diff
nmap <Leader>hd <Plug>GitGutterPreviewHunk

set nowrap
set gdefault " replace all instances on a line in search/replace

autocmd Filetype javascript map <Leader>t :call RunCurrentSpecFile()<CR>
autocmd Filetype javascript map <Leader>s :call RunNearestSpec()<CR>
autocmd Filetype javascript map <Leader>l :call RunLastSpec()<CR>
autocmd Filetype javascript map <Leader>a :call RunAllSpecs()<CR>

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.mm set filetype=objcpp

autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal textwidth=80

let g:mocha_js_command = "Dispatch mocha {spec}"

nmap <Leader>D :Dispatch

" Fix escape not working correctly in neovim
" https://github.com/neovim/neovim/issues/2051#issuecomment-75767873
set timeout
set timeoutlen=750
set ttimeoutlen=250
if !has('nvim')
  set ttimeout
  set ttimeoutlen=0
endif

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


if has('nvim')
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
endif
