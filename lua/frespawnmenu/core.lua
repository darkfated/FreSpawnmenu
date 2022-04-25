CreateClientConVar( 'frespawnmenu', 1, true )
CreateClientConVar( 'frespawnmenu_content', '#spawnmenu.content_tab', true )
CreateClientConVar( 'frespawnmenu_blur', 1, true )

local function DrawRect( x, y, w, h, t )
	if ( not t ) then
		t = 1
	end

	surface.DrawRect( x, y, w, t )
	surface.DrawRect( x, y + h - t, w, t )
	surface.DrawRect( x, y, t, h )
	surface.DrawRect( x + w - t, y, t, h )
end

local Mat = Material( 'pp/blurscreen' )
local color_white = Color(255,255,255)
local color_gray = Color(70,70,70,200)
local color_blue = Color(47,96,255)
local color_button = Color(226,226,226)
local color_panel = Color(202,202,202,200)
local color_icon_depressed = Color(230,230,230)
local color_panel_tool_content = Color(255,255,255,100)
local color_panel_dm = Color(230,230,230)
local scrw, scrh = ScrW(), ScrH()

local function freBlur( panel, amount )
	if ( GetConVar( 'frespawnmenu_blur' ):GetBool() ) then
		local x, y = panel:LocalToScreen( 0, 0 )

		surface.SetDrawColor( color_white )
		surface.SetMaterial( Mat )

		for i = 1, 3 do
			Mat:SetFloat( '$blur', i * 0.3 * ( amount or 8 ) )
			Mat:Recompute()

			render.UpdateScreenEffectTexture()

			surface.DrawTexturedRect( x * -1, y * -1, scrw, scrh )
		end
	end
end

local function freOutlinedBox( x, y, w, h, col, bordercol, thickness )
	surface.SetDrawColor( col )
	surface.DrawRect( x + 1, y + 1, w - 2, h - 2 )

	surface.SetDrawColor( bordercol )

	DrawRect( x, y, w, h, thickness )
end

local function frePanel( self, w, h )
	freBlur( self )
	freOutlinedBox( 0, 0, w, h, color_panel, color_gray )
end

local function freButton( self, w, h, name )
	draw.RoundedBox( 4, 0, 0, w, h, GetConVar( 'frespawnmenu_content' ):GetString() == name and color_blue or GetConVar( 'gmod_toolmode' ):GetString() == name and color_blue or color_gray )

	local bor = self:IsHovered() and 2 or 1

	draw.RoundedBox( 4, bor, bor, w - bor * 2, h - bor * 2, color_button )
end

local function soundPlay( snd )
	surface.PlaySound( snd == nil and 'UI/buttonclickrelease.wav' or snd )
end

local function openFreMenu()
	scrw, scrh = ScrW(), ScrH() -- Resetting the permission when recreating the menu

	achievements.SpawnMenuOpen()

	local spawn_w = math.min( scrw - 10, scrw * 0.92 )

	FreSpawnMenu = vgui.Create( 'DPanel' )
	FreSpawnMenu:SetSize( spawn_w, math.min( scrh - 10, scrh * 0.95 )  )
	FreSpawnMenu:Center()
	FreSpawnMenu:MakePopup()
	FreSpawnMenu:SetKeyboardInputEnabled( false )
	FreSpawnMenu:SetMouseInputEnabled( true )
	FreSpawnMenu:SetSkin( 'fsm' )
	FreSpawnMenu.Paint = nil

	// Separation into Spawn and Tool part

	local global_div = vgui.Create( 'DHorizontalDivider', FreSpawnMenu )
	global_div:Dock( FILL )
	global_div:SetDividerWidth( 4 )

	local MainPanel = vgui.Create( 'DPanel', global_div )
	MainPanel:SetWide( spawn_w )
	MainPanel.Paint = nil

	local ToolPanel = vgui.Create( 'DPanel', global_div )
	ToolPanel.Paint = function( self, w, h )
		frePanel( self, w, h )
	end

	global_div:SetLeft( MainPanel )
	global_div:SetLeftWidth( spawn_w - 160 ) 
	global_div:SetLeftMin( spawn_w * 0.8 )
	global_div:SetRight( ToolPanel )
	global_div:SetRightMin( 120 )

	// Splitting the Spawn part into a selection of tabs and an action bar

	local spawn_div = vgui.Create( 'DVerticalDivider', MainPanel )
	spawn_div:SetWide( MainPanel:GetWide() )
	spawn_div:Dock( FILL )
	spawn_div:SetDividerHeight( 4 )

	local tabs_panel = vgui.Create( 'DPanel', spawn_div )
	tabs_panel.Paint = function( self, w, h )
		frePanel( self, w, h )
	end

	local action_panel = vgui.Create( 'DPanel', spawn_div )
	action_panel.Paint = function( self, w, h )
		frePanel( self, w, h )
	end

	local action_panel_div = vgui.Create( 'DHorizontalDivider', action_panel )
	action_panel_div:Dock( FILL )
	action_panel_div:DockMargin( 6, 6, 6, 6 )
	action_panel_div:SetDividerWidth( 4 )

	local action_panel_content = vgui.Create( 'DPanel', action_panel_div )
	action_panel_content.Paint = nil

	action_panel_div:SetLeft( action_panel_content )
	action_panel_div:SetLeftWidth( spawn_div:GetWide() )
	action_panel_div:SetRightMin( 0 )

	local tab_panel_sp = vgui.Create( 'DHorizontalScroller', tabs_panel )
	tab_panel_sp:Dock( FILL )
	tab_panel_sp:DockMargin( 6, 6, 6, 6 )
	tab_panel_sp:SetOverlap( -4 )

	surface.SetFont( 'Default' )

	for name, v in SortedPairsByMemberValue( spawnmenu.GetCreationTabs(), 'Order' ) do
		local btn_item = vgui.Create( 'DButton', tab_panel_sp )
		btn_item:SetWide( surface.GetTextSize( name ) + 44 )
		btn_item:SetText( name )

		local function OpenContent()
			if ( GetConVar( 'frespawnmenu_content' ):GetString() == name ) then
				return
			end

			soundPlay( 'buttons/lightswitch2.wav' )

			action_panel_content:Clear()

			local content = v.Function()
			content:SetParent( action_panel_content )
			content:Dock( FILL )
			content:SetSkin( 'fsm' )

			RunConsoleCommand( 'frespawnmenu_content', name )
		end

		btn_item.DoClick = function( self, w, h )
			OpenContent()
		end
		btn_item.Paint = function( self, w, h )
			freButton( self, w, h, name )
		end

		local icon_pan = vgui.Create( 'DButton', tab_panel_sp )
		icon_pan:SetWide( 22 )
		icon_pan:SetText( '' )
		icon_pan.Paint = function( self, w, h )
			surface.SetDrawColor( self.Depressed and GetConVar( 'frespawnmenu_content' ):GetString() != name and color_icon_depressed or color_white )
			surface.SetMaterial( Material( v.Icon ) )
			surface.DrawTexturedRect( 4, h * 0.5 - 8, w - 8, 16 )
		end
		icon_pan.DoClick = function()
			OpenContent()
		end

		tab_panel_sp:AddPanel( icon_pan )
		tab_panel_sp:AddPanel( btn_item )
	end

	local PanelEnd = vgui.Create( 'DPanel', tab_panel_sp )
	PanelEnd:SetWide( 4 )
	PanelEnd.Paint = function( self, w, h )
		freOutlinedBox( 0, 0, w, h, color_white, color_gray )
	end

	tab_panel_sp:AddPanel( PanelEnd )

	spawn_div:SetTop( tabs_panel )
	spawn_div:SetTopMin( 34 )
	spawn_div:SetTopMax( 80 )
	spawn_div:SetTopHeight( spawn_div:GetTopMin() )
	spawn_div:SetBottom( action_panel )

	// Splitting the Spawn part into a list of tools

	local tool_sp = vgui.Create( 'DScrollPanel', ToolPanel )
	tool_sp:Dock( FILL )
	tool_sp:DockMargin( 6, 6, 6, 6 )
	tool_sp:GetVBar():SetWide( 0 )

	local tool_CategoryButton = vgui.Create( 'DButton', ToolPanel )
	tool_CategoryButton:Dock( TOP )
	tool_CategoryButton:DockMargin( 4, 4, 4, -2 )
	tool_CategoryButton:SetTall( 18 )
	tool_CategoryButton:SetText( 'Categories' )
	tool_CategoryButton.Paint = function( self, w, h )
		freButton( self, w, h )
	end

	local tool_cp_sp = vgui.Create( 'DScrollPanel', action_panel_div )
	tool_cp_sp:DockMargin( 6, 0, 0, 0 )
	tool_cp_sp.Paint = function( self, w, h )
		draw.RoundedBox( 6, 0, 0, w, h, color_panel_tool_content )
	end

	action_panel_div:SetRight( tool_cp_sp )

	local function tools_create( tool )
		tool_sp:Clear()

		for _, category in ipairs( tool.Items ) do
			local CollapsibleTool = vgui.Create( 'DCollapsibleCategory', tool_sp )
			CollapsibleTool:Dock( TOP )
			CollapsibleTool:SetLabel( category.Text )

			for _, item in ipairs( category ) do
				local tool_btn = vgui.Create( 'DButton', CollapsibleTool )
				tool_btn:Dock( TOP )
				-- tool_btn:DockMargin( 0, 4, 0, 0 )
				tool_btn:SetText( item.Text )

				local cnt = item.Controls
				local name = item.ItemName

				tool_btn.Paint = function( self, w, h )
					freButton( self, w, h, cnt )
				end
				tool_btn.DoClick = function()
					if ( GetConVar( 'gmod_toolmode' ):GetString() == item.ItemName ) then
						return
					end

					soundPlay()

					spawnmenu.ActivateTool( name )

					tool_cp_sp:Clear()

					if ( item.CPanelFunction != nil ) then
						action_panel_div:SetRightMin( math.min( 300, spawn_w * 0.32 ) )
	
						local cp = vgui.Create( 'ControlPanel', tool_cp_sp )
						cp:Dock( FILL )
						cp:SetLabel( item.Text )

						item.CPanelFunction( cp )

						local PanSplit = vgui.Create( 'DPanel', cp )
						PanSplit:SetTall( 6 )
						PanSplit:Dock( TOP )
						PanSplit.Paint = nil
					end
				end
			end
		end
	end

	tool_CategoryButton.DoClick = function()
		local DM = DermaMenu()
		DM.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, color_gray )
			draw.RoundedBox( 4, 1, 1, w - 2, h - 2, color_panel_dm )
		end

		for _, tool in ipairs( spawnmenu.GetTools() ) do
			local btn = DM:AddOption( tool.Label, function()
				soundPlay()

				tools_create( tool )
			end )
			btn:SetIcon( tool.Icon )
			btn.Paint = nil

			-- DM:AddSpacer()
		end

		DM:Open()
	end

	// Setting standard settings when opening for the first time

	for _, tool in ipairs( spawnmenu.GetTools() ) do
		if ( _ == 1 ) then
			tools_create( tool )
		end
	end

	for k, v in SortedPairsByMemberValue( spawnmenu.GetCreationTabs(), 'Order' ) do
		if ( k == GetConVar( 'frespawnmenu_content' ):GetString() ) then
			local content = v.Function()
			content:SetParent( action_panel_content )
			content:Dock( FILL )
			content:SetSkin( 'fsm' )
		end
	end
end

hook.Add( 'OnSpawnMenuOpen', 'FreSpawnMenuOpen', function()
	if ( GetConVar( 'frespawnmenu' ):GetBool() ) then
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

		hook.Call( 'SpawnMenuOpened', self )

		return false
	end
end )

hook.Add( 'OnSpawnMenuClose', 'FreSpawnMenuClose', function()
	if ( GetConVar( 'frespawnmenu' ):GetBool() ) then
		RememberCursorPosition()

		if ( IsValid( FreSpawnMenu ) ) then
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

// Console command to recreate the menu

concommand.Add( 'frespawnmenu_rebuild', function()
	if ( IsValid( FreSpawnMenu ) ) then
		FreSpawnMenu:Remove()

		FreSpawnMenu = nil
	end
end )

// Custom menu settings

hook.Add( 'PopulateToolMenu', 'FreSpawnMenuTool', function()
	spawnmenu.AddToolMenuOption( 'Utilities', 'User', 'SpawnMenu', 'FreSpawnMenu', '', '', function( panel )
		panel:AddControl( 'CheckBox', { Label = 'Menu activation status (enabled for operation or not)', Command = 'frespawnmenu' } )
		panel:AddControl( 'CheckBox', { Label = 'Blur for background', Command = 'frespawnmenu_blur' } )
		panel:AddControl( 'Button', { Label = 'Rebuild SpawnMenu', Command = 'frespawnmenu_rebuild' } )
	end )
end )
