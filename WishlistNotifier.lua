local wishlist = {}

local function CheckBags()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if itemLink then
                for _, wanted in ipairs(wishlist) do
                    if string.find(string.lower(itemLink), string.lower(wanted)) then
                        PlaySoundFile("Sound\\Interface\\LevelUp.wav")
                        DEFAULT_CHAT_FRAME:AddMessage("|cffff00ff[Wishlist]|r Encontraste algo: " .. itemLink)
                    end
                end
            end
        end
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("BAG_UPDATE")
frame:SetScript("OnEvent", CheckBags)

SLASH_WL1 = "/wl"
SlashCmdList["WL"] = function(msg)
    local cmd, rest = "", ""
    local sp = string.find(msg, " ")
    if sp then
        cmd = string.sub(msg, 1, sp - 1)
        rest = string.sub(msg, sp + 1)
    else
        cmd = msg
    end

    if cmd == "add" and rest ~= "" then
        table.insert(wishlist, rest)
        print("|cffff00ff[Wishlist]|r añadido: " .. rest)
    elseif cmd == "list" then
        print("|cffff00ff[Wishlist actual]:|r")
        for _, v in ipairs(wishlist) do print(" - " .. v) end
    elseif cmd == "popup" then
        StaticPopupDialogs["WISHLIST_ADD"] = {
            text = "Ingresa el texto del item a seguir:",
            button1 = "Añadir",
            button2 = "Cancelar",
            hasEditBox = true,
            maxLetters = 50,
            OnAccept = function(self)
                local item = self.editBox:GetText()
                table.insert(wishlist, item)
                print("|cffff00ff[Wishlist]|r añadido desde ventana: " .. item)
            end,
            EditBoxOnEnterPressed = function(self)
                local item = self:GetText()
                table.insert(wishlist, item)
                print("|cffff00ff[Wishlist]|r añadido desde ventana: " .. item)
                self:GetParent():Hide()
            end,
            OnShow = function(self)
                self.editBox:SetFocus()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true
        }
        StaticPopup_Show("WISHLIST_ADD")
    elseif cmd ~= "" then
        table.insert(wishlist, cmd)
        print("|cffff00ff[Wishlist]|r añadido: " .. cmd)
    else
        print("|cffff00ffUso:|r /wl add <palabra> | /wl <palabra> | /wl list | /wl popup")
    end
end