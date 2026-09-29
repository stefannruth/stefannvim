vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.colors_name = "gotham-terminal"

-- Exact palette used by Rio
local c = {
	bg = "#0a0f14",
	fg = "#98d1ce",

	black = "#0a0f14",
	red = "#c33027",
	green = "#26a98b",
	yellow = "#edb54b",
	blue = "#195465",
	magenta = "#4e5165",
	cyan = "#33859d",
	white = "#98d1ce",

	dark = "#10151b",
	orange = "#d26939",
	dark_green = "#081f2d",
	selection = "#245361",
	dark_blue = "#093748",
	bright_magenta = "#888ba5",
	bright_cyan = "#599caa",
	bright_white = "#d3ebe9",
}

local function hl(group, options)
	vim.api.nvim_set_hl(0, group, options)
end

local function link(group, target)
	hl(group, { link = target })
end

-- Editor
hl("Normal", { fg = c.fg, bg = c.bg })
hl("NormalNC", { fg = c.fg, bg = c.bg })
hl("NormalFloat", { fg = c.fg, bg = c.dark })
hl("FloatBorder", { fg = c.cyan, bg = c.dark })

hl("Cursor", { fg = c.bg, bg = c.fg })
hl("CursorLine", { bg = c.dark })
hl("CursorColumn", { bg = c.dark })
hl("ColorColumn", { bg = c.dark })

hl("LineNr", { fg = c.magenta })
hl("CursorLineNr", { fg = c.yellow, bold = true })
hl("SignColumn", { fg = c.cyan, bg = c.bg })
hl("WinSeparator", { fg = c.blue })

hl("Visual", { bg = c.selection })
hl("Search", { fg = c.bg, bg = c.yellow, bold = true })
hl("IncSearch", { fg = c.bg, bg = c.orange, bold = true })
hl("CurSearch", { fg = c.bg, bg = c.orange, bold = true })
hl("MatchParen", { fg = c.bright_white, bg = c.blue, bold = true })

hl("Pmenu", { fg = c.fg, bg = c.dark })
hl("PmenuSel", { fg = c.bright_white, bg = c.selection, bold = true })
hl("PmenuSbar", { bg = c.dark_blue })
hl("PmenuThumb", { bg = c.cyan })

hl("StatusLine", { fg = c.bright_white, bg = c.blue })
hl("StatusLineNC", { fg = c.magenta, bg = c.dark })
hl("TabLine", { fg = c.bright_cyan, bg = c.dark })
hl("TabLineSel", { fg = c.yellow, bg = c.bg, bold = true })
hl("TabLineFill", { bg = c.bg })

hl("Directory", { fg = c.bright_cyan })
hl("Title", { fg = c.yellow, bold = true })
hl("NonText", { fg = c.dark })
hl("Whitespace", { fg = c.dark })
hl("SpecialKey", { fg = c.blue })
hl("EndOfBuffer", { fg = c.bg })

hl("ErrorMsg", { fg = c.red, bold = true })
hl("WarningMsg", { fg = c.yellow })
hl("MoreMsg", { fg = c.green })
hl("Question", { fg = c.green })

-- Syntax
hl("Comment", { fg = c.magenta, italic = true })

hl("Constant", { fg = c.orange })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.orange })
hl("Boolean", { fg = c.orange, bold = true })
hl("Float", { fg = c.orange })

hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.bright_cyan })

hl("Statement", { fg = c.yellow })
hl("Conditional", { fg = c.yellow })
hl("Repeat", { fg = c.yellow })
hl("Label", { fg = c.yellow })
hl("Operator", { fg = c.bright_white })
hl("Keyword", { fg = c.yellow })
hl("Exception", { fg = c.red })

hl("PreProc", { fg = c.bright_magenta })
hl("Include", { fg = c.bright_magenta })
hl("Define", { fg = c.bright_magenta })
hl("Macro", { fg = c.bright_magenta })

hl("Type", { fg = c.cyan })
hl("StorageClass", { fg = c.cyan })
hl("Structure", { fg = c.cyan })
hl("Typedef", { fg = c.cyan })

hl("Special", { fg = c.orange })
hl("Delimiter", { fg = c.bright_cyan })
hl("Underlined", { fg = c.bright_cyan, underline = true })
hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })
hl("Error", { fg = c.red })

-- Diffs and diagnostics
hl("DiffAdd", { fg = c.green, bg = c.dark_green })
hl("DiffChange", { fg = c.bright_cyan, bg = c.dark_blue })
hl("DiffDelete", { fg = c.red, bg = c.dark })
hl("DiffText", { fg = c.bright_white, bg = c.blue, bold = true })

hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.bright_cyan })
hl("DiagnosticHint", { fg = c.green })
hl("DiagnosticOk", { fg = c.green })

hl("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = c.bright_cyan })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = c.green })

-- Tree-sitter
local treesitter = {
	["@comment"] = "Comment",
	["@comment.documentation"] = "Comment",

	["@string"] = "String",
	["@string.escape"] = "Special",
	["@character"] = "Character",
	["@number"] = "Number",
	["@number.float"] = "Float",
	["@boolean"] = "Boolean",
	["@constant"] = "Constant",
	["@constant.builtin"] = "Constant",

	["@variable"] = "Identifier",
	["@variable.builtin"] = "Special",
	["@variable.parameter"] = "Identifier",
	["@property"] = "Identifier",

	["@function"] = "Function",
	["@function.call"] = "Function",
	["@function.builtin"] = "Function",
	["@function.method"] = "Function",
	["@function.method.call"] = "Function",
	["@constructor"] = "Type",

	["@keyword"] = "Keyword",
	["@keyword.function"] = "Keyword",
	["@keyword.return"] = "Keyword",
	["@keyword.operator"] = "Operator",
	["@operator"] = "Operator",

	["@type"] = "Type",
	["@type.builtin"] = "Type",
	["@attribute"] = "PreProc",
	["@module"] = "Include",
	["@label"] = "Label",

	["@tag"] = "Function",
	["@tag.attribute"] = "Identifier",
	["@tag.delimiter"] = "Delimiter",

	["@punctuation.bracket"] = "Delimiter",
	["@punctuation.delimiter"] = "Delimiter",
	["@punctuation.special"] = "Special",
}

for group, target in pairs(treesitter) do
	link(group, target)
end

-- LSP semantic highlighting
local lsp = {
	["@lsp.type.class"] = "Type",
	["@lsp.type.struct"] = "Structure",
	["@lsp.type.enum"] = "Type",
	["@lsp.type.interface"] = "Type",
	["@lsp.type.typeParameter"] = "Type",
	["@lsp.type.function"] = "Function",
	["@lsp.type.method"] = "Function",
	["@lsp.type.parameter"] = "Identifier",
	["@lsp.type.variable"] = "Identifier",
	["@lsp.type.property"] = "Identifier",
	["@lsp.type.enumMember"] = "Constant",
	["@lsp.type.namespace"] = "Include",
	["@lsp.type.macro"] = "Macro",
	["@lsp.type.decorator"] = "PreProc",
}

for group, target in pairs(lsp) do
	link(group, target)
end

-- Telescope
hl("TelescopeNormal", { fg = c.fg, bg = c.bg })
hl("TelescopeBorder", { fg = c.blue, bg = c.bg })
hl("TelescopePromptNormal", { fg = c.fg, bg = c.dark })
hl("TelescopePromptBorder", { fg = c.cyan, bg = c.dark })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.cyan, bold = true })
hl("TelescopePreviewTitle", { fg = c.bg, bg = c.green, bold = true })
hl("TelescopeResultsTitle", { fg = c.bg, bg = c.blue, bold = true })
hl("TelescopeSelection", { fg = c.bright_white, bg = c.selection, bold = true })
hl("TelescopeMatching", { fg = c.yellow, bold = true })

-- Common plugins
hl("LazyNormal", { fg = c.fg, bg = c.bg })
hl("LazyButton", { fg = c.fg, bg = c.dark })
hl("LazyButtonActive", { fg = c.bg, bg = c.cyan, bold = true })
hl("LazyH1", { fg = c.bg, bg = c.yellow, bold = true })

hl("GitSignsAdd", { fg = c.green })
hl("GitSignsChange", { fg = c.yellow })
hl("GitSignsDelete", { fg = c.red })

hl("WhichKey", { fg = c.yellow })
hl("WhichKeyGroup", { fg = c.cyan })
hl("WhichKeyDesc", { fg = c.fg })
hl("WhichKeySeparator", { fg = c.magenta })
hl("WhichKeyFloat", { bg = c.dark })
