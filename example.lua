-- гемини поработал
local function get_lib()
    if getgenv().shitaroebet and type(getgenv().shitaroebet) == "table" then
        return getgenv().shitaroebet
    end

    local src = nil
    local GITHUB_URL = "https://raw.githubusercontent.com/onyx-svag/shitaroui/refs/heads/main/shitaro.lua"


    local ok_http, res = pcall(function()
        if game.HttpGet then
            return game:HttpGet(GITHUB_URL)
        end
        return nil
    end)

    if ok_http and type(res) == "string" and #res > 0 then
        src = res
    end


    if not src then
        if isfile and isfile("shitaroebet.lua") then
            src = readfile("shitaroebet.lua")
        elseif isfile and isfile("shitaro/shitaroebet.lua") then
            src = readfile("shitaro/shitaroebet.lua")
        end
    end

    if not src then
        error("2")
    end

    local fn, err = loadstring(src, "@shitaro_ui")
    if not fn then
        error("1: " .. tostring(err))
    end

    local lib = fn()
    getgenv().shitaroebet = lib
    return lib
end

local lib = get_lib()


local root = lib:window({ bind = "Insert" })
if not root.open then root:toggle() end

local function hook_watermark_title(custom_title)
    local function try_replace(inst)
        if inst:IsA("TextLabel") and inst.Text == "shitaro.lol" then
            inst.Text = custom_title
            pcall(function()
                inst.Size = UDim2.new(0, inst.TextBounds.X + 6, 0, 20)
            end)
            return true
        end
        return false
    end

    task.spawn(function()
        local scr = lib.scr
        while not scr do
            scr = lib.scr or game:GetService("CoreGui"):FindFirstChild("Shitaro_UI")
            task.wait(0.1)
        end


        for _, desc in ipairs(scr:GetDescendants()) do
            if try_replace(desc) then return end
        end


        local conn
        conn = scr.DescendantAdded:Connect(function(desc)
            if try_replace(desc) then
                conn:Disconnect()
            end
        end)
    end)
end


hook_watermark_title("example.lol") -- hook

local game_tab = root:tab({
    name = "game",
    icon = "mouse-scrollwheel",
    tip = "game func"
})

local sheriff_sec = game_tab:section({ name = "sheriff", side = "left" })
sheriff_sec:toggle({ name = "silent aim", default = false, callback = function(v) print("Silent:", v) end })
sheriff_sec:toggle({ name = "prediction", default = true, callback = function(v) end })
sheriff_sec:slider({ name = "fire gap", min = 0, max = 50, default = 15, suffix = "studs", callback = function(v) end })

local murderer_sec = game_tab:section({ name = "murderer", side = "right" })
murderer_sec:toggle({ name = "kill aura", default = false, callback = function(v) print("Kill aura:", v) end })
murderer_sec:slider({ name = "kill range", min = 5, max = 50, default = 25, suffix = "studs", callback = function(v) end })

local visuals_tab = root:tab({
    name = "visuals",
    icon = "eye",
    tip = "players visuals"
})

local esp_sec = visuals_tab:section({ name = "esp", side = "left" })
esp_sec:toggle({ name = "enable esp", default = true, callback = function(v) end })
esp_sec:color({ name = "sheriff color", default = Color3.fromRGB(0, 150, 255), callback = function(c) end })
esp_sec:color({ name = "murderer color", default = Color3.fromRGB(255, 50, 50), callback = function(c) end })

local chams_sec = visuals_tab:section({ name = "chams", side = "right" })
chams_sec:toggle({ name = "chams fill", default = false, callback = function(v) end })
chams_sec:slider({ name = "glow width", min = 1, max = 10, default = 3, callback = function(v) end })

local world_sub = visuals_tab:sub({
    name = "world",
    icon = "globe",
    tip = "world visuals"
})
local amb_sec = world_sub:section({ name = "ambient", side = "left" })
amb_sec:toggle({ name = "night mode", default = false, callback = function(v) end })
amb_sec:color({ name = "fog color", default = Color3.fromRGB(50, 50, 70), callback = function(c) end })

local player_tab = root:tab({
    name = "player",
    icon = "user",
    tip = "local player"
})

local move_sec = player_tab:section({ name = "movement", side = "left" })
move_sec:slider({ name = "walk speed", min = 16, max = 120, default = 16, suffix = "ws", callback = function(v) end })
move_sec:slider({ name = "jump power", min = 50, max = 250, default = 50, suffix = "jp", callback = function(v) end })

local models_sub = player_tab:sub({
    name = "models",
    icon = "shirt",
    tip = "model library"
})
local mod_sec = models_sub:section({ name = "custom skin", side = "left" })
mod_sec:button({ name = "Apply Default", callback = function() print("Default model applied") end })

local anim_tab = root:tab({
    name = "animations",
    icon = "activity",
    tip = "custom animations"
})

local anim_gallery = anim_tab:gallery({
    name = "animations",
    icon = "footprints",
    side = "full",
    multi = true,
    thumb = "BundleThumbnail",
    height = 290,
    cell = 74,
    tools = false,
    empty = "loading bundles",
    list = {
        { name = "Ninja", id = 80 },
        { name = "Zombie", id = 81 },
        { name = "Mage", id = 82 },
        { name = "Levitation", id = 83 },
        { name = "Vampire", id = 84 },
        { name = "Superhero", id = 85 },
        { name = "Cartoony", id = 86 }
    },
    flag = "player_anim_bundle",
    callback = function(v)
        print("[ANIMATIONS] Selected pack:", v)
    end
})


local emotes_sub = anim_tab:sub({
    name = "emotes",
    icon = "video",
    tip = "emote library"
})


local emote_gallery = emotes_sub:gallery({
    name = "emotes",
    icon = "video",
    side = "full",
    thumb = "Asset",
    height = 310,
    cell = 74,
    reset = true,
    tools = false,
    empty = "loading emotes",
    flag = "player_emote_library",
    list = {
        { name = "Griddy", id = "129149402922241" },
        { name = "Floss", id = "5918726674" },
        { name = "Dab", id = "248263260" },
        { name = "Take The L", id = "10214311282" },
        { name = "Jiggle", id = "13617300762" },
        { name = "Orange Justice", id = "11340501867" },
        { name = "Electro Shuffle", id = "10214315264" }
    },
    callback = function(v)
        local emoteName = type(v) == "table" and v.name or v
        print("[EMOTES] Play Emote:", emoteName)
        
        -- Проигрывание через нативный Humanoid (как в shitaro.txt L15500)
        local char = game:GetService("Players").LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and v and v.id then
            pcall(function()
                for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://" .. tostring(v.id):gsub("%D", "")
                local track = hum:LoadAnimation(anim)
                anim:Destroy()
                track.Priority = Enum.AnimationPriority.Action
                track.Looped = true
                track:Play()
            end)
        end
    end
})


local target_tab = root:tab({
    name = "target",
    icon = "crosshair",
    tip = "target selection"
})

local trg_sec = target_tab:section({ name = "filters", side = "left" })
trg_sec:combo({
    name = "target priority",
    list = {"Nearest", "Lowest HP", "Murderer First", "Sheriff First"},
    default = "Nearest",
    callback = function(t) end
})


local misc_tab = root:tab({
    name = "misc",
    icon = "box",
    tip = "miscellaneous"
})

local msec = misc_tab:section({ name = "utils", side = "left" })
msec:toggle({ name = "anti-afk", default = true, callback = function(v) end })
msec:toggle({ name = "auto-rejoin", default = false, callback = function(v) end })

local maps_sub = misc_tab:sub({
    name = "maps",
    icon = "map",
    tip = "map vote"
})
local map_sec = maps_sub:section({ name = "map vote", side = "left" })
map_sec:toggle({ name = "auto vote favorite", default = false, callback = function(v) end })


local skin_tab = root:tab({
    name = "skins",
    icon = "database",
    tip = "weapon skins"
})

local filt_sec = skin_tab:section({ name = "filter", side = "left" })
filt_sec:combo({
    name = "slot",
    list = {"all", "knives", "guns"},
    default = "all",
    callback = function(v) print("Skin slot:", v) end
})

filt_sec:combo({
    name = "rarity",
    list = {"all", "Common", "Rare", "Legendary", "Godly", "Ancient"},
    default = "all",
    callback = function(v) print("Rarity:", v) end
})

local applied_sec = skin_tab:section({ name = "applied", side = "right" })
applied_sec:label({ name = "Knife: Default  |  Gun: Default" })

local skin_gallery = skin_tab:gallery({
    name = "skins",
    icon = "database",
    side = "full",
    thumb = "Asset",
    height = 290,
    cell = 74,
    multi = false,
    empty = "No skins loaded yet",
    list = {
        { name = "Harvester", id = 0 },
        { name = "Chroma Lightbringer", id = 0 },
        { name = "Icebreaker", id = 0 },
        { name = "Corrupt", id = 0 },
        { name = "Bat", id = 0 }
    },
    flag = "skin_library",
    callback = function(item)
        print("Selected weapon skin:", item)
    end
})

local config_tab = root:tab({
    name = "config",
    icon = "save",
    tip = "menu settings"
})

config_tab:color({ name = "Accent Glow", key = "accent", side = "left" })
config_tab:color({ name = "Panel BG", key = "panel", side = "right" })

local csec = config_tab:section({ name = "Menu", side = "left" })
csec:label({ name = "Нажми INSERT на клавиатуре, чтобы свернуть окно" })

-- Всплывающее уведомление
lib:notify({
    title = "тзис ис шит",
    text = "test тест 123456789",
    life = 4
})
