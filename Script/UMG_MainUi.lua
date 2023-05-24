--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type UMG_MainUi_C
local M = UnLua.Class()
local Init = require("BP_Initialize")

local isDone = false
local e = 99;
--function M:Initialize(Initializer)
    --print("900909090")
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.Button_1.OnClicked:Add(self,M.OnClick1)
    self.Button_2.OnClicked:Add(self,M.OnClick2)
    self.Button_3.OnClicked:Add(self,M.OnClick3)
    self.Button_4.OnClicked:Add(self,M.OnClick4)
    self.Button_5.OnClicked:Add(self,M.OnClick5)
    self.Button_6.OnClicked:Add(self,M.OnClick6)
    self.Button_7.OnClicked:Add(self,M.OnClick7)
    self.Button_8.OnClicked:Add(self,M.OnClick8)
    self.Button_9.OnClicked:Add(self,M.OnClick9)
    --self.Button_test.OnClicked:Add(self,M.OnClick)

    

end


--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:GetIsDone()
    return isDone
end
function M:GetE()
    return e
end
function M:SetIsDone(_bool)
    isDone = _bool
    return isDone
end

-- 结局条件检查
---@param _allPlan any
---@param _allSlot any
function M:EndCheck(_allPlan,_allSlot)
    local is = false
    for index, value in ipairs(_allSlot) do
        for index2, value2 in ipairs(value) do
            if not value2.isInput_ then
                is = true
            end
        end
    end
    if not is then
        print("Drawing!!!!!")
        return 1
    else
        for key, plan in pairs(_allPlan) do
            if not plan.isImpossibleAchieve_ and plan.completeValue_ == 3 then
                print(plan.belongingPlayer_,"WIN!!!")
                if plan.belongingPlayer_ == Init:GetAiName() then
                    e = 2
                    return 2
                end
                if plan.belongingPlayer_ == Init:GetPersonName() then
                    e = 3
                    return 3
                end
            end
        end
    end 
    return 0
end

-- 落子操作
---@param _SlotId integer
---@param _chessTable table
---@param _player string
---@param _allPlan table
function M:PieceAction(_SlotId,_chessTable,_player,_allPlan)

    local slot = Init:GetSlotById(_SlotId)
    if not slot.isInput_ then
        slot.isInput_ = true
        slot.belongingPlayer_ = _player
    else 
        print("[Error] 操作了已经输入插槽")
    end
    
    -- 挑选当前被影响的计划
    local currentPlan = {}
    for key, plan in pairs(_allPlan) do
        if not plan.isImpossibleAchieve_ then
            -- 除去当前已经不可能的plan
            for key2, slotId in pairs(plan.slotIdTable_) do
                if slotId ==  _SlotId then
                    table.insert(currentPlan,plan)
                    break
                end
            end
        end
    end

    --更新受影响的Plan
    for key, plan in pairs(currentPlan) do
        -- 当计划当前无从属者时
        if not plan.belongingPlayer_ then  
            plan.belongingPlayer_ = _player
            plan.completeValue_ = 1
        -- 计划有从属者且当前更新者相同时
        elseif plan.belongingPlayer_ and plan.belongingPlayer_ == _player then
            plan.completeValue_ = plan.completeValue_ + 1
        -- 计划有从属者但当前更新者不同时
        elseif plan.belongingPlayer_ and plan.belongingPlayer_ ~= _player then
            plan.isImpossibleAchieve_ = true
        end
    end
    print(_player,"piece",tostring(_SlotId))
    
    return M:EndCheck(_allPlan,_chessTable)
end

function M.OnClick1()
    print("1CXlick")
    if not isDone then
        local r = M:PieceAction(1,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end

function M.OnClick2()
    print("2CXlick")
    if not isDone then
        local r = M:PieceAction(2,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end

function M.OnClick3()
    print("3CXlick")
    if not isDone then
        local r = M:PieceAction(3,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end
function M.OnClick4()
    print("4CXlick")
    if not isDone then
        local r = M:PieceAction(4,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end
function M.OnClick5()
    print("5CXlick")
    if not isDone then
        local r = M:PieceAction(5,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end
function M.OnClick6()
    print("6CXlick")
    if not isDone then
        local r = M:PieceAction(6,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end
function M.OnClick7()
    print("7CXlick")
    if not isDone then
        local r = M:PieceAction(7,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end

function M.OnClick8()
    print("8CXlick")
    if not isDone then
        local r = M:PieceAction(8,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end

function M.OnClick9()
    print("9CXlick")
    if not isDone then
        local r = M:PieceAction(9,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
        if r == 0 then
            isDone = true
        elseif r == 1 or r == 2 or r == 3 then
            e = r
        end
    end
end
return M
