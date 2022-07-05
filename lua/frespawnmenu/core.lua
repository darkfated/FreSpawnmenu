CreateClientConVar( 'frespawnmenu', 1, true )

local frespawnmenu_content = CreateClientConVar( 'frespawnmenu_content', '#spawnmenu.content_tab', true )
local frespawnmenu_tool_right = CreateClientConVar( 'frespawnmenu_tool_right', 1, true )
local frespawnmenu_menubar = CreateClientConVar( 'frespawnmenu_menubar', 0, true )
local frespawnmenu_size = CreateClientConVar( 'frespawnmenu_size', 1, true )
local frespawnmenu_save_tool = CreateClientConVar( 'frespawnmenu_save_tool', '[1.0,1.0,1.0]', true )
local frespawnmenu_tab_icon = CreateClientConVar( 'frespawnmenu_tab_icon', 1, true )
local frespawnmenu_scrollbar_tools = CreateClientConVar( 'frespawnmenu_scrollbar_tools', 0, true )
local frespawnmenu_custom_sound = CreateClientConVar( 'frespawnmenu_custom_sound', 1, true )
local frespawnmenu_simple_tabs = CreateClientConVar( 'frespawnmenu_simple_tabs', 0, true )
local frespawnmenu_derma_skin = CreateClientConVar( 'frespawnmenu_derma_skin', 'fsm', true )
local frespawnmenu_tool_drawer = CreateClientConVar( 'frespawnmenu_tool_drawer', 0, true )
local frespawnmenu_fav_startup = CreateClientConVar( 'frespawnmenu_fav_startup', 0, true )
local frespawnmenu_frame = CreateClientConVar( 'frespawnmenu_frame', 0, true )
local frespawnmenu_quick_category_buttons = CreateClientConVar( 'frespawnmenu_quick_category_buttons', 0, true )

CreateClientConVar( 'frespawnmenu_blur', 1, true )
CreateClientConVar( 'frespawnmenu_adaptive_wide_nav', 1, true )
CreateClientConVar( 'frespawnmenu_frame_blur', 1, true )
CreateClientConVar( 'frespawnmenu_sounds', 1, true )

local color_white = Color(255,255,255)
local color_gray = Color(70,70,70,200)
local color_panel = Color(202,202,202,200)
local color_icon_depressed = Color(230,230,230)
local color_panel_tool_content = Color(255,255,255,145)
local scrw, scrh = ScrW(), ScrH()

local function freOutlinedBox( x, y, w, h, col, bordercol )
	surface.SetDrawColor( col )
	surface.DrawRect( x + 1, y + 1, w - 2, h - 2 )

	surface.SetDrawColor( bordercol )
	surface.DrawOutlinedRect( x, y, w, h, 1 )
end

local function soundPlay( snd )
	if ( !GetConVar( 'frespawnmenu_sounds' ):GetBool() ) then
		return
	end

	surface.PlaySound( !snd and 'UI/buttonclickrelease.wav' or snd )
end

local function openFreMenu()
	scrw, scrh = ScrW(), ScrH() -- Resetting the permission when recreating the menu

	achievements.SpawnMenuOpen()

	if ( !file.Exists( 'frespawnmenu_tabs.txt', 'DATA' ) ) then
		local data_tabs = {}
		data_tabs.renamed = {}
		data_tabs.notvisible = {}

		file.Write( 'frespawnmenu_tabs.txt', util.TableToJSON( data_tabs ) )
	end

	local spawn_w = math.min( scrw - 10, scrw * 0.92 ) * frespawnmenu_size:GetFloat()
	local spawnmenu_tabs = spawnmenu.GetCreationTabs()
	local spawnmenu_tools = spawnmenu.GetTools()
	local menu_skin = frespawnmenu_derma_skin:GetString()
	local data_tabs = util.JSONToTable( file.Read( 'frespawnmenu_tabs.txt', 'DATA' ) )

	local function spawnmenu_set_standart_size()
		FreSpawnMenu:SetSize( spawn_w, math.min( scrh - 10, scrh * 0.95 ) * frespawnmenu_size:GetFloat() )
	end

	if ( frespawnmenu_frame:GetBool() ) then
		FreSpawnMenu = vgui.Create( 'DFrame' )
		FreSpawnMenu:SetTitle( 'FreSpawnMenu' )

		if ( GetConVar( 'frespawnmenu_frame_blur' ):GetBool() ) then
			FreSpawnMenu:SetBackgroundBlur( true )
		end

		FreSpawnMenu:SetScreenLock( true )
		FreSpawnMenu.btnMaxim:SetDisabled( false )
		FreSpawnMenu.btnMaxim.DoClick = function()
			soundPlay( frespawnmenu_custom_sound:GetBool() and 'frespawnmenu/frame_full.ogg' )

			if ( FreSpawnMenu:GetWide() == scrw ) then
				spawnmenu_set_standart_size()
			else
				FreSpawnMenu:SetSize( scrw, scrh )
			end

			FreSpawnMenu:Center()
		end
		FreSpawnMenu.btnClose.DoClick = function()
			soundPlay( frespawnmenu_custom_sound:GetBool() and 'frespawnmenu/frame_close.ogg' )

			FreSpawnMenu:Remove()
		end
	else
		FreSpawnMenu = vgui.Create( 'EditablePanel' )
	end

	spawnmenu_set_standart_size()

	FreSpawnMenu:Center()
	FreSpawnMenu:MakePopup()
	FreSpawnMenu:SetSkin( menu_skin )
	FreSpawnMenu:SetKeyboardInputEnabled( false )

	function FreSpawnMenu:StartKeyFocus( pPanel )
		self.m_pKeyFocus = pPanel

		self:SetKeyboardInputEnabled( true )

		self.m_bHangOpen = true
	end

	function FreSpawnMenu:EndKeyFocus( pPanel )
		if ( self.m_pKeyFocus != pPanel ) then
			return
		end

		self:SetKeyboardInputEnabled( false )
	end

	FreSpawnMenu.Tabs = {}

	// Separation into Spawn and Tool part

	local global_div = vgui.Create( 'DHorizontalDivider', FreSpawnMenu )
	global_div:Dock( FILL )
	global_div:SetDividerWidth( 4 )

	local MainPanel = vgui.Create( 'DPanel', global_div )
	MainPanel:SetWide( spawn_w )
	MainPanel.Paint = nil

	local ToolPanel = vgui.Create( 'DPanel', global_div )

	if ( frespawnmenu_tool_right:GetBool() ) then
		global_div:SetLeft( MainPanel )
		global_div:SetLeftWidth( spawn_w - 160 )
		global_div:SetLeftMin( spawn_w * 0.8 )
		global_div:SetRight( ToolPanel )
		global_div:SetRightMin( 120 )
	else
		global_div:SetLeft( ToolPanel )
		global_div:SetLeftWidth( 160 )
		global_div:SetLeftMin( 120 )
		global_div:SetRight( MainPanel )
		global_div:SetRightMin( spawn_w * 0.8 )
	end

	// Splitting the Spawn part into a selection of tabs and an action bar

	local spawn_div = vgui.Create( 'DVerticalDivider', MainPanel )
	spawn_div:SetWide( MainPanel:GetWide() )
	spawn_div:Dock( FILL )
	spawn_div:SetDividerHeight( 4 )

	local tabs_panel = vgui.Create( 'DPanel', spawn_div )
	tabs_panel.user_wide = 0

	local action_panel = vgui.Create( 'DPanel', spawn_div )

	if ( frespawnmenu_simple_tabs:GetBool() ) then
		action_panel.Paint = nil
	end

	local action_panel_div = vgui.Create( 'DHorizontalDivider', action_panel )
	action_panel_div:Dock( FILL )
	action_panel_div:DockMargin( 6, 6, 6, 6 )
	action_panel_div:SetDividerWidth( 4 )

	local action_panel_content_scroll = vgui.Create( 'DHorizontalScroller', action_panel_div )

	local action_panel_content = vgui.Create( 'DPanel', action_panel_content_scroll )
	action_panel_content.Paint = nil

	action_panel_content_scroll:AddPanel( action_panel_content )
	action_panel_content_scroll.Paint = function()
		local convar_right = frespawnmenu_tool_right:GetBool()

		if ( convar_right and action_panel_div:GetLeftWidth() < 400 or !convar_right and spawn_div:GetWide() - action_panel_div:GetLeftWidth() < 400 ) then
			action_panel_content:SetWide( 500 )
		else
			action_panel_content:SetWide( convar_right and action_panel_div:GetLeftWidth() or spawn_div:GetWide() - action_panel_div:GetLeftWidth() - 16 )
		end
	end

	if ( frespawnmenu_tool_right:GetBool() ) then
		action_panel_div:SetLeft( action_panel_content_scroll )
		action_panel_div:SetLeftWidth( spawn_div:GetWide() )
		action_panel_div:SetRightMin( math.min( 300, spawn_w * 0.32 ) )
	else
		action_panel_div:SetRight( action_panel_content_scroll )
		action_panel_div:SetLeftMin( math.min( 300, spawn_w * 0.32 ) )
	end

	if ( !frespawnmenu_simple_tabs:GetBool() ) then
		local tab_panel_sp = vgui.Create( 'DHorizontalScroller', tabs_panel )
		tab_panel_sp:Dock( FILL )
		tab_panel_sp:DockMargin( 6, 6, 6, 6 )
		tab_panel_sp:SetOverlap( -4 )

		surface.SetFont( 'Default' )

		local function OpenContent( tab_id )
			local TabTable = FreSpawnMenu.Tabs[ tab_id ]

			if ( frespawnmenu_content:GetString() == TabTable.Title ) then
				return
			end

			soundPlay( 'buttons/lightswitch2.wav' )

			RunConsoleCommand( 'frespawnmenu_content', TabTable.Title )

			for k, tab in pairs( FreSpawnMenu.Tabs ) do
				FreSpawnMenu.Tabs[ k ].Panel:SetVisible( false )
			end

			TabTable.Panel:SetVisible( true )
		end

		local function TabEditionOptions( panel, name_tab )
			panel:AddOption( '#frespawnmenu.rename', function()
				soundPlay()

				Derma_StringRequest(
					'FreSpawnMenu',
					'#frespawnmenu.rename_description',
					data_tabs.renamed[ name_tab ] and data_tabs.renamed[ name_tab ] or '',
					function( text )
						if ( text != '' ) then
							data_tabs.renamed[ name_tab ] = text
						else
							table.RemoveByValue( data_tabs.renamed, data_tabs.renamed[ name_tab ] )
						end

						file.Write( 'frespawnmenu_tabs.txt', util.TableToJSON( data_tabs ) )

						FreSpawnMenu:Remove()
					end
				):SetSkin( menu_skin )
			end ):SetIcon( 'icon16/book_edit.png' )

			panel:AddOption( '#frespawnmenu.not_display', function()
				soundPlay()

				if ( table.HasValue( data_tabs.notvisible, name_tab ) ) then
					table.remove( data_tabs.notvisible, k )
				else
					table.insert( data_tabs.notvisible, name_tab )
				end

				file.Write( 'frespawnmenu_tabs.txt', util.TableToJSON( data_tabs ) )

				FreSpawnMenu:Remove()
			end ):SetIcon( 'icon16/camera.png' )
		end

		local function OpenTabsDermaMenu()
			local DM = DermaMenu()
			DM:SetSkin( menu_skin )

			for name_tab, elem in SortedPairsByMemberValue( spawnmenu_tabs, 'Order' ) do
				if ( !table.HasValue( data_tabs.notvisible, name_tab ) ) then
					local ChildOption, ParentOption = DM:AddSubMenu( data_tabs.renamed[ name_tab ] and data_tabs.renamed[ name_tab ] or name_tab, function()
						OpenContent( elem.num )
					end )
					ParentOption:SetIcon( elem.Icon )
					ParentOption.right_clicked = false
					ParentOption.DoRightClick = function()
						if ( !ParentOption.right_clicked ) then
							soundPlay()

							ParentOption.right_clicked = true
							ParentOption.ArrowActive = true

							TabEditionOptions( ChildOption, name_tab )
						end
					end
					ParentOption.ArrowActive = false
				end
			end

			DM:AddSpacer()

			for name_tab, elem in SortedPairsByMemberValue( spawnmenu_tabs, 'Order' ) do
				if ( table.HasValue( data_tabs.notvisible, name_tab ) ) then
					DM:AddOption( name_tab, function()
						soundPlay()

						for k, tab in pairs( data_tabs.notvisible ) do
							if ( tab == name_tab ) then
								table.remove( data_tabs.notvisible, k )
							end
						end

						file.Write( 'frespawnmenu_tabs.txt', util.TableToJSON( data_tabs ) )

						FreSpawnMenu:Remove()
					end ):SetIcon( elem.Icon )
				end
			end

			DM:Open()
		end

		local tab_num = 0

		for name, tab in SortedPairsByMemberValue( spawnmenu_tabs, 'Order' ) do
			tab_num = tab_num + 1
			tab.num = tab_num

			if ( data_tabs.renamed[ name ] ) then
				name = data_tabs.renamed[ name ]
			end

			local Tab = {}
			Tab.Title = name

			Tab.Panel = vgui.Create( 'DPanel', action_panel_content )
			Tab.Panel:Dock( FILL )
			Tab.Panel.Paint = nil
			Tab.Panel:SetVisible( false )

			local content = tab.Function()
			content:SetParent( Tab.Panel )
			content:Dock( FILL )
			content:SetSkin( menu_skin )

			table.insert( FreSpawnMenu.Tabs, Tab )

			if ( !table.HasValue( data_tabs.notvisible, name ) ) then
				local size_name = surface.GetTextSize( name )

				local function TabClick( pnl )
					pnl.DoClick = function()
						OpenContent( tab.num )
					end
					pnl.DoRightClick = function()
						OpenTabsDermaMenu()
					end
					pnl.DoMiddleClick = function()
						local DM = DermaMenu()
						DM:SetSkin( menu_skin )

						TabEditionOptions( DM, name )

						DM:Open()
					end
				end

				local btn_item = vgui.Create( 'DButton', tab_panel_sp )

				local btn_item_wide = size_name + 10 + btn_item:GetTall()

				btn_item:SetWide( btn_item_wide )
				btn_item:SetText( name )

				tabs_panel.user_wide = tabs_panel.user_wide + btn_item_wide + 4

				TabClick( btn_item )

				btn_item.id = name

				btn_item.PaintOver = function()
					if ( spawn_div:GetDragging() ) then
						btn_item:SetWide( size_name + 10 + btn_item:GetTall() )

						tabs_panel.user_wide = 0

						for name, v in SortedPairsByMemberValue( spawnmenu_tabs, 'Order' ) do
							tabs_panel.user_wide = tabs_panel.user_wide + size_name + 26 + btn_item:GetTall()

							if ( frespawnmenu_tab_icon:GetBool() ) then
								tabs_panel.user_wide = tabs_panel.user_wide + 26
							end
						end

						tabs_panel.user_wide = tabs_panel.user_wide + 16
					end
				end

				if ( frespawnmenu_tab_icon:GetBool() ) then
					local icon_pan = vgui.Create( 'DButton', tab_panel_sp )
					icon_pan:SetWide( 22 )

					tabs_panel.user_wide = tabs_panel.user_wide + 26

					local IconMat = Material( tab.Icon )

					icon_pan:SetText( '' )
					icon_pan.Paint = function( self, w, h )
						surface.SetDrawColor( self.Depressed and frespawnmenu_content:GetString() != name and color_icon_depressed or color_white )
						surface.SetMaterial( IconMat )
						surface.DrawTexturedRect( 4, h * 0.5 - 8, w - 8, 16 )
					end

					TabClick( icon_pan )

					tab_panel_sp:AddPanel( icon_pan )
				end

				tab_panel_sp:AddPanel( btn_item )
			end
		end

		tabs_panel.user_wide = tabs_panel.user_wide + 16

		local PanelEnd = vgui.Create( 'DPanel', tab_panel_sp )
		PanelEnd:SetWide( 4 )
		PanelEnd.Paint = function( self, w, h )
			freOutlinedBox( 0, 0, w, h, color_white, color_gray )
		end

		PanelEnd.btn = vgui.Create( 'DButton', PanelEnd )
		PanelEnd.btn:Dock( FILL )
		PanelEnd.btn:SetText( '' )
		PanelEnd.btn.Paint = nil
		PanelEnd.btn.DoClick = function()
			OpenTabsDermaMenu()
		end

		tab_panel_sp:AddPanel( PanelEnd )
	end

	if ( frespawnmenu_menubar:GetBool() ) then
		local panel_menubar = vgui.Create( 'DPanel', MainPanel )
		panel_menubar:Dock( TOP )
		panel_menubar:SetTall( 30 )
		panel_menubar:DockMargin( 0, 0, 0, 4 )
		panel_menubar.user_wide = 0

		local mb = vgui.Create( 'DMenuBar', panel_menubar )
		mb:Dock( FILL )
		mb.Paint = nil

		function mb:AddMenu( label )
			local DM = DermaMenu()
			DM:SetDeleteSelf( false )
			DM:SetDrawColumn( true )
			DM:Hide()
			DM:SetSkin( menu_skin )

			self.Menus[ label ] = DM

			local b = self:Add( 'DButton' )
			b:SetText( label )
			b:Dock( LEFT )
			b:DockMargin( 5, 0, 0, 0 )
			b:SetIsMenu( true )
			b:SetPaintBackground( false )
			b:SizeToContentsX( 16 )
			b.DoClick = function()
				if ( DM:IsVisible() ) then
					DM:Hide()

					return
				end

				local x, y = b:LocalToScreen( 0, 0 )

				DM:Open( x, y + b:GetTall(), false, b )
			end
			b.OnCursorEntered = function()
				local opened = self:GetOpenMenu()

				if ( !IsValid( opened ) or opened == DM ) then
					return
				end

				opened:Hide()

				b:DoClick()
			end

			panel_menubar.user_wide = panel_menubar.user_wide + b:GetWide() + 5

			return DM
		end

		hook.Run( 'PopulateMenuBar', mb )

		if ( !frespawnmenu_simple_tabs:GetBool() ) then
			local ContextMenu = mb:AddMenu( 'ContextMenu' )

			for k, context_item in pairs( list.Get( 'DesktopWindows' ) ) do
				ContextMenu:AddOption( context_item.title, function()
					action_panel_content:Clear()

					local ContextMenu_Window = vgui.Create( 'DPanel', action_panel_content )
					ContextMenu_Window:SetSize( action_panel_content:GetSize() )
					ContextMenu_Window:Dock( FILL )
					ContextMenu_Window:SetSkin( menu_skin )
					ContextMenu_Window.Paint = nil

					function ContextMenu_Window:SetTitle()
					end

					function ContextMenu_Window:SetSizable()
					end

					function ContextMenu_Window:SetMinWidth()
					end

					function ContextMenu_Window:SetMinHeight()
					end

					context_item.init( context_item.icon or nil, ContextMenu_Window )
				end )
			end
		end

		panel_menubar.user_wide = panel_menubar.user_wide + 5
	end

	spawn_div:SetTop( tabs_panel )

	if ( frespawnmenu_simple_tabs:GetBool() ) then
		spawn_div:SetTopMin( 0 )
		spawn_div:SetTopMax( 0 )
		spawn_div:SetTopHeight( 0 )
	else
		spawn_div:SetTopMin( 34 )
		spawn_div:SetTopMax( 80 )
	end

	spawn_div:SetTopHeight( spawn_div:GetTopMin() )
	spawn_div:SetBottom( action_panel )

	// Splitting the Spawn part into a list of tools

	local tool_sp = vgui.Create( 'DScrollPanel', ToolPanel )
	tool_sp:Dock( FILL )
	tool_sp:DockMargin( 6, 6, 6, 6 )

	if ( !frespawnmenu_scrollbar_tools:GetBool() ) then
		tool_sp:GetVBar():SetWide( 0 )
	end

	local tool_CategoryPanel = vgui.Create( 'DPanel', ToolPanel )
	tool_CategoryPanel:Dock( TOP )
	tool_CategoryPanel:DockMargin( 4, 4, 4, -2 )
	tool_CategoryPanel:SetTall( 18 )
	tool_CategoryPanel.Paint = nil

	local tool_CategoryButton = vgui.Create( 'DButton', tool_CategoryPanel )
	tool_CategoryButton:Dock( FILL )
	tool_CategoryButton:SetText( '#frespawnmenu.categories' )

	local tool_cp_sp_panel = vgui.Create( 'DPanel', action_panel_div )

	local function drawLiteToolBackground( pnl )
		pnl.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, color_panel_tool_content )
		end
	end

	local tool_cp_sp = vgui.Create( 'DCategoryList', tool_cp_sp_panel )
	tool_cp_sp:Dock( FILL )

	if ( !frespawnmenu_simple_tabs:GetBool() ) then
		tool_cp_sp:DockMargin( 2, 4, 2, 4 )

		drawLiteToolBackground( tool_cp_sp_panel )

		tool_cp_sp.Paint = nil
	else
		tool_cp_sp:DockMargin( 6, 6, 6, 6 )

		drawLiteToolBackground( tool_cp_sp )
	end

	if ( frespawnmenu_tool_right:GetBool() ) then
		action_panel_div:SetRight( tool_cp_sp_panel )
	else
		action_panel_div:SetLeft( tool_cp_sp_panel )
	end

	local function create_tool( item )
		local cp = vgui.Create( 'ControlPanel', tool_cp_sp )
		cp:Dock( FILL )
		cp:SetLabel( item.Text )

		item.CPanelFunction( cp )

		local PanSplit = vgui.Create( 'DPanel', cp )
		PanSplit:SetTall( 6 )
		PanSplit:Dock( TOP )
		PanSplit.Paint = nil
	end

	local function ToolAction( tool, fav_tools, category, item_data )
		local tool_btn = vgui.Create( 'DButton', category )
		tool_btn:Dock( TOP )
		tool_btn:SetText( tool.Text )

		local cnt = tool.Controls
		local name = tool.ItemName

		tool_btn.id = cnt

		if ( table.HasValue( fav_tools, name ) ) then -- Preset favorite tool
			tool_btn.fav = true
		end

		tool_btn.DoClick = function()
			if ( GetConVar( 'gmod_toolmode' ):GetString() == name ) then
				return
			end

			soundPlay()

			spawnmenu.ActivateTool( name )

			RunConsoleCommand( 'frespawnmenu_save_tool', util.TableToJSON( item_data ) )

			tool_cp_sp:Clear()

			if ( tool.CPanelFunction != nil ) then
				create_tool( tool )
			end
		end
		tool_btn.DoRightClick = function()
			local DM = DermaMenu()
			DM:SetSkin( menu_skin )

			if ( not tool_btn.fav ) then
				local fav = DM:AddOption( '#frespawnmenu.fav_add', function()
					soundPlay( 'garrysmod/content_downloaded.wav' )

					table.insert( fav_tools, tool.ItemName )

					file.Write( 'frespawnmenu_fav_tools.json', util.TableToJSON( fav_tools ) )

					tool_btn.fav = true
				end )
				fav.Paint = nil
				fav:SetIcon( 'icon16/star.png' )
			else
				local remove_fav = DM:AddOption( '#frespawnmenu.fav_remove', function()
					soundPlay( 'garrysmod/content_downloaded.wav' )

					table.RemoveByValue( fav_tools, tool.ItemName )

					file.Write( 'frespawnmenu_fav_tools.json', util.TableToJSON( fav_tools ) )

					tool_btn.fav = false
				end )
				remove_fav.Paint = nil
				remove_fav:SetIcon( 'icon16/cross.png' )
			end

			DM:Open()
		end
	end

	local function tools_create( tool, category_id )
		local favorites_tool = util.JSONToTable( file.Read( 'frespawnmenu_fav_tools.json', 'DATA' ) or '[]' )

		tool_sp:Clear()

		for category_num, category in ipairs( tool.Items ) do
			local CollapsibleTool = vgui.Create( 'DCollapsibleCategory', tool_sp )
			CollapsibleTool:Dock( TOP )
			CollapsibleTool:SetLabel( category.Text )

			for item_num, item in ipairs( category ) do
				ToolAction( item, favorites_tool, CollapsibleTool, { category_id, category_num, item_num } )
			end
		end
	end

	local function FavToolsCreate()
		local favorites_tool = util.JSONToTable( file.Read( 'frespawnmenu_fav_tools.json', 'DATA' ) or '[]' )

		local Favorite_Category = vgui.Create( 'DCollapsibleCategory', tool_sp )
		Favorite_Category:Dock( TOP )
		Favorite_Category:SetLabel( '#frespawnmenu.favourites' )

		for category_tab_id, tools_tab in ipairs( spawnmenu_tools ) do
			for category_num, category in pairs( tools_tab.Items ) do
				for tool_num, tool in pairs( category ) do
					if ( table.HasValue( favorites_tool, tool.ItemName ) ) then
						ToolAction( tool, favorites_tool, Favorite_Category, { category_tab_id, category_num, tool_num } )
					end
				end
			end
		end
	end

	local function ClickToCreateFavTools()
		soundPlay()

		tool_sp:Clear()

		FavToolsCreate()
	end

	local function OpenCategoriesDM()
		local DM = DermaMenu()
		DM:SetSkin( menu_skin )

		for category_id, tool in ipairs( spawnmenu_tools ) do
			local btn = DM:AddOption( tool.Label, function()
				soundPlay()

				tools_create( tool, category_id )
			end )
			btn:SetIcon( tool.Icon )
			btn.Paint = nil
		end

		DM:AddSpacer()

		local favorites_tool = util.JSONToTable( file.Read( 'frespawnmenu_fav_tools.json', 'DATA' ) or '[]' )

		if ( table.Count( favorites_tool ) != 0 ) then
			local fav_option = DM:AddOption( '#frespawnmenu.favourites', function()
				ClickToCreateFavTools()
			end )
			fav_option.Paint = nil
			fav_option:SetIcon( 'icon16/star.png' )
		end

		DM:Open()
	end

	tool_CategoryButton.DoClick = function()
		OpenCategoriesDM()
	end
	tool_CategoryButton.DoRightClick = function()
		OpenCategoriesDM()
	end
	tool_CategoryButton.DoMiddleClick = function()
		ClickToCreateFavTools()
	end

	if ( frespawnmenu_tool_drawer:GetBool() ) then
		local ToolDrawer = vgui.Create( 'DDrawer', ToolPanel )
		ToolDrawer:SetOpenTime( 0.2 )
		ToolDrawer.ToggleButton:SetText( '' )
		ToolDrawer.tall = 18

		local DrawerPanel = vgui.Create( 'DPanel', ToolDrawer )
		DrawerPanel:Dock( FILL )

		local DrawerContentPanel = vgui.Create( 'DPanel', DrawerPanel )
		DrawerContentPanel:Dock( FILL )
		DrawerContentPanel:DockMargin( 6, 12, 6, 6 )
		DrawerContentPanel.Paint = nil
		DrawerContentPanel.num = 0

		local function CreateDrawerCheckBox( title, cvar )
			local DrawerCheckbox = vgui.Create( 'DCheckBoxLabel', DrawerContentPanel )
			DrawerCheckbox:Dock( TOP )

			if ( DrawerContentPanel.num > 0 ) then
				DrawerCheckbox:DockMargin( 0, 8, 0, 0 )

				ToolDrawer.tall = ToolDrawer.tall + 8
			end

			DrawerCheckbox:SetText( title )
			DrawerCheckbox:SetTooltip( title )
			DrawerCheckbox:SetChecked( GetConVar( cvar ):GetBool() )
			DrawerCheckbox:SetDark( true )

			function DrawerCheckbox:OnChange( val )
				RunConsoleCommand( cvar, DrawerCheckbox:GetChecked() and '1' or '0' )
				RunConsoleCommand( 'frespawnmenu_rebuild' )
			end

			DrawerContentPanel.num = DrawerContentPanel.num + 1
			ToolDrawer.tall = ToolDrawer.tall + 15
		end

		CreateDrawerCheckBox( '#frespawnmenu.tool.tool_right', 'frespawnmenu_tool_right' )
		CreateDrawerCheckBox( '#frespawnmenu.tool.scrollbar_tools', 'frespawnmenu_scrollbar_tools' )
		CreateDrawerCheckBox( 'Tool Drawer', 'frespawnmenu_tool_drawer' )
		CreateDrawerCheckBox( '#frespawnmenu.tool.fav_startup', 'frespawnmenu_fav_startup' )
		CreateDrawerCheckBox( '#frespawnmenu.tool.quick_category_buttons', 'frespawnmenu_quick_category_buttons' )

		ToolDrawer:SetOpenSize( ToolDrawer.tall )
	end

	local save_tool_data = util.JSONToTable( frespawnmenu_save_tool:GetString() )

	tool_CategoryPanel.category_nav = save_tool_data[ 1 ]

	if ( frespawnmenu_quick_category_buttons:GetBool() ) then
		local save_tool_data = util.JSONToTable( frespawnmenu_save_tool:GetString() )

		local tool_NavigationPanel = vgui.Create( 'DPanel', tool_CategoryPanel )
		tool_NavigationPanel:Dock( RIGHT )
		tool_NavigationPanel:DockMargin( 2, 0, 0, 0 )
		tool_NavigationPanel:SetWide( 38 )
		tool_NavigationPanel.Paint = nil

		local tool_PrevButton = vgui.Create( 'DButton', tool_NavigationPanel )
		tool_PrevButton:Dock( LEFT )
		tool_PrevButton:SetWide( 18 )
		tool_PrevButton:SetText( '' )

		local tool_NextButton = vgui.Create( 'DButton', tool_NavigationPanel )
		tool_NextButton:Dock( RIGHT )
		tool_NextButton:SetWide( 18 )
		tool_NextButton:SetText( '' )

		tool_PrevButton.DoClick = function()
			tool_CategoryPanel.category_nav = tool_CategoryPanel.category_nav - 1

			if ( tool_CategoryPanel.category_nav < 1 ) then
				tool_CategoryPanel.category_nav = 1
			else
				soundPlay()

				tool_PrevButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav - 1 < 1 and 1 or tool_CategoryPanel.category_nav - 1 ].Icon )
				tool_NextButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav + 1 ].Icon )

				tools_create( spawnmenu_tools[ tool_CategoryPanel.category_nav ], tool_CategoryPanel.category_nav )
			end
		end

		tool_NextButton.DoClick = function()
			tool_CategoryPanel.category_nav = tool_CategoryPanel.category_nav + 1

			if ( tool_CategoryPanel.category_nav > #spawnmenu_tools ) then
				tool_CategoryPanel.category_nav = #spawnmenu_tools
			else
				soundPlay()

				tool_PrevButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav - 1 ].Icon )
				tool_NextButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav + 1 > #spawnmenu_tools and #spawnmenu_tools or tool_CategoryPanel.category_nav + 1 ].Icon )

				tools_create( spawnmenu_tools[ tool_CategoryPanel.category_nav ], tool_CategoryPanel.category_nav )
			end
		end

		tool_PrevButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav - 1 < 1 and 1 or tool_CategoryPanel.category_nav - 1 ].Icon )
		tool_NextButton.nav_icon = Material( spawnmenu_tools[ tool_CategoryPanel.category_nav + 1 > #spawnmenu_tools and #spawnmenu_tools or tool_CategoryPanel.category_nav + 1 ].Icon )

		tool_PrevButton.DoRightClick = function()
			OpenCategoriesDM()
		end
		tool_NextButton.DoRightClick = function()
			OpenCategoriesDM()
		end
	end

	// Setting standard settings when opening for the first time

	local active_category = spawnmenu_tools[ save_tool_data[ 1 ] ] or spawnmenu_tools[ 1 ]
	local active_tool_category = active_category.Items[ save_tool_data[ 2 ] ] or active_category.Items[ 1 ]
	local active_tool = active_tool_category[ save_tool_data[ 3 ] ] or active_tool_category[ 1 ]

	if ( frespawnmenu_fav_startup:GetBool() ) then
		FavToolsCreate()
	else
		tools_create( active_category, save_tool_data[ 1 ] )
	end

	create_tool( active_tool )

	if ( !frespawnmenu_simple_tabs:GetBool() ) then
		for k, tab in pairs( FreSpawnMenu.Tabs ) do
			if ( tab.Title == frespawnmenu_content:GetString() ) then
				FreSpawnMenu.Tabs[ k ].Panel:SetVisible( true )
			end
		end
	else
		local TabsSheet = vgui.Create( 'CreationMenu', action_panel_content_scroll )
		TabsSheet:Dock( FILL )

		local tabs_list = TabsSheet:GetItems()

		function TabsSheet:OnActiveTabChanged( pan_old, pan_new )
			for m, tab_par in pairs( tabs_list ) do
				if ( tab_par.Tab == pan_new and tab_par.Name != frespawnmenu_content:GetString() ) then
					RunConsoleCommand( 'frespawnmenu_content', tab_par.Name )
				end
			end
		end

		for m, tab_par in pairs( tabs_list ) do
			if ( tab_par.Name == frespawnmenu_content:GetString() ) then
				TabsSheet:SetActiveTab( tab_par.Tab )
			end

			if ( data_tabs.renamed[ tab_par.Name ] ) then
				tab_par.Tab:SetText( data_tabs.renamed[ tab_par.Name ] )
			end
		end
	end
end

hook.Add( 'OnSpawnMenuOpen', 'FreSpawnMenuOpen', function()
	if ( GetConVar( 'frespawnmenu' ):GetBool() and IsValid( g_SpawnMenu ) ) then
		RestoreCursorPosition()

		if ( not IsValid( FreSpawnMenu ) ) then
			hook.Run( 'PreReloadToolsMenu' )

			spawnmenu.ClearToolMenus()

			hook.Run( 'AddGamemodeToolMenuTabs' )
			hook.Run( 'AddToolMenuTabs' )
			hook.Run( 'AddGamemodeToolMenuCategories' )
			hook.Run( 'AddToolMenuCategories' )
			hook.Run( 'PopulateToolMenu' )

			openFreMenu()

			hook.Run( 'PostReloadToolsMenu' )
		else
			FreSpawnMenu:SetVisible( true )
		end

		FreSpawnMenu.m_bHangOpen = false

		hook.Call( 'SpawnMenuOpened', self )

		return false
	end
end )

hook.Add( 'OnSpawnMenuClose', 'FreSpawnMenuClose', function()
	if ( GetConVar( 'frespawnmenu' ):GetBool() and IsValid( g_SpawnMenu ) ) then
		RememberCursorPosition()

		if ( IsValid( FreSpawnMenu ) ) then
			if ( FreSpawnMenu.m_bHangOpen ) then

				FreSpawnMenu.m_bHangOpen = false

				return
			end

			FreSpawnMenu:SetVisible( false )
		end

		if ( IsValid( g_SpawnMenu ) ) then
			g_SpawnMenu:SetVisible( false )
		end

		hook.Call( 'SpawnMenuClosed', self )

		return false
	elseif ( IsValid( FreSpawnMenu ) ) then
		FreSpawnMenu:Remove()
	end
end )

hook.Add( 'OnTextEntryGetFocus', 'FreSpawnMenuFocusOn', function( pnl )
	if ( IsValid( FreSpawnMenu ) && IsValid( pnl ) && pnl:HasParent( FreSpawnMenu ) ) then
		FreSpawnMenu:StartKeyFocus( pnl )
	end
end )

hook.Add( 'OnTextEntryLoseFocus', 'FreSpawnMenuFocusOff', function( pnl )
	if ( IsValid( FreSpawnMenu ) && IsValid( pnl ) && pnl:HasParent( FreSpawnMenu ) ) then
		FreSpawnMenu:EndKeyFocus( pnl )
	end
end )

// Console command to recreate the menu

concommand.Add( 'frespawnmenu_rebuild', function()
	if ( IsValid( FreSpawnMenu ) ) then
		if ( FreSpawnMenu:IsVisible() ) then
			soundPlay( frespawnmenu_custom_sound:GetBool() and 'frespawnmenu/frame_close.ogg' )
		end

		FreSpawnMenu:Remove()

		FreSpawnMenu = nil
	end
end )

// Custom menu settings

hook.Add( 'PopulateToolMenu', 'FreSpawnMenuTool', function()
	spawnmenu.AddToolMenuOption( 'Utilities', 'User', 'SpawnMenu', 'FreSpawnMenu', '', '', function( panel )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.status', Command = 'frespawnmenu' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.blur', Command = 'frespawnmenu_blur' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.adaptive_wide_nav', Command = 'frespawnmenu_adaptive_wide_nav' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.sounds', Command = 'frespawnmenu_sounds' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.custom_sound', Command = 'frespawnmenu_custom_sound' } )

		panel:AddControl( 'Button', { Label = '#frespawnmenu.tool.rebuild', Command = 'frespawnmenu_rebuild' } )

		panel:AddControl( 'Header', { Description = '#frespawnmenu.tool.rebuild_info' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.window', Command = 'frespawnmenu_frame' } )

		if ( frespawnmenu_frame:GetBool() ) then
			panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.frame_blur', Command = 'frespawnmenu_frame_blur' } )
		end

		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.menubar', Command = 'frespawnmenu_menubar' } )
		panel:AddControl( 'Slider', { Label = '#frespawnmenu.tool.size', Command = 'frespawnmenu_size', Min = 0.5, Max = 1.05, Type = 'float' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.tab_icon', Command = 'frespawnmenu_tab_icon' } )
		panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.simple_tabs', Command = 'frespawnmenu_simple_tabs' } )

		if ( !frespawnmenu_tool_drawer:GetBool() ) then
			panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.tool_right', Command = 'frespawnmenu_tool_right' } )
			panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.scrollbar_tools', Command = 'frespawnmenu_scrollbar_tools' } )
			panel:AddControl( 'CheckBox', { Label = 'Tool Drawer', Command = 'frespawnmenu_tool_drawer' } )
			panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.fav_startup', Command = 'frespawnmenu_fav_startup' } )
			panel:AddControl( 'CheckBox', { Label = '#frespawnmenu.tool.quick_category_buttons', Command = 'frespawnmenu_quick_category_buttons' } )
		end

		panel:AddControl( 'Header', { Description = 'Derma Skin:' } )

		local SkinChanger = vgui.Create( 'DComboBox', panel )
		SkinChanger:Dock( TOP )
		SkinChanger:DockMargin( 10, 8, 10, 0 )
		SkinChanger:SetValue( frespawnmenu_derma_skin:GetString() )
		SkinChanger.OnSelect = function( self, index, value, data )
			RunConsoleCommand( 'frespawnmenu_derma_skin', data )
			RunConsoleCommand( 'frespawnmenu_rebuild' )
		end

		for skin, skindata in pairs( derma.SkinList ) do
			SkinChanger:AddChoice( skindata.PrintName, skin )
		end
	end )
end )
