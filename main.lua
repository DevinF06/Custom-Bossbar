local mod = RegisterMod("Custom Bossbar", 1)
local mcm = {}
local hsv = require("hsv")
local json = require("json")

require("scripts.screenhelper")

local function default(value, default)
	return value ~= nil and value or default
end

mod.ENTITYLIST = {}
if not ModConfigMenu then -- Include Mega Satan, Mother, and The Beast (...and horsemen) without MCM
	local function f(id)
		mod.ENTITYLIST[id] = true
	end
	
	f("274.0.0")
	f("275.0.0")
	f("912.0.0")
	f("912.10.0")
	f("951.0.0")
	f("951.10.0")
	f("951.20.0")
	f("951.30.0")
	f("951.40.0")
end

mod.Pos = Vector.Zero
mod.BasePos = Vector(1, -10)
mod.Offset = 0
mod.RightClamp = Vector.Zero
mod.MCM = mcm

mod.CustomAnm = true
mod.ForceColor = true
mod.InstaFix = false

mod.CustomBars = {
	HasAnm = {},
	
	Color = {}
}

mod.Sprite = {
	Base = Sprite(),
	Bar = Sprite(),
	Over = Sprite()
}


mcm.Defaults = {
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
	SepBar = true,
	InstaFix = false
}

function mcm.LoadData(data)
	-- Make sure data has defaults, and of same type
	for k, v in pairs(mcm.Defaults) do
		if type(data[k]) ~= type(v) then
			data[k] = v
		end
	end
	mcm.Data = data
	
	if not ModConfigMenu then return end
	
	ModConfigMenu.Config["Custom Bossbar"] = data
	mcm.FixOffset()
	mcm.ColorChange()
	mcm.BossChange()
	mcm.OtherChange()
end

function mcm.SaveData()
	if not ModConfigMenu then return mcm.Data end
	return ModConfigMenu.Config["Custom Bossbar"]
end

function mod.FixPos()
	local size = ScreenHelper.GetScreenSize()
	mod.Pos = mod.BasePos + Vector(size.X / 2, size.Y - mod.Offset * 1.6)
end

if ModConfigMenu then

	function mcm.FixOffset()
		mod.Offset = default(ModConfigMenu.Config["General"].HudOffset, 0)
		ScreenHelper.SetOffset(mod.Offset)
		mod.FixPos()
	end
	
	function mcm.Display(text)
		return function ()
			mcm.InMenu = true
			return text
		end
	end
	
	function mcm.OnChange(setting, func)
		-- Keep the old value, or nothing else will happen
		local oldFunc = setting.OnChange
		
		setting.OnChange = function (value)
			oldFunc(value)
			func(value)
		end
		
		return setting
	end
	
	
	function mcm.ColorChange()
		mod.Sprite.Bar.Color = Color(
			ModConfigMenu.Config["Custom Bossbar"].ColorR / 10,
			ModConfigMenu.Config["Custom Bossbar"].ColorG / 10,
			ModConfigMenu.Config["Custom Bossbar"].ColorB / 10
		)
		
		if mod.Chroma then mod.Chroma = nil end
		if ModConfigMenu.Config["Custom Bossbar"].Chroma ~= 0 then
			local hue, sat, val = hsv.FromRGB(mod.Sprite.Bar.Color.R, mod.Sprite.Bar.Color.G, mod.Sprite.Bar.Color.B)
			local shift = math.floor(1 / sat + 0.5)
			local mult = default(ModConfigMenu.Config["Custom Bossbar"].Chroma, 1)
			
			mod.Chroma = { hue = hue, sat = sat, val = val, shift = shift, mult = mult }
			mod.Sprite.Bar.Color = Color(hsv.ToRGB(Isaac.GetFrameCount() / shift * 2, 1, val))
		end
		
	end
	
	function mcm.BossChange()
		local function f(id, name)
			mod.ENTITYLIST[id] = ModConfigMenu.Config["Custom Bossbar"][name]
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
	
	function mcm.OtherChange()
		mod.CustomAnm = ModConfigMenu.Config["Custom Bossbar"].CustomAnm
		mod.ForceColor = ModConfigMenu.Config["Custom Bossbar"].ForceColor
		mod.BasePos.Y = ModConfigMenu.Config["Custom Bossbar"].SepBar and -25 or -10
		mod.InstaFix = ModConfigMenu.Config["Custom Bossbar"].InstaFix
		
		mod.FixPos()
	end
	
	
	local t, t2, v, f
	
	mcm.OnChange(ModConfigMenu.MenuData[1].Subcategories[1].Options[1], mcm.FixOffset)
	
	ModConfigMenu.AddText("Custom Bossbar", "General", mcm.Display("Default color"))
	t = "Modify the bar's color"
	mcm.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorR", 10, "R", t), mcm.ColorChange)
	mcm.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorG", 0, "G", t), mcm.ColorChange)
	mcm.OnChange(ModConfigMenu.AddScrollSetting("Custom Bossbar", "General", "ColorB", 0, "B", t), mcm.ColorChange)
	mcm.OnChange(ModConfigMenu.AddNumberSetting("Custom Bossbar", "General", "Chroma", 0, 5, 0, "Chroma", { [0] = "off", "x1", "x2", "x3", "x4", "x5" }, "Allows the bar to shift hue$newlineIt's speed depends on the saturation"), mcm.ColorChange)
	
	t = "Allows the bar to show on "
	t2 = "$newlineHud needs to be hidden for the custom bar to show"
	v = false
	f = function (value, name)
		mcm.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", "Boss" .. value, v, name, t .. name .. t2), mcm.BossChange)
	end
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", mcm.Display("Enable on minibosses"))
	f("Sloth", "Sloth")
	f("Lust", "Lust")
	f("Wrath", "Wrath")
	f("Gluttony", "Gluttony")
	f("Greed", "Greed")
	f("Envy", "Envy")
	f("Pride", "Pride")
	ModConfigMenu.AddText("Custom Bossbar", "General", mcm.Display(""))
	f("SuperSloth", "Super Sloth")
	f("SuperLust", "Super Lust")
	f("SuperWrath", "Super Wrath")
	f("SuperGluttony", "Super Gluttony", t .. "Super Gluttony")
	f("SuperGreed", "Super Greed")
	f("SuperEnvy", "Super Envy")
	f("SuperPride", "Super Pride")
	
	ModConfigMenu.AddSpace("Custom Bossbar", "General")
	ModConfigMenu.AddText("Custom Bossbar", "General", mcm.Display("Enable on bosses"))
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
	ModConfigMenu.AddText("Custom Bossbar", "General", mcm.Display("Enable on final bosses"))
	f("MegaSatan", "Mega Satan")
	f("Mother", "Mother")
	f("TheBeast", "The Beast")
	
	f = function (value, name, def, desc)
		mcm.OnChange(ModConfigMenu.AddBooleanSetting("Custom Bossbar", "General", value, def, name, { [false] = "off", [true] = "on" }, desc), mcm.OtherChange)
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

function mod.GetCustomBar(Type, Variant, SubType)
	if not mod.CustomAnm then return end
	if mod.CustomBars.Current then return end
	
	local str = string.format("%i.%i.%i", Type, Variant, SubType)
	local str2, spr
	
	if not mod.CustomBars.HasAnm[str] or mod.CustomBars.HasAnm == nil then
		str2 = string.format("gfx/custom_ui/ui_bosshealthbar-%s", str):gsub("%.", "_") .. ".anm2"
		
		-- Create a new sprite because it breaks the og sprite
		spr = Sprite()
		spr:Load(str2, true)
		
		-- Check if the default animation name is a number and greater than 0
		if default(tonumber(spr:GetDefaultAnimationName()), 0) <= 0 then
			-- It is not, mark the type to not be checked again
			mod.CustomBars.HasAnm[str] = false
			return
		end
		
		mod.Sprite.Base:Load(str2, true)
		mod.Sprite.Base:Play("Base")
		
		mod.Sprite.Bar:Load(str2, true)
		mod.Sprite.Bar:Play("Bar")
		
		mod.Sprite.Over:Load(str2, true)
		mod.Sprite.Over:Play("Over")
		
		if not mod.ForceColor then
			mod.Sprite.Bar.Color = default(mod.CustomBars.Color[str], Color(1, 0, 0))
		end
		
		mod.CustomBars.Current = str
		mod.CustomBars.HasAnm[str] = true
	end
end

function mod.EntityListCheck(entity)
	return (
		--entity:IsBoss() or
		mod.ENTITYLIST[entityTypeString(entity)]
	) and true or false
end

function mod:MC_POST_RENDER()
	if mcm.InMenu then -- Previews while on the MCM page
		mod.RightClamp = Vector.Zero
		mcm.InMenu = false
	elseif not mod.HitPoints then
		return
	end
	
	local frame = Isaac.GetFrameCount()
	if mod.InstaFix or frame % 30 == 0 then mod.FixPos() end
	
	if mod.Chroma and (mod.ForceColor or not mod.CustomBars.Current) and frame % mod.Chroma.shift == 0 then
		local hue = frame / mod.Chroma.shift * mod.Chroma.mult
		mod.Sprite.Bar.Color = Color(hsv.ToRGB(hue, 1, mod.Chroma.val))
	end
	
	mod.Sprite.Base:Render(mod.Pos)
	mod.Sprite.Bar:Render(mod.Pos, Vector.Zero, mod.RightClamp)
	mod.Sprite.Over:Render(mod.Pos)
	
	mod.Sprite.Base:Update()
	mod.Sprite.Bar:Update()
	mod.Sprite.Over:Update()
end

function mod:CalculateHitPoints(entity)
	if not mod.EntityListCheck(entity) then return end
	-- Must be something you can deal damage to or already in the table
	if not entity:IsVulnerableEnemy() and (not mod.HitPoints or not mod.HitPoints[GetPtrHash(entity)]) then return end
	
	if not mod.HitPoints then
		mod.HitPoints = {
			Value = 0, LastValue = 0, -- LastValue used for animation
			Max = { Value = 0 }, -- Max value of bar
			Entities = 0, -- Number of entities
			
			ID = {} -- Entity types, don't ask why it's called ID
		}
	end
	
	-- Setup vars
	local ptr = GetPtrHash(entity)
	local hp = math.max(entity.HitPoints, 0)
	local diff = default(mod.HitPoints.Max[ptr], 0)
	local id = entityTypeString(entity)
	
	-- If entity is not in the table
	if not mod.HitPoints[ptr] then
		mod.HitPoints.Entities = mod.HitPoints.Entities + 1
		mod.HitPoints.ID[ptr] = id
		mod.GetCustomBar(entity.Type, entity.Variant, entity.SubType)
	end
	
	
	-- Modify maximum value
	mod.HitPoints.Max[ptr] = math.max(hp, diff)
	if hp <= 1 and mod.HitPoints.ID[ptr] ~= id then -- Make sure entity health is 1, because what kind of entity changes when not at 1 health?
		-- If entity has changed, reset max value
		mod.HitPoints.Max[ptr] = 0
		mod.HitPoints.ID[ptr] = id
	end
	mod.HitPoints.Max.Value = mod.HitPoints.Max.Value + mod.HitPoints.Max[ptr] - diff
	
	-- Modify value
	diff = default(mod.HitPoints[ptr], 0)
	mod.HitPoints[ptr] = hp
	mod.HitPoints.Value = mod.HitPoints.Value + mod.HitPoints[ptr] - diff
	
	mod.UpdateBar()
end

function mod.FixHitPoints()
	if not mod.HitPoints then return end
	
	mod.HitPoints.Value = 0
	for k,v in pairs(mod.HitPoints) do
		if type(v) == "number" then
			mod.HitPoints.Value = mod.HitPoints.Value + v
		end
	end
	
	mod.HitPoints.Max.Value = 0
	for k,v in pairs(mod.HitPoints.Max) do
		if type(v) == "number" then
			mod.HitPoints.Max.Value = mod.HitPoints.Max.Value + v
		end
	end
	
	mod.UpdateBar()
end

function mod:MC_POST_ENTITY_REMOVE(entity)
	if not mod.HitPoints then return end
	
	local ptr = GetPtrHash(entity)
	if not mod.HitPoints[ptr] then return end
	
	-- Decrement the number of entities
	mod.HitPoints.Entities = mod.HitPoints.Entities - 1
	mod:CalculateHitPoints(entity)
	
	if mod.HitPoints and mod.CustomBars.Current == entityTypeString(entity) then
		mod.ResetSprites()
		for k,v in pairs(mod.HitPoints) do
			if type(v) == "number" and v > 0 then
				mod.GetCustomBar(mod.HitPoints.ID[k]:match("([^.]*)%.([^.]*)%.([^.]*)"))
				if mod.CustomBars.Current then break end
			end
		end
	end
end

function mod.UpdateBar()
	if not mod.HitPoints then return end
	
	if mod.HitPoints.Entities == 0 then
		mod.ResetStuff()
		return
	end
	
	mod.RightClamp = Vector(mod.Length - mod.HitPoints.Value / mod.HitPoints.Max.Value * mod.Length, 0)
	
	if mod.HitPoints.LastValue > mod.HitPoints.Value and not mod.Sprite.Bar:IsPlaying() then
		mod.Sprite.Bar:Play("Bar", true)
	end
	
	mod.HitPoints.LastValue = mod.HitPoints.Value
end

function mod.ResetSprites()
	
	local anm
	if (
		mod.StageID == LevelStage.STAGE8 or
		mod.RoomID == RoomType.ROOM_BOSS or
		mod.RoomID == RoomType.ROOM_BOSSRUSH
	) then -- If the room is a boss room, use the default bar
		anm = "gfx/custom_ui/ui_bosshealthbar.anm2"
	else -- Otherwise use the mini bar
		anm = "gfx/custom_ui/ui_bosshealthbar_mini.anm2"
	end
	
	-- Load animations
	mod.Sprite.Base:Load(anm, true)
	mod.Sprite.Base:Play("Base")
	
	mod.Sprite.Bar:Load(anm, true)
	mod.Sprite.Bar:Play("Bar")
	
	mod.Sprite.Over:Load(anm, true)
	mod.Sprite.Over:Play("Over")
	
	mod.Length = mod.Sprite.Bar:GetDefaultAnimationName()
	if ModConfigMenu then
		mcm.ColorChange()
	else
		mod.Sprite.Bar.Color = Color(1, 0, 0)
	end
	
	mod.CustomBars.Current = nil
end
mod.ResetSprites()

function mod.ResetStuff()
	mod.HitPoints = nil
	
	mod.RoomID = Game():GetRoom():GetType()
	mod.StageID = Game():GetLevel():GetStage()
	mod.ResetSprites()
end

function mod:MC_POST_GAME_STARTED()
	if not mod:HasData() then return end
	local data = json.decode(mod:LoadData())
	
	mod.ENTITYLIST = data.ENTITYLIST
	mcm.LoadData(default(data.MCM, {}))
end

function mod:MC_PRE_GAME_EXIT()
	mod:SaveData(json.encode({
		ENTITYLIST = mod.ENTITYLIST,
		MCM = mcm.SaveData()
	}))
end


mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.MC_POST_RENDER)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.CalculateHitPoints)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.CalculateHitPoints)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CalculateHitPoints)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.MC_POST_ENTITY_REMOVE)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetStuff)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.MC_POST_GAME_STARTED)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.MC_PRE_GAME_EXIT)

_G.CustomBossbar = mod