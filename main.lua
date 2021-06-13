local Mod = RegisterMod("Custom Bossbar", 1)
local MCM = {}
local json = require("json")
local hsv = require("hsv")

pcall(require, "scripts.screenhelper")

Mod.ENTITYLIST = {"274.0.0", "275.0.0", "912.0.0", "912.10.0", "951.0.0", "951.10.0", "951.20.0", "951.30.0", "951.40.0"}
Mod.RECALCULATE_LIST = {}

Mod.Pos = Vector.Zero
Mod.BasePos = Vector(1, -10)
Mod.Offset = 0
Mod.RightClamp = Vector.Zero

Mod.InstaFix = false
Mod.CustomAnm = true

Mod.CustomBars = {
	AnmNotExist = {},
	PngNotExist = {},
	
	Colors = {
		["274.0.0"] = Color(1, 0, 0),
		["275.0.0"] = Color(1, 0, 0),
		["412.0.0"] = Color(1, 1, 1),
		["912.0.0"] = Color(0.3, 0.5, 0),
		["912.10.0"] = Color(0.3, 0.5, 0)
	}
}

Mod.Base = Sprite()
Mod.Bar = Sprite()
Mod.Over = Sprite()


function MCM.LoadData(data)
	ModConfigMenu.Config["Custom Bossbar"].ColorR = data.ColorR or 10
	ModConfigMenu.Config["Custom Bossbar"].ColorG = data.ColorG or 0
	ModConfigMenu.Config["Custom Bossbar"].ColorB = data.ColorB or 0
	ModConfigMenu.Config["Custom Bossbar"].Chroma = data.Chroma or 0
	ModConfigMenu.Config["Custom Bossbar"].ForceColor = data.ForceColor or false
	ModConfigMenu.Config["Custom Bossbar"].BossSatan = data.BossSatan or false
	ModConfigMenu.Config["Custom Bossbar"].BossTheLamb = data.BossTheLamb or false
	ModConfigMenu.Config["Custom Bossbar"].BossIsaac = data.BossIsaac or false
	ModConfigMenu.Config["Custom Bossbar"].BossBlueBaby = data.BossBlueBaby or false
	ModConfigMenu.Config["Custom Bossbar"].BossHush = data.BossHush or false
	ModConfigMenu.Config["Custom Bossbar"].BossDelirium = data.BossDelirium or false
	ModConfigMenu.Config["Custom Bossbar"].BossMegaSatan = data.BossMegaSatan or true
	ModConfigMenu.Config["Custom Bossbar"].BossMother = data.BossMother or true
	ModConfigMenu.Config["Custom Bossbar"].BossTheBeast = data.BossTheBeast or true
	ModConfigMenu.Config["Custom Bossbar"].CustomAnm = data.CustomAnm or true
	ModConfigMenu.Config["Custom Bossbar"].InstaFix = data.InstaFix or false
	
	MCM.Data = data
	
	if ModConfigMenu then
		MCM.FixOffset()
		MCM.ColorChange()
		MCM.BossChange()
		MCM.OtherChange()
	end
end

function MCM.SaveData()
	if not ModConfigMenu then return MCM.Data end
	return {
		ColorR = ModConfigMenu.Config["Custom Bossbar"].ColorR,
		ColorG = ModConfigMenu.Config["Custom Bossbar"].ColorG,
		ColorB = ModConfigMenu.Config["Custom Bossbar"].ColorB,
		Chroma = ModConfigMenu.Config["Custom Bossbar"].Chroma,
		ForceColor = ModConfigMenu.Config["Custom Bossbar"].ForceColor,
		BossSatan = ModConfigMenu.Config["Custom Bossbar"].BossSatan,
		BossTheLamb = ModConfigMenu.Config["Custom Bossbar"].BossTheLamb,
		BossIsaac = ModConfigMenu.Config["Custom Bossbar"].BossIsaac,
		BossBlueBaby = ModConfigMenu.Config["Custom Bossbar"].BossBlueBaby,
		BossHush = ModConfigMenu.Config["Custom Bossbar"].BossHush,
		BossDelirium = ModConfigMenu.Config["Custom Bossbar"].BossDelirium,
		BossMegaSatan = ModConfigMenu.Config["Custom Bossbar"].BossMegaSatan,
		BossMother = ModConfigMenu.Config["Custom Bossbar"].BossMother,
		BossTheBeast = ModConfigMenu.Config["Custom Bossbar"].BossTheBeast,
		CustomAnm = ModConfigMenu.Config["Custom Bossbar"].CustomAnm,
		InstaFix = ModConfigMenu.Config["Custom Bossbar"].InstaFix
	}
end

function Mod.FixPos()
	local size = ScreenHelper.GetScreenSize()
	Mod.Pos = Mod.BasePos + Vector(size.X / 2, size.Y - Mod.Offset * 1.6)
end

function MCM.FixOffset()
	Mod.Offset = ModConfigMenu.Config["General"].HudOffset or 0
	ScreenHelper.SetOffset(Mod.Offset)
	Mod.FixPos()
end

function MCM.Display(text)
	return function ()
		MCM.InMenu = true
		return text
	end
end

function MCM.OnChange(setting, func)
	local OldOnChange = setting.OnChange
	
	setting.OnChange = function (value)
		OldOnChange(value)
		func(value)
	end
	
	return setting
end

function MCM.ColorChange()
	Mod.Bar.Color = Color(
		(ModConfigMenu.Config["Custom Bossbar"].ColorR or 10) / 10,
		(ModConfigMenu.Config["Custom Bossbar"].ColorG or 0) / 10,
		(ModConfigMenu.Config["Custom Bossbar"].ColorB or 0) / 10
	)
	
	if Mod.Chroma then Mod.Chroma = nil end
	if ModConfigMenu.Config["Custom Bossbar"].Chroma ~= 0 then
		local hue, sat, val = hsv.FromRGB(Mod.Bar.Color.R, Mod.Bar.Color.G, Mod.Bar.Color.B)
		local shift = math.floor(1 / sat + 0.5)
		local mult = ModConfigMenu.Config["Custom Bossbar"].Chroma or 1
		
		Mod.Chroma = { hue = hue, sat = sat, val = val, shift = shift, mult = mult }
		Mod.Bar.Color = Color(hsv.ToRGB(Isaac.GetFrameCount() / shift * 2, 1, val))
	end
	
end

function MCM.BossChange()
	local megasatan = ModConfigMenu.Config["Custom Bossbar"].BossMegaSatan
	local mother = ModConfigMenu.Config["Custom Bossbar"].BossMother
	local thebeast = ModConfigMenu.Config["Custom Bossbar"].BossTheBeast
	
	Mod.ENTITYLIST["84.0.0"] = ModConfigMenu.Config["Custom Bossbar"].BossSatan
	Mod.ENTITYLIST["84.10.0"] = ModConfigMenu.Config["Custom Bossbar"].BossSatan
	Mod.ENTITYLIST["273.0.0"] = ModConfigMenu.Config["Custom Bossbar"].BossTheLamb
	Mod.ENTITYLIST["273.10.0"] = ModConfigMenu.Config["Custom Bossbar"].BossTheLamb
	Mod.ENTITYLIST["102.0.0"] = ModConfigMenu.Config["Custom Bossbar"].BossIsaac
	Mod.ENTITYLIST["102.1.0"] = ModConfigMenu.Config["Custom Bossbar"].BossBlueBaby
	Mod.ENTITYLIST["102.2.0"] = ModConfigMenu.Config["Custom Bossbar"].BossHush
	Mod.ENTITYLIST["407.0.0"] = ModConfigMenu.Config["Custom Bossbar"].BossHush
	Mod.ENTITYLIST["412.0.0"] = ModConfigMenu.Config["Custom Bossbar"].BossDelirium
	
	Mod.ENTITYLIST["274.0.0"] = megasatan
	Mod.ENTITYLIST["275.0.0"] = megasatan
	Mod.ENTITYLIST["912.0.0"] = mother
	Mod.ENTITYLIST["912.10.0"] = mother
	Mod.ENTITYLIST["951.0.0"] = thebeast
	Mod.ENTITYLIST["951.10.0"] = thebeast
	Mod.ENTITYLIST["951.20.0"] = thebeast
	Mod.ENTITYLIST["951.30.0"] = thebeast
	Mod.ENTITYLIST["951.40.0"] = thebeast
	
end

function MCM.OtherChange()
	Mod.CustomAnm = ModConfigMenu.Config["Custom Bossbar"].CustomAnm
	Mod.InstaFix = ModConfigMenu.Config["Custom Bossbar"].InstaFix
end


if ModConfigMenu then
	local t, t2
	
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Default color"))
	t = "Modify the bar's color"
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorR", 10, "R", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorG", 0, "G", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorB", 0, "B", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddNumberSetting("Custom Bossbar", "General", "Chroma", 0, 5, 0, "Chroma", { [0] = "off", "x1", "x2", "x3", "x4", "x5" }, "Allows the bar to shift hue$newlineIt's speed depends on the saturation"), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "ForceColor", false, "Force Color", { [false] = "off", [true] = "on" }, "Changes the color of custom animations"), MCM.ColorChange)
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Enable on bosses"))
	t = "Allows the bar to show on"
	t2 = "$newlineHudAPI needs to be active for the custom bar to show"
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossSatan", false, "Satan", t .. "Satan" .. t2), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossTheLamb", false, "The Lamb", t .. "The Lamb" .. t2), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossIsaac", false, "Isaac", t .. "Isaac" .. t2), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossBlueBaby", false, "Blue Baby", t .. "???" .. t2), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossHush", false, "Hush", t .. "Hush" .. t2), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossDelirium", false, "Delirium", t .. "Delirium" .. t2), MCM.BossChange)
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Enable on final bosses"))
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossMegaSatan", true, "Mega Satan", t .. "Mega Satan"), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossMother", true, "Mother", t .. "Mother"), MCM.BossChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "BossTheBeast", true, "The Beast", t .. "The Beast"), MCM.BossChange)
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "CustomAnm", true, "Custom Animations", { [false] = "off", [true] = "on" }, "Enables custom animations"), MCM.OtherChange)
	--MCM.OnChange(ModConfigMenu.AddNumberSetting("Custom Bossbar", "General", "ReplaceBar", 0, 2, 2, "Replace Bar", { [0] = "off", "exclude old boss", "include old boss" }, "Replaces the old bossbar"), MCM.OtherChange)
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "InstaFix", false, "Insta Fix", { [false] = "off", [true] = "on" }, "Runs fixes every frame"), MCM.OtherChange)
	
	MCM.OnChange(ModConfigMenu.MenuData[1].Subcategories[1].Options[1], MCM.FixOffset)
	
end


function Mod.GetCustomBar(entity)
	if not Mod.CustomAnm then return end
	if Mod.CustomBars.Current then return end
	local str = string.format("%i.%i.%i", entity.Type, entity.Variant, entity.SubType)
	local str2 = string.format("%i_%i_%i", entity.Type, entity.Variant, entity.SubType)
	local str3
	
	if not Mod.ForceColor then
		Mod.Bar.Color = Mod.CustomBars.Colors[str] or Mod.Bar.Color
	end
	
	if not Mod.CustomBars.AnmNotExist[str] then
		str3 = string.format("gfx/custom_ui/ui_bosshealthbar-%s.anm2", str2, true)
		
		if pcall(Sprite, Load, Mod.Base, str3) then
			Mod.CustomBars.AnmNotExist[str] = true
		else
			Mod.Bar:Load(str3, true)
			Mod.Over:Load(str3, true)
			Mod.Base:Play("Base", true)
			Mod.Bar:Play("Bar", true)
			Mod.Over:Play("Over", true)
			--if Mod.CustomBars.Color[str] then Mod.Bar.Color = Mod.CustomBars.Color[str] end
			
			Mod.CustomBars.Current = str
		end
	end
	
	if not Mod.CustomBars.Current and not Mod.CustomBars.PngNotExist[str] then
		str3 = string.format("gfx/custom_ui/ui_bosshealthbar-%s.png", str2)
		
		if pcall(Sprite, ReplaceSpritesheet, Mod.Base, str3) then
			Mod.CustomBars.PngNotExist[str] = true
		else
			Mod.Bar:ReplaceSpritesheet(str3)
			Mod.Over:ReplaceSpritesheet(str3)
			Mod.Base:LoadGraphics()
			Mod.Bar:LoadGraphics()
			Mod.Over:LoadGraphics()
			Mod.Base:Play("Base", true)
			Mod.Bar:Play("Bar", true)
			Mod.Over:Play("Over", true)
			--if Mod.CustomBars.Color[str] then Mod.Bar.Color = Mod.CustomBars.Color[str] end
		
		Mod.CustomBars.Current = str
		end
	end
end

function Mod.EntityListCheck(entity, str)
	str = str or string.format("%i.%i.%i", entity.Type, entity.Variant, entity.SubType)
	return Mod.ENTITYLIST[str] and true or false
end

function Mod.IsMultiPhaseBoss(entity)
	local str = string.format("%i.%i.%i", entity.Type, entity.Variant, entity.SubType)
	
	return str == "84.0.0" or -- satan
	str == "84.10.0" or -- satan
	str == "102.2.0" or -- hush
	str == "407.0.0" or -- hush
	str == "274.0.0" or -- megasatan
	str == "275.0.0" or -- megasatan
	str == "912.0.0" or -- mother
	str == "912.10.0" -- mother
end

function Mod:MC_POST_RENDER()
	if MCM.InMenu then -- Previews while on the ModConfigMenu page
		Mod.RightClamp = Vector.Zero
		MCM.InMenu = false
	elseif not Mod.HitPoints then
		return
	end
	
	local frame = Isaac.GetFrameCount()
	if Mod.InstaFix or frame % 30 == 0 then Mod.FixPos() end
	
	if Mod.Chroma and (Mod.ForceColor or not Mod.CustomBars.Current) and frame % Mod.Chroma.shift == 0 then
		local hue = frame / Mod.Chroma.shift * Mod.Chroma.mult
		Mod.Bar.Color = Color(hsv.ToRGB(hue, 1, Mod.Chroma.val))
	end
	
	if not Mod.Over:IsPlaying() then Mod.Over:Play("Over") end
	
	Mod.Base:Render(Mod.Pos)
	Mod.Bar:Render(Mod.Pos, Vector.Zero, Mod.RightClamp)
	Mod.Over:Render(Mod.Pos)
end

function Mod:CalculateHitPoints(entity)
	-- Entity checks
	if not Mod.EntityListCheck(entity) then return end -- Must be on the entity list
	if not entity:IsVulnerableEnemy() and (not Mod.HitPoints or not Mod.HitPoints[GetPtrHash(entity)]) then return end -- Must be something you can deal damage to
	
	if not Mod.HitPoints then
		Mod.HitPoints = { Entities = 0, Value = 0, LValue = 0, Max = { Value = 0 } }
	end
	
	-- Setup vars
	local ptr = GetPtrHash(entity)
	local hp = math.max(entity.HitPoints, 0)
	local diff = Mod.HitPoints.Max[ptr] or 0
	
	if not Mod.HitPoints[ptr] then
		Mod.HitPoints.Entities = Mod.HitPoints.Entities + 1
		Mod.GetCustomBar(entity)
	end
	
	
	-- Modify maximum value
	Mod.HitPoints.Max[ptr] = math.max(hp, diff)
	if Mod.RECALCULATE_LIST[ptr] then
		Mod.HitPoints.Max[ptr] = 0
		Mod.RECALCULATE_LIST[ptr] = nil
	end
	Mod.HitPoints.Max.Value = Mod.HitPoints.Max.Value + Mod.HitPoints.Max[ptr] - diff
	
	-- Modify value
	diff = Mod.HitPoints[ptr] or 0
	Mod.HitPoints[ptr] = hp
	Mod.HitPoints.Value = Mod.HitPoints.Value + Mod.HitPoints[ptr] - diff
	
	Mod.UpdateBar()
end

function Mod.FixHitPoints()
	if not Mod.HitPoints then return end
	
	local val = 0
	Mod.HitPoints.Value = nil
	for k,v in pairs(Mod.HitPoints) do
		val = val + v
	end
	Mod.HitPoints.Value = val
	
	val = 0
	Mod.HitPoints.Max.Value = nil
	for k,v in pairs(Mod.HitPoints.Max) do
		val = val + v
	end
	Mod.HitPoints.Max.Value = val
	
	Mod.UpdateBar()
end

function Mod:MC_POST_ENTITY_REMOVE(entity)
	if not Mod.HitPoints then return end
	
	local ptr = GetPtrHash(entity)
	if not Mod.HitPoints[ptr] then return end
	
	if entity:IsBoss() and Mod.IsMultiPhaseBoss(entity) then
		Mod.RECALCULATE_LIST[ptr] = true
	end
	
	Mod.HitPoints.Entities = Mod.HitPoints.Entities - 1
	Mod:CalculateHitPoints(entity)
end

function Mod:MC_POST_ENTITY_KILL(entity)
	if not Mod.HitPoints then return end
	if not entity:IsBoss() or not Mod.IsMultiPhaseBoss(entity) then return end
	
	local ptr = GetPtrHash(entity)
	if not Mod.HitPoints[ptr] then return end
	
	Mod.RECALCULATE_LIST[ptr] = true
	Mod:CalculateHitPoints(entity)
end

function Mod.UpdateBar()
	if not Mod.HitPoints then return end
	
	if Mod.HitPoints.Entities == 0 then
		Mod.HitPoints = nil
		Mod.ResetAnm()
		return
	end
		
	Mod.RightClamp = Vector(Mod.Length - Mod.HitPoints.Value / Mod.HitPoints.Max.Value * Mod.Length, 0)
	
	if Mod.HitPoints.LValue > Mod.HitPoints.Value then
		Mod.Bar:Play("Bar")
	end
	
	Mod.HitPoints.LValue = Mod.HitPoints.Value
end

function Mod.ResetAnm()
	if Mod.CustomBars.Current then
		Mod.Base:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
		Mod.Base:SetAnimation("Base")
		Mod.Base:Play("Base")
		
		Mod.Bar:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
		Mod.Bar:SetAnimation("Bar")
		Mod.Bar:Play("Bar")
		
		Mod.Over:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
		Mod.Over:SetAnimation("Over")
		Mod.Over:Play("Over")
		
		Mod.Length = tonumber(Mod.Bar:GetDefaultAnimationName()) or 110
		if ModConfigMenu then
			MCM.ColorChange()
		else
			Mod.Bar.Color = Color(1, 0, 0)
		end
		
		Mod.CustomBars.Current = nil
	end
end
Mod.ResetAnm()

function Mod:MC_POST_NEW_ROOM()
	Mod.RECALCULATE_LIST = {}
	Mod.HitPoints = nil
	Mod.ResetAnm()
end

function Mod:MC_POST_GAME_STARTED()
	if not Mod:HasData() then return end
	local data = json.decode(Mod:LoadData())
	
	Mod.ENTITYLIST = data.ENTITYLIST
	MCM.LoadData(data.MCM or {})
end

function Mod:MC_PRE_GAME_EXIT()
	Mod:SaveData(json.encode({
		ENTITYLIST = Mod.ENTITYLIST,
		MCM = MCM.SaveData()
	}))
end


Mod:AddCallback(ModCallbacks.MC_POST_RENDER, Mod.MC_POST_RENDER)
Mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, Mod.CalculateHitPoints)
Mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Mod.CalculateHitPoints)
Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.CalculateHitPoints)
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, Mod.MC_POST_ENTITY_REMOVE)
Mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, Mod.MC_POST_ENTITY_KILL)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.MC_POST_NEW_ROOM)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.MC_POST_GAME_STARTED)
Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Mod.MC_PRE_GAME_EXIT)

_G.CustomBossbar = Mod