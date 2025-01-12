--[[
This script is a module with various functions for "cards" the player can access, these cards do different things on activation such as causing the player to jump or firing a projectile

A lot of "elseif" due to the fact that Roblox does not have switch statements.
]]




local module = {}
local player=game.Players.LocalPlayer
local char=game.Workspace:WaitForChild(player.Name)
local stats=char:WaitForChild("Stats")
local remotes = game.ReplicatedStorage.Remotes
local remote = remotes:WaitForChild("Projectile")
local Q = require(game.ReplicatedStorage.Modules.ClassModule)
local ready = false
local class = char.CurrentClass.Value
local sounds = game.ReplicatedStorage.Sounds.Cards

char.ChildAdded:connect(function(child)
	if child.Name=="Playing" then
		ready = true
	end
end)

function module.initialize(person)
	char = person
	ready = true
	playsound(sounds.CardCD)
end

function playsound(sound)
	game.ReplicatedStorage.Remotes.Sound:FireServer(sound)
end

function localsound(id, speed, volume)
	local sound=Instance.new("Sound") --DASH SOUND
	sound.SoundId="rbxassetid://"..id
	sound.PlaybackSpeed = speed
	sound.Volume = volume
	sound.Parent=char.Torso
	game.Debris:AddItem(sound ,5)
	sound:Play()
end

function cooldown(time)
	wait(time)
	ready = true
	playsound(sounds.CardCD)
end

function module.useCard(card)
	if ready and char.Stats.Disable.Value == 0 then
		if card == "Awakening" then
			if char.Stats.CurrentHP.Value < (char.Stats.MaxHP.Value * 0.25) then
				playsound(sounds.CardUse)
			end
		else
			playsound(sounds.CardUse)
		end
		ready=false
		if card == "Heal" then
			healCard()
		elseif card == "Haste" then
			hasteCard()
		elseif card == "Spotdodge" then
			spotdodgeCard()
		elseif card == "Burst" then
			burstCard()
		elseif card == "Laser" then
			laserCard()
		elseif card == "Blaze" then
			blazeCard()
		elseif card == "Jump" then
			jumpCard()
		elseif card == "Awakening" then
			awakening()
		else
			cooldown(2)
		end
	else
		playsound(sounds.NotReady)
	end
end

function healCard() --Heals the user.
	heal(char, math.ceil(char.Stats.MaxHP.Value * 0.1))
	cooldown(14)
end

function spotdodgeCard() -- maybe add animation
	game:GetService('RunService').Stepped:Wait()
	local animtrack=char.Humanoid:LoadAnimation(game.ReplicatedStorage.Modules.CardEffects.SpotdodgeAnim)
	animtrack:Play()
	animtrack:AdjustSpeed(1.8)
	Q.playsound(game.ReplicatedStorage.Sounds.Cards.Spotdodge)
	Q.effectapply(char,game.ReplicatedStorage.Modules.CardEffects.ForceField,char.Head)
	wait(0.5)
	animtrack:Stop()
	cooldown(7)
end

local musicName = "asd"
local music = "rbxassetid://16495467689"
local volume = 1
function awakening() --the main one
	game:GetService('RunService').Stepped:Wait()

	local animtrack=char.Humanoid:LoadAnimation(game.ReplicatedStorage.Modules.CardEffects.AwakeningAnim)
	if char.Stats.CurrentHP.Value < (char.Stats.MaxHP.Value * 0.25) then
		animtrack:Play()
		print(class.. " used awakening")
		Q.shockwave()
		--game.ReplicatedStorage.Remotes.MusicChange:FireServer(musicName,music,volume)
		if char.CurrentClass.Value == "ZERO" then
			music = "rbxassetid://12989671337" --bringer of justice(naoto theme)
		end
		game.Workspace.Music.Volume.Value=2
		game.Workspace.Music.Speed.Value=1
		game.Workspace.Music.CurrentMusic.Value=music
		Q.effectapply(char,game.ReplicatedStorage.Modules.CardEffects.Awakening, char.Head)
	else
		localsound(3779045779,1,1)
		ready = true
	end
end

function jumpCard()
	print("bigwinner")
	effectapply(char,game.ReplicatedStorage.Modules.CardEffects.Jump,char.Head)
	cooldown(8)
end
function blazeCard()
	effectapply(char,game.ReplicatedStorage.Modules.CardEffects.Blaze,char.Head)
	cooldown(7)
end
function laserCard()
	localsound(8561500387,1,1)
	local projectile = game.ReplicatedStorage.Modules.CardEffects.beam
	local projectilecframe = char.HumanoidRootPart.CFrame*CFrame.new(0,1,-20)*CFrame.Angles(0,math.pi/2,0)
	fireprojectile(projectile,projectilecframe)
	for index=1,26 do
		Q.hitbox(5,index*1,0,0,0,"Laser",script.Parent.CardEffects.BeamStun,nil,nil)
	end
	cooldown(14)
end

function burstCard() --Knocks away all enemies in a radius around the user.
	game:GetService('RunService').Stepped:Wait()
	local animtrack=char.Humanoid:LoadAnimation(game.ReplicatedStorage.Modules.CardEffects.BurstAnim)
	animtrack:Play()
	animtrack.TimePosition = 0.4
	animtrack:AdjustSpeed(1.2)
	wait(0.3)
	Q.hitbox(26,1,1,1,1,"Burst","KnockbackAOE",100,nil)
	Q.shockwave()
	cooldown(11)
end

-----------------------------------------------------

local password=nil
local rsf
if game.Players.LocalPlayer:FindFirstChild("remotesFired")==nil then
	rsf=Instance.new("IntValue",game.Players.LocalPlayer)rsf.Value=0 rsf.Name="remotesFired"
else rsf=game.Players.LocalPlayer:FindFirstChild("remotesFired") end
function pass()
	local remotesFired=rsf.Value+1 rsf.Value=remotesFired
	local generatedNumber=math.floor((remotesFired*7)^2.1)+25
	local password=("{CS-G10-"..generatedNumber.."-AB2g-dAB50NYU}")
	return password
end
function effectapply(target,effect,part)
	coroutine.resume(coroutine.create(function()
		password=pass()
		local applyingeffect=game.ReplicatedStorage.Remotes.EffectApply:InvokeServer(password,target,effect,part)
	end))
end
function knockback(target,effect,part,direction,power)
	coroutine.resume(coroutine.create(function()
		password=pass()
		local applyingeffect=game.ReplicatedStorage.Remotes.EffectApply:InvokeServer(password,target,effect,part,direction,power)
	end))
end
function heal(target,healammount)
	coroutine.resume(coroutine.create(function()
		password=pass()
		local totalheal=game.ReplicatedStorage.Remotes.Heal:InvokeServer(password,target,healammount)
	end))
end
function sdamage(target,dmg)
	coroutine.resume(coroutine.create(function()
		password=pass()
		local totaldmg=game.ReplicatedStorage.Remotes.Damage:InvokeServer(password,workspace.RealTime.Value,target,dmg,"Safe")
	end))
end

function fireprojectile(projectile, cframe)
	local projectilecframe = cframe
	--Crash:FireServer(projectile)
	local newProjectile=projectile:Clone()
	newProjectile.Owner.Value=player
	newProjectile.Origin.Value=projectilecframe.p
	newProjectile.CFrame=projectilecframe
	newProjectile.Color=player.CharacterColors.WeaponColor.Value
	newProjectile.Speed.Value=newProjectile.Speed.Value
	local projectileHandler=newProjectile.ProjectileHandler
	projectileHandler.Projectile.Value=newProjectile
	projectileHandler.Parent=char
	newProjectile.Parent=workspace
	remotes.Projectile:FireServer(projectile, projectilecframe, player.CharacterColors.WeaponColor.Value)
end
return module

