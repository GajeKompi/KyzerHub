
-- [[ 1. LOAD FLUENT UI LIBRARY RESMI ]]
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ 2. INISIALISASI WINDOW UTAMA ]]
local Window = Fluent:CreateWindow({
    Title = "Grow a Garden - Optional KG Filter",
    SubTitle = "by AI Assistant",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ 3. DATA CONFIG & CACHE SESSIONS ]]
local Config = {
    SelectedPets = {},
    WhitelistMutation = {},
    ThresholdMode = "Below",
    ThresholdBaseKG = 0, -- Default 0 berarti OPSIONAL (mengabaikan filter KG)
    Enable = false
}

-- Database ingatan agar pet yang lolos kriteria hanya difavoritkan 1 kali (Anti-Looping)
local PetTerprosesSesiIni = {}

-- [[ 4. AUTO SCAN LIST PET DARI ANIMASI GAME ]]
local function AmbilDaftarPet()
    local ListPet = {}
    local FolderPet = game:GetService("ReplicatedStorage"):FindFirstChild("Assets") 
        and game:GetService("ReplicatedStorage").Assets:FindFirstChild("Animations") 
        and game:GetService("ReplicatedStorage").Assets.Animations:FindFirstChild("PetAnimations")
    if FolderPet then
        for _, pet in pairs(FolderPet:GetChildren()) do 
            table.insert(ListPet, pet.Name) 
        end
    else 
        ListPet = {"Albino Peacock", "Amethyst Beetle", "Angora Goat", "Ankylosaurus", "Apple Gazelle", "Arctic Fox", "Armadillo"} 
    end
    table.sort(ListPet)
    return ListPet
end

local MasterListPet = AmbilDaftarPet()

-- [[ 5. MEMBUAT HALAMAN SETTINGS ]]
local Tabs = {
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [[ 6. KONTROL UTAMA: SAKELAR ON / OFF ]]
local ToggleFavorit = Tabs.Settings:AddToggle("AutoFavToggle", {
    Title = "Enable Auto Favorite", 
    Default = false,
    Callback = function(Value)
        Config.Enable = Value
        if not Value then
            table.clear(PetTerprosesSesiIni) -- Bersihkan cache memori jika dimatikan
        end
    end
})

-- [[ 7. SEARCH BAR PET MANDIRI ]]
local DropdownPet

local SearchInput = Tabs.Settings:AddInput("PetSearchInput", {
    Title = "Search Pet Name",
    Default = "",
    PlaceholderText = "Ketik nama pet untuk memfilter daftar di bawah...",
    Numeric = false,
    Finished = false,
    Callback = function(Text)
        local Keyword = string.lower(Text)
        local FilteredList = {}
        
        for _, petName in pairs(MasterListPet) do
            if Keyword == "" or string.find(string.lower(petName), Keyword) then
                table.insert(FilteredList, petName)
            end
        end
        
        if DropdownPet then
            DropdownPet:SetValues(FilteredList)
        end
    end
})

-- [[ 8. DROPDOWN SELEKSI BANYAK PET (MULTIPLE SELECTION) ]]
DropdownPet = Tabs.Settings:AddDropdown("MultiPetSelect", {
    Title = "Select Pet Type",
    Description = "Centang banyak pet yang ingin difavoritkan (Gunakan kolom search di atas)",
    Values = MasterListPet,
    Multi = true, 
    Default = {},
    Callback = function(Value)
        Config.SelectedPets = Value
    end
})

-- [[ 9. MULTI-SELECT: SELECTION MUTATION ]]
local DropdownMutasi = Tabs.Settings:AddDropdown("MultiMutationSelect", {
    Title = "Whitelist Mutation",
    Description = "Mutasi terpilih otomatis langsung lolos favorit tanpa cek bobot KG",
    Values = {"Shiny", "Golden", "Mega", "Emerald", "None"},
    Multi = true, 
    Default = {},
    Callback = function(Value)
        Config.WhitelistMutation = Value
    end
})

-- [[ 10. INPUT TEKS: BATAS ANGKA KG (OPSIONAL) ]]
local InputKG = Tabs.Settings:AddInput("KGInput", {
    Title = "Threshold Base KG (Opsional)",
    Default = "0", -- Jika bernilai 0 atau kosong, filter KG dilewati otomatis
    PlaceholderText = "Kosongkan atau isi 0 untuk memfavoritkan semua KG",
    Numeric = true, 
    Finished = true,
    Callback = function(Value)
        Config.ThresholdBaseKG = tonumber(Value) or 0
    end
})

-- [[ 11. MODE DROPDOWN: BELOW OR ABOVE ]]
local DropdownMode = Tabs.Settings:AddDropdown("ModeSelect", {
    Title = "Threshold Mode",
    Values = {"Below", "Above"},
    CurrentValue = "Below",
    Multi = false,
    Callback = function(Value)
        Config.ThresholdMode = Value
    end
})

-- [[ 12. LOGIKA PARSING DAN MATHEMATICAL FILTER ]]
local function ParsingDataPet(NamaObjek)
    local kg = tonumber(string.match(NamaObjek, "%[(%d+%.?%d*)%s*KG%]")) or 0
    local mutasi = "None"
    for _, m in pairs({"Shiny", "Golden", "Mega", "Emerald"}) do 
        if string.find(NamaObjek, m) then mutasi = m break end 
    end
    return kg, mutasi
end

local function CekApakahLolosFilter(item)
    local nama = item.Name
    local kg, mutasi = ParsingDataPet(nama)
    
    -- Evaluasi Multi-Selection Jenis Pet
    local CocokJenis = false
    local TotalPilihanPet = 0
    for _ in pairs(Config.SelectedPets) do TotalPilihanPet = TotalPilihanPet + 1 end
    
    if TotalPilihanPet > 0 then
        for p, aktif in pairs(Config.SelectedPets) do 
            if aktif and string.find(nama, p) then CocokJenis = true break end 
        end
    else
        return false 
    end
    if not CocokJenis then return false end
    
    -- Evaluasi Multi-Selection Whitelist Mutasi (Jika cocok langsung lolos)
    for wm, aktif in pairs(Config.WhitelistMutation) do 
        if aktif and mutasi == wm and wm ~= "None" then return true end 
    end
    
    -- ===== LOGIKA BARU: FILTER KG MENJADI OPSIONAL =====
    -- Jika diisi 0 atau kosong, maka bypass / loloskan semua berat KG pet
    if Config.ThresholdBaseKG > 0 then
        if Config.ThresholdMode == "Below" and kg > Config.ThresholdBaseKG then return false end
        if Config.ThresholdMode == "Above" and kg < Config.ThresholdBaseKG then return false end
    end
    -- ====================================================
    
    return true
end

-- [[ 13. RUNNING BACKGROUND PROCESS THREAD ]]
task.spawn(function()
    while true do
        local Backpack = game:GetService("Players").LocalPlayer:FindFirstChild("Backpack")
        if Backpack and Config.Enable then
            for _, item in pairs(Backpack:GetChildren()) do
                if CekApakahLolosFilter(item) then
                    
                    if not PetTerprosesSesiIni[item] then
                        PetTerprosesSesiIni[item] = true
                        
                        game:GetService("ReplicatedStorage").GameEvents.Favorite_Item:FireServer(item)
                        task.wait(0.12) 
                    end
                    
                end
            end
        end
        task.wait(0.5)
    end
end)

Window:SelectTab(1)
