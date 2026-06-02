if not game:IsLoaded() then game.Loaded:Wait() end

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

-- Pastikan PlayerGui sudah termuat sempurna di dalam game
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then return end

-- Hapus UI lama jika sebelumnya sudah pernah dijalankan agar tidak menumpuk
if PlayerGui:FindFirstChild("AntiStuckRejoinUI") then PlayerGui.AntiStuckRejoinUI:Destroy() end

-- ========================================================
-- SISTEM DOWNLOAD & PEMBACAAN LOGO OTOMATIS DARI GITHUB
-- ========================================================
local LogoLocalName = "Kyzerlogo.jpg"
local LogoAssetID = "rbxassetid://0" -- Cadangan jika fitur tidak didukung executor

local RawGithubLogoUrl = "https://raw.githubusercontent.com/GajeKompi/KyzerHub/main/Kyzerlogo.png"

if writefile and readfile and getcustomasset and isfile then
    pcall(function()
        -- Jika file logo belum ada di folder workspace executor, unduh otomatis dari GitHub Anda
        if not isfile(LogoLocalName) then
            local downloadImage = game:HttpGet(RawGithubLogoUrl)
            writefile(LogoLocalName, downloadImage)
        end
        -- Mengubah file lokal menjadi aset yang dikenali oleh engine gambar Roblox
        LogoAssetID = getcustomasset(LogoLocalName)
    end)
end

-- ========================================================
-- SISTEM AUTO-SAVE LINK (MEMBACA DATA TERAKHIR YANG DISIMPAN)
-- ========================================================
local FileName = "KyzerHub"
local PrivateServerLink = "paste link" -- Link bawaan

if readfile and isfile and isfile(FileName) then
    PrivateServerLink = readfile(FileName)
end

local rejoinMinutes = 15
local timeLeft = rejoinMinutes * 60
local isEnabled = true

-- Membuat Layanan UI Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiStuckRejoinUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ========================================================
-- 1. TOMBOL IKON LOGO KYZERHUB (Bulat Kecil di Pojok Layar)
-- ========================================================
local IconButton = Instance.new("ImageButton")
IconButton.Size = UDim2.new(0, 55, 0, 55)
IconButton.Position = UDim2.new(0.02, 0, 0.2, 0) -- Di kiri atas layar agar tidak menghalangi analog HP
IconButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconButton.BorderSizePixel = 0
IconButton.Image = LogoAssetID
IconButton.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- Membuat bulatan sempurna
IconCorner.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 255) -- Garis luar neon biru cyan mengikuti tema logo K
IconStroke.Thickness = 2
IconStroke.Parent = IconButton

-- ========================================================
-- 2. PANEL UTAMA MENU REJOIN (Awalnya Tersembunyi)
-- ========================================================
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 250)
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35) -- Biru gelap mewah
Frame.BorderSizePixel = 0
Frame.Visible = false -- Menunggu ikon diklik baru muncul
Frame.Active = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "⚡ KYZER HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = Frame

local ServerID = Instance.new("TextLabel")
ServerID.Size = UDim2.new(1, -20, 0, 20)
ServerID.Position = UDim2.new(0, 10, 0, 35)
ServerID.Text = "Server ID: " .. string.sub(tostring(game.JobId), 1, 12) .. "..."
ServerID.TextColor3 = Color3.fromRGB(180, 180, 180)
ServerID.TextSize = 13
ServerID.Font = Enum.Font.SourceSans
ServerID.TextXAlignment = Enum.TextXAlignment.Left
ServerID.BackgroundTransparency = 1
ServerID.Parent = Frame

local ServerTime = Instance.new("TextLabel")
ServerTime.Size = UDim2.new(1, -20, 0, 20)
ServerTime.Position = UDim2.new(0, 10, 0, 55)
ServerTime.Text = "Jam Server: 00:00:00"
ServerTime.TextColor3 = Color3.fromRGB(180, 180, 180)
ServerTime.TextSize = 13
ServerTime.Font = Enum.Font.SourceSans
ServerTime.TextXAlignment = Enum.TextXAlignment.Left
ServerTime.BackgroundTransparency = 1
ServerTime.Parent = Frame

local Countdown = Instance.new("TextLabel")
Countdown.Size = UDim2.new(1, -20, 0, 20)
Countdown.Position = UDim2.new(0, 10, 0, 75)
Countdown.Text = "Rejoin Dalam: 15m 00s"
Countdown.TextColor3 = Color3.fromRGB(0, 255, 255)
Countdown.TextSize = 14
Countdown.Font = Enum.Font.SourceSansBold
Countdown.TextXAlignment = Enum.TextXAlignment.Left
Countdown.BackgroundTransparency = 1
Countdown.Parent = Frame

local LinkLabel = Instance.new("TextLabel")
LinkLabel.Size = UDim2.new(1, -20, 0, 20)
LinkLabel.Position = UDim2.new(0, 10, 0, 100)
LinkLabel.Text = "Tempel Link Private Server Di Bawah:"
LinkLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LinkLabel.TextSize = 12
LinkLabel.Font = Enum.Font.SourceSans
LinkLabel.TextXAlignment = Enum.TextXAlignment.Left
LinkLabel.BackgroundTransparency = 1
LinkLabel.Parent = Frame

local LinkBox = Instance.new("TextBox")
LinkBox.Size = UDim2.new(1, -20, 0, 25)
LinkBox.Position = UDim2.new(0, 10, 0, 120)
LinkBox.Text = PrivateServerLink
LinkBox.PlaceholderText = "Tempel link share di sini..."
LinkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
LinkBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
LinkBox.BorderSizePixel = 0
LinkBox.TextSize = 11
LinkBox.Font = Enum.Font.SourceSans
LinkBox.TextTruncate = Enum.TextTruncate.AtEnd
LinkBox.ClearTextOnFocus = true
LinkBox.ClipsDescendants = true
LinkBox.Parent = Frame

local LinkCorner = Instance.new("UICorner")
LinkCorner.CornerRadius = UDim.new(0, 5)
LinkCorner.Parent = LinkBox

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(0, 140, 0, 25)
InputLabel.Position = UDim2.new(0, 10, 0, 155)
InputLabel.Text = "Rejoin Setiap (menit):"
InputLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InputLabel.TextSize = 13
InputLabel.Font = Enum.Font.SourceSans
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.BackgroundTransparency = 1
InputLabel.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 50, 0, 25)
TextBox.Position = UDim2.new(0, 150, 0, 155)
TextBox.Text = tostring(rejoinMinutes)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
TextBox.BorderSizePixel = 0
TextBox.TextSize = 14
TextBox.Font = Enum.Font.SourceSansBold
TextBox.Parent = Frame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 5)
InputCorner.Parent = TextBox

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -20, 0, 35)
ToggleBtn.Position = UDim2.new(0, 10, 0, 195)
ToggleBtn.Text = "AUTO REJOIN: AKTIF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = Frame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 5)
BtnCorner.Parent = ToggleBtn

-- Klik Ikon untuk Toggle Membuka / Menutup Jendela Menu Utama
IconButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Logika Utama Teleportasi Anti-Stuck Protokol Browser
local function doTeleport()
    local input = LinkBox.Text
    local shareCode = input:match("code=([^&]+)") or input
    
    if not shareCode or shareCode == "" then
        Countdown.Text = "Error: Link Tidak Valid!"
        return
    end
    
    Countdown.Text = "Memproses Teleport..."
    
    task.spawn(function()
        pcall(function()
            GuiService:OpenBrowserWindow("roblox://experiences/start?placeId=" .. game.PlaceId .. "&shareCode=" .. shareCode)
        end)
        
        -- Cadangan jika executor menolak membuka link eksternal
        task.wait(4)
        if Countdown.Text == "Memproses Teleport..." then
            Countdown.Text = "Cadangan: Rejoin Biasa..."
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        end
    end)
end

-- Timer Loop
task.spawn(function()
    while true do
        local timeString = os.date("%H:%M:%S")
        ServerTime.Text = "Jam Server: " .. timeString
        
        if isEnabled then
            if timeLeft > 0 then
                timeLeft = timeLeft - 1
                local minutes = math.floor(timeLeft / 60)
                local seconds = timeLeft % 60
                Countdown.Text = string.format("Rejoin Dalam: %dm %02ds", minutes, seconds)
            else
                doTeleport()
                task.wait(15)
            end
        else
            Countdown.Text = "Auto Rejoin: JEDA"
        end
        task.wait(1)
    end
end)

-- Simpan otomatis link baru yang diketik ke memori internal file executor
LinkBox.FocusLost:Connect(function()
    if LinkBox.Text ~= "" then
        PrivateServerLink = LinkBox.Text
        if writefile then
            pcall(function()
                writefile(FileName, PrivateServerLink)
            end)
        end
    else
        LinkBox.Text = PrivateServerLink
    end
end)

-- ========================================================
-- PERBAIKAN STRUKTUR SINTAKS KEDUA TOMBOL LISTENER (UNTUK KELUAR KOLOM)
-- ========================================================
-- LOGIKA INPUT MENIT (KOTAK TEKS)
-- ========================================================
TextBox.FocusLost:Connect(function()
    local num = tonumber(TextBox.Text)
    if num and num > 0 then
        rejoinMinutes = num
        timeLeft = rejoinMinutes * 60
    else
        TextBox.Text = tostring(rejoinMinutes)
    end
end)

-- ========================================================
-- LOGIKA TOMBOL TOGGLE AKTIF / JEDA (BERDIRI SENDIRI)
-- ========================================================
ToggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    if isEnabled then
        ToggleBtn.Text = "AUTO REJOIN: AKTIF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Warna Hijau
        timeLeft = rejoinMinutes * 60
    else
        ToggleBtn.Text = "AUTO REJOIN: JEDA"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)   -- Warna Merah
        timeLeft = rejoinMinutes * 60
    end
end)
