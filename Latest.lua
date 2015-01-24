--[[

---//==================================================\\---
--|| > About Script										||--
---\===================================================//---

	Script:			Nidalee - The Bestial God
	Version:		1.01
	Script Date:	2015-01-23
	Author:			Devn

---//==================================================\\---
--|| > Changelog										||--
---\===================================================//---

	Version 1.00:
		- Initial script release.
		
	Version 1.01:
		- Changed around pounce logic for combo mode.
		- Changed form swapping logic for combo mode.
		- Fixed killstealing during cougar mode.
		- Add key for ScriptStatus.net.

--]]

--[[ Temporary Anti-AFK (Please remove before release)
function OnTick()
	if (not _ANTI_AFK or (_ANTI_AFK <= GetGameTimer())) then
		_ANTI_AFK = GetGameTimer() + 40
		local position = myHero + (Vector(mousePos) - myHero):normalized() * 250
		myHero:MoveTo(position.x, position.z)
	end
end
--]]

---//==================================================\\---
--|| > User Variables									||--
---\===================================================//---

-- Public user variables.
_G.Nidalee_EnableDebugMode = false

---//==================================================\\---
--|| > Initialization									||--
---\===================================================//---

-- Load GodLib.
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQcLAAAABgBAAEFAAAAWQAAAQYAAAKUAAADlQAAAJYEAAGXBAACAAYACnUGAAB8AgAADAAAABAkAAABMSUJfUEFUSAAECwAAAEdvZExpYi5sdWEABEYAAABodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vR29kU2NyaXB0cy9Hb2RMaWIvbWFzdGVyL0xhdGVzdC5sdWEABAAAAAwAAAAUAAAAAQAFDAAAAEYAQABHQMAAgAAAAMGAAABdgIABjMDAAAEBAQCdgIABzEDBAN1AAAGfAAABHwCAAAYAAAAEAwAAAGlvAAQFAAAAb3BlbgAEAgAAAHIABAUAAAByZWFkAAQFAAAAKmFsbAAEBgAAAGNsb3NlAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAFgAAABoAAAABAAYKAAAAQAAAAIEAAADGQEAAx4DAAQHBAABBAQEA3YCAAVbAgABfAAABHwCAAAUAAAAEBwAAAD9yYW5kPQAEBQAAAG1hdGgABAcAAAByYW5kb20AAwAAAAAAAPA/AwAAAAAAiMNAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAcAAAAIAAAAAEABQcAAABGAEAAgUAAAMAAAAABgQAAlgABAV1AAAEfAIAAAwAAAAQKAAAAUHJpbnRDaGF0AAQ8AAAAPGZvbnQgY29sb3I9IiNmNzgxYmUiPkdvZExpYjo8L2ZvbnQ+IDxmb250IGNvbG9yPSIjYmVmNzgxIj4ABAgAAAA8L2ZvbnQ+AAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAIgAAADEAAAAAAAYiAAAACwAAAAgAAIAGQEAARQCAAB2AAAEbAAAAF0ADgAaAQABGwEAAhQAAAcUAgACdgAABxAAAAAEBAQBFAQAAXQCAAh2AAAAdQIAABgBAAAqAwYIXwAKABQCAAUHAAQAdQAABBgBCAEUAAAKFAIACXYAAAYUAgADlAAAAHUAAAgYAQAAKQMKCHwCAAAoAAAAEDQAAAEdvZExpYl9TZXR1cAAECgAAAEZpbGVFeGlzdAAEBwAAAGFzc2VydAAEBQAAAGxvYWQABAIAAAB0AAQHAAAATG9hZGVkAAEBBBwAAABEb3dubG9hZGluZywgcGxlYXNlIHdhaXQuLi4ABA0AAABEb3dubG9hZEZpbGUAAQABAAAAKwAAAC0AAAAAAAIEAAAABQAAAEEAAAAdQAABHwCAAAEAAAAEOwAAAERvd25sb2FkZWQgc3VjY2Vzc2Z1bGx5ISBQbGVhc2UgcmVsb2FkIHNjcmlwdCAoZG91YmxlIEY5KS4AAAAAAAEAAAAAAwAAAAAAAAAAAAAAAAAAAAAGAAAAAAABAAECAQQBAwEBAAAAAAAAAAAAAAAAAAAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAAA="), nil, "bt", _ENV))()
if (not GodLib_Setup.Loaded) then return end

-- Script variables.
GodLib_Setup.ScriptTitle		= "Nidalee - The Bestial God"
GodLib_Setup.ScriptName 		= "Nidalee"
GodLib_Setup.ScriptVersion		= "1.01"
GodLib_Setup.ScriptDate			= "2015-01-23"
GodLib_Setup.StatusKey			= "PCFDDBHBJEE"

-- Required libraries.
GodLib_Setup.RequiredLibraries	= {
	["SxOrbWalk"]				= "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
}

-- Initialize GodLib script.
Initialize("nidalee")

---//==================================================\\---
--|| > Callback Handlers								||--
---\===================================================//---

Callbacks:Bind("Initialize", function()

	SetupVariables()
	SetupDebugger()
	SetupConfig()

end)

Callbacks:Bind("ProcessSpell", function(unit, spell)

	if (unit.isMe) then
		OnUpdateCooldowns(spell)
	end

end)

Callbacks:Bind("Draw", function()

	if (myHero.dead) then
		return
	end
	
	OnDrawRanges(Config.Drawing)

end)

Callbacks:Bind("Attack", function(target)

	if (CougarForm and Config.Combo.Active and Config.Combo.UseQCougar and Spells.Cougar[_Q]:IsReady() and target and IsValid(target)) then
		Spells.Cougar[_Q]:Cast()
	end

end)

---//==================================================\\---
--|| > Script Setup										||--
---\===================================================//---

function SetupVariables()
	
	Spells			= {
		["Human"]	= {
			[_Q]	= SpellData(_Q, "Javelin Toss", 1500),
			[_W]	= SpellData(_W, "Bushwhack", 900),
			[_E]	= SpellData(_R, "Primal Surge", 650),
		},
		["Cougar"]	= {
			[_Q]	= SpellData(_Q, "Takedown", 200),
			[_W]	= SpellData(_W, "Pounce", 375),
			[_E]	= SpellData(_E, "Swipe", 300),
		},
		[_R]		= SpellData(_R, "Aspect of the Cougar"),
	}

	Cooldowns		= {
		["Human"]	= {
			[_Q]	= 0,
			[_W]	= 0,
			[_E]	= 0,
		},
		["Cougar"]	= {
			[_Q]	= 0,
			[_W]	= 0,
			[_E]	= 0,
		},
	}
	
	CurrentTarget	= nil
	CougarForm		= false
	
	Config			= MenuConfig(ScriptName, ScriptTitle)
	Selector		= SimpleTS(STS_LESS_CAST)
	Debugger		= VisualDebugger()
	
	Spells.Human[_Q]:SetSkillshot(SKILLSHOT_LINEAR, 40, 0.5, 1300, true)
	Spells.Human[_W]:SetSkillshot(SKILLSHOT_CIRCULAR, 100, 0.5, 1500, false)
	
	Spells.Cougar[_W]:SetSkillshot(SKILLSHOT_CONE, 400, 0.5, 1500, false)
	Spells.Cougar[_E]:SetSkillshot(SKILLSHOT_CONE, 375, 0.5, 1500, false)
	
	TickManager:Add("Combo", "Combo Mode", 100, function() OnComboMode(Config.Combo) end)
	TickManager:Add("Harass", "Harass Mode", 100, function() OnHarassMode(Config.Harass) end)
	TickManager:Add("Killsteal", "Killsteal", 100, function() OnKillsteal(Config.Killstealing) end)
	TickManager:Add("UpdateTarget", "Update Current Target", 100, OnUpdateTarget)
	TickManager:Add("UpdateCougarForm", "Update Cougar Form", 100, OnUpdateCougarForm)
	TickManager:Add("ProcessCooldowns", "Process Cooldowns", 100, OnProcessCooldowns)
	
end

function SetupDebugger()

	Debugger:Group("SpellsHuman", "Hero Spells (Human)")
	Debugger:Variable("SpellsHuman", Format("{1} (Q)", Spells.Human[_Q].Name), function() return (Spells.Human[_Q].Ready) end)
	Debugger:Variable("SpellsHuman", Format("{1} (W)", Spells.Human[_W].Name), function() return (Spells.Human[_W].Ready) end)
	Debugger:Variable("SpellsHuman", Format("{1} (E)", Spells.Human[_E].Name), function() return (Spells.Human[_E].Ready) end)
	Debugger:Variable("SpellsHuman", Format("{1} (R)", Spells[_R].Name), function() return Spells[_R]:IsReady() end)

	Debugger:Group("SpellsCougar", "Hero Spells (Cougar)")
	Debugger:Variable("SpellsCougar", Format("{1} (Q)", Spells.Cougar[_Q].Name), function() return (Spells.Cougar[_Q].Ready) end)
	Debugger:Variable("SpellsCougar", Format("{1} (W)", Spells.Cougar[_W].Name), function() return (Spells.Cougar[_W].Ready) end)
	Debugger:Variable("SpellsCougar", Format("{1} (E)", Spells.Cougar[_E].Name), function() return (Spells.Cougar[_E].Ready) end)

	Debugger:Group("Misc", "Misc Variables")
	Debugger:Variable("Misc", "Cougar Form", function() return CougarForm end)
	
end

function SetupConfig()

	Config:Menu("Orbwalker", "Settings: Orbwalker")
	Config:Menu("Selector", "Settings: Target Selector")
	Config:Menu("Combo", "Settings: Combo Mode")
	Config:Menu("Harass", "Settings: Harass Mode")
	Config:Menu("Killstealing", "Settings: Killstealing")
	Config:Menu("Drawing", "Settings: Drawing")
	Config:Menu("TickManager", "Settings: Tick Manager")
	Config:Separator()
	Config:Info("Version", ScriptVersion)
	Config:Info("Build Date", ScriptDate)
	Config:Info("Author", "Devn")
	
	SxOrb:LoadToMenu(Config.Orbwalker, true, false)
	Selector:LoadToMenu(Config.Selector)
	SetupConfig_Combo(Config.Combo)
	SetupConfig_Harass(Config.Harass)
	SetupConfig_Killstealing(Config.Killstealing)
	SetupConfig_Drawing(Config.Drawing)
	TickManager:LoadToMenu(Config.TickManager)
	
	if (EnableDebugMode) then
		Config:Menu("Debugger", "Settings: Visual Debugger")
		Debugger:LoadToMenu(Config.Debugger)
	end

end

---//==================================================\\---
--|| > Config Setup										||--
---\===================================================//---

function SetupConfig_Combo(config)
	
	config:KeyBinding("Active", "Combo Mode Active", false, 32)
	config:Separator()
	config:Toggle("UseQHuman", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config:Toggle("UseQCougar", Format("Use {1} (Q)", Spells.Cougar[_Q].Name), true)
	config:Separator()
	config:DropDown("UseWHuman", Format("Use {1} (W)", Spells.Human[_W].Name), 2, { "Always", "On Inmobile", "Disabled" })
	config:DropDown("UseWCougar", Format("Use {1} (W)", Spells.Cougar[_W].Name), 2, { "Always", "If out of AA Range", "Disabled" })
	config:Separator()
	config:Toggle("UseECougar", Format("Use {1} (E)", Spells.Cougar[_Q].Name), true)
	config:Separator()
	config:Toggle("UseR", Format("Use {1} (R)", Spells[_R].Name), true)
	
end

function SetupConfig_Harass(config)
	
	config:KeyBinding("Active", "Harass Mode Active", false, "T")
	config:Separator()
	config:Toggle("UseQHuman", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config:Slider("MinManaQHuman", "Minimum Mana", 35, 0, 100)

end

function SetupConfig_Killstealing(config)

	config:Toggle("Enable", "Enable Killstealing", true)
	config:Separator()
	config:Toggle("UseQHuman", Format("Use {1} (Q)", Spells.Human[_Q].Name), true)
	config:Toggle("AutoR", "Auto Switch Form to KS", true)

end

function SetupConfig_Drawing(config)

	config:Menu("Human", "Spell: Human")
	--config:Menu("Cougar", "Spell: Cougar")
	
	config.Human:Toggle("QRange", Format("Draw {1} (Q) Range", Spells.Human[_Q].Name), true)
	config.Human:DropDown("QRangeColor", "Range Color", 1, DrawManager.Colors)
	
	config:Separator()
	DrawManager:LoadToMenu(config)
	config:Separator()
	config:Toggle("AA", "Draw Auto-Attack Range", true)
	config:DropDown("AAColor", "Range Color", 1, DrawManager.Colors)
	config:Separator()
	config:Toggle("Cooldowns", "Draw Opposite Form Cooldowns", true)
	config:DropDown("CooldownsColor", "Text Color", 1, DrawManager.Colors)
	
end

---//==================================================\\---
--|| > Main Callback Handlers							||--
---\===================================================//---

function OnComboMode(config)

	if (myHero.dead or not config.Active or not IsValid(CurrentTarget, 1500)) then
		return
	end
	
	if (CougarForm) then
		if (Spells.Cougar[_Q]:IsReady() and config.UseQCougar and Spells.Cougar[_Q]:InRange(CurrentTarget)) then
			Spells.Cougar[_Q]:Cast()
			SxOrb:MyAttack(CurrentTarget)
		end
		if (Spells.Cougar[_W]:IsReady() and (config.UseWCougar < 3)) then
			if ((config.UseWCougar == 1) or ((config.UseWCougar == 2) and not InRange(CurrentTarget, Player:GetRange(CurrentTarget)))) then
				--Spells.Cougar[_W]:CastAt(CurrentTarget)
				if (Spells.Cougar[_W]:InRange(CurrentTarget)) then
					Spells.Cougar[_W]:CastAt(CurrentTarget)
				elseif (TargetHunted(CurrentTarget) and InRange(CurrentTarget, 750)) then
					Spells.Cougar[_W]:CastAt(CurrentTarget)
				end
			end
		end
		if (Spells.Cougar[_E]:IsReady() and config.UseECougar and Spells.Cougar[_E]:IsValid(CurrentTarget)) then
			Spells.Cougar[_E]:CastAt(CurrentTarget)
		end
		if (Spells[_R]:IsReady() and config.UseR) then
			if (Spells.Human[_Q].Ready) then
				if (CurrentTarget.health <= CougarDamage(CurrentTarget) and InRange(CurrentTarget, (Spells.Cougar[_E].Range + Spells.Cougar[_W].Range))) then
					return
				end
				local _, hitchance, _ = Spells.Human[_Q]:GetPrediction(CurrentTarget)
				if (hitchance >= 2) then
					Spells[_R]:Cast()
				end
			end
			if (not Spells.Cougar[_Q]:IsReady() and not Spells.Cougar[_W]:IsReady() and not Spells.Cougar[_E]:IsReady() and not Spells.Cougar[_W]:InRange(CurrentTarget)) then
				Spells[_R]:Cast()
			end
		end
	else
		if (Spells.Human[_Q]:IsReady() and config.UseQHuman and Spells.Human[_Q]:IsValid(CurrentTarget)) then
			Spells.Human[_Q]:Cast(CurrentTarget)
		end
		if (Spells.Human[_W]:IsReady() and (config.UseWHuman < 3) and Spells.Human[_W]:InRange(CurrentTarget)) then
			if (config.UseWHuman == 1) then
				Spells.Human[_W]:Cast(CurrentTarget)
			elseif (config.UseWHuman == 2) then
				Spells.Human[_W]:CastIfImmobile(CurrentTarget)
			end
		end
		if (Spells[_R]:IsReady() and config.UseR) then
			local first = false
			local swap = false
			if (Spells.Human[_Q]:IsReady()) then
				local _, hitchance, _ = Spells.Human[_Q]:GetPrediction(CurrentTarget)
				if (hitchance < 2) then
					first = true
				end
			else
				first = true
			end
			if (first) then
				if (Spells.Cougar[_W].Ready) then
					if (not TargetHunted(CurrentTarget) and Spells.Cougar[_W]:InRange(CurrentTarget)) then
						swap = true
					elseif (InRange(CurrentTarget, 750)) then
						swap = true
					end
				end
				if (Spells.Cougar[_Q].Ready and Spells.Cougar[_Q]:InRange(CurrentTarget)) then
					swap = true
				elseif (Spells.Cougar[_E].Ready and Spells.Cougar[_E]:InRange(CurrentTarget)) then
					swap = true
				end
				if (swap) then
					Spells[_R]:Cast()
				end
			end
		end
	end
	
end

function OnHarassMode(config)

	if (myHero.dead or not config.Active or not IsValid(CurrentTarget, 1500)) then
		return
	end
	
	if (not CougarForm and config.UseQHuman and Spells.Human[_Q]:IsReady() and HaveEnoughMana(config.MinManaQHuman)) then
		Spells.Human[_Q]:Cast(CurrentTarget)
	end

end

function OnKillsteal(config)

	if (not config.Enable) then
		return
	end
	
	for _, enemy in ipairs(GetEnemyHeroes()) do
		if (enemy and not enemy.dead and Spells.Human[_Q]:IsValid(enemy)) then
			local damage = getDmg("Q", enemy, myHero)
			local damageA = getDmg("AD", enemy, myHero)
			if (CougarForm) then
				local damageQ = getDmg("QM", enemy, myHero)
				local damageW = getDmg("WM", enemy, myHero)
				local damageE = getDmg("EM", enemy, myHero)
				if ((enemy.health <= damageE) and Spells.Cougar[_E]:IsReady() and Spells.Cougar[_E]:IsValid(enemy)) then
					Spells.Cougar[_E]:CastAt(enemy)
					return
				elseif ((enemy.health <= damageQ) and Spells.Cougar[_Q]:IsReady() and Spells.Cougar[_Q]:IsValid(enemy)) then
					Spells.Cougar[_Q]:Cast()
					SxOrb:MyAttack(enemy)
					return
				elseif ((enemy.health <= damageW) and Spells.Cougar[_W]:IsReady() and Spells.Cougar[_W]:IsValid(enemy)) then
					Spells.Cougar[_W]:CastAt(enemy)
					return
				elseif ((enemy.health <= damageA) and not InRange(enemy, Player:GetRange(enemy)) and InRange(enemy, 600)) then
					Spells[_R]:Cast()
					return
				end
			else
				if ((enemy.health <= damageA) and InRange(enemy, Player:GetRange(enemy))) then
					SxOrb:MyAttack(enemy)
				end
			end
			if (enemy.health <= damage) then
				if (not CougarForm) then
					if (Spells.Human[_Q]:IsReady()) then
						Spells.Human[_Q]:Cast(enemy)
						return
					end
				elseif (Spells[_R]:IsReady() and Spells.Human[_Q].Ready) then
					local _, hitchance, _ = Spells.Human[_Q]:GetPrediction(CurrentTarget)
					if (hitchance >= 2) then
						Spells[_R]:Cast()
						return
					end
				end
			end
		end
	end

end

function OnDrawRanges(config)

	if (config.AA) then
		DrawManager:DrawCircleAt(myHero, Player:GetRange(), config.AAColor)
	end

	if (config.Human.QRange) then
		DrawManager:DrawCircleAt(myHero, Spells.Human[_Q].Range, config.Human.QRangeColor)
	end

	if (config.Cooldowns) then
		local size = 14
		local position = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
		if (CougarForm) then
			if (Spells.Human[_Q]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("Q: Null", size, position.x - 80, position.y, config.CooldownsColor)
			elseif (Spells.Human[_Q].Ready) then
				DrawManager:DrawTextWithBorder("Q: Ready", size, position.x - 80, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("Q: {1}", tostring(math.floor(1 + (Cooldowns.Human[_Q] - GetGameTimer())))), size, position.x - 80, position.y, config.CooldownsColor)
			end
			if (Spells.Human[_W]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("W: Null", size, position.x - 30, position.y + 30, config.CooldownsColor)
			elseif (Spells.Human[_W].Ready) then
				DrawManager:DrawTextWithBorder("W: Ready", size, position.x - 30, position.y + 30, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("W: {1}", tostring(math.floor(1 + (Cooldowns.Human[_W] - GetGameTimer())))), size, position.x - 30, position.y + 30, config.CooldownsColor)
			end
			if (Spells.Human[_E]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("E: Null", size, position.x, position.y, config.CooldownsColor)
			elseif (Spells.Human[_E].Ready) then
				DrawManager:DrawTextWithBorder("E: Ready", size, position.x, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("E: {1}", tostring(math.floor(1 + (Cooldowns.Human[_E] - GetGameTimer())))), size, position.x, position.y, config.CooldownsColor)
			end
		else
			if (Spells.Cougar[_Q]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("Q: Null", size, position.x - 80, position.y, config.CooldownsColor)
			elseif (Spells.Cougar[_Q].Ready) then
				DrawManager:DrawTextWithBorder("Q: Ready", size, position.x - 80, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("Q: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_Q] - GetGameTimer())))), size, position.x - 80, position.y, config.CooldownsColor)
			end
			if (Spells.Cougar[_W]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("W: Null", size, position.x - 30, position.y + 30, config.CooldownsColor)
			elseif (Spells.Cougar[_W].Ready) then
				DrawManager:DrawTextWithBorder("W: Ready", size, position.x - 30, position.y + 30, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("W: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_W] - GetGameTimer())))), size, position.x - 30, position.y + 30, config.CooldownsColor)
			end
			if (Spells.Cougar[_E]:GetLevel() == 0) then
				DrawManager:DrawTextWithBorder("E: Null", size, position.x, position.y, config.CooldownsColor)
			elseif (Spells.Cougar[_E].Ready) then
				DrawManager:DrawTextWithBorder("E: Ready", size, position.x, position.y, config.CooldownsColor)
			else
				DrawManager:DrawTextWithBorder(Format("E: {1}", tostring(math.floor(1 + (Cooldowns.Cougar[_E] - GetGameTimer())))), size, position.x, position.y, config.CooldownsColor)
			end
		end
	end
	
end

---//==================================================\\---
--|| > Misc Callback Handlers							||--
---\===================================================//---

function OnUpdateTarget()

	CurrentTarget = Selector:SelectedTarget() or Selector:GetTarget(Spells.Human[_Q].Range)

end

function OnProcessCooldowns()

	Spells.Cougar[_Q].Ready	= (not myHero.dead and (Spells.Cougar[_Q]:GetLevel() >= 1) and (Cooldowns.Cougar[_Q] - GetGameTimer() <= 0))
	Spells.Cougar[_W].Ready	= (not myHero.dead and (Spells.Cougar[_W]:GetLevel() >= 1) and (Cooldowns.Cougar[_W] - GetGameTimer() <= 0))
	Spells.Cougar[_E].Ready	= (not myHero.dead and (Spells.Cougar[_E]:GetLevel() >= 1) and (Cooldowns.Cougar[_E] - GetGameTimer() <= 0))
	
	Spells.Human[_Q].Ready	= (not myHero.dead and (Spells.Human[_Q]:GetLevel() >= 1) and (Cooldowns.Human[_Q] - GetGameTimer() <= 0))
	Spells.Human[_W].Ready	= (not myHero.dead and (Spells.Human[_W]:GetLevel() >= 1) and (Cooldowns.Human[_W] - GetGameTimer() <= 0))
	Spells.Human[_E].Ready	= (not myHero.dead and (Spells.Human[_E]:GetLevel() >= 1) and (Cooldowns.Human[_E] - GetGameTimer() <= 0))

end

function OnUpdateCougarForm()

	CougarForm = (Spells.Cougar[_Q]:GetName():equals("Takedown"))
	
end

function OnUpdateCooldowns(spell)

	if (CougarForm) then
		if (spell.name:equals("Takedown")) then
			Cooldowns.Cougar[_Q] = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:equals("Pounce")) then
			Cooldowns.Cougar[_W] = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:equals("Swipe")) then
			Cooldowns.Cougar[_E] = GetGameTimer() + GetSpellCooldown(5)
		end
	else
		if (spell.name:equals("JavelinToss")) then
			Cooldowns.Human[_Q] = GetGameTimer() + GetSpellCooldown(6)
		elseif (spell.name:equals("Bushwhack")) then
			Cooldowns.Human[_W] = GetGameTimer() + GetSpellCooldown(14 - (1 * Player:GetLevel()))
		elseif (spell.name:equals("PrimalSurge")) then
			Cooldowns.Human[_E] = GetGameTimer() + GetSpellCooldown(12)
		end
	end
	
end

---//==================================================\\---
--|| > Misc Functions									||--
---\===================================================//---

function GetCooldowns(spell)

	if (not CougarForm) then
		if (spell.name == "javelintoss") then
			Cooldowns.Human[_Q].Total = GetGameTimer() + GetSpellCooldown(6)
		elseif (spell.name:equals("bushwhack")) then
			Cooldowns.Human[_W].Total = GetGameTimer() + GetSpellCooldown(13 - (1 * (Spells.Human[_W]:GetLevel() - 1)))
		elseif (spell.name:equals("primalsurge")) then
			Cooldowns.Human[_E].Total = GetGameTimer() + GetSpellCooldown(12)
		end
	else
		if (spell.name == "takedown") then
			Cooldowns.Cougar[_Q].Total = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:equals("pounce")) then
			Cooldowns.Cougar[_W].Total = GetGameTimer() + GetSpellCooldown(5)
		elseif (spell.name:equals("swipe")) then
			Cooldowns.Cougar[_E].Total = GetGameTimer() + GetSpellCooldown(5)
		end
	end

end

function GetSpellCooldown(cooldown)

	local cdr = Player:GetCooldownReduction()
	return (cooldown - (cooldown * cdr))

end

function TargetHunted(unit)

	return (HasBuff(unit, "nidaleepassivehunted"))

end

function CougarDamage(target)

	local damage = 0
	
	if (Cooldowns.Cougar[_Q] < 1) then
		damage = damage + (getDmg("QM", target, myHero) or 0)
	end
	
	if (Cooldowns.Cougar[_W] < 1) then
		damage = damage + (getDmg("WM", target, myHero) or 0)
	end
	
	if (Cooldowns.Cougar[_E] < 1) then
		damage = damage + (getDmg("EM", target, myHero) or 0)
	end
	
	return damage

end

function CanKillAA(target)

	local damage = 0
	
	if (IsValid(target, Player:GetRange(target))) then
		damage = getDmg("AD", target, myHero)
	end
	
	return (target.health <= (damage * 5))

end

---//==================================================\\---
--|| > Override Functions								||--
---\===================================================//---

Callbacks:Bind("Overrides", function()

	function SxOrb:GetTarget(range)
	
		return (self:ValidTarget(CurrentTarget, range) and CurrentTarget) or Selector:GetTarget(Player:GetRange())
	
	end

end)
