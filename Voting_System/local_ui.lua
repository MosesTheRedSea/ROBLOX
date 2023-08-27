--[[
				This Script Was Made By
				
 █▀▄▀█ █▀▀█ █▀▀ █▀▀ █▀▀ ▀▀█▀▀ █  █ █▀▀ █▀▀█ █▀▀ █▀▀▄ █▀▀▀█ █▀▀ █▀▀█ 
 █ █ █ █  █ ▀▀█ █▀▀ ▀▀█   █   █▀▀█ █▀▀ █▄▄▀ █▀▀ █  █ ▀▀▀▄▄ █▀▀ █▄▄█ 
 █   █ ▀▀▀▀ ▀▀▀ ▀▀▀ ▀▀▀   █   ▀  ▀ ▀▀▀ █  █ ▀▀▀ ▀▀▀  █▄▄▄█ ▀▀▀ ▀  ▀

 The Code Bellow is the Layout for the Server - Side of A Voting System I made.
 					Use it Well Use it Wisely
--]]

-- Players Service
local player = game.Players.LocalPlayer
-- Voting System Model
local VotingSystem = script.Parent.Parent
-- Replicated Storage Service
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- RemoteEvent that sends the countdown Value of the GUI (Server Side)
-- It's Fired to all Clients so that it appears on everyone's screeen
local sendInfoRemote2 = ReplicatedStorage.SendInfo2

-- Countdown UI
local countdownUI = script.Parent
-- TextLabel to Displayed Voting Time Countdown
local textLabel = countdownUI.countdown

-- Remote Event is handled on the Client Event 
--and sets the textLabel text tot he timeLeft parameter (new time)
sendInfoRemote2.OnClientEvent:Connect(function(timeLeft)
	textLabel.Text = tostring(timeLeft)
end)
