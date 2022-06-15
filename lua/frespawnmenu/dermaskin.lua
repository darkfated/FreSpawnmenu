local surface = surface
local Color = Color
local mat = Material( 'pp/blurscreen' )
local color_white = Color(255,255,255)
local color_gray = Color(70,70,70,200)
local color_blue = Color(47,96,255)
local color_button = Color(226,226,226)
local color_orange = Color(255,145,0)
local scrw, scrh = ScrW(), ScrH()

local function Blur( panel )
	if ( !GetConVar( 'frespawnmenu_blur' ):GetBool() or GetConVar( 'frespawnmenu_frame' ):GetBool() and IsValid( FreSpawnMenu.lblTitle ) ) then
		return
	end
 
	local x, y = panel:LocalToScreen( 0, 0 )

	surface.SetDrawColor( color_white )
	surface.SetMaterial( mat )

	for i = 1, 3 do
		mat:SetFloat( '$blur', i * 2.4 )
		mat:Recompute()

		render.UpdateScreenEffectTexture()

		surface.DrawTexturedRect( x * -1, y * -1, scrw, scrh )
	end
end

local function ButtonPaint( self, w, h, name, fav_bool )
	local frespawnmenu_content = GetConVar( 'frespawnmenu_content' )
	local toolmode = GetConVar( 'gmod_toolmode' )

	draw.RoundedBox( 4, 0, 0, w, h, fav_bool and color_orange or ( ( frespawnmenu_content:GetString() == name or toolmode:GetString() == name ) and color_blue or color_gray ) )

	local bor = ( self:IsHovered() or fav_bool ) and 2 or 1

	draw.RoundedBox( 4, bor, bor, w - bor * 2, h - bor * 2, color_button )
end

SKIN = {}

SKIN.PrintName = 'FreSpawnMenu Skin'
SKIN.Author = 'Freline'
SKIN.DermaVersion = 1.1
SKIN.GwenTexture = Material( 'gwenskin/frespawnmenu_skin_1_1.png' )

SKIN.text_dark = Color( 0, 0, 0, 255 )
SKIN.colTextEntryText = Color( 0, 0, 0, 255 )
SKIN.colTextEntryTextHighlight = Color( 0, 120, 215, 255 )
SKIN.colTextEntryTextCursor = Color( 0, 0, 0, 255 )
SKIN.colTextEntryTextPlaceholder = Color( 109, 109, 109, 255 )

SKIN.tex = {}

SKIN.tex.Selection = GWEN.CreateTextureBorder( 384, 32, 31, 31, 4, 4, 4, 4 )
SKIN.tex.Shadow = GWEN.CreateTextureBorder( 448, 0, 31, 31, 8, 8, 8, 8 )

SKIN.tex.Panels = {}
SKIN.tex.Panels.Normal = GWEN.CreateTextureBorder( 256 + 64, 0, 63, 63, 16, 16, 16, 16 )
SKIN.tex.Panels.Bright = GWEN.CreateTextureBorder( 256 + 64, 0, 63, 63, 16, 16, 16, 16 )
SKIN.tex.Panels.Dark = GWEN.CreateTextureBorder( 256, 64, 63, 63, 16, 16, 16, 16 )
SKIN.tex.Panels.Highlight = GWEN.CreateTextureBorder( 256 + 64, 64, 63, 63, 16, 16, 16, 16 )

SKIN.tex.Tree = GWEN.CreateTextureBorder( 256, 128, 127, 127, 16, 16, 16, 16 )
SKIN.tex.Checkbox_Checked = GWEN.CreateTextureNormal( 448, 32, 15, 15 )
SKIN.tex.Checkbox = GWEN.CreateTextureNormal( 464, 32, 15, 15 )
SKIN.tex.CheckboxD_Checked = GWEN.CreateTextureNormal( 448, 48, 15, 15 )
SKIN.tex.CheckboxD = GWEN.CreateTextureNormal( 464, 48, 15, 15 )
SKIN.tex.RadioButton_Checked = GWEN.CreateTextureNormal( 448, 64, 15, 15 )
SKIN.tex.RadioButton = GWEN.CreateTextureNormal( 464, 64, 15, 15 )
SKIN.tex.RadioButtonD_Checked = GWEN.CreateTextureNormal( 448, 80, 15, 15 )
SKIN.tex.RadioButtonD = GWEN.CreateTextureNormal( 464, 80, 15, 15 )
SKIN.tex.TreePlus = GWEN.CreateTextureNormal( 448, 96, 15, 15 )
SKIN.tex.TreeMinus = GWEN.CreateTextureNormal( 464, 96, 15, 15 )
SKIN.tex.TextBox = GWEN.CreateTextureBorder( 0, 150, 127, 21, 4, 4, 4, 4 )
SKIN.tex.TextBox_Focus = GWEN.CreateTextureBorder( 0, 172, 127, 21, 4, 4, 4, 4 )
SKIN.tex.TextBox_Disabled = GWEN.CreateTextureBorder( 0, 194, 127, 21, 4, 4, 4, 4 )
SKIN.tex.MenuBG_Column = GWEN.CreateTextureBorder( 128, 128, 127, 63, 24, 8, 8, 8 )
SKIN.tex.MenuBG = GWEN.CreateTextureBorder( 128, 192, 127, 63, 8, 8, 8, 8 )
SKIN.tex.MenuBG_Hover = GWEN.CreateTextureBorder( 128, 256, 127, 31, 8, 8, 8, 8 )
SKIN.tex.MenuBG_Spacer = GWEN.CreateTextureNormal( 128, 288, 127, 3 )
SKIN.tex.Menu_Strip = GWEN.CreateTextureBorder( 0, 128, 127, 21, 8, 8, 8, 8 )
SKIN.tex.Menu_Check = GWEN.CreateTextureNormal( 448, 112, 15, 15 )
SKIN.tex.Tab_Control = GWEN.CreateTextureBorder( 0, 256, 127, 127, 8, 8, 8, 8 )
SKIN.tex.TabB_Active = GWEN.CreateTextureBorder( 0, 416, 63, 31, 8, 8, 8, 8 )
SKIN.tex.TabB_Inactive = GWEN.CreateTextureBorder( 128, 416, 63, 31, 8, 8, 8, 8 )
SKIN.tex.TabT_Active = GWEN.CreateTextureBorder( 0, 384, 63, 31, 8, 8, 8, 8 )
SKIN.tex.TabT_Inactive = GWEN.CreateTextureBorder( 128, 384, 63, 31, 8, 8, 8, 8 )
SKIN.tex.TabL_Active = GWEN.CreateTextureBorder( 64, 384, 31, 63, 8, 8, 8, 8 )
SKIN.tex.TabL_Inactive = GWEN.CreateTextureBorder( 64 + 128, 384, 31, 63, 8, 8, 8, 8 )
SKIN.tex.TabR_Active = GWEN.CreateTextureBorder( 96, 384, 31, 63, 8, 8, 8, 8 )
SKIN.tex.TabR_Inactive = GWEN.CreateTextureBorder( 96 + 128, 384, 31, 63, 8, 8, 8, 8 )
SKIN.tex.Tab_Bar = GWEN.CreateTextureBorder( 128, 352, 127, 31, 4, 4, 4, 4 )

SKIN.tex.Window = {}

SKIN.tex.Window.Normal = GWEN.CreateTextureBorder( 0, 0, 127, 127, 8, 24, 8, 8 )
SKIN.tex.Window.Inactive = GWEN.CreateTextureBorder( 128, 0, 127, 127, 8, 24, 8, 8 )

SKIN.tex.Window.Close = GWEN.CreateTextureNormal( 32, 448, 31, 24 )
SKIN.tex.Window.Close_Hover = GWEN.CreateTextureNormal( 64, 448, 31, 24 )
SKIN.tex.Window.Close_Down = GWEN.CreateTextureNormal( 96, 448, 31, 24 )

SKIN.tex.Window.Maxi = GWEN.CreateTextureNormal( 32 + 96 * 2, 448, 31, 24 )
SKIN.tex.Window.Maxi_Hover = GWEN.CreateTextureNormal( 64 + 96 * 2, 448, 31, 24 )
SKIN.tex.Window.Maxi_Down = GWEN.CreateTextureNormal( 96 + 96 * 2, 448, 31, 24 )

SKIN.tex.Window.Restore = GWEN.CreateTextureNormal( 32 + 96 * 2, 448 + 32, 31, 24 )
SKIN.tex.Window.Restore_Hover = GWEN.CreateTextureNormal( 64 + 96 * 2, 448 + 32, 31, 24 )
SKIN.tex.Window.Restore_Down = GWEN.CreateTextureNormal( 96 + 96 * 2, 448 + 32, 31, 24 )

SKIN.tex.Window.Mini = GWEN.CreateTextureNormal( 32 + 96, 448, 31, 24 )
SKIN.tex.Window.Mini_Hover = GWEN.CreateTextureNormal( 64 + 96, 448, 31, 24 )
SKIN.tex.Window.Mini_Down = GWEN.CreateTextureNormal( 96 + 96, 448, 31, 24 )

SKIN.tex.Scroller = {}
SKIN.tex.Scroller.TrackV = GWEN.CreateTextureBorder( 384, 208, 15, 127, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonV_Normal = GWEN.CreateTextureBorder( 384 + 16, 208, 15, 127, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonV_Hover = GWEN.CreateTextureBorder( 384 + 32, 208, 15, 127, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonV_Down = GWEN.CreateTextureBorder( 384 + 48, 208, 15, 127, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonV_Disabled = GWEN.CreateTextureBorder( 384 + 64, 208, 15, 127, 4, 4, 4, 4 )

SKIN.tex.Scroller.TrackH = GWEN.CreateTextureBorder( 384, 128, 127, 15, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonH_Normal = GWEN.CreateTextureBorder( 384, 128 + 16, 127, 15, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonH_Hover = GWEN.CreateTextureBorder( 384, 128 + 32, 127, 15, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonH_Down = GWEN.CreateTextureBorder( 384, 128 + 48, 127, 15, 4, 4, 4, 4 )
SKIN.tex.Scroller.ButtonH_Disabled = GWEN.CreateTextureBorder( 384, 128 + 64, 127, 15, 4, 4, 4, 4 )

SKIN.tex.Scroller.LeftButton_Normal = GWEN.CreateTextureBorder( 464, 208, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.LeftButton_Hover = GWEN.CreateTextureBorder( 480, 208, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.LeftButton_Down = GWEN.CreateTextureBorder( 464, 272, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.LeftButton_Disabled = GWEN.CreateTextureBorder( 480 + 48, 272, 15, 15, 2, 2, 2, 2 )

SKIN.tex.Scroller.UpButton_Normal = GWEN.CreateTextureBorder( 464, 208 + 16, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.UpButton_Hover = GWEN.CreateTextureBorder( 480, 208 + 16, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.UpButton_Down = GWEN.CreateTextureBorder( 464, 272 + 16, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.UpButton_Disabled = GWEN.CreateTextureBorder( 480 + 48, 272 + 16, 15, 15, 2, 2, 2, 2 )

SKIN.tex.Scroller.RightButton_Normal = GWEN.CreateTextureBorder( 464, 208 + 32, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.RightButton_Hover = GWEN.CreateTextureBorder( 480, 208 + 32, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.RightButton_Down = GWEN.CreateTextureBorder( 464, 272 + 32, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.RightButton_Disabled = GWEN.CreateTextureBorder( 480 + 48, 272 + 32, 15, 15, 2, 2, 2, 2 )

SKIN.tex.Scroller.DownButton_Normal = GWEN.CreateTextureBorder( 464, 208 + 48, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.DownButton_Hover = GWEN.CreateTextureBorder( 480, 208 + 48, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.DownButton_Down = GWEN.CreateTextureBorder( 464, 272 + 48, 15, 15, 2, 2, 2, 2 )
SKIN.tex.Scroller.DownButton_Disabled = GWEN.CreateTextureBorder( 480 + 48, 272 + 48, 15, 15, 2, 2, 2, 2 )

SKIN.tex.Menu = {}
SKIN.tex.Menu.RightArrow = GWEN.CreateTextureNormal( 464, 112, 15, 15 )

SKIN.tex.Input = {}

SKIN.tex.Input.ComboBox = {}
SKIN.tex.Input.ComboBox.Normal = GWEN.CreateTextureBorder( 384, 336, 127, 31, 8, 8, 32, 8 )
SKIN.tex.Input.ComboBox.Hover = GWEN.CreateTextureBorder( 384, 336 + 32, 127, 31, 8, 8, 32, 8 )
SKIN.tex.Input.ComboBox.Down = GWEN.CreateTextureBorder( 384, 336 + 64, 127, 31, 8, 8, 32, 8 )
SKIN.tex.Input.ComboBox.Disabled = GWEN.CreateTextureBorder( 384, 336 + 96, 127, 31, 8, 8, 32, 8 )

SKIN.tex.Input.ComboBox.Button = {}
SKIN.tex.Input.ComboBox.Button.Normal = GWEN.CreateTextureNormal( 496, 272, 15, 15 )
SKIN.tex.Input.ComboBox.Button.Hover = GWEN.CreateTextureNormal( 496, 272 + 16, 15, 15 )
SKIN.tex.Input.ComboBox.Button.Down = GWEN.CreateTextureNormal( 496, 272 + 32, 15, 15 )
SKIN.tex.Input.ComboBox.Button.Disabled = GWEN.CreateTextureNormal( 496, 272 + 48, 15, 15 )

SKIN.tex.Input.UpDown = {}
SKIN.tex.Input.UpDown.Up = {}
SKIN.tex.Input.UpDown.Up.Normal = GWEN.CreateTextureCentered( 384, 112, 7, 7 )
SKIN.tex.Input.UpDown.Up.Hover = GWEN.CreateTextureCentered( 384 + 8, 112, 7, 7 )
SKIN.tex.Input.UpDown.Up.Down = GWEN.CreateTextureCentered( 384 + 16, 112, 7, 7 )
SKIN.tex.Input.UpDown.Up.Disabled = GWEN.CreateTextureCentered( 384 + 24, 112, 7, 7 )

SKIN.tex.Input.UpDown.Down = {}
SKIN.tex.Input.UpDown.Down.Normal = GWEN.CreateTextureCentered( 384, 120, 7, 7 )
SKIN.tex.Input.UpDown.Down.Hover = GWEN.CreateTextureCentered( 384 + 8, 120, 7, 7 )
SKIN.tex.Input.UpDown.Down.Down = GWEN.CreateTextureCentered( 384 + 16, 120, 7, 7 )
SKIN.tex.Input.UpDown.Down.Disabled = GWEN.CreateTextureCentered( 384 + 24, 120, 7, 7 )

SKIN.tex.Input.Slider = {}
SKIN.tex.Input.Slider.H = {}
SKIN.tex.Input.Slider.H.Normal = GWEN.CreateTextureNormal( 416, 32, 15, 15 )
SKIN.tex.Input.Slider.H.Hover = GWEN.CreateTextureNormal( 416, 32 + 16, 15, 15 )
SKIN.tex.Input.Slider.H.Down = GWEN.CreateTextureNormal( 416, 32 + 32, 15, 15 )
SKIN.tex.Input.Slider.H.Disabled = GWEN.CreateTextureNormal( 416, 32 + 48, 15, 15 )

SKIN.tex.Input.Slider.V = {}
SKIN.tex.Input.Slider.V.Normal = GWEN.CreateTextureNormal( 416 + 16, 32, 15, 15 )
SKIN.tex.Input.Slider.V.Hover = GWEN.CreateTextureNormal( 416 + 16, 32 + 16, 15, 15 )
SKIN.tex.Input.Slider.V.Down = GWEN.CreateTextureNormal( 416 + 16, 32 + 32, 15, 15 )
SKIN.tex.Input.Slider.V.Disabled = GWEN.CreateTextureNormal( 416 + 16, 32 + 48, 15, 15 )

SKIN.tex.Input.ListBox = {}
SKIN.tex.Input.ListBox.Background = GWEN.CreateTextureBorder( 256, 256, 63, 127, 8, 8, 8, 8 )
SKIN.tex.Input.ListBox.Hovered = GWEN.CreateTextureBorder( 320, 320, 31, 31, 8, 8, 8, 8 )
SKIN.tex.Input.ListBox.EvenLine = GWEN.CreateTextureBorder( 352, 256, 31, 31, 8, 8, 8, 8 )
SKIN.tex.Input.ListBox.OddLine = GWEN.CreateTextureBorder( 352, 288, 31, 31, 8, 8, 8, 8 )
SKIN.tex.Input.ListBox.EvenLineSelected = GWEN.CreateTextureBorder( 320, 256, 31, 31, 8, 8, 8, 8 )
SKIN.tex.Input.ListBox.OddLineSelected = GWEN.CreateTextureBorder( 320, 288, 31, 31, 8, 8, 8, 8 )

SKIN.tex.ProgressBar = {}
SKIN.tex.ProgressBar.Back = GWEN.CreateTextureBorder( 384, 0, 31, 31, 8, 8, 8, 8 )
SKIN.tex.ProgressBar.Front = GWEN.CreateTextureBorder( 384 + 32, 0, 31, 31, 8, 8, 8, 8 )

SKIN.tex.CategoryList = {}
SKIN.tex.CategoryList.Outer = GWEN.CreateTextureBorder( 256, 384, 63, 63, 8, 8, 8, 8 )
SKIN.tex.CategoryList.Inner = GWEN.CreateTextureBorder( 320, 384, 63, 63, 8, 21, 8, 8 )
SKIN.tex.CategoryList.Header = GWEN.CreateTextureBorder( 320, 352, 63, 31, 8, 8, 8, 8 )

SKIN.tex.Tooltip = GWEN.CreateTextureBorder( 384, 64, 31, 31, 8, 8, 8, 8 )

SKIN.Colours = {}

SKIN.Colours.Window = {}
SKIN.Colours.Window.TitleActive = GWEN.TextureColor( 4 + 8 * 0, 508 )
SKIN.Colours.Window.TitleInactive = GWEN.TextureColor( 4 + 8 * 1, 508 )

SKIN.Colours.Button = {}
SKIN.Colours.Button.Normal = GWEN.TextureColor( 4 + 8 * 2, 508 )
SKIN.Colours.Button.Hover = GWEN.TextureColor( 4 + 8 * 3, 508 )
SKIN.Colours.Button.Down = GWEN.TextureColor( 4 + 8 * 2, 500 )
SKIN.Colours.Button.Disabled = GWEN.TextureColor( 4 + 8 * 3, 500 )

SKIN.Colours.Tab = {}
SKIN.Colours.Tab.Active = {}
SKIN.Colours.Tab.Active.Normal = GWEN.TextureColor( 4 + 8 * 4, 508 )
SKIN.Colours.Tab.Active.Hover = GWEN.TextureColor( 4 + 8 * 5, 508 )
SKIN.Colours.Tab.Active.Down = GWEN.TextureColor( 4 + 8 * 4, 500 )
SKIN.Colours.Tab.Active.Disabled = GWEN.TextureColor( 4 + 8 * 5, 500 )

SKIN.Colours.Tab.Inactive = {}
SKIN.Colours.Tab.Inactive.Normal = GWEN.TextureColor( 4 + 8 * 6, 508 )
SKIN.Colours.Tab.Inactive.Hover = GWEN.TextureColor( 4 + 8 * 7, 508 )
SKIN.Colours.Tab.Inactive.Down = GWEN.TextureColor( 4 + 8 * 6, 500 )
SKIN.Colours.Tab.Inactive.Disabled = GWEN.TextureColor( 4 + 8 * 7, 500 )

SKIN.Colours.Label = {}
SKIN.Colours.Label.Default = GWEN.TextureColor( 4 + 8 * 8, 508 )
SKIN.Colours.Label.Bright = GWEN.TextureColor( 4 + 8 * 9, 508 )
SKIN.Colours.Label.Dark = GWEN.TextureColor( 4 + 8 * 8, 500 )
SKIN.Colours.Label.Highlight = GWEN.TextureColor( 4 + 8 * 9, 500 )

SKIN.Colours.Tree = {}
SKIN.Colours.Tree.Lines = GWEN.TextureColor( 4 + 8 * 10, 508 )
SKIN.Colours.Tree.Normal = GWEN.TextureColor( 4 + 8 * 11, 508 )
SKIN.Colours.Tree.Hover = GWEN.TextureColor( 4 + 8 * 10, 500 )
SKIN.Colours.Tree.Selected = GWEN.TextureColor( 4 + 8 * 11, 500 )

SKIN.Colours.Properties = {}
SKIN.Colours.Properties.Line_Normal = GWEN.TextureColor( 4 + 8 * 12, 508 )
SKIN.Colours.Properties.Line_Selected = GWEN.TextureColor( 4 + 8 * 13, 508 )
SKIN.Colours.Properties.Line_Hover = GWEN.TextureColor( 4 + 8 * 12, 500 )
SKIN.Colours.Properties.Title = GWEN.TextureColor( 4 + 8 * 13, 500 )
SKIN.Colours.Properties.Column_Normal = GWEN.TextureColor( 4 + 8 * 14, 508 )
SKIN.Colours.Properties.Column_Selected = GWEN.TextureColor( 4 + 8 * 15, 508 )
SKIN.Colours.Properties.Column_Hover = GWEN.TextureColor( 4 + 8 * 14, 500 )
SKIN.Colours.Properties.Border = GWEN.TextureColor( 4 + 8 * 15, 500 )
SKIN.Colours.Properties.Label_Normal = GWEN.TextureColor( 4 + 8 * 16, 508 )
SKIN.Colours.Properties.Label_Selected = GWEN.TextureColor( 4 + 8 * 17, 508 )
SKIN.Colours.Properties.Label_Hover = GWEN.TextureColor( 4 + 8 * 16, 500 )

SKIN.Colours.Category = {}
SKIN.Colours.Category.Header = GWEN.TextureColor( 4 + 8 * 18, 500 )
SKIN.Colours.Category.Header_Closed = GWEN.TextureColor( 4 + 8 * 19, 500 )
SKIN.Colours.Category.Line = {}
SKIN.Colours.Category.Line.Text = GWEN.TextureColor( 4 + 8 * 20, 508 )
SKIN.Colours.Category.Line.Text_Hover = GWEN.TextureColor( 4 + 8 * 21, 508 )
SKIN.Colours.Category.Line.Text_Selected = GWEN.TextureColor( 4 + 8 * 20, 500 )
SKIN.Colours.Category.Line.Button = GWEN.TextureColor( 4 + 8 * 21, 500 )
SKIN.Colours.Category.Line.Button_Hover = GWEN.TextureColor( 4 + 8 * 22, 508 )
SKIN.Colours.Category.Line.Button_Selected = GWEN.TextureColor( 4 + 8 * 23, 508 )
SKIN.Colours.Category.LineAlt = {}
SKIN.Colours.Category.LineAlt.Text = GWEN.TextureColor( 4 + 8 * 22, 500 )
SKIN.Colours.Category.LineAlt.Text_Hover = GWEN.TextureColor( 4 + 8 * 23, 500 )
SKIN.Colours.Category.LineAlt.Text_Selected = GWEN.TextureColor( 4 + 8 * 24, 508 )
SKIN.Colours.Category.LineAlt.Button = GWEN.TextureColor( 4 + 8 * 25, 508 )
SKIN.Colours.Category.LineAlt.Button_Hover = GWEN.TextureColor( 4 + 8 * 24, 500 )
SKIN.Colours.Category.LineAlt.Button_Selected = GWEN.TextureColor( 4 + 8 * 25, 500 )

SKIN.Colours.TooltipText = GWEN.TextureColor( 4 + 8 * 26, 500 )

--[[---------------------------------------------------------
	Panel
-----------------------------------------------------------]]
function SKIN:PaintPanel( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	Blur( panel )

	self.tex.Panels.Normal( 0, 0, w, h, panel.m_bgColor )
end

function SKIN:PaintShadow( panel, w, h )
	SKIN.tex.Shadow( 0, 0, w, h )
end

--[[---------------------------------------------------------
	Frame
-----------------------------------------------------------]]
function SKIN:PaintFrame( panel, w, h )
	if ( panel.m_bPaintShadow ) then
		DisableClipping( true )

		self.tex.Shadow( -4, -4, w + 10, h + 10 )

		DisableClipping( false )
	end

	if ( panel:HasHierarchicalFocus() ) then
		self.tex.Window.Normal( 0, 0, w, h )
	else
		self.tex.Window.Inactive( 0, 0, w, h )
	end
end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
function SKIN:PaintButton( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	ButtonPaint( panel, w, h, panel.id, panel.fav )
end

--[[---------------------------------------------------------
	Tree
-----------------------------------------------------------]]
local color_panel_tree = Color(255,255,255,145)

function SKIN:PaintTree( panel, w, h )
	draw.RoundedBox( 6, 0, 0, w, h, color_panel_tree )
end

--[[---------------------------------------------------------
	CheckBox
-----------------------------------------------------------]]
function SKIN:PaintCheckBox( panel, w, h )
	if ( panel:GetChecked() ) then
		if ( panel:GetDisabled() ) then
			self.tex.CheckboxD_Checked( 0, 0, w, h )
		else
			self.tex.Checkbox_Checked( 0, 0, w, h )
		end
	else
		if ( panel:GetDisabled() ) then
			self.tex.CheckboxD( 0, 0, w, h )
		else
			self.tex.Checkbox( 0, 0, w, h )
		end
	end
end

--[[---------------------------------------------------------
	ExpandButton
-----------------------------------------------------------]]
function SKIN:PaintExpandButton( panel, w, h )
	if ( !panel:GetExpanded() ) then
		self.tex.TreePlus( 0, 0, w, h )
	else
		self.tex.TreeMinus( 0, 0, w, h )
	end
end

--[[---------------------------------------------------------
	TextEntry
-----------------------------------------------------------]]
function SKIN:PaintTextEntry( panel, w, h )
	if ( panel.m_bBackground ) then
		if ( panel:GetDisabled() ) then
			self.tex.TextBox_Disabled( 0, 0, w, h )
		elseif ( panel:HasFocus() ) then
			self.tex.TextBox_Focus( 0, 0, w, h )
		else
			self.tex.TextBox( 0, 0, w, h )
		end
	end

	if ( panel.GetPlaceholderText && panel.GetPlaceholderColor && panel:GetPlaceholderText() && panel:GetPlaceholderText():Trim() != '' && panel:GetPlaceholderColor() && ( !panel:GetText() || panel:GetText() == '' ) ) then
		local oldText = panel:GetText()
		local str = panel:GetPlaceholderText()

		if ( str:StartWith( "#" ) ) then
			str = str:sub( 2 )
		end

		str = language.GetPhrase( str )

		panel:SetText( str )
		panel:DrawTextEntryText( panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
		panel:SetText( oldText )

		return
	end

	panel:DrawTextEntryText( panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor() )
end

--[[---------------------------------------------------------
	Menu
-----------------------------------------------------------]]
local color_gray = Color(70,70,70,200)
local color_panel_dm = Color(230,230,230)

function SKIN:PaintMenu( panel, w, h )
	draw.RoundedBox( 4, 0, 0, w, h, color_gray )
	draw.RoundedBox( 4, 1, 1, w - 2, h - 2, color_panel_dm )
end

--[[---------------------------------------------------------
	Menu
-----------------------------------------------------------]]
function SKIN:PaintMenuSpacer( panel, w, h )
	surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
	surface.DrawRect( 0, 0, w, h )
end

--[[---------------------------------------------------------
	MenuOption
-----------------------------------------------------------]]
function SKIN:PaintMenuOption( panel, w, h )
	if ( panel.m_bBackground && ( panel.Hovered || panel.Highlight ) ) then
		self.tex.MenuBG_Hover( 0, 0, w, h )
	end

	if ( panel:GetChecked() ) then
		self.tex.Menu_Check( 5, h / 2 - 7, 15, 15 )
	end
end

--[[---------------------------------------------------------
	MenuRightArrow
-----------------------------------------------------------]]
function SKIN:PaintMenuRightArrow( panel, w, h )
	self.tex.Menu.RightArrow( 0, 0, w, h )
end

--[[---------------------------------------------------------
	PropertySheet
-----------------------------------------------------------]]
function SKIN:PaintPropertySheet( panel, w, h )
	local ActiveTab = panel:GetActiveTab()
	local Offset = 0

	if ( ActiveTab ) then
		Offset = ActiveTab:GetTall() - 8
	end

	self.tex.Tab_Control( 0, Offset, w, h-Offset )
end

--[[---------------------------------------------------------
	Tab
-----------------------------------------------------------]]
function SKIN:PaintTab( panel, w, h )
	if ( panel:IsActive() ) then
		return self:PaintActiveTab( panel, w, h )
	end

	self.tex.TabT_Inactive( 0, 0, w, h )
end

function SKIN:PaintActiveTab( panel, w, h )
	self.tex.TabT_Active( 0, 0, w, h )
end

--[[---------------------------------------------------------
	Button
-----------------------------------------------------------]]
local color_text_window_btn_dis = Color(255,255,255,50)

function SKIN:PaintWindowCloseButton( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel:GetDisabled() ) then
		return self.tex.Window.Close( 0, 0, w, h, color_text_window_btn_dis )
	end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Window.Close_Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Window.Close_Hover( 0, 0, w, h )
	end

	self.tex.Window.Close( 0, 0, w, h )
end

function SKIN:PaintWindowMinimizeButton( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel:GetDisabled() ) then
		return self.tex.Window.Mini( 0, 0, w, h, color_text_window_btn_dis )
	end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Window.Mini_Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Window.Mini_Hover( 0, 0, w, h )
	end

	self.tex.Window.Mini( 0, 0, w, h )
end

function SKIN:PaintWindowMaximizeButton( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel:GetDisabled() ) then
		return self.tex.Window.Maxi( 0, 0, w, h, color_text_window_btn_dis )
	end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Window.Maxi_Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Window.Maxi_Hover( 0, 0, w, h )
	end

	self.tex.Window.Maxi( 0, 0, w, h )
end

--[[---------------------------------------------------------
	VScrollBar
-----------------------------------------------------------]]
function SKIN:PaintVScrollBar( panel, w, h )
	self.tex.Scroller.TrackV( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ScrollBarGrip
-----------------------------------------------------------]]
function SKIN:PaintScrollBarGrip( panel, w, h )
	if ( panel:GetDisabled() ) then
		return self.tex.Scroller.ButtonV_Disabled( 0, 0, w, h )
	end

	if ( panel.Depressed ) then
		return self.tex.Scroller.ButtonV_Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.ButtonV_Hover( 0, 0, w, h )
	end

	return self.tex.Scroller.ButtonV_Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ButtonDown
-----------------------------------------------------------]]
function SKIN:PaintButtonDown( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Scroller.DownButton_Down( 0, 0, w, h )
	end

	if ( panel:GetDisabled() ) then
		return self.tex.Scroller.DownButton_Dead( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.DownButton_Hover( 0, 0, w, h )
	end

	self.tex.Scroller.DownButton_Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ButtonUp
-----------------------------------------------------------]]
function SKIN:PaintButtonUp( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Scroller.UpButton_Down( 0, 0, w, h )
	end

	if ( panel:GetDisabled() ) then
		return self.tex.Scroller.UpButton_Dead( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.UpButton_Hover( 0, 0, w, h )
	end

	self.tex.Scroller.UpButton_Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ButtonLeft
-----------------------------------------------------------]]
function SKIN:PaintButtonLeft( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Scroller.LeftButton_Down( 0, 0, w, h )
	end

	if ( panel:GetDisabled() ) then
		return self.tex.Scroller.LeftButton_Dead( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.LeftButton_Hover( 0, 0, w, h )
	end

	self.tex.Scroller.LeftButton_Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ButtonRight
-----------------------------------------------------------]]
function SKIN:PaintButtonRight( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	if ( panel.Depressed || panel:IsSelected() ) then
		return self.tex.Scroller.RightButton_Down( 0, 0, w, h )
	end

	if ( panel:GetDisabled() ) then
		return self.tex.Scroller.RightButton_Dead( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Scroller.RightButton_Hover( 0, 0, w, h )
	end

	self.tex.Scroller.RightButton_Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ComboDownArrow
-----------------------------------------------------------]]
function SKIN:PaintComboDownArrow( panel, w, h )
	if ( panel.ComboBox:GetDisabled() ) then
		return self.tex.Input.ComboBox.Button.Disabled( 0, 0, w, h )
	end

	if ( panel.ComboBox.Depressed || panel.ComboBox:IsMenuOpen() ) then
		return self.tex.Input.ComboBox.Button.Down( 0, 0, w, h )
	end

	if ( panel.ComboBox.Hovered ) then
		return self.tex.Input.ComboBox.Button.Hover( 0, 0, w, h )
	end

	self.tex.Input.ComboBox.Button.Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
function SKIN:PaintComboBox( panel, w, h )
	if ( panel:GetDisabled() ) then
		return self.tex.Input.ComboBox.Disabled( 0, 0, w, h )
	end

	if ( panel.Depressed || panel:IsMenuOpen() ) then
		return self.tex.Input.ComboBox.Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Input.ComboBox.Hover( 0, 0, w, h )
	end

	self.tex.Input.ComboBox.Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	ComboBox
-----------------------------------------------------------]]
function SKIN:PaintListBox( panel, w, h )
	self.tex.Input.ListBox.Background( 0, 0, w, h )
end

--[[---------------------------------------------------------
	NumberUp
-----------------------------------------------------------]]
function SKIN:PaintNumberUp( panel, w, h )
	if ( panel:GetDisabled() ) then
		return self.tex.Input.UpDown.Up.Disabled( 0, 0, w, h )
	end

	if ( panel.Depressed ) then
		return self.tex.Input.UpDown.Up.Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Input.UpDown.Up.Hover( 0, 0, w, h )
	end

	self.tex.Input.UpDown.Up.Normal( 0, 0, w, h )
end

--[[---------------------------------------------------------
	NumberDown
-----------------------------------------------------------]]
function SKIN:PaintNumberDown( panel, w, h )
	if ( panel:GetDisabled() ) then
		return self.tex.Input.UpDown.Down.Disabled( 0, 0, w, h )
	end

	if ( panel.Depressed ) then
		return self.tex.Input.UpDown.Down.Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Input.UpDown.Down.Hover( 0, 0, w, h )
	end

	self.tex.Input.UpDown.Down.Normal( 0, 0, w, h )
end

function SKIN:PaintTreeNode( panel, w, h )
	if ( !panel.m_bDrawLines ) then return end

	surface.SetDrawColor( self.Colours.Tree.Lines )

	if ( panel.m_bLastChild ) then

		surface.DrawRect( 9, 0, 1, 7 )
		surface.DrawRect( 9, 7, 9, 1 )

	else
		surface.DrawRect( 9, 0, 1, h )
		surface.DrawRect( 9, 7, 9, 1 )
	end
end

function SKIN:PaintTreeNodeButton( panel, w, h )
	if ( !panel.m_bSelected ) then return end

	local w, _ = panel:GetTextSize()

	self.tex.Selection( 38, 0, w + 6, h )
end

function SKIN:PaintSelection( panel, w, h )
	self.tex.Selection( 0, 0, w, h )
end

function SKIN:PaintSliderKnob( panel, w, h )
	if ( panel:GetDisabled() ) then
		return self.tex.Input.Slider.H.Disabled( 0, 0, w, h )
	end

	if ( panel.Depressed ) then
		return self.tex.Input.Slider.H.Down( 0, 0, w, h )
	end

	if ( panel.Hovered ) then
		return self.tex.Input.Slider.H.Hover( 0, 0, w, h )
	end

	self.tex.Input.Slider.H.Normal( 0, 0, w, h )
end

local function PaintNotches( x, y, w, h, num )
	if ( !num ) then return end

	local space = w / num

	for i = 0, num do
		surface.DrawRect( x + i * space, y + 4, 1, 5 )
	end
end

function SKIN:PaintNumSlider( panel, w, h )
	surface.SetDrawColor( Color( 0, 0, 0, 100 ) )
	surface.DrawRect( 8, h / 2 - 1, w - 15, 1 )

	PaintNotches( 8, h / 2 - 1, w - 16, 1, panel.m_iNotches )
end

function SKIN:PaintProgress( panel, w, h )
	self.tex.ProgressBar.Back( 0, 0, w, h )
	self.tex.ProgressBar.Front( 0, 0, w * panel:GetFraction(), h )
end

function SKIN:PaintCollapsibleCategory( panel, w, h )
	if ( h < 21 ) then
		return self.tex.CategoryList.Header( 0, 0, w, h )
	end

	self.tex.CategoryList.Inner( 0, 0, w, 63 )
end

function SKIN:PaintCategoryList( panel, w, h )
	self.tex.CategoryList.Outer( 0, 0, w, h )
end

function SKIN:PaintCategoryButton( panel, w, h )
	if ( panel.AltLine ) then
		if ( panel.Depressed || panel.m_bSelected ) then
			surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Selected )
		elseif ( panel.Hovered ) then
			surface.SetDrawColor( self.Colours.Category.LineAlt.Button_Hover )
		else
			surface.SetDrawColor( self.Colours.Category.LineAlt.Button )
		end
	else
		if ( panel.Depressed || panel.m_bSelected ) then
			surface.SetDrawColor( self.Colours.Category.Line.Button_Selected )
		elseif ( panel.Hovered ) then
			surface.SetDrawColor( self.Colours.Category.Line.Button_Hover )
		else
			surface.SetDrawColor( self.Colours.Category.Line.Button )
		end
	end

	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintListViewLine( panel, w, h )
	if ( panel:IsSelected() ) then
		self.tex.Input.ListBox.EvenLineSelected( 0, 0, w, h )
	elseif ( panel.Hovered ) then
		self.tex.Input.ListBox.Hovered( 0, 0, w, h )
	elseif ( panel.m_bAlt ) then
		self.tex.Input.ListBox.EvenLine( 0, 0, w, h )
	end
end

function SKIN:PaintListView( panel, w, h )
	if ( !panel.m_bBackground ) then return end

	self.tex.Input.ListBox.Background( 0, 0, w, h )
end

function SKIN:PaintTooltip( panel, w, h )
	self.tex.Tooltip( 0, 0, w, h )
end

function SKIN:PaintMenuBar( panel, w, h )
	self.tex.Menu_Strip( 0, 0, w, h )
end

derma.DefineSkin( 'fsm', 'Derma Skin for FreSpawnMenu', SKIN )