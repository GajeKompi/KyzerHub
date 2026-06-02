-- ========================================================
-- 🛡️ SISTEM KEAMANAN KYZERHUB (VERSI REVISI)
-- ========================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer or LocalPlayer.Name == "" or LocalPlayer.Name == "Player" do
    task.wait(0.5)
    LocalPlayer = Players.LocalPlayer
end

local TargetPlaceId = 126884695634066
if game.PlaceId ~= TargetPlaceId then
    LocalPlayer:Kick("❌ KyzerHub: Game tidak diizinkan!")
    return
end

local WhitelistUsernames = {
    ["handukbasah142"] = true,
    ["handukbasah140"] = true,
    ["sepuhhhhqil4"] = true,
    ["handukbasah143"] = true,
    ["fessca_0"] = true   
}

if not WhitelistUsernames[LocalPlayer.Name] then
    LocalPlayer:Kick("❌ KyzerHub: Akun ("..tostring(LocalPlayer.Name)..") tidak terdaftar di Whitelist!")
    return
end
-- ========================================================

loadstring(game:HttpGet("https://raw.githubusercontent.com/GajeKompi/KyzerHub/main/kyzerloader.lua"))()
