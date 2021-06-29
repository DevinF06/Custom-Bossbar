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

Mod.CustomAnm = true
Mod.ForceColor = true
Mod.InstaFix = false

Mod.CustomBars = {
	HasAnm = {},
	
	Color = {}
}

Mod.Sprite = {
	Base = Sprite(),
	Bar = Sprite(),
	Over = Sprite()
}


MCM.Defaults = {
	ColorR = 10,
	ColorG = 0,
	ColorB = 0,
	Chroma = 0,
	
	BossSloth = false,
	BossLust = false,
	BossWrath = false,
	BossGluttony = false,
	BossGreed = false,
	BossEnvy = false,
	BossPride = false,
	BossSuperSloth = false,
	BossSuperLust = false,
	BossSuperWrath = false,
	BossSuperGluttony = false,
	BossSuperGreed = false,
	BossSuperEnvy = false,
	BossSuperPride = false,
	
	BossSatan = false,
	BossTheLamb = false,
	BossIsaac = false,
	BossBlueBaby = false,
	BossHush = false,
	BossDelirium = false,
	BossUltraGreed = false,
	
	BossMegaSatan = true,
	BossMother = true,
	BossTheBeast = true,
	
	CustomAnm = false,
	ForceColor = true,
	SepBar = false,
	InstaFix = false
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
		local function f(id, name)
			Mod.ENTITYLIST[id] = ModConfigMenu.Config["Custom Bossbar"][name]
		end
		
		f("46.0.0", "BossSloth")
		f("47.0.0", "BossLust")
		f("48.0.0", "BossWrath")
		f("49.0.0", "BossGluttony")
		f("50.0.0", "BossGreed")
		f("51.0.0", "BossEnvy")
		f("52.0.0", "BossPride")
		f("46.1.0", "BossSuperSloth")
		f("47.1.0", "BossSuperLust")
		f("48.1.0", "BossSuperWrath")
		f("49.1.0", "BossSuperGluttony")
		f("50.1.0", "BossSuperGreed")
		f("51.1.0", "BossSuperEnvy")
		f("52.1.0", "BossSuperPride")
		
		f("84.0.0", "BossSatan")
		f("84.10.0", "BossSatan")
		f("273.0.0", "BossTheLamb")
		f("273.10.0", "BossTheLamb")
		f("102.0.0", "BossIsaac")
		f("102.1.0", "BossBlueBaby")
		f("102.2.0", "BossHush")
		f("407.0.0", "BossHush")
		f("412.0.0", "BossDelirium")
		f("406.0.0", "BossUltraGreed")
		f("406.1.0", "BossUltraGreed")
		
		f("274.0.0", "BossMegaSatan")
		f("275.0.0", "BossMegaSatan")
		f("912.0.0", "BossMother")
		f("912.10.0", "BossMother")
		f("951.0.0", "BossTheBeast")
		f("951.10.0", "BossTheBeast")
		f("951.20.0", "BossTheBeast")
		f("951.30.0", "BossTheBeast")
		f("951.40.0", "BossTheBeast")
		
	end
	
	function MCM.OtherChange()
		Mod.CustomAnm = ModConfigMenu.Config["Custom Bossbar"].CustomAnm
		Mod.ForceColor = ModConfigMenu.Config["Custom Bossbar"].ForceColor
		Mod.BasePos.Y = ModConfigMenu.Config["Custom Bossbar"].SepBar and -25 or -10
		Mod.InstaFix = ModConfigMenu.Config["Custom Bossbar"].InstaFix
		
		Mod.FixPos()
	end
	
	
	local t, t2, v, f
	
	MCM.OnChange(ModConfigMenu.MenuData[1].Subcategories[1].Options[1], MCM.FixOffset)
	
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Default color"))
	t = "Modify the bar's color"
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorR", 10, "R", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorG", 0, "G", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorB", 0, "B", t), MCM.ColorChange)
	MCM.OnChange(ModConfigMenu.AddNumberSetting("Custom Bossbar", "General", "Chroma", 0, 5, 0, "Chroma", { [0] = "off", "x1", "x2", "x3", "x4", "x5" }, "Allows the bar to shift hue$newlineIt's speed depends on the saturation"), MCM.ColorChange)
	
	t = "Allows the bar to show on "
	t2 = "$newlineHud needs to be hidden for the custom bar to show"
	v = false
	f = function (value, name)
		MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "Boss" .. value, v, name, t .. name .. t2), MCM.BossChange)
	end
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Enable on minibosses"))
	f("Sloth", "Sloth")
	f("Lust", "Lust")
	f("Wrath", "Wrath")
	f("Gluttony", "Gluttony")
	f("Greed", "Greed")
	f("Envy", "Envy")
	f("Pride", "Pride")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display(""))
	f("SuperSloth", "Super Sloth")
	f("SuperLust", "Super Lust")
	f("SuperWrath", "Super Wrath")
	f("SuperGluttony", "Super Gluttony", t .. "Super Gluttony")
	f("SuperGreed", "Super Greed")
	f("SuperEnvy", "Super Envy")
	f("SuperPride", "Super Pride")
	
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Enable on bosses"))
	f("Satan", "Satan")
	f("TheLamb", "The Lamb")
	f("Isaac", "Isaac")
	f("BlueBaby", "Blue Baby")
	f("Hush", "Hush")
	f("Delirium", "Delirium")
	f("UltraGreed", "Ultra Greed")
	
	t2 = ""
	v = true
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", MCM.Display("Enable on final bosses"))
	f("MegaSatan", "Mega Satan")
	f("Mother", "Mother")
	f("TheBeast", "The Beast")
	
	f = function (value, name, def, desc)
		MCM.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", value, def, name, { [false] = "off", [true] = "on" }, desc), MCM.OtherChange)
	end
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	f("CustomAnm", "Custom Animations", true, "Enables custom animations")
	f("ForceColor", "Force Color", true, "Changes the color of custom animations")
	f("SepBar", "Separate Bar", false, "Moves the bar above the other bar$newlineAllows bar to be shown without hiding the Hud")
	f("InstaFix", "Insta Fix", false, "Runs fixes every frame")
	
end


local function entityTypeString(entity)
	return string.format("%i.%i.%i", entity.Type, entity.Variant, entity.SubType)
end

function Mod.GetCustomBar(Type, Variant, SubType)
	if not Mod.CustomAnm then return end
	if Mod.CustomBars.Current then return end
	
	local str = string.format("%i.%i.%i", Type, Variant, SubType)
	local str2, spr
	
	if not Mod.CustomBars.HasAnm[str] or Mod.CustomBars.HasAnm == nil then
		str2 = string.format("gfx/custom_ui/ui_bosshealthbar-%s", str):gsub("%.", "_") .. ".anm2"
		
		-- Create a new sprite because it breaks the og sprite
		spr = Sprite()
		spr:Load(str2, true)
		
		-- Check if the default animation name is a number and greater than 0
		if default(tonumber(spr:GetDefaultAnimationName()), 0) <= 0 then
			-- It is not, mark the type to not be checked again
			Mod.CustomBars.HasAnm[str] = false
			return
		end
		
		Mod.Sprite.Base:Load(str2, true)
		Mod.Sprite.Base:Play("Base")
		
		Mod.Sprite.Bar:Load(str2, true)
		Mod.Sprite.Bar:Play("Bar")
		
		Mod.Sprite.Over:Load(str2, true)
		Mod.Sprite.Over:Play("Over")
		
		if not Mod.ForceColor then
			Mod.Sprite.Bar.Color = default(Mod.CustomBars.Color[str], Color(1, 0, 0))
		end
		
		Mod.CustomBars.Current = str
		Mod.CustomBars.HasAnm[str] = true
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
			Value = 0, LastValue = 0, -- LastValue used for animation
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
		Mod.GetCustomBar(entity.Type, entity.Variant, entity.SubType)
	end
	
	
	-- Modify maximum value
	Mod.HitPoints.Max[ptr] = math.max(hp, diff)
	if hp <= 1 and Mod.HitPoints.ID[ptr] ~= id then -- Make sure entity health is 1, because what kind of entity changes when not at 1 health?
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
	
	Mod.HitPoints.Value = 0
	for k,v in pairs(Mod.HitPoints) do
		if type(v) == "number" then
			Mod.HitPoints.Value = Mod.HitPoints.Value + v
		end
	end
	
	Mod.HitPoints.Max.Value = 0
	for k,v in pairs(Mod.HitPoints.Max) do
		if type(v) == "number" then
			Mod.HitPoints.Max.Value = Mod.HitPoints.Max.Value + v
		end
	end
	
	Mod.UpdateBar()
end

function Mod:MC_POST_ENTITY_REMOVE(entity)
	if not Mod.HitPoints then return end
	
	local ptr = GetPtrHash(entity)
	if not Mod.HitPoints[ptr] then return end
	
	-- Decrement the number of entities
	Mod.HitPoints.Entities = Mod.HitPoints.Entities - 1
	Mod:CalculateHitPoints(entity)
	
	if Mod.HitPoints and Mod.CustomBars.Current == entityTypeString(entity) then
		Mod.ResetSprites()
		for k,v in pairs(Mod.HitPoints) do
			if type(v) == "number" and v > 0 then
				Mod.GetCustomBar(Mod.HitPoints.ID[k]:match("([^.]*)%.([^.]*)%.([^.]*)"))
				if Mod.CustomBars.Current then break end
			end
		end
	end
end

function Mod.UpdateBar()
	if not Mod.HitPoints then return end
	
	if Mod.HitPoints.Entities == 0 then
		Mod.ResetStuff()
		return
	end
	
	Mod.RightClamp = Vector(Mod.Length - Mod.HitPoints.Value / Mod.HitPoints.Max.Value * Mod.Length, 0)
	
	if Mod.HitPoints.LastValue > Mod.HitPoints.Value and not Mod.Sprite.Bar:IsPlaying() then
		Mod.Sprite.Bar:Play("Bar", true)
	end
	
	Mod.HitPoints.LastValue = Mod.HitPoints.Value
end

function Mod.ResetSprites()
	
	local anm
	local id = Game():GetRoom():GetType()
	if (
		Mod.ForceFullBar or
		id == RoomType.ROOM_BOSS or
		id == RoomType.ROOM_BOSSRUSH
	) then -- If the room is a boss room, use the default bar
		anm = "gfx/custom_ui/ui_bosshealthbar.anm2"
	else -- Otherwise use the mini bar
		anm = "gfx/custom_ui/ui_bosshealthbar_mini.anm2"
	end
	
	-- Load animations
	Mod.Sprite.Base:Load(anm, true)
	Mod.Sprite.Base:Play("Base")
	
	Mod.Sprite.Bar:Load(anm, true)
	Mod.Sprite.Bar:Play("Bar")
	
	Mod.Sprite.Over:Load(anm, true)
	Mod.Sprite.Over:Play("Over")
	
	Mod.Length = Mod.Sprite.Bar:GetDefaultAnimationName()
	if ModConfigMenu then
		MCM.ColorChange()
	else
		Mod.Sprite.Bar.Color = Color(1, 0, 0)
	end
	
	Mod.CustomBars.Current = nil
end
Mod.ResetSprites()

function Mod.ResetStuff()
	Mod.HitPoints = nil
	Mod.ForceFullBar = (
		Game():GetLevel():GetStage() == LevelStage.STAGE8
	)
	Mod.ResetSprites()
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
Mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.ResetStuff)
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.MC_POST_GAME_STARTED)
Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, Mod.MC_PRE_GAME_EXIT)

_G.CustomBossbar = Mod