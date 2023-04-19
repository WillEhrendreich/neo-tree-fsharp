--This file should have all functions that are in the public api and either set
--or read the state of this source.

local vim = vim
local utils = require("neo-tree.utils")
local defaults = require("neo-tree.defaults")
local mapping_helper = require("neo-tree.setup.mapping-helper")
local events = require("neo-tree.events")
local log = require("neo-tree.log")
local file_nesting = require("neo-tree.sources.common.file-nesting")
local highlights = require("neo-tree.ui.highlights")
local manager = require("neo-tree.sources.manager")
local netrw = require("neo-tree.setup.netrw")
local renderer = require("neo-tree.ui.renderer")

local M = {
	-- This is the name our source will be referred to as
	-- within Neo-tree
	-- name = "example",
	name = "neo-tree-fsharp",
	-- This is how our source will be displayed in the Source Selector
	display_name = "neo-tree-fsharp",
}

---Navigate to the given path.
---@param path string Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path)
	if path == nil then
		path = vim.fn.getcwd()
	end
	state.path = path

	-- Do something useful here to get items
	local items = {
		{
			id = "1",
			name = "root",
			type = "directory",
			children = {
				{
					id = "1.1",
					name = "child1",
					type = "directory",
					children = {
						{
							id = "1.1.1",
							name = "child1.1 (you'll need a custom renderer to display this properly)",
							type = "custom",
							extra = { custom_text = "HI!" },
						},
						{
							id = "1.1.2",
							name = "child1.2",
							type = "file",
						},
					},
				},
			},
		},
	}
	renderer.show_nodes(items, state)
end

---Configures the plugin, should be called before the plugin is used.
---@param config table Configuration table containing any keys that the user
--wants to change from the defaults. May be empty to accept default values.
M.setup = function(config, global_config)
	-- You most likely want to use this function to subscribe to events
	if config.use_libuv_file_watcher then
		manager.subscribe(M.name, {
			event = events.FS_EVENT,
			handler = function(args)
				manager.refresh(M.name)
			end,
		})
	end

	-- events.subscribe({
	-- 	event = events.VIM_COLORSCHEME,
	-- 	handler = highlights.setup,
	-- 	id = "neo-tree-highlight",
	-- })
	--
	-- events.subscribe({
	-- 	event = events.VIM_WIN_ENTER,
	-- 	handler = M.win_enter_event,
	-- 	id = "neo-tree-win-enter",
	-- })
	--
	-- --Dispose ourselves if the tab closes
	-- events.subscribe({
	-- 	event = events.VIM_TAB_CLOSED,
	-- 	handler = function(args)
	-- 		local tabnr = tonumber(args.afile)
	-- 		log.debug("VIM_TAB_CLOSED: disposing state for tab", tabnr)
	-- 		manager.dispose_tab(tabnr)
	-- 	end,
	-- })
	--
	-- --Dispose ourselves if the tab closes
	-- events.subscribe({
	-- 	event = events.VIM_WIN_CLOSED,
	-- 	handler = function(args)
	-- 		local winid = tonumber(args.afile)
	-- 		log.debug("VIM_WIN_CLOSED: disposing state for window", winid)
	-- 		manager.dispose_window(winid)
	-- 	end,
	-- })

	-- local rt = utils.get_value(M.config, "resize_timer_interval", 50, true)
	-- require("neo-tree.ui.renderer").resize_timer_interval = rt
end

return M
