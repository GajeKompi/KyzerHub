-- [[ FILE GITHUB 2: main.lua ]]
-- File ini bertugas menerima data transfer variabel dan menjalankan loop seleksi pet

local Data_Transfer = ... -- Menangkap data kiriman dari script utama/loader

local Config = Data_Transfer.Config
local PetTerprosesSesiIni = Data_Transfer.PetTerprosesSesiIni
local MasterListMutasi = Data_Transfer.MasterListMutasi

-- [[ LOGIKA PARSING DAN FILTER NAMA PET ASLI ]]
local function ParsingDataPet(NamaObjek)
    local mutasi = "None"
    for _, m in pairs(MasterListMutasi) do 
        if m ~= "None" and string.find(NamaObjek, m) then 
            mutasi = m 
            break 
        end 
    end
    return mutasi
end

local function CekApakahLolosFilter(item)
    local nama = item.Name
    local mutasi = ParsingDataPet(nama)
    
    local CocokJenis = false
    local TotalPilihanPet = 0
    for _ in pairs(Config.SelectedPets) do TotalPilihanPet = TotalPilihanPet + 1 end
    
    if TotalPilihanPet > 0 then
        -- Solusi Perbaikan Spasi (e.g. Empress Bee vs EmpressBee)
        local namaGameDibersihkan = string.lower(string.gsub(nama, "%s+", ""))
        for p, aktif in pairs(Config.SelectedPets) do 
            if aktif then
                local namaIndexDibersihkan = string.lower(string.gsub(p, "%s+", ""))
                if string.find(namaGameDibersihkan, namaIndexDibersihkan) then 
                    CocokJenis = true 
                    break 
                end 
            end
        end
    else
        return false 
    end
    if not CocokJenis then return false end
    
    local TotalPilihanMutasi = 0
    for _ in pairs(Config.WhitelistMutation) do TotalPilihanMutasi = TotalPilihanMutasi + 1 end
    
    if TotalPilihanMutasi > 0 then
        local MutasiCocok = false
        for wm, aktif in pairs(Config.WhitelistMutation) do 
            if aktif and mutasi == wm then 
                MutasiCocok = true 
                break 
            end 
        end
        if not MutasiCocok then return false end
    end
    
    return true
end

-- [[ RUNNING BACKGROUND PROCESS THREAD ]]
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
