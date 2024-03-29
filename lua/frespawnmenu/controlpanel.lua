local PANEL = {}

AccessorFunc(PANEL, 'm_bInitialized', 'Initialized')

function PANEL:Init()
	self:SetInitialized(false)
end

function PANEL:ClearControls()
	self:Clear()
end

function PANEL:GetEmbeddedPanel()
	return self
end

function PANEL:AddPanel(pnl)
	self:AddItem(pnl, nil)

	self:InvalidateLayout()
end

function PANEL:MatSelect(strConVar, tblOptions, bAutoStretch, iWidth, iHeight)
	local MatSelect = vgui.Create('MatSelect', self)

	Derma_Hook(MatSelect.List, 'Paint', 'Paint', 'Panel')

	MatSelect:SetConVar(strConVar)

	if bAutoStretch != nil then MatSelect:SetAutoHeight(bAutoStretch) end
	if iWidth != nil then MatSelect:SetItemWidth(iWidth) end
	if iHeight != nil then MatSelect:SetItemHeight(iHeight) end

	if tblOptions != nil then
		for k, v in pairs(tblOptions) do
			local nam = isnumber(k) and v or k
			MatSelect:AddMaterial(nam, v)
		end
	end

	self:AddPanel(MatSelect)

	return MatSelect
end

function PANEL:ToolPresets(group, cvarlist)
	local preset = vgui.Create('ControlPresets', self)

	preset:SetPreset(group)
	preset:AddOption('#preset.default', cvarlist)

	for k, v in pairs(cvarlist) do
		preset:AddConVar(k)
	end

	self:AddItem(preset)

	return preset
end

function PANEL:KeyBinder(label1, convar1, label2, convar2)
	local binder = vgui.Create('CtrlNumPad', self)

	binder:SetLabel1(label1)
	binder:SetConVar1(convar1)

	if label2 != nil and convar2 != nil then
		binder:SetLabel2(label2)
		binder:SetConVar2(convar2)
	end

	self:AddPanel(binder)

	return binder
end

function PANEL:ColorPicker(label, convarR, convarG, convarB, convarA)
	local color = vgui.Create('CtrlColor', self)
	color:Dock(TOP)
	color:SetLabel(label)
	color:SetConVarR(convarR)
	color:SetConVarG(convarG)
	color:SetConVarB(convarB)

	if convarA != nil then
		color:SetConVarA(convarA)
	end

	self:AddPanel(color)

	return color
end

function PANEL:FillViaTable(Table)
	self:SetInitialized(true)
	self:SetName(Table.Text)

	if Table.ControlPanelBuildFunction then
		self:FillViaFunction(Table.ControlPanelBuildFunction)
	end
end

function PANEL:FillViaFunction(func)
	func(self)
end

function PANEL:ControlValues(data)
	if data.label then
		self:SetLabel(data.label)
	end

	if data.closed then
		self:SetExpanded(false)
	end
end

function PANEL:AddControl(control, data)
	local data = table.LowerKeyNames(data)
	local original = control
	local frespawnmenu_font = GetConVar('frespawnmenu_font'):GetString()

	control = string.lower(control)

	if control == 'header' then
		if data.description then
			local ctrl = self:Help(data.description)
			ctrl:SetFont(frespawnmenu_font)

			return ctrl
		end

		return
	end

	if control == 'textbox' then
		local ctrl = self:TextEntry(data.label or 'Untitled', data.command)
		ctrl:SetTall(fh(20))
		ctrl:SetFont(frespawnmenu_font)

		return ctrl
	end

	if control == 'label' then
		local ctrl = self:Help(data.text)
		ctrl:SetFont(frespawnmenu_font)
	
		return ctrl
	end

	if control == 'checkbox' or control == 'toggle' then
		local ctrl = self:CheckBox(data.label or 'Untitled', data.command)
		ctrl:SetFont(frespawnmenu_font)
		ctrl:SetSize(fw(15), fh(15))

		ctrl.Button:SetSize(fw(15), fh(15))

		ctrl.Label:SetFont(frespawnmenu_font)

		if data.help then
			local ctrl_help = self:ControlHelp(data.label .. '.help')
			ctrl_help:SetFont(frespawnmenu_font)
		end

		return ctrl
	end

	if control == 'slider' then
		local Decimals = 0

		if data.type && string.lower(data.type) == 'float' then Decimals = 2 end

		local ctrl = self:NumSlider(data.label or 'Untitled', data.command, data.min or 0, data.max or 100, Decimals)

		if data.help then
			local ctrl_help = self:ControlHelp(data.label .. '.help')
			ctrl_help:SetFont(frespawnmenu_font)
		end

		if data.default then
			ctrl:SetDefaultValue(data.default)
		elseif data.command then
			local cvar = GetConVar(data.command)
			
			if cvar then
				ctrl:SetDefaultValue(cvar:GetDefault())
			end
		end

		ctrl.TextArea:SetFont(frespawnmenu_font)
		ctrl.TextArea:SetWide(fw(45))

		ctrl.Slider:SetTall(fh(16))

		ctrl.Label:SetFont(frespawnmenu_font)

		ctrl:SetTall(fh(32))

		return ctrl
	end

	if control == 'propselect' then
		local ctrl = vgui.Create('PropSelect', self)
		ctrl:ControlValues(data)

		self:AddPanel(ctrl)

		return ctrl
	end

	if control == 'matselect' then
		local ctrl = vgui.Create('MatSelect', self)
		ctrl:ControlValues(data)
		ctrl:SetItemWidth(fw(128))
		ctrl:SetItemHeight(fh(128))

		self:AddPanel(ctrl)

		Derma_Hook(ctrl.List, 'Paint', 'Paint', 'Panel')

		return ctrl
	end

	if control == 'ropematerial' then
		local ctrl = vgui.Create('RopeMaterial', self)
		ctrl:SetConVar(data.convar)

		self:AddPanel(ctrl)

		return ctrl
	end

	if control == 'button' then
		local ctrl = vgui.Create('DButton', self)
		ctrl:SetTall(fh(22))

		if data.command then
			function ctrl:DoClick() LocalPlayer():ConCommand(data.command) end
		end

		ctrl:SetText(data.label or data.text or 'No Label')
		ctrl:SetFont(frespawnmenu_font)

		self:AddPanel(ctrl)

		return ctrl
	end

	if control == 'numpad' then
		local ctrl = vgui.Create('CtrlNumPad', self)
		ctrl:SetConVar1(data.command)
		ctrl:SetConVar2(data.command2)
		ctrl:SetLabel1(data.label)
		ctrl:SetLabel2(data.label2)

		self:AddPanel(ctrl)

		return ctrl
	end

	if control == 'color' then
		local ctrl = vgui.Create('CtrlColor', self)
		ctrl:SetLabel(data.label)
		ctrl:SetConVarR(data.red)
		ctrl:SetConVarG(data.green)
		ctrl:SetConVarB(data.blue)
		ctrl:SetConVarA(data.alpha)

		self:AddPanel(ctrl)

		return ctrl
	end

	if control == 'combobox' then
		if tostring(data.menubutton) == '1' then
			local ctrl = vgui.Create('ControlPresets', self)
			ctrl:SetPreset(data.folder)

			if data.options then
				for k, v in pairs(data.options) do
					ctrl:AddOption(k, v)
				end
			end

			if data.cvars then
				for k, v in pairs(data.cvars) do
					ctrl:AddConVar(v)
				end
			end

			self:AddPanel(ctrl)

			return ctrl
		end

		control = 'listbox'
	end

	if control == 'listbox' then
		if data.height then
			local ctrl = vgui.Create('DListView')
			ctrl:SetMultiSelect(false)
			ctrl:AddColumn(data.label or 'Unknown')
			ctrl:SetHeaderHeight(fh(16))
			ctrl:SetDataHeight(fh(17))

			if data.options then
				for k, v in pairs(data.options) do

					local line = ctrl:AddLine(k)

					line.data = v

					for k, v in pairs(line.data) do
						if GetConVarString(k) == tostring(v) then
							line:SetSelected(true)
						end
					end
				end
			end

			ctrl:SetTall(data.height)
			ctrl:SortByColumn(1, false)

			function ctrl:OnRowSelected(LineID, Line)
				for k, v in pairs(Line.data) do
					RunConsoleCommand(k, v)
				end
			end

			self:AddItem(ctrl)

			return ctrl
		else
			local ctrl = vgui.Create('CtrlListBox', self)

			if data.options then
				for k, v in pairs(data.options) do
					ctrl:AddOption(k, v)
				end
			end

			local left = vgui.Create('DLabel', self)
			left:SetText(data.label)
			left:SetDark(true)
			ctrl:SetHeight(25)
			ctrl:Dock(TOP)

			self:AddItem(left, ctrl)

			return ctrl
		end
	end

	if control == 'materialgallery' then
		local ctrl = vgui.Create('MatSelect', self)
		ctrl:SetItemWidth(data.width or fw(32))
		ctrl:SetItemHeight(data.height or fh(32))
		ctrl:SetNumRows(data.rows or 4)
		ctrl:SetConVar(data.convar or nil)

		Derma_Hook(ctrl.List, 'Paint', 'Paint', 'Panel')

		for name, tab in pairs(data.options) do
			local mat = tab.material
			local value = tab.value

			tab.material = nil
			tab.value = nil

			ctrl:AddMaterialEx(name, mat, value, tab)
		end

		self:AddPanel(ctrl)

		return ctrl
	end

	local ctrl = vgui.Create(original, self)

	if !ctrl then
		ctrl = vgui.Create(control, self)
	end

	if ctrl then
		if ctrl.ControlValues then
			ctrl:ControlValues(data)
		end

		self:AddPanel(ctrl)

		return ctrl
	end

	MsgN('UNHANDLED CONTROL: ', control)
	
	PrintTable(data)

	MsgN('\n\n')
end

vgui.Register('FreSpawnMenu-ControlPanel', PANEL, 'DForm')
