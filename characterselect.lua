--[[
A "class-selection" script used on a class selection screen in a fighting game. It adds functions for when the mouse hovers over and when the mouse clicks any button in the ui, then relates each button to a 
specific dictionary entry.
]]

local player = game.Players.LocalPlayer
local char = player.Character
local ui = script.Parent.ClassPickFrame
local classcont = script.Parent.ClassPickFrame.ScrollingFrame
local classes = {
	-- Template: 	Class = {"Name", "Playstyle","Passives"},
	Noble = {"NOBLE","A BLADE wielder who excels at playing at their own pace.","Duel - When dealing damage, if the target has higher current HP than you, deal 1 extra damage\n\nPrecise - Your LMB has a hitbox at the tip of the attack. Hitting this tipper deals extra damage and briefly stuns."},
	Brawler = {"BRAWLER","A FIST fighter who excels in taking and dealing hits","Scrapper - Higher energy capacity.\n\nGrit - Gain a small shield upon using Skill 1."},
	Gunner = {"GUNNER","A dual-wielding GUN user who can fire off a barrage of attacks","Dual Wield - After using a skill, your next LMB will fire twice.\n\nGun User - Block is replaced with a projectile firing move"},
	Knight = {"KNIGHT", "A bulky HEAVY user that prioritizes protection of themself and allies", "Your Shield - Block has a reduced cooldown.\n\nStandoff - Take reduced damage while using Skill 1."},
}

function showInfo(class)
	print("heheheha")
	script.Parent.hoversound.PlaybackSpeed = math.random(8, 10)*0.1
	script.Parent.hoversound:Play()
	local classlocation = game.ReplicatedStorage.Classes[string.upper(class)]
	ui.ClassInfo.Text.Text = "PASSIVES:\n\n"..classes[class][3]
	ui.CLASSNAME.Text = classes[class][1]
	ui.CLASSPLAY.Text= classes[class][2]
	ui.STATS.Text="HP: "..classlocation.Health.Value.. " SPD: " ..classlocation.Speed.Value
end

for _, child in pairs(classcont:GetChildren()) do --iterate through each object inside of the ui
	if child:FindFirstChild("Class") then
	child.MouseEnter:Connect(function() --add a function to it for when its hovered over
		print("entered " ..child.Name)
		showInfo(child.Class.Value)
	end)
	child.MouseButton1Click:Connect(function() -- add a function to it for when it is clicked
		print("picking " ..child.Class.Value)
		--unlockables
		if child:FindFirstChild("Require") then
			if player.PlayerData.Inventory:FindFirstChild(string.upper(child.Require.Value).."CLASS")then
				script.Parent.Visible = false -- this triggers the fades
				script.Parent.Parent.abilityBg.Visible = true
				game.Workspace["CLASSES"]["ClassPick"]["Button Main Skin"].ClassArmor:FireServer(char,string.upper(child.Class.Value))
			else
				script.Parent.locked:Play()
			end
		else
			--free classes
			script.Parent.Visible = false --hide the ui because the player has chosen
			game.Workspace["CLASSES"]["ClassPick"]["Button Main Skin"].ClassArmor:FireServer(char,string.upper(child.Class.Value)) --calls a remote that gives the class to the player
		end
		--child.PickSound:Play()
	end)
	end
end
