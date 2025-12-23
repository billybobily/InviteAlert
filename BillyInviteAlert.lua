--[[
    Billy's Invite Alert - WoW 1.12 (Classic) Addon
    
    Automatically sends a whisper to players when you try to invite them
    but they're already in a group.
    
    COMPATIBILITY NOTES:
    - Uses Lua 5.0 (NOT 5.1+)
    - DO NOT USE: # operator, continue keyword
    - USE INSTEAD: table.getn(), getglobal()
--]]

BillyInviteAlert = {};

-- Saved variables with defaults
BillyInviteAlertDB = BillyInviteAlertDB or {
    enabled = true,
    message = "Hey! I tried to invite you but you're already in a group. Let me know when you're free!",
    debug = false,
};

-- Track the last player we tried to invite
local lastInviteTarget = nil;
local lastInviteTime = 0;

-- Function to handle addon load
function BillyInviteAlert:OnLoad()
    self:RegisterEvents();
    self:RegisterSlashCmds();
    DEFAULT_CHAT_FRAME:AddMessage("Billy's Invite Alert: Loaded. Use /bia to configure.", 0.5, 1, 0.5);
end

-- Register events
function BillyInviteAlert:RegisterEvents()
    local frame = getglobal("BillyInviteAlertFrame");
    if not frame then
        frame = CreateFrame("Frame", "BillyInviteAlertFrame");
    end
    
    frame:RegisterEvent("VARIABLES_LOADED");
    frame:RegisterEvent("UI_ERROR_MESSAGE");
    frame:RegisterEvent("CHAT_MSG_SYSTEM");
    
    frame:SetScript("OnEvent", function()
        BillyInviteAlert:OnEvent();
    end);
end

-- Event handler
function BillyInviteAlert:OnEvent()
    if event == "VARIABLES_LOADED" then
        -- Initialize saved variables
        if not BillyInviteAlertDB then
            BillyInviteAlertDB = {
                enabled = true,
                message = "Hey! I tried to invite you but you're already in a group. Let me know when you're free!",
                debug = false,
            };
        end
        -- Add debug field if missing from older versions
        if BillyInviteAlertDB.debug == nil then
            BillyInviteAlertDB.debug = false;
        end
        
        -- Hook functions after variables are loaded
        BillyInviteAlert:HookFunctions();
    elseif event == "UI_ERROR_MESSAGE" then
        if BillyInviteAlertDB.enabled then
            self:HandleErrorMessage(arg1);
        end
    elseif event == "CHAT_MSG_SYSTEM" then
        if BillyInviteAlertDB.enabled then
            self:HandleErrorMessage(arg1);
        end
    end
end

-- Store original functions
local Orig_InviteByName;
local Orig_UnitPopup_OnClick;

-- Hook the invite functions to track who we're inviting
function BillyInviteAlert:HookFunctions()
    -- Hook /invite command
    Orig_InviteByName = InviteByName;
    InviteByName = function(name)
        if name then
            lastInviteTarget = name;
            lastInviteTime = GetTime();
            if BillyInviteAlertDB.debug then
                DEFAULT_CHAT_FRAME:AddMessage("GIA [DEBUG]: InviteByName called for " .. name, 1, 1, 0);
            end
        end
        Orig_InviteByName(name);
    end;
    
    -- Hook right-click invite (UnitPopup)
    Orig_UnitPopup_OnClick = UnitPopup_OnClick;
    UnitPopup_OnClick = function()
        -- Get the dropdown info
        local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
        local button = this.value;
        local unit = dropdownFrame.unit;
        local name = dropdownFrame.name;
        
        -- Check if this is an invite action
        if button == "INVITE" or button == "PARTY_INVITE" or button == "RAID_INVITE" then
            local targetName = name or (unit and UnitName(unit));
            
            if targetName then
                lastInviteTarget = targetName;
                lastInviteTime = GetTime();
                if BillyInviteAlertDB.debug then
                    DEFAULT_CHAT_FRAME:AddMessage("GIA [DEBUG]: UnitPopup invite for " .. targetName, 1, 1, 0);
                end
            end
        end
        
        -- Call original function
        Orig_UnitPopup_OnClick();
    end;
    
    DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Hooks installed", 0, 1, 0);
end

-- Handle UI error messages
function BillyInviteAlert:HandleErrorMessage(errorMsg)
    -- Check if this is the "already in group" error
    -- In Classic WoW 1.12, this error message is: "X is already in a group"
    if errorMsg and string.find(errorMsg, "already in a group") then
        -- Get the current time
        local currentTime = GetTime();
        local timeSinceInvite = currentTime - lastInviteTime;
        
        if BillyInviteAlertDB.debug then
            DEFAULT_CHAT_FRAME:AddMessage("BIA [DEBUG]: Detected 'already in group' for " .. tostring(lastInviteTarget) .. " (" .. string.format("%.2f", timeSinceInvite) .. "s ago)", 0.5, 1, 1);
        end
        
        -- Only send whisper if we recently tried to invite (within 2 seconds)
        if lastInviteTarget and timeSinceInvite < 2 then
            self:SendAlertWhisper(lastInviteTarget);
            lastInviteTarget = nil; -- Reset so we don't spam
        elseif BillyInviteAlertDB.debug then
            DEFAULT_CHAT_FRAME:AddMessage("BIA [DEBUG]: No recent invite target or timeout expired", 1, 0.5, 0);
        end
    end
end

-- Send the alert whisper
function BillyInviteAlert:SendAlertWhisper(playerName)
    if not playerName or playerName == "" then
        return;
    end
    
    local message = BillyInviteAlertDB.message;
    SendChatMessage(message, "WHISPER", nil, playerName);
    
    if BillyInviteAlertDB.debug then
        DEFAULT_CHAT_FRAME:AddMessage("BIA [DEBUG]: Whispered " .. playerName, 0, 1, 0);
    else
        DEFAULT_CHAT_FRAME:AddMessage("Billy's Invite Alert: Whispered " .. playerName, 0, 1, 0);
    end
end

-- Register slash commands
function BillyInviteAlert:RegisterSlashCmds()
    SLASH_BILLYINVITEALERT1 = "/billyinvitealert";
    SLASH_BILLYINVITEALERT2 = "/bia";
    
    SlashCmdList["BILLYINVITEALERT"] = function(msg)
        BillyInviteAlert:HandleSlashCommand(msg);
    end;
end

-- Handle slash commands
function BillyInviteAlert:HandleSlashCommand(msg)
    msg = msg or "";
    
    -- Extract first word as command (lowercase) and rest as arguments
    local command, args = "", "";
    local spacePos = string.find(msg, " ");
    if spacePos then
        command = string.lower(string.sub(msg, 1, spacePos - 1));
        args = string.sub(msg, spacePos + 1);
    else
        command = string.lower(msg);
    end
    
    if command == "on" or command == "enable" then
        BillyInviteAlertDB.enabled = true;
        DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Enabled", 0, 1, 0);
    elseif command == "off" or command == "disable" then
        BillyInviteAlertDB.enabled = false;
        DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Disabled", 1, 0, 0);
    elseif command == "status" then
        local status = BillyInviteAlertDB.enabled and "Enabled" or "Disabled";
        DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: " .. status, 1, 1, 0);
        DEFAULT_CHAT_FRAME:AddMessage("Current message: " .. BillyInviteAlertDB.message, 1, 1, 0);
    elseif command == "msg" then
        if args and args ~= "" then
            BillyInviteAlertDB.message = args;
            DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Message updated to: " .. args, 0, 1, 0);
        else
            DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Please provide a message", 1, 0, 0);
        end
    elseif command == "debug" then
        BillyInviteAlertDB.debug = not BillyInviteAlertDB.debug;
        local debugStatus = BillyInviteAlertDB.debug and "Enabled" or "Disabled";
        DEFAULT_CHAT_FRAME:AddMessage("BillyInviteAlert: Debug mode " .. debugStatus, 1, 1, 0);
    else
        DEFAULT_CHAT_FRAME:AddMessage("Billy's Invite Alert Commands:", 1, 1, 0);
        DEFAULT_CHAT_FRAME:AddMessage("/bia on - Enable the addon", 0.8, 0.8, 0.8);
        DEFAULT_CHAT_FRAME:AddMessage("/bia off - Disable the addon", 0.8, 0.8, 0.8);
        DEFAULT_CHAT_FRAME:AddMessage("/bia status - Show current status", 0.8, 0.8, 0.8);
        DEFAULT_CHAT_FRAME:AddMessage("/bia msg <text> - Set custom whisper message", 0.8, 0.8, 0.8);
        DEFAULT_CHAT_FRAME:AddMessage("/bia debug - Toggle debug logging", 0.8, 0.8, 0.8);
    end
end

-- Initialize addon on load
BillyInviteAlert:OnLoad();
