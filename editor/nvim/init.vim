" ============================================================
" # PLUGINS
" ============================================================
call plug#begin()

" LSP stuff
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim'

" Theme
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'yggdroot/indentLine'

" Editing and GUI enhancements
Plug 'machakann/vim-highlightedyank'
Plug 'stephpy/vim-yaml'
Plug 'ciaranm/securemodelines'
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-rooter'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/ShowTrailingWhitespace'

" FZF
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Git
Plug 'mhinz/vim-signify'
Plug 'jreybert/vimagit', { 'branch': 'next' }
Plug 'tpope/vim-fugitive'

" Rust
Plug 'rust-lang/rust.vim'

call plug#end()

" ============================================================
" # PLUGINS SETTINGS
" ============================================================
set background=dark
let base16colorspace=256
colorscheme base16-gruvbox-dark-hard

" Plugin settings
let g:secure_modelines_allowed_items = [
	\ "textwidth",   "tw",
	\ "softtabstop", "sts",
	\ "tabstop",     "ts",
	\ "shiftwidth",  "sw",
	\ "expandtab",   "et",   "noexpandtab", "noet",
	\ "filetype",    "ft",
	\ "foldmethod",  "fdm",
	\ "readonly",    "ro",   "noreadonly", "noro",
	\ "rightleft",   "rl",   "norightleft", "norl",
	\ "colorcolumn"
	\ ]

" Lightline
let g:lightline = {
	\ 'active': {
	\   'left': [ [ 'mode', 'pase' ],
	\             [ 'readonly', 'filename', 'modified' ] ],
	\   'right': [ [ 'lineinfo' ],
	\              [ 'percent' ],
	\              [ 'fileencoding', 'filetype' ] ],
	\ },
	\ 'component_function': {
	\   'filename': 'LightlineFilename'
	\ },
	\ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" LSP config
set completeopt=menu,menuone,noselect

lua <<EOF
	local cmp = require'cmp'
	local lspkind = require('lspkind')

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		},
		formatting = {
			format = lspkind.cmp_format({
				mode = 'symbol', -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

				before = function (entry, vim_item)
					return vim_item
				end
			})
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'luasnip' },
			{ name = 'buffer' },
		}
	})

	require('lspconfig').pyright.setup{
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	}
EOF

" Enable type inlay hints for current line on cursor hover
autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" NERD Commenter config
let g:NERDSpaceDelims = 1

" Vimagit config
let g:magit_discard_untracked_do_delete = 1

""" Vim-Signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_realtime = 0
let g:signify_sign_add = '⨁'
let g:signify_sign_change = '✎'
let g:signify_sign_delete = '✖'
highlight SignColumn ctermbg=NONE guibg=NONE

" Indent line plugin character
let g:indentLine_char = '│'

" Delete trailing whitespace on save
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    " Delete the last entry from the search history, which is the substitution
    " command
    call histdel("search", -1)
    let @/ = histget("search", -1)
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" ============================================================
" # EDITOR AND GUI SETTINGS
" ============================================================
syntax on
let mapleader = " "

set nu
set relativenumber
set encoding=utf-8
set noerrorbells
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set nowrap
set noswapfile
set signcolumn=yes
set colorcolumn=80
set incsearch
set ignorecase
set smartcase
set gdefault
set undodir=~/.vimundo
set timeoutlen=300
set shortmess+=c
set completeopt=menuone,noinsert,noselect
set mouse=a
set cursorline
set clipboard^=unnamed,unnamedplus
set list
set listchars=tab:▸\ ,eol:¬
highlight NonText ctermfg=7 guifg=gray guibg=NONE ctermbg=NONE

" ============================================================
" # REMAPS
" ============================================================
nmap <leader>w :w<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

nnoremap ; :
nnoremap Y y$
map H ^
map L $

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d
xnoremap <leader>p "_dP

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

map <F1> <Esc>
imap <F1> <Esc>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>k :wincmd k<CR>

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <leader>f :NERDTreeFocus<CR>
nnoremap <leader>n :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nmap <leader>r :NERDTreeRefreshRoot

vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>
