local B = AscensionBags
local S = Syndicator335
local Log = B.Log

local sorter = CreateFrame("Frame")
sorter:Hide()

function B.SortKey(link)
    local name, _, quality, iLvl, _, itemType, subType = GetItemInfo(link or "")
    name, quality, iLvl = name or "", quality or 0, iLvl or 0
    itemType, subType = itemType or "", subType or ""
    local method = B.Config().sortMethod
    if method == "quality" then
        return string.format("%02d|%s|%s|%s", 9 - quality, itemType, subType, name)
    elseif method == "ilvl" then
        return string.format("%04d|%s", 9999 - iLvl, name)
    else
        return string.format("%s|%s|%02d|%s", itemType, subType, 9 - quality, name)
    end
end

local function SortStep(bags)
    local slots = {}
    for _, bag in ipairs(bags) do
        for slot = 1, GetContainerNumSlots(bag) or 0 do
            local _, count, locked = GetContainerItemInfo(bag, slot)
            local link = GetContainerItemLink(bag, slot)
            if locked then return true end
            slots[#slots+1] = {
                bag = bag, slot = slot, link = link,
                id = S.ItemID(link), count = count or 0,
                max = link and (select(8, GetItemInfo(link)) or 1) or 1,
            }
        end
    end

    local partial = {}
    for _, s in ipairs(slots) do
        if s.id and s.count < s.max then
            local o = partial[s.id]
            if o then
                PickupContainerItem(o.bag, o.slot)
                PickupContainerItem(s.bag, s.slot)
                return true
            end
            partial[s.id] = s
        end
    end

    local items = {}
    for _, s in ipairs(slots) do
        if s.link then items[#items+1] = s end
    end
    table.sort(items, function(a, b)
        local ka, kb = B.SortKey(a.link), B.SortKey(b.link)
        if ka ~= kb then return ka < kb end
        if a.count ~= b.count then return a.count > b.count end
        return false
    end)

    for pos, want in ipairs(items) do
        local target = slots[pos]
        if not target then break end
        if target.bag ~= want.bag or target.slot ~= want.slot then
            PickupContainerItem(want.bag, want.slot)
            PickupContainerItem(target.bag, target.slot)
            return true
        end
    end
    return false
end

sorter:SetScript("OnUpdate", function(self, elapsed)
    self.t = (self.t or 0) + (elapsed or 0)
    if self.t < 0.15 then return end
    self.t = 0
    if CursorHasItem() then return end
    self.steps = (self.steps or 0) + 1
    if self.steps > 400 then
        Log("Sort aborted (too many steps)")
        self:Hide()
        return
    end
    local ok, more = pcall(SortStep, self.bags)
    if not ok or not more then
        if not ok then Log("ERROR while sorting: "..tostring(more)) end
        self:Hide()
        Log("Sort finished ("..(self.steps or 0).." steps)")
    end
end)

function B.StartSort(bags)
    if sorter:IsShown() then return end
    sorter.bags  = bags
    sorter.t     = 0
    sorter.steps = 0
    sorter:Show()
    Log("Sort started (method: "..B.Config().sortMethod..")")
end
