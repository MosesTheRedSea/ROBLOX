--[[
				This Script Was Made By
				
 █▀▄▀█ █▀▀█ █▀▀ █▀▀ █▀▀ ▀▀█▀▀ █  █ █▀▀ █▀▀█ █▀▀ █▀▀▄ █▀▀▀█ █▀▀ █▀▀█
 █ █ █ █  █ ▀▀█ █▀▀ ▀▀█   █   █▀▀█ █▀▀ █▄▄▀ █▀▀ █  █ ▀▀▀▄▄ █▀▀ █▄▄█
 █   █ ▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀   █   ▀  ▀ ▀▀▀ █  █ ▀▀▀ ▀▀▀  █▄▄▄█ ▀▀▀ ▀  ▀

 The Code Bellow is the Layout for the Server - Side of A Voting System I made
 					Use it Well Use it Wisely
--]]

-- Services
-- Players 
local Players game:GetService("Players")
-- Voting System Model
local VotingSystem = script.Parent.Parent
--Replicated Storage 
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Pad's Folder For Players to vote for each individual Map
local Pads = script.Parent.Parent.Pads
--Pad for Map 1
local Pad1 = Pads.Pad1
--Pad for Map 2
local Pad2 = Pads.Pad2
--Pad for Map 3
local Pad3 = Pads.Pad3

--List of Players who have Voted
--(Resets each time players need to vote for a map)
voted = {}


--[[

 	█▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
 	█    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
 	█▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀
 	
 	Folder Holding Different Maps Players can vote for
 	Feel Free to add as many maps as you wish
 	just remeber to make another voting booth for the players
 
]]--
local Maps = script.Parent.Parent.Maps
local RedMap = Maps.REDMAP
local BlueMap = Maps.BLUEMAP
local GreenMap = Maps.GREENMAP

--Int Values for each of the respective maps
local place1 = VotingSystem.Values.p1
local place2 = VotingSystem.Values.p2
local place3 = VotingSystem.Values.p3

--Remotes For Voting 
local sendInfoRemote = ReplicatedStorage.SendInfo
local sendInfoRemote2 = ReplicatedStorage.SendInfo2
local checkRemote = ReplicatedStorage.checkInfo

--Text Labels for the Parts displaying the Map Selections
--(Displays how many users have voted for the respective map)
local pad1Label = VotingSystem.VotingBuild.Map1.SpecificAmount.SurfaceGui.TextMap1
local pad2Label =  VotingSystem.VotingBuild.Map2.SpecificAmount2.SurfaceGui.TextMap2
local pad3Label = VotingSystem.VotingBuild.Map3.SpecificAmout3.SurfaceGui.TextMap3

--Before Any Voting is enabled the Text Labels are 
pad1Label.Text = tostring(place1.Value)
pad2Label.Text = tostring(place2.Value)
pad3Label.Text = tostring(place3.Value)

--[[

 	█▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
 	█    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
 	█▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀
 
]]--
-- This is the Part that was used for Testing 
--you can alter it to just call the start Voting Function
local part = VotingSystem.CountDown.start
-- pressed boolean essentially a debounce to check if voting was initilized (you can remove)
pressed = false

-- Table of Spawns for Each Respective Map
local RedSpawn = {}
local BlueSpawn = {}
local GreenSpawn = {}

-- Table of Votes which represent the values for each respective map
local Votes = {
	["1"] = place1.Value,
	["2"] = place2.Value,
	["3"] = place3.Value
}

-- boolean isVoting determines whether users are able to vote
local isVoting = true

-- Map Spawns Setting Values
--[[
These for loops loop through the Spawns folder for each of 
the maps and adds the individual spawns to the Spawn List Above
]]-- 
for _, spa1 in pairs(RedMap.RedSpawns:GetChildren()) do
	table.insert(RedSpawn, spa1)
end

for _, spa2 in pairs(BlueMap.BlueSpawns:GetChildren()) do
	table.insert(BlueSpawn, spa2)
end

for _, spa3 in pairs(GreenMap.GreenSpawns:GetChildren()) do
	table.insert(GreenSpawn, spa3)
end

--[[
	These functions essentially check whether the value's representing
	the indivual maps change and updates the Map text so it holds the 
	string value of how many users voted for that specific map
]]--
place1:GetPropertyChangedSignal("Value"):Connect(function()
	pad1Label.Text = tostring(place1.Value)
	print("Map 1 Vote Value Updated")
end)

place2:GetPropertyChangedSignal("Value"):Connect(function()
	pad2Label.Text = tostring(place2.Value)
	print("Map 2 Vote Value Updated")
end)

place3:GetPropertyChangedSignal("Value"):Connect(function()
	pad3Label.Text = tostring(place3.Value)
	print("Map 3 Vote Value Updated")
end)

--[[
Reset's Each Value
- Clears the table of Player's who've voted
- Resets each vote count for the
three different maps
sets the boolean isVoting to true
sets the boolean pressed to false
]]--
function resetVoting()
	place1.Value = 0
	place2.Value = 0
	place3.Value = 0
	table.clear(voted)
	isVoting = true
	pressed = false
end

--[[

 	█▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
 	█    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
 	█▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀

	This function determines which map was voted for
	the map with the highest number of votes is returned
	
	You can alter this script for edge cases
	check whether two maps have the same value
	and return which ever one has a higher priority
	or create your own way to decide which map is selected
]]-- 
function FindMap()
	local max = math.max(place1.Value, place2.Value, place3.Value)
	if (max == place1.Value) then
		return "1"
	else if (max == place2.Value) then
		return "2"
	else if (max == place3.Value) then
		return "3"
			end
		end
	end
end

--[[
	This function essentially teleports the players who've already VOTED
	to a spawn location placed around the map which was selected
]]--
function teleportPlayers(location)
	for _, player in pairs(game.Players:GetPlayers()) do
		if (table.find(voted, player.Name) ~= nil) then
			local char = player.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")

			if hrp then
				if location == "1" then
					local randomSpawn = RedSpawn[math.random(1, #RedSpawn)]
					hrp.Position = randomSpawn.Position
				else if location == "2" then
					local randomSpawn =	BlueSpawn[math.random(1, #BlueSpawn)]
						hrp.Position = randomSpawn.Position
				else if location == "3" then
					local randomSpawn = GreenSpawn[math.random(1, #GreenSpawn)]
					hrp.Position = randomSpawn.Position
						end
					end
				end
			end
		end
	end
end

--[[
	
	█▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
	█    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
	█▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀
	
	This function will essentially start the voting
	calls the resetVoting but also checks if it's already been started once
	You can edit this section by added the startVoting Method to any place
	within your game code.
	
	You can also edit how long you want the countdown to be
	Feel Free to Delete Any Print statements as these were used
	for testing purposes only
	
]]--
function startVoting()
	resetVoting()
	if pressed == false then
		pressed = true
		print(voted)
		
		for i = 30, 0, -1 do
			sendInfoRemote2:FireAllClients(i)
			wait(1)
		end
		isVoting = false
		sendInfoRemote2:FireAllClients("Teleporting Players...")
		local map = FindMap()
		print(voted)
		print(map)
		print("Now Teleporting Players")
		teleportPlayers(map)
		sendInfoRemote2:FireAllClients("...")
	end
end

--[[

 █▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
 █    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
 █▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀

	
	This part bascially fires / initiates the Voting System
	
	it checks whether the thing that touched it is a player
	(primarily used for testing purposes)
	Feel free to delete this code and call the startVoting method
	from any other place within your game code
	
]]--
part.Touched:Connect(function(hit)
	local character = hit.Parent
	local player_Name = character.Name
	if character:FindFirstChild("Humanoid") and pressed == false then
		startVoting()
	end
end)



--[[

 	█▀▀█ █  █ █▀▀ ▀▀█▀▀ █▀▀█ █▀▄▀█  ▀  ▀▀█ █▀▀ 
 	█    █  █ ▀▀█   █   █  █ █   █ ▀█▀ ▄▀  █▀▀ 
 	█▄▄█  ▀▀▀ ▀▀▀   ▀   ▀▀▀▀ ▀   ▀ ▀▀▀ ▀▀▀ ▀▀▀

	This are touched events for the 3 inidivual voting pads
	
	They check the object who pressed it is a player
	it checks for the humanoid root part, it checks whether
	the player has voted already and if its an appropiate time to vote
	using the isVoting boolean
	
	Feel Free to remove the print Statments and wait() calls since these
	were just implemented for testing purposes.
	
	The values of each of the repsective maps and incremented by 1 everything a player 
	votes for that specific map.

]]--
Pad1.Touched:Connect(function(hit)
	local characer = hit.Parent
	local player_Name = characer.Name
	if (table.find(voted, player_Name) == nil and isVoting == true) then
		place1.Value = place1.Value + 1 
		table.insert(voted, player_Name)
		print("Map1: " .. place1.Value)
		task.wait(2)
	end
	print(player_Name .. " Already Voted")
end)

Pad2.Touched:Connect(function(hit)
	local character = hit.Parent
	local player_Name = character.Name
	if (table.find(voted, player_Name) == nil and isVoting == true) then
		place2.Value = place2.Value + 1
		table.insert(voted, player_Name)
		print("Map2: " .. place2.Value)
		task.wait(2)
	end
	print(player_Name .. " Already Voted")
end)

Pad3.Touched:Connect(function(hit)
	local character = hit.Parentmghy
	local player_Name = character.Name
	if (table.find(voted, player_Name) == nil and isVoting == true) then
		place3.Value = place3.Value + 1
		table.insert(voted, player_Name)
		print("Map3: " .. place3.Value)
		task.wait(2)
	end
	print(player_Name .. " Already Voted")
end)
