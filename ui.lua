-- [[ FILE GITHUB 1: ui.lua ]]
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Bersihkan UI lama jika dieksekusi ulang agar tidak menumpuk
if CoreGui:FindFirstChild("KyzerHub_CustomUI") then CoreGui["KyzerHub_CustomUI"]:Destroy() end
if CoreGui:FindFirstChild("KyzerHub_MinimizeIcon") then CoreGui["KyzerHub_MinimizeIcon"]:Destroy() end

local UI = Instance.new("ScreenGui")
UI.Name = "KyzerHub_CustomUI"
UI.ResetOnSpawn = false
UI.DisplayOrder = 99
UI.Parent = CoreGui

-- [[ DATA CONFIG & DATABASE ]]
local Config = { SelectedPets = {}, WhitelistMutation = {}, Enable = false }
local PetTerprosesSesiIni = {}

local function AmbilDaftarPet()
    local ListPet = {}
    local FolderPet = game:GetService("ReplicatedStorage"):FindFirstChild("Assets") 
        and game:GetService("ReplicatedStorage").Assets:FindFirstChild("Animations") 
        and game:GetService("ReplicatedStorage").Assets.Animations:FindFirstChild("PetAnimations")
    if FolderPet then
        for _, pet in pairs(FolderPet:GetChildren()) do table.insert(ListPet, pet.Name) end
    else 
        ListPet = {"Butterfly", "Empress Bee", "French Fry Ferret", "New Year's Dragon", "Raccoon", "Albino Peacock", "Amethyst Beetle"} 
    end
    table.sort(ListPet)
    return ListPet
end

local function AmbilDaftarMutasiOtomatis()
    local ListMutasi = {"Shiny", "Inverted", "Frozen", "Windy", "Golden", "Mega", "Tiny", "IronSkin", "Radiant", "Rainbow", "Shocked", "Ascended", "Tranquil", "Corrupted", "Fried", "Aromatic", "GiantBean", "Silver", "Glimmering", "Luminous", "Nutty", "Dreadbound", "Soulflame", "Spectral", "Nightmare", "Tethered", "Aurora", "Jumbo", "Oxpecker", "Giraffe", "Rhino", "Crocodile", "Lion", "Forger", "Nocturnal", "Peppermint", "Spirit Sparkle", "Christmas Rally", "Jolly Decorator", "Merry Nursery", "GiantGolem", "HyperHunger", "Venom", "Fiery", "UFO", "Alienated", "Blossoming", "Everchanted", "RoyalJelly"}
    if not table.find(ListMutasi, "None") then table.insert(ListMutasi, "None") end
    table.sort(ListMutasi)
    return ListMutasi
end

local MasterListPet = AmbilDaftarPet()
local MasterListMutasi = AmbilDaftarMutasiOtomatis()

-- [[ MEMBUAT FRAME UTAMA (BACKGROUND GELAP) ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(580, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = UI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Parent = MainFrame

-- [[ HEADER TITLE ]]
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.fromOffset(15, 0)
TitleLabel.Text = "Ӄ | Kyzer HUB V1.23"
TitleLabel.TextColor3 = Color3.fromRGB(254, 203, 0)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = HeaderFrame

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(25, 25)
MinButton.Position = UDim2.new(1, -35, 0.5, -12.5)
MinButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinButton.Text = "-"
MinButton.TextColor3 = Color3.fromRGB(200, 200, 200)
MinButton.TextSize = 16
MinButton.Font = Enum.Font.GothamBold
MinButton.Parent = HeaderFrame
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinButton

-- [[ PANEL MENU SEBELAH KIRI ]]
local LeftPanel = Instance.new("Frame")
LeftPanel.Size = UDim2.new(0, 150, 1, -40)
LeftPanel.Position = UDim2.fromOffset(0, 40)
LeftPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
LeftPanel.BorderSizePixel = 0
LeftPanel.Parent = MainFrame

local LeftStroke = Instance.new("UIStroke")
LeftStroke.Thickness = 1
LeftStroke.Color = Color3.fromRGB(30, 30, 30)
LeftStroke.Parent = LeftPanel

local TabMiscBtn = Instance.new("TextButton")
TabMiscBtn.Size = UDim2.new(1, -20, 0, 40)
TabMiscBtn.Position = UDim2.fromOffset(10, 150)
TabMiscBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabMiscBtn.Text = "MISC"
TabMiscBtn.TextColor3 = Color3.fromRGB(254, 203, 0)
TabMiscBtn.TextSize = 14
TabMiscBtn.Font = Enum.Font.GothamBold
TabMiscBtn.Parent = LeftPanel

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 4)
TabCorner.Parent = TabMiscBtn

local ActiveLine = Instance.new("Frame")
ActiveLine.Size = UDim2.new(0.6, 0, 0, 2)
ActiveLine.Position = UDim2.new(0.2, 0, 1, -4)
ActiveLine.BackgroundColor3 = Color3.fromRGB(254, 203, 0)
ActiveLine.BorderSizePixel = 0
ActiveLine.Parent = TabMiscBtn

-- [[ PANEL ISI KONTEN SEBELAH KANAN ]]
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -160, 1, -55)
RightPanel.Position = UDim2.fromOffset(155, 45)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local SubHeaderFake = Instance.new("TextButton")
SubHeaderFake.Size = UDim2.fromOffset(90, 30)
SubHeaderFake.Position = UDim2.fromOffset(110, 5)
SubHeaderFake.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SubHeaderFake.Text = "Auto Gift"
SubHeaderFake.TextColor3 = Color3.fromRGB(254, 203, 0)
SubHeaderFake.Font = Enum.Font.GothamBold
SubHeaderFake.TextSize = 12
SubHeaderFake.Parent = RightPanel
local SubCorner = Instance.new("UICorner")
SubCorner.CornerRadius = UDim.new(0, 15)
SubCorner.Parent = SubHeaderFake
local SubStroke = Instance.new("UIStroke")
SubStroke.Color = Color3.fromRGB(254, 203, 0)
SubStroke.Thickness = 1
SubStroke.Parent = SubHeaderFake

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
ToggleFrame.Position = UDim2.fromOffset(0, 60)
ToggleFrame.BackgroundTransparency = 1
ToggleFrame.Parent = RightPanel

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.Text = "Enable Auto Favorite"
ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleLabel.TextSize = 14
ToggleLabel.Font = Enum.Font.GothamMedium
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Parent = ToggleFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.fromOffset(45, 22)
ToggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleFrame
local TCorner = Instance.new("UICorner")
TCorner.CornerRadius = UDim.new(1, 0)
TCorner.Parent = ToggleBtn

local ToggleBall = Instance.new("Frame")
ToggleBall.Size = UDim2.fromOffset(16, 16)
ToggleBall.Position = UDim2.fromOffset(3, 3)
ToggleBall.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
ToggleBall.Parent = ToggleBtn
local BCorner = Instance.new("UICorner")
BCorner.CornerRadius = UDim.new(1, 0)
BCorner.Parent = ToggleBall

ToggleBtn.MouseButton1Click:Connect(function()
    Config.Enable = not Config.Enable
    if Config.Enable then
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(254, 203, 0)}):Play()
        TweenService:Create(ToggleBall, TweenInfo.new(0.2), {Position = UDim2.fromOffset(26, 3), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    else
        table.clear(PetTerprosesSesiIni)
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(ToggleBall, TweenInfo.new(0.2), {Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end
end)

local PetSelectTitle = Instance.new("TextLabel")
PetSelectTitle.Size = UDim2.new(1, 0, 0, 20)
PetSelectTitle.Position = UDim2.fromOffset(0, 120)
PetSelectTitle.Text = "Select Pet Type"
PetSelectTitle.TextColor3 = Color3.fromRGB(130, 130, 130)
PetSelectTitle.TextSize = 12
PetSelectTitle.Font = Enum.Font.GothamMedium
PetSelectTitle.TextXAlignment = Enum.TextXAlignment.Left
PetSelectTitle.BackgroundTransparency = 1
PetSelectTitle.Parent = RightPanel

local OpenPetMenuBtn = Instance.new("TextButton")
OpenPetMenuBtn.Size = UDim2.new(1, 0, 0, 35)
OpenPetMenuBtn.Position = UDim2.fromOffset(0, 145)
OpenPetMenuBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
OpenPetMenuBtn.Text = " Click to select pets... ▼"
OpenPetMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
OpenPetMenuBtn.TextSize = 13
OpenPetMenuBtn.Font = Enum.Font.Gotham
OpenPetMenuBtn.TextXAlignment = Enum.TextXAlignment.Left
OpenPetMenuBtn.Parent = RightPanel
local OCorner = Instance.new("UICorner")
OCorner.CornerRadius = UDim.new(0, 4)
OCorner.Parent = OpenPetMenuBtn
local OStroke = Instance.new("UIStroke")
OStroke.Color = Color3.fromRGB(40, 40, 40)
OStroke.Parent = OpenPetMenuBtn

local MutSelectTitle = Instance.new("TextLabel")
MutSelectTitle.Size = UDim2.new(1, 0, 0, 20)
MutSelectTitle.Position = UDim2.fromOffset(0, 200)
MutSelectTitle.Text = "Whitelist Mutation Filter"
MutSelectTitle.TextColor3 = Color3.fromRGB(130, 130, 130)
MutSelectTitle.TextSize = 12
MutSelectTitle.Font = Enum.Font.GothamMedium
MutSelectTitle.TextXAlignment = Enum.TextXAlignment.Left
MutSelectTitle.BackgroundTransparency = 1
MutSelectTitle.Parent = RightPanel

local OpenMutMenuBtn = Instance.new("TextButton")
OpenMutMenuBtn.Size = UDim2.new(1, 0, 0, 35)
OpenMutMenuBtn.Position = UDim2.fromOffset(0, 225)
OpenMutMenuBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
OpenMutMenuBtn.Text = " Click to select mutations... ▼"
OpenMutMenuBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
OpenMutMenuBtn.TextSize = 13
OpenMutMenuBtn.Font = Enum.Font.Gotham
OpenMutMenuBtn.TextXAlignment = Enum.TextXAlignment.Left
OpenMutMenuBtn.Parent = RightPanel
local MOCorner = Instance.new("UICorner")
MOCorner.CornerRadius = UDim.new(0, 4)
MOCorner.Parent = OpenMutMenuBtn
local MOStroke = Instance.new("UIStroke")
MOStroke.Color = Color3.fromRGB(40, 40, 40)
MOStroke.Parent = OpenMutMenuBtn

-- [[ PEMBUATAN POPUP FRAME SELECTION ]]
local function BuatWindowPopup(JudulWindow, DaftarItem, ConfigTarget)
    local PopupFrame = Instance.new("Frame")
    PopupFrame.Name = "Popup_" .. JudulWindow
    PopupFrame.Size = UDim2.fromOffset(330, 320)
    PopupFrame.Position = UDim2.new(0.5, -165, 0.5, -160)
    PopupFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    PopupFrame.BorderSizePixel = 0
    PopupFrame.ZIndex = 10
    PopupFrame.Visible = false
    PopupFrame.Parent = MainFrame

    local PopCorner = Instance.new("UICorner")
    PopCorner.CornerRadius = UDim.new(0, 8)
    PopCorner.Parent = PopupFrame

    local PopStroke = Instance.new("UIStroke")
    PopStroke.Thickness = 1.5
    PopStroke.Color = Color3.fromRGB(254, 203, 0)
    PopStroke.Parent = PopupFrame

    local PopTitle = Instance.new("TextLabel")
    PopTitle.Size = UDim2.new(0.8, 0, 0, 40)
    PopTitle.Position = UDim2.fromOffset(15, 0)
    PopTitle.Text = JudulWindow
    PopTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    PopTitle.TextSize = 14
    PopTitle.Font = Enum.Font.GothamBold
    PopTitle.TextXAlignment = Enum.TextXAlignment.Left
    PopTitle.BackgroundTransparency = 1
    PopTitle.ZIndex = 11
    PopTitle.Parent = PopupFrame

    local CloseX = Instance.new("TextButton")
    CloseX.Size = UDim2.fromOffset(24, 24)
    CloseX.Position = UDim2.new(1, -35, 0, 8)
    CloseX.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CloseX.Text = "X"
    CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseX.Font = Enum.Font.GothamBold
    CloseX.TextSize = 12
    CloseX.ZIndex = 11
    CloseX.Parent = PopupFrame
    local XCorner = Instance.new("UICorner")
    XCorner.CornerRadius = UDim.new(0, 4)
    XCorner.Parent = CloseX
    CloseX.MouseButton1Click:Connect(function() PopupFrame.Visible = false end)

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -30, 0, 30)
    SearchBox.Position = UDim2.fromOffset(15, 45)
    SearchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 13
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.ZIndex = 11
    SearchBox.Parent = PopupFrame
    local SBoxCorner = Instance.new("UICorner")
    SBoxCorner.CornerRadius = UDim.new(0, 4)
    SBoxCorner.Parent = SearchBox

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, -30, 1, -95)
    ScrollList.Position = UDim2.fromOffset(15, 85)
    ScrollList.BackgroundTransparency = 1
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 4
    ScrollList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    ScrollList.ZIndex = 11
    ScrollList.Parent = PopupFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 6)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = ScrollList

    local ButtonsCache = {}
    for i, itemName in pairs(DaftarItem) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Size = UDim2.new(1, -6, 0, 32)
        ItemBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        ItemBtn.Text = itemName
        ItemBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        ItemBtn.TextSize = 13
        ItemBtn.Font = Enum.Font.GothamMedium
        ItemBtn.ZIndex = 12
        ItemBtn.Parent = ScrollList
        
        local ICorner = Instance.new("UICorner")
        ICorner.CornerRadius = UDim.new(0, 4)
        ICorner.Parent = ItemBtn

        ItemBtn.MouseButton1Click:Connect(function()
            ConfigTarget[itemName] = not ConfigTarget[itemName]
            if ConfigTarget[itemName] then
                ItemBtn.BackgroundColor3 = Color3.fromRGB(254, 203, 0)
                ItemBtn.TextColor3 = Color3.fromRGB(15, 15, 15)
            else
                ItemBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
                ItemBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end)

        ButtonsCache[itemName] = ItemBtn
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchBox.Text)
        for name, btn in pairs(ButtonsCache) do
            if query == "" or string.find(string.lower(name), query) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end)

    ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)

    return PopupFrame
end

local PetPopupFrame = BuatWindowPopup("Select Pet Type", MasterListPet, Config.SelectedPets)
local MutPopupFrame = BuatWindowPopup("Whitelist Mutation Filter", MasterListMutasi, Config.WhitelistMutation)

OpenPetMenuBtn.MouseButton1Click:Connect(function() MutPopupFrame.Visible = false PetPopupFrame.Visible = true end)
OpenMutMenuBtn.MouseButton1Click:Connect(function() PetPopupFrame.Visible = false MutPopupFrame.Visible = true end)

-- [[ TOMBOL MINIMIZE BULAT MENGAMBANG ]]
local MinimizeIcon = Instance.new("ImageButton")
MinimizeIcon.Name = "KyzerHub_MinimizeIcon"
MinimizeIcon.Size = UDim2.fromOffset(60, 60)
MinimizeIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
MinimizeIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizeIcon.Image = "rbxassetid://135894172778385"
MinimizeIcon.Visible = false
MinimizeIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = MinimizeIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Thickness = 2
IconStroke.Color = Color3.fromRGB(254, 203, 0)
IconStroke.Parent = MinimizeIcon

MinButton.MouseButton1Click:Connect(function() MainFrame.Visible = false MinimizeIcon.Visible = true end)
MinimizeIcon.MouseButton1Click:Connect(function() MinimizeIcon.Visible = false MainFrame.Visible = true end)

-- [[ SISTEM DRAG / GESER FRAME ]]
local function EnableDrag(WadahObjek)
    local dragging, dragInput, dragStart, startPos
    WadahObjek.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = WadahObjek.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    WadahObjek.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            WadahObjek.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
EnableDrag(MainFrame)
EnableDrag(MinimizeIcon)

-- PENGEMBALIAN VARIABEL KE SCRIPT UTAMA
return {
    Config = Config,
    PetTerprosesSesiIni = PetTerprosesSesiIni,
    MasterListMutasi = MasterListMutasi
}
