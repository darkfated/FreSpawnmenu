CreateClientConVar( 'frespawnmenu', 1, true )
CreateClientConVar( 'frespawnmenu_content', '#spawnmenu.content_tab', true )

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
local color_white = Color(255, 255, 255)
local color_gray = Color(70,70,70,200)
local color_blue = Color(47,96,255)
local scrw, scrh = ScrW(), ScrH()

function freBlur( panel, amount )
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

local function freOutlinedBox( x, y, w, h, col, bordercol, thickness )
	surface.SetDrawColor( col )
	surface.DrawRect( x + 1, y + 1, w - 2, h - 2 )

	surface.SetDrawColor( bordercol )

	DrawRect( x, y, w, h, thickness )
end

local function frePanel( self, w, h )
	freBlur( self )
	freOutlinedBox( 0, 0, w, h, Color(202,202,202,200), color_gray )
end

local function freButton( self, w, h, name )
	draw.RoundedBox( 4, 0, 0, w, h, GetConVar( 'frespawnmenu_content' ):GetString() == name and color_blue or GetConVar( 'gmod_toolmode' ):GetString() == name and color_blue or color_gray )

	local bor = self:IsHovered() and 2 or 1

	draw.RoundedBox( 4, bor, bor, w - bor * 2, h - bor * 2, Color(226,226,226) )
end

local function soundPlay( snd )
	surface.PlaySound( snd == nil and 'UI/buttonclickrelease.wav' or snd )
end

local function openFreMenu()
	achievements.SpawnMenuOpen()

	local spawn_w = math.min( scrw - 10, scrw * 0.92 )

	FreSpawnMenu = vgui.Create( 'DPanel' )
	FreSpawnMenu:SetSize( spawn_w, math.min( scrh - 10, scrh * 0.95 )  )
	FreSpawnMenu:Center()
	FreSpawnMenu:MakePopup()
	FreSpawnMenu:SetKeyboardInputEnabled( false )
	FreSpawnMenu:SetMouseInputEnabled( true )
	FreSpawnMenu.Paint = nil

	// Separation into Spawn and Tool part

	local global_div = vgui.Create( 'DHorizontalDivider', FreSpawnMenu )
	global_div:Dock( FILL )
	global_div:SetDividerWidth( 4 )

	local MainPanel = vgui.Create( 'DPanel', global_div )
	MainPanel:SetWide( spawn_w * 0.7 )
	MainPanel.Paint = nil

	local ToolPanel = vgui.Create( 'DPanel', global_div )
	ToolPanel.Paint = function( self, w, h )
		frePanel( self, w, h )
	end

	global_div:SetLeft( MainPanel )
	global_div:SetLeftWidth( spawn_w - 150 ) 
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

	local action_panel_content = vgui.Create( 'DPanel', action_panel )
	action_panel_content:Dock( FILL )
	action_panel_content:DockMargin( 6, 6, 6, 6 )
	action_panel_content.Paint = nil

	local tab_panel_sp = vgui.Create( 'DHorizontalScroller', tabs_panel )
	tab_panel_sp:Dock( FILL )
	tab_panel_sp:DockMargin( 6, 6, 6, 6 )
	tab_panel_sp:SetOverlap( -4 )

	surface.SetFont( 'Default' )

	for name, v in SortedPairsByMemberValue( spawnmenu.GetCreationTabs(), 'Order' ) do
		local btn_item = vgui.Create( 'DButton', tab_panel_sp )
		btn_item:SetWide( surface.GetTextSize( name ) + 44 )
		btn_item:SetText( name )
		-- btn_item:SetIcon( v.Icon )
		btn_item.DoClick = function( self, w, h )
			soundPlay( 'buttons/lightswitch2.wav' )

			if ( GetConVar( 'frespawnmenu_content' ):GetString() == name ) then
				return
			end

			action_panel_content:Clear()

			local content = v.Function()
			content:SetParent( action_panel_content )
			content:Dock( FILL )

			RunConsoleCommand( 'frespawnmenu_content', name )
		end
		btn_item.Paint = function( self, w, h )
			freButton( self, w, h, name )
		end

		local icon_pan = vgui.Create( 'DPanel', tab_panel_sp )
		icon_pan:SetWide( 22 )
		icon_pan.Paint = function( self, w, h )
			surface.SetDrawColor( color_white )
			surface.SetMaterial( Material( v.Icon ) )
			surface.DrawTexturedRect( 2, h * 0.5 - 10, w - 4, 20 )
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

	for _, tool in ipairs( spawnmenu.GetTools() ) do
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

				tool_btn.Paint = function( self, w, h )
					freButton( self, w, h, cnt )
				end
				tool_btn.DoClick = function()
					soundPlay()

					if ( IsValid( FreSpawnMenu_cp_sp ) ) then
						FreSpawnMenu_cp_sp:Remove()
					end
					
					FreSpawnMenu_cp_sp = vgui.Create( 'DScrollPanel', action_panel_content )
					FreSpawnMenu_cp_sp:SetWide( action_panel_content:GetWide() * 0.32 )
					FreSpawnMenu_cp_sp:Dock( RIGHT )
					FreSpawnMenu_cp_sp:DockMargin( 6, 0, 0, 0 )
					FreSpawnMenu_cp_sp.Paint = function( self, w, h )
						draw.RoundedBox( 6, 0, 0, w, h, Color(255,255,255,100) )
					end

					local cp = vgui.Create( 'ControlPanel', FreSpawnMenu_cp_sp )
					cp:Dock( FILL )
					cp:SetLabel( item.Text )

					item.CPanelFunction( cp )

					local PanSplit = vgui.Create( 'DPanel', cp )
					PanSplit:SetTall( 2 )
					PanSplit:Dock( TOP )
					PanSplit.Paint = nil

					RunConsoleCommand( 'gmod_tool', cnt )
				end
			end
		end
	end

	for k, v in SortedPairsByMemberValue( spawnmenu.GetCreationTabs(), 'Order' ) do
		if ( k == '#spawnmenu.content_tab' ) then
			local content = v.Function()
			content:SetParent( action_panel_content )
			content:Dock( FILL )
		end
	end
end

hook.Add( 'OnSpawnMenuOpen', 'FreSpawnMenuOpen', function()
	if ( GetConVar( 'frespawnmenu' ):GetBool() ) then
		RestoreCursorPosition()

		if ( not IsValid( FreSpawnMenu ) ) then
			openFreMenu()
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

		FreSpawnMenu:SetVisible( false )
		-- FreSpawnMenu:Remove()

		hook.Call( 'SpawnMenuClosed', self )

		return false
	end
end )
