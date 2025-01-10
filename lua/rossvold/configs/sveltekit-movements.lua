require("sveltekit-movements").setup({
	-- Jump to spesific file
	page_keymap = '<C-h>',   -- Jump to +page.svelte
	server_keymap = '<C-y>',  -- Jump to +page.server.ts
	layout_keymap = '<C-n>',  -- Jump to nearest layout file
	-- Toggles
	toggle_keymap = 'gs',  -- Toggle between page and server
})
