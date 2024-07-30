local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Organic Hub", "Synapse")
local Player = Window:NewTab("Player")
local Kat = Window:NewTab("KAT")
local Tools = Window:NewTab("Tools")
local More = Window:NewTab("More")
local Credit = Window:NewTab("Credit")
local CreditSection = Credit:NewSection("Credit")
local MoreSection = More:NewSection("More")
local PlayerSection = Player:NewSection("Player")
local KatSection = Kat:NewSection("-- Knife Ability Test --")
local ToolsSection = Tools:NewSection("Tools")
-- Variables
local Players = game:GetService("Players"):GetPlayers()
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local infjumpenabled = false
local HavePremium = false
if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(Player.UserId,876259407) then
    HavePremium = true
else
    HavePremium = false
end
local DEnabled = false
local Noclip = nil
local fovVisible = true
local lastSize = 150
local X, Y = 0, 0
local SelectedTarget = "Torso"
local ESP = false
local selectedId = "None"
local selectedVolume = 1
_G.SpinSpeedy = 20
local Clip = nil
local themes = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background = Color3.fromRGB(36, 37, 43),
    Header = Color3.fromRGB(28, 29, 34),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}
-- Starting
local plr = game:GetService("Players").LocalPlayer
-- Functions
function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end
function noclip()
	Clip = false
	local function Nocl()
		if Clip == false and game:GetService("Players").LocalPlayer.Character ~= nil then
			for _,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide and v.Name ~= floatName then
					v.CanCollide = false
				end
			end
		end
		wait(0.50) -- basic optimization
	end
	Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

game:GetService("UserInputService").JumpRequest:Connect(function()
	if infjumpenabled == true then
		game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
	end
end)

function PlaySound(ID,instance,Volume:number,Looped:boolean)
	local Data = {"PlaySound",game:GetService("Players").LocalPlayer.Name,"rbxassetid://" .. tonumber(ID),{instance},tonumber(Volume),false}
	game:GetService("ReplicatedStorage").GameEvents.Misk.ReplicateSound:FireServer(Data)
	local Sound = Instance.new("Sound")
	Sound.Parent = instance
	Sound.SoundId = "rbxassetid://" .. tostring(ID)
	Sound.Volume = tonumber(Volume)
	Sound.Looped = Looped
	Sound:Play()
	Sound.Stopped:Wait()
	Sound:Destroy()
end

function infJumpOn()
	infjumpenabled = true
end

function Clear(plr11) --Clears all the esps
	if plr11 == nil then
		for _, g in pairs(game:GetService("Players"):GetChildren()) do
			if g.Character:FindFirstChild("TadachiisESPTags") and g.Character:FindFirstChild("Highlight") then
				g.Character:FindFirstChild("TadachiisESPTags"):Destroy()
				g.Character:FindFirstChild("Highlight"):Destroy()
			end
		end
	else
		if plr11.Character:FindFirstChild("TadachiisESPTags") and plr11.Character:FindFirstChild("Highlight") then
			plr11.Character:FindFirstChild("TadachiisESPTags"):Destroy()
			plr11.Character:FindFirstChild("Highlight"):Destroy()
		end
	end
end

function UpdateESP()
	for _, v in pairs(game:GetService("Players"):GetChildren()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character and not v.Character:FindFirstChild("TadachiisESPTags") and not v.Character:FindFirstChild("Highlight") and v.Character.Head ~= nil then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "TadachiisESPTags" -- Use the correct name for the BillboardGui
            billboardGui.Adornee = v.Character.Head
            billboardGui.Size = UDim2.new(6, 0, 2, 0) -- fixed size for the BillboardGui
            billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- adjust the vertical offset as needed
            billboardGui.AlwaysOnTop = true
            billboardGui.LightInfluence = 1
            billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            billboardGui.Parent = v.Character
	
            local textLabel = Instance.new("TextLabel")
            textLabel.Name = "NameLabel" -- Use the correct name for the label
            textLabel.Text = "@"..v.Name.." ( "..v.DisplayName.." )"
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1 -- transparent background
            textLabel.TextColor3 = Color3.new(255,255,255)
            textLabel.TextScaled = true
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0) -- black text stroke
            textLabel.TextStrokeTransparency = 0 -- fully opaque text stroke (visible through walls)
            textLabel.Visible = true -- ESP is always visible without a GUI
            textLabel.Parent = billboardGui

			Instance.new("Highlight", v.Character)
           	v.Character.Highlight.FillTransparency = 0.98
           	v.Character.Highlight.OutlineTransparency = 0.1
           	v.Character.Highlight.FillColor = Color3.new(255,255,255)

        elseif (v ~= game:GetService("Players").LocalPlayer and v.Character and v.Character:FindFirstChild("TadachiisESPTags") and v.Character:FindFirstChild("Highlight")) then
			v.Character:FindFirstChild("TadachiisESPTags").NameLabel.TextColor3 = Color3.new(255,255,255)
			v.Character.Highlight.FillColor = Color3.new(255,255,255)
		else
			Clear(v)
        end
	end
end

function infJumpOff()
	infjumpenabled = false
end

function clip()
	if Noclip then Noclip:Disconnect() end
	Clip = true
end
-- Player Tab

PlayerSection:NewSlider("Walkspeed", "Changes the walkspeed", 250, 16, function(v)
    game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
 
PlayerSection:NewSlider("Jumppower", "Changes the jumppower", 250, 50, function(v)
    game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = v
end)

PlayerSection:NewSlider("Spin Speed", "Changes the speed", 120, 20, function(v)
    _G.SpinSpeedy = v
end)

PlayerSection:NewToggle("Spin", "On / Off", function(state)
    if state then
	local Spin = Instance.new("BodyAngularVelocity")
	Spin.Name = "Spinning"
	Spin.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
	Spin.MaxTorque = Vector3.new(0, math.huge, 0)
	Spin.AngularVelocity = Vector3.new(0,_G.SpinSpeedy,0)
    else
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Spinning"):Destroy()
    end
end)

PlayerSection:NewButton("Fly [E]", "Press 'E' to fly", function()
	repeat wait()
	until game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:findFirstChild("Humanoid")
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	repeat wait() until mouse
	local plr = game:GetService("Players").LocalPlayer
	local torso
	if plr.Character:FindFirstChild("Torso") then
		torso = plr.Character:FindFirstChild("Torso")
	else
		torso = plr.Character:FindFirstChild("UpperTorso")
	end
	local flying = true
	local deb = true
	local ctrl = {f = 0, b = 0, l = 0, r = 0}
	local lastctrl = {f = 0, b = 0, l = 0, r = 0}
	local maxspeed = 50
	local speed = 0

	function Fly()
		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		repeat wait()
			plr.Character.Humanoid.PlatformStand = true
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0.1,0)
			end
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		until not flying
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
	end
	mouse.KeyDown:connect(function(key)
		if key:lower() == "e" then
			if flying then flying = false
			else
				flying = true
				Fly()
			end
		elseif key:lower() == "w" then
			ctrl.f = 1
		elseif key:lower() == "s" then
			ctrl.b = -1
		elseif key:lower() == "a" then
			ctrl.l = -1
		elseif key:lower() == "d" then
			ctrl.r = 1
		end
	end)
	mouse.KeyUp:connect(function(key)
		if key:lower() == "w" then
			ctrl.f = 0
		elseif key:lower() == "s" then
			ctrl.b = 0
		elseif key:lower() == "a" then
			ctrl.l = 0
		elseif key:lower() == "d" then
			ctrl.r = 0
		end
	end)
	Fly()
end)

PlayerSection:NewToggle("InfJump", "On / Off", function(state)
    if state then
		infJumpOn()
        print("infJump On")
    else
		infJumpOff()
        print("infJump Off")
    end
end)

PlayerSection:NewToggle("Noclip", "On / Off", function(state)
    if state then
		noclip()
        print("Noclip On")
    else
		clip()
        print("Noclip Off")
    end
end)
-- kat tab
KatSection:NewButton("Silent aim", "for killing without taking aim", function()
    -- Services
    local Players1 = game:GetService("Players")
    local RunService = game:GetService("RunService")
    -- Player
    local Player = Players1.LocalPlayer
    local Mouse = Player:GetMouse()
    local CurrentCamera = workspace.CurrentCamera
    local function GetClosest(Fov)
        local Target, Closest = nil, Fov or math.huge
        for i,v in pairs(Players1:GetPlayers()) do
            if (v.Character and v ~= Player and v.Character:FindFirstChild(SelectedTarget)) then
                local Position, OnScreen = CurrentCamera:WorldToScreenPoint(v.Character[SelectedTarget].Position)
                local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if (Distance < Closest and OnScreen) then
                    Closest = Distance
                    Target = v
                end
            end
        end
        return Target
    end
    local Target
    local CircleInline = Drawing.new("Circle")
    local CircleOutline = Drawing.new("Circle")
    RunService.Stepped:Connect(function()
        CircleInline.Radius = lastSize
        CircleInline.Thickness = 2
        CircleInline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        CircleInline.Transparency = 1
        CircleInline.Color = Color3.fromRGB(255, 255, 255)
        CircleInline.Visible = fovVisible
        CircleInline.ZIndex = 2
        CircleOutline.Radius = lastSize
        CircleOutline.Thickness = 4
        CircleOutline.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        CircleOutline.Transparency = 1
        CircleOutline.Color = Color3.new()
        CircleOutline.Visible = fovVisible
        CircleOutline.ZIndex = 1
        Target = GetClosest(lastSize)
    end)
    local Old; Old = hookmetamethod(game, "__namecall", function(Self, ...)
        local Args = {...}
        if (not checkcaller() and getnamecallmethod() == "FindPartOnRayWithIgnoreList") then
            if (table.find(Args[2], workspace.WorldIgnore.Ignore) and Target and Target.Character) then
                local Origin = Args[1].Origin
                Args[1] = Ray.new(Origin, Target.Character[SelectedTarget].Position - Origin)
            end
        end
        return Old(Self, unpack(Args))
    end)
end)
KatSection:NewDropdown("Target part", "Silent aim target part", {"Torso", "Head"}, function(currentOption)
    SelectedTarget = currentOption
end)
KatSection:NewSlider("Fov Circle size", "Changes the size", 300, 150, function(v)
    lastSize = v
end)
KatSection:NewToggle("Fov Circle visible", "On / Off", function(state)
    fovVisible = not state
end)
KatSection:NewLabel("-- Global playing sound (Premium) --")
KatSection:NewButton("Error all", "None", function()
    if not HavePremium then game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 876259407); return end
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        task.wait(math.random(1,100)/400)
        task.spawn(function()
            if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") then
                PlaySound(tostring(1304562514),v.Character:FindFirstChild("HumanoidRootPart"),tostring(1),false)
            end
        end)
    end
end)
KatSection:NewButton("Jumpscare all", "None", function()
    if not HavePremium then game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 876259407); return end
    PlaySound(tostring(6600188325),workspace,"5",false)
end)
--[[KatSection:NewButton("", "None", function()
    PlaySound(6600188325,workspace,5,false)
end)]]
KatSection:NewTextBox("Custom id:", "-None-", function(txt)
    if not HavePremium then game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 876259407); return end
	selectedId = tonumber(txt)
end)
KatSection:NewTextBox("Custom volume:", "-None-", function(txt)
    if not HavePremium then game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 876259407); return end
	selectedVolume = tonumber(txt)
end)
KatSection:NewButton("Play custom", "None", function()
    if not HavePremium then game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 876259407); return end
    PlaySound(tostring(selectedId),workspace,tostring(selectedVolume),false)
end)
-- Tool Tab
ToolsSection:NewButton("TpTool", "Teleport Tool", function()
	mouse = game:GetService("Players").LocalPlayer:GetMouse()
	tool = Instance.new("Tool")
	tool.RequiresHandle = false
	tool.Name = "Teleport Tool"
	tool.Activated:connect(function()
		local pos = mouse.Hit+Vector3.new(0,2.5,0)
		pos = CFrame.new(pos.X,pos.Y,pos.Z)
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = pos
	end)
	tool.Parent = game:GetService("Players").LocalPlayer.Backpack
end)
ToolsSection:NewButton("Btools", "Btools [Visual]", function()
	backpack = game:GetService("Players").LocalPlayer.Backpack

	hammer = Instance.new("HopperBin")
	hammer.Name = "Hammer"
	hammer.BinType = 4
	hammer.Parent = backpack

	cloneTool = Instance.new("HopperBin")
	cloneTool.Name = "Clone"
	cloneTool.BinType = 3
	cloneTool.Parent = backpack

	grabTool = Instance.new("HopperBin")
	grabTool.Name = "Grab"
	grabTool.BinType = 2
	grabTool.Parent = backpack
end)
-- More Tab
MoreSection:NewButton("Fuck Menu", "Fuck players!", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/BangScript.lua"))()
end)
MoreSection:NewButton("Bhop [Need R15]", "Click to Execute", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/Bhop.lua"))()
end)
MoreSection:NewButton("PCP", "Player Control Panel", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/controlPlayerPanel.lua"))()
end)
MoreSection:NewButton("ReJoin", "Rejoin On the Server", function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)
MoreSection:NewToggle("Player Esp", "on / off", function(state)
    if state then
		ESP = true
	else
		ESP = false
		Clear()
	end
end)
MoreSection:NewButton("Meme texts", "need chat", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/OrganicMusicTexts.lua"))()
end)
MoreSection:NewButton("Radio Gui", "Play your own sounds [Visual]", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/MusicGui.lua"))()
end)
MoreSection:NewButton("Radio Advanced (20R$)", "Play your own sounds [Visual]", function()
	if not game:GetService("MarketplaceService"):UserOwnsGamePassAsync(Player.UserId, 845344371) then
		game:GetService("MarketplaceService"):PromptGamePassPurchase(Player, 845344371)
	else
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Jerka2009/Hubs/main/ExclusiveMusicUI.lua"))()
	end
end)
-- KeyBind GUI
MoreSection:NewKeybind("Toggle Gui", "Show / Hide Gui", Enum.KeyCode.X, function()
	Library:ToggleUI()
end)
-- Color Picker
local PickerTheme = More:NewSection("Custom Theme")
for theme, color in pairs(themes) do
    PickerTheme:NewColorPicker(theme, "Change your "..theme, color, function(color3)
        Library:ChangeColor(theme, color3)
    end)
end
-- Credits
CreditSection:NewButton("Created by : @Jerkaa2009", "Click to copy", function()
	setclipboard("anti__furry")
end)
CreditSection:NewButton("ChatMessageIntro", "Click to send in rbx chat", function()
	local args = {[1] = "[Organic hub] Functional made by Jere2009",[2] = "All"}
	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
end)
game:GetService("RunService").Heartbeat:Connect(function()
	if ESP == true then
		UpdateESP()
		wait(0.1)
	end
	wait(0.1)
end)
