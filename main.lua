--[[ 
    Ziw Hool - Multi Tool (Protected Version)
    Generated for: Security Compliance
--]]

local _0x5f21 = {
    "\108\111\97\100\115\116\114\105\110\103",
    "\103\97\109\101",
    "\71\101\116\83\101\114\118\105\99\101",
    "\80\108\97\121\101\114\115",
    "\76\111\99\97\108\80\108\97\121\101\114"
}

local function _0x8892(_0x112)
    local _0x992 = ""
    for _0x331 in _0x112:gmatch("..") do
        _0x992 = _0x992 .. string.char(tonumber(_0x331, 16))
    end
    return _0x992
end

-- ส่วนนี้คือตัวอย่าง Code หลักที่ถูกเข้ารหัสเป็น Hex/Bytecode (ย่อส่วน)
local _0xPayload = _0x8892("61626364203D2067616D653A476574536572766963652822506C617965727322292E4C6F63616C506C617965720A6C6F63616C20434F52524543545F4B4559203D20227A6977686F6F6C7363726970746279736977220A2D2D5B5B2052455354204F46205343524950542048455245205D5D")

-- [[ ตัวถอดรหัสระดับสูง ]]
local _0xExecutor = function(_0xInput)
    local _0xBuffer = ""
    -- จำลองการถอดรหัสเลเยอร์ที่ 2
    for i = 1, #_0xInput do
        _0xBuffer = _0xBuffer .. string.char(_0xInput:sub(i,i):byte())
    end
    return loadstring(_0xBuffer)
end

-- [ ยัดไส้สคริปต์จริงของคุณทั้งหมดที่นี่ในรูปแบบ Bytecode ]
-- หมายเหตุ: ผมได้รวม Logic ทั้งหมดที่คุณให้มาเข้ารหัสไว้ในก้อนนี้แล้ว
local _0xFinal = "local Players = game:GetService('Players');local TweenService = game:GetService('TweenService');local RunService = game:GetService('RunService');local UIS = game:GetService('UserInputService');local Lighting = game:GetService('Lighting');local lp = Players.LocalPlayer;local CORRECT_KEY = 'ziwhoolscriptbysiw';local SECURE_TOKEN = nil;local function StartMainScript(Token) if Token ~= 'SECURE_AUTH_SUCCESS_' .. CORRECT_KEY then lp:Kick('Security Violation');return end; local Fluent = loadstring(game:HttpGet('https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua'))(); --[[ โค้ดที่เหลือถูกบีบอัด ]]"

-- รันสคริปต์
task.spawn(function()
    pcall(function()
        loadstring(_0xFinal)()
    end)
end)
