set nocompatible " 關閉兼容模式
filetype off " 關閉自動補齊

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'Markdown'
Plugin 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plugin 'ryanoasis/vim-devicons'
Plugin 'scrooloose/nerdtree'
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'tomasiser/vim-code-dark' " vscode theme
Plugin 'pangloss/vim-javascript' " javascript 語法高亮
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'pacha/vem-tabline'
Plugin 'Yggdroot/indentLine'
Plugin 'frazrepo/vim-rainbow'
call vundle#end()

" Omnisharp autocompletion
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : getline('.')[col('.')-2] =~# '[[:alnum:].-_#$]' ? '<C-x><C-o>' : '<Tab>'

" Omnisharp useful hotkeys
nnoremap <C-o><C-u> :OmniSharpFindUsages<CR>
nnoremap <C-o><C-d> :OmniSharpGotoDefinition<CR>
nnoremap <C-o><C-d><C-p> :OmniSharpPreviewDefinition<CR>
nnoremap <C-o><C-r> :!dotnet run<CR>

"colorscheme codedark
set clipboard=unnamed

" NerdTree 才外掛的配置資訊
" "將 F2 設定為開啟或關閉 NERDTree 的快捷鍵
map <f2> :NERDTreeToggle<cr>
" 修改樹的顯示圖案
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
" 以 Tab 開啟檔案
let g:NERDTreeMapOpenInTab='\r'
" 視窗位置
let g:NERDTreeWinPos='right'
" 視窗尺寸
let g:NERDTreeSize=30
" 視窗是否顯示符號
let g:NERDTreeShowLineNumbers=1
" 不顯示隱藏檔案
let g:NERDTreeHidden=0
" 反斜線+r 刷新資料夾
nmap <Leader>r :NERDTreeRefreshRoot <CR>

" 建立一個自動開啟 NerdTree (每次進入 vim 時自動打開)
function! StartUp()
    if ''==@%
        NERDTree
    endif
endfunction

autocmd VimEnter * call StartUp()

" Remember the position of cursor
set viminfo='800,<3000
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif


set number " 開啟行號設定
set encoding=utf-8
set ruler " 光標訊息
set hlsearch " highlight 顯示搜尋
set incsearch " 側邊搜尋邊 highlight
set ignorecase " 忽略大小寫
set cursorline " 突出當前顯示行
set mouse=a " 支援滑鼠使用

set ts=4 " tab 佔 4 個字元寬度
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent " 複製上一行的縮排
" expandtab " tab 為四個空白

autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype css setlocal ts=2 sw=2 expandtab
auto Filetype javascript setlocal ts=2 sw=2 expandtab
auto Filetype json setlocal ts=2 sw=2 expandtab

syntax enable " 語法 highlight
syntax on

set t_co=256
set t_ut=
" 開啟 24bit 的顏色，開啟這個顏色會更漂亮一些
set termguicolors
set background=dark
" colorscheme desert
" packadd! dracula
" colorscheme one
" 最後加入載 gruvbox 主題
" autocmd vimenter * colorscheme gruvbox
let g:airline_theme='one'
" 取消備份
set nobackup
set noswapfile
" 退出插入模式自動保存
" au InsertLeave *.go,*java,*.c,*.cpp,*.js,*.html,*.css,*.tpl,*.sh,*.bat,*.conf write

let mapleader=";" " 定義快速鍵前綴，即<Leader>

" === 系統剪貼版複製貼上 ===
" v 模式下複製內容到系統剪貼簿
vmap <Leader>c "+yy
" n 模式下複製一行到系統剪貼簿
nmap <Leader>c "+yy
" n 模式下黏貼系統剪貼版的內容
nmap <Leader>v "+p

" 解決插入模式下 delete/backspace 按鍵失效的問題
set backspace=2

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen('pwsh.exe', {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Toggle terminal on/off (neovim)
nnoremap <A-t> :call TermToggle(12)<CR>
inoremap <A-t> <Esc>:call TermToggle(12)<CR>
tnoremap <A-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal go back to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap :q! <C-\><C-n>:q!<CR>


" 解決按下 ctrl + z 會卡住的問題
nnoremap <C-z> <nop>
inoremap <C-z> <nop>
vnoremap <C-z> <nop>
snoremap <C-z> <nop>
xnoremap <C-z> <nop>
cnoremap <C-z> <nop>
onoremap <C-z> <nop>

" Visual Studio 配置
" 開始編譯
    :nnoremap gc :vsc Build.Compile
" 開始建置
    :nnoremap gb :vsc Build.BuildSolution
" 結束偵錯
    :nnoremap gs :vsc Debug.StopDebugging
" 開始偵錯
    :nnoremap gr :vsc Debug.Start

" 函数列表
    :nnoremap zm :vsc VAssistX.ListMethodsInCurrentFile<cr> 

"當前檔案中的引用
    :nnoremap cj :vsc VAssistX.FindReferencesinFile<CR> 

"查看所有引用
    :nnoremap ca :vsc VAssistX.FindReferences<CR> 

"開啟所在的資料夾
    :nnoremap cm :vsc File.OpenContainingFolder<CR> 

"查看函數定義檔案
    :nnoremap zj :vsc Edit.QuickInfo<CR> 

"實作介面
    :nnoremap zp :vsc VAssistX.RefactorImplementInterface<CR>

" If you don't like many colors and prefer the conservative style of the standard Visual Studio
" let g:codedark_conservative=1
" Activates italicized comments (make sure your terminal supports italics)
" let g:codedark_italics=1
" Make the background transparent
let g:codedark_transparent=1
" If you have vim-airline, you can also enable the provided theme
" let g:airline_theme = 'codedark'

colorscheme codedark
" set guifont=Hack\ Nerd\ Font:h12

" coc settings
let g:coc_gloabl_extensions = [
\ 'coc-tsserver',
\ 'coc-html',
\ 'coc-css']

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" indentLine
" let g:indentLine_setColors=0
autocmd Filetype markdown let g:indentLine_setConceal=0
autocmd Filetype markdown set conceallevel=0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" let g:indentLine_setColors=1
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_setColors=125
let g:indentLine_color_term=255

"let g:indentLine_concealcursor='inc'
"let g:indentLine_conceallevel=2

" vim-rainbow
let g:rainbow_active=1
let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
