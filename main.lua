local Mod = RegisterMod("Custom Bossbar", 1)
local MCM = {}
local hsv = require("hsv")
local json = require("json")

require("scripts.screenhelper")

local function default(value, default)
	return value ~= nil and value or default
end

-- Include Mega Satan, Mother, and The Beast (...and horsemen) by default
Mod.ENTITYLIST = {
	"274.0.0", "275.0.0", -- Mega satan
	"912.0.0", "912.10.0", -- Mother
	"951.0.0", "951.10.0", "951.20.0", "951.30.0", "951.40.0" -- The Beast
}

Mod.Pos = Vector.Zero
Mod.BasePos = Vector(1, -10)
Mod.Offset = 0
Mod.RightClamp = Vector.Zero
Mod.MCM = MCM

Mod.InstaFix = false
Mod.CustomAnm = true

Mod.CustomBars = {
	AnmNotExist = {},
	PngNotExist = {},
	
	Color = {
		--[[
		["274.0.0"] = Color(1, 0, 0),
		["275.0.0"] = Color(1, 0, 0),
		["412.0.0"] = Color(1, 1, 1),
		["912.0.0"] = Color(0.3, 0.5, 0),
		["912.10.0"] = Color(0.3, 0.5, 0)
		--]]
	}
}

Mod.Sprite = {
	Base = Sprite(),
	Bar = Sprite(),
	Over = Sprite()
}


function MCM.LoadData(data)
	-- Make sure data has defaults, and of same type
	for k, v in pairs(MCM.Defaults) do
		if type(data[k]) ~= type(v) then
			data[k] = v
		end
	end
	MCM.Data = data
	
	if not ModConfigMenu then return end
	
	ModConfigMenu.Config["Custom Bossbar"] = data
	MCM.FixOffset()
	MCM.ColorChange()
	MCM.BossChange()
	MCM.OtherChange()
end

function MCM.SaveData()
	if not ModConfigMenu then return MCM.Data end
	return ModConfigMenu.Config["Custom Bossbar"]
end

function Mod.FixPos()
	local size = ScreenHelper.GetScreenSize()
	Mod.Pos = Mod.BasePos + Vector(size.X / 2, size.Y - Mod.Offset * 1.6)
end

if ModConfigMenu then
	
	MCM.Defaults = {
		ColorR = 10,
		ColorG = 0,
		ColorB = 0,
		Chroma = 0,
		ForceColor = false,
		BossSatan = false,
		BossTheLamb = false,
		BossIsaac = false,
		BossBlueBaby = false,
		BossHush = false,
		BossDelirium = false,
		BossMegaSatan = true,
		BossMother = true,
		BossTheBeast = true,
		CustomAnm = false,
		InstaFix = false
	}

	function MCM.FixOffset()
		Mod.Offset = default(ModConfigMenu.Config["General"].HudOffset, 0)
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
		-- Keep the old value, or nothing else will happen
		local oldFunc = setting.OnChange
		
		setting.OnChange = function (value)
			oldFunc(value)
			func(value)
		end
		
		return setting
	end
	
	
	function MCM.ColorChange()
		Mod.Sprite.Bar.Color = Color(
			ModConfigMenu.Config["Custom Bossbar"].ColorR / 10,
			ModConfigMenu.Config["Custom Bossbar"].ColorG / 10,
			ModConfigMenu.Config["Custom Bossbar"].ColorB / 10
		)
		
		if Mod.Chroma then Mod.Chroma = nil end
		if ModConfigMenu.Config["Custom Bossbar"].Chroma ~= 0 then
			local hue, sat, val = hsv.FromRGB(Mod.Sprite.Bar.Color.R, Mod.Sprite.Bar.Color.G, Mod.Sprite.Bar.Color.B)
			local shift = math.floor(1 / sat + 0.5)
			local mult = default(ModConfigMenu.Config["Custom Bossbar"].Chroma, 1)
			
			Mod.Chroma = { hue = hue, sat = sat, val = val, shift = shift, mult = mult }
			Mod.Sprite.Bar.Color = Color(hsv.ToRGB(Isaac.GetFrameCount() / shift * 2, 1, val))
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
	t = "Allows the bar to show on "
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
	MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "InstaFix", false, "Insta Fix", { [false] = "off", [true] = "on" }, "Runs fixes every frame"), MCM.OtherChange)
	
	MCM.OnChange(ModConfigMenu.MenuData[1].Subcategories[1].Options[1], MCM.FixOffset)
	
end


local function entityTypeString(entity)
	return string.format("%i.%i.%i", entity.Type, entity.Variant, entity.SubType)
end

function Mod.GetCustomBar(entity)
	if not Mod.CustomAnm then return end
	if Mod.CustomBars.Current then return end
	local str = string.format("%i_%i_%i", entity.Type, entity.Variant, entity.SubType)
	local str2, spr
	
	if not Mod.CustomBars.AnmNotExist[str] then
		str2 = string.format("gfx/custom_ui/ui_bosshealthbar-%s.anm2", str)
		
		-- Create a new sprite because it breaks the og sprite
		spr = Sprite()
		spr:Load(str2, true)
		
		-- Check if the default animation name is a number and greater than 0
		if default(tonumber(spr:GetDefaultAnimationName()), 0) <= 0 then
			-- It is not, mark the type to not be checked again
			Mod.CustomBars.AnmNotExist[str] = true
			return
		end
		
		Mod.Sprite.Base:Load(str2, true)
		Mod.Sprite.Base:Play("Base")
		
		Mod.Sprite.Bar:Load(str2, true)
		Mod.Sprite.Bar:Play("Bar")
		
		Mod.Sprite.Over:Load(str2, true)
		Mod.Sprite.Over:Play("Over")
		
		if not Mod.ForceColor then Mod.Sprite.Bar.Color = default(Mod.CustomBars.Color[str], Color(1, 0, 0)) end
		
		Mod.CustomBars.Current = str
	end
end

function Mod.EntityListCheck(entity)
	return (
		--entity:IsBoss() or
		Mod.ENTITYLIST[entityTypeString(entity)]
	) and true or false
end

function Mod:MC_POST_RENDER()
	if MCM.InMenu then -- Previews while on the MCM page
		Mod.RightClamp = Vector.Zero
		MCM.InMenu = false
	elseif not Mod.HitPoints then
		return
	end
	
	local frame = Isaac.GetFrameCount()
	if Mod.InstaFix or frame % 30 == 0 then Mod.FixPos() end
	
	if Mod.Chroma and (Mod.ForceColor or not Mod.CustomBars.Current) and frame % Mod.Chroma.shift == 0 then
		local hue = frame / Mod.Chroma.shift * Mod.Chroma.mult
		Mod.Sprite.Bar.Color = Color(hsv.ToRGB(hue, 1, Mod.Chroma.val))
	end
	
	Mod.Sprite.Base:Render(Mod.Pos)
	Mod.Sprite.Bar:Render(Mod.Pos, Vector.Zero, Mod.RightClamp)
	Mod.Sprite.Over:Render(Mod.Pos)
	
	Mod.Sprite.Base:Update()
	Mod.Sprite.Bar:Update()
	Mod.Sprite.Over:Update()
end

function Mod:CalculateHitPoints(entity)
	if not Mod.EntityListCheck(entity) then return end
	-- Must be something you can deal damage to or already in the table
	if not entity:IsVulnerableEnemy() and (not Mod.HitPoints or not Mod.HitPoints[GetPtrHash(entity)]) then return end
	
	if not Mod.HitPoints then
		Mod.HitPoints = {
			Value = 0, LastValue = 0, -- LastValue used for (broken) animation
			Max = { Value = 0 }, -- Max value of bar
			Entities = 0, -- Number of entities
			
			ID = {} -- Entity types, don't ask why it's called ID
		}
	end
	
	-- Setup vars
	local ptr = GetPtrHash(entity)
	local hp = math.max(entity.HitPoints, 0)
	local diff = default(Mod.HitPoints.Max[ptr], 0)
	local id = entityTypeString(entity)
	
	-- If entity is not in the table
	if not Mod.HitPoints[ptr] then
		Mod.HitPoints.Entities = Mod.HitPoints.Entities + 1
		Mod.HitPoints.ID[ptr] = id
		Mod.GetCustomBar(entity)
	end
	
	
	-- Modify maximum value
	Mod.HitPoints.Max[ptr] = math.max(hp, diff)
	if Mod.HitPoints.ID[ptr] ~= id then
		-- If entity has changed, reset max value
		Mod.HitPoints.Max[ptr] = 0
		Mod.HitPoints.ID[ptr] = id
	end
	Mod.HitPoints.Max.Value = Mod.HitPoints.Max.Value + Mod.HitPoints.Max[ptr] - diff
	
	-- Modify value
	diff = default(Mod.HitPoints[ptr], 0)
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
	
	-- Decrement the number of entities
	Mod.HitPoints.Entities = Mod.HitPoints.Entities - 1
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
	
	if Mod.HitPoints.LastValue > Mod.HitPoints.Value then
		Mod.Sprite.Bar:Play("Bar", true)
	end
	
	Mod.HitPoints.LastValue = Mod.HitPoints.Value
end

function Mod.ResetAnm()
	-- Reset sprites to defaults
	
	Mod.Sprite.Base:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
	Mod.Sprite.Base:Play("Base")
	
	Mod.Sprite.Bar:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
	Mod.Sprite.Bar:Play("Bar")
	
	Mod.Sprite.Over:Load("gfx/custom_ui/ui_bosshealthbar.anm2", true)
	Mod.Sprite.Over:Play("Over")
	
	Mod.Length = Mod.Sprite.Bar:GetDefaultAnimationName()
	if ModConfigMenu then
		MCM.ColorChange()
	else
		Mod.Sprite.Bar.Color = Color(1, 0, 0)
	end
	
	Mod.CustomBars.Current = nil
end
Mod.ResetAnm()

function Mod:MC_POST_NEW_ROOM()
	-- Reset HitPoints and sprites
	Mod.HitPoints = nil
	Mod.ResetAnm()
end

function Mod:MC_POST_GAME_STARTED()
	if not Mod:HasData() then return end
	local data = json.decode(Mod:LoadData())
	
	Mod.ENTITYLIST = data.ENTITYLIST
	MCM.LoadData(default(data.MCM, {}))
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
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.MC_POST_NEW_ROOM)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.MC_POST_GAME_STARTED)
Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Mod.MC_PRE_GAME_EXIT)

_G.CustomBossbar = Mod