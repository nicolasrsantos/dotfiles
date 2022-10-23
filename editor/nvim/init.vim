" ============================================================
" # PLUGINS
" ============================================================
call plug#begin()

" LSP stuff
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'
Plug 'onsails/lspkind.nvim'
Plug 'ray-x/lsp_signature.nvim'

" Theme
" Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'yggdroot/indentLine'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
" Plug 'jordwalke/vim-taste'

" Editing and GUI enhancements
Plug 'machakann/vim-highlightedyank'
Plug 'stephpy/vim-yaml'
Plug 'ciaranm/securemodelines'
Plug 'itchyny/lightline.vim'
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
" colorscheme base16-gruvbox-dark-hard
let g:catppuccin_flavour = "mocha" " latte, frappe, macchiato, mocha
lua << EOF
require("catppuccin").setup()
EOF
colorscheme catppuccin

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

lua << END
	local cmp = require'cmp'
	local lspkind = require'lspkind'
	local lspconfig = require'lspconfig'

	cmp.setup({
		mapping = {
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<Tab>'] = cmp.mapping.confirm({ select = true }),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
			{ name = 'buffer' },
		}),
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		formatting = {
			format = lspkind.cmp_format{
				with_text = true,
				mode = 'symbol', -- show only symbol annotations
				maxwidth = 50,
				menu = {
						buffer = "[buf]",
						nvim_lsp = "[LSP]",
						nvim_lua = "[api]",
						vim_vsnip = "[snip]"
				}
			},
			symbol_map = {
				Text = "",
				Method = "",
				Function = "",
				Constructor = "",
				Field = "ﰠ",
				Variable = "",
				Class = "ﴯ",
				Interface = "",
				Module = "",
				Property = "ﰠ",
				Unit = "塞",
				Value = "",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "",
				File = "",
				Reference = "",
				Folder = "",
				EnumMember = "",
				Constant = "",
				Struct = "פּ",
				Event = "",
				Operator = "",
				TypeParameter = ""
			}
		},
	})

	local on_attach = function(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

		-- Mappings.
		local opts = { noremap=true, silent=true }

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

		require("lsp_signature").on_attach({
			bind = true,
			handler_opts = {
				border = "shadow"
			},
		})
	end

	lspconfig.pyright.setup{
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	}
END

" Nerdcommenter confi
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
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
set updatetime=1000
set list
set listchars=tab:▸\ ,eol:↲
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

vnoremap <C-h> :nohlsearch<CR>
nnoremap <C-h> :nohlsearch<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>

nnoremap <c-w><c-r> :%s/<c-r><c-w>//g<left><left>

" Make esc leave terminal mode
tnoremap <leader><Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bf :bfirst<CR>
nnoremap <leader>bl :blast<CR>
