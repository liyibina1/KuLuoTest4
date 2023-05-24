--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Initialize_C
local M = UnLua.Class()

local Slot = require("BP_Slot")
local Plan = require("BP_Plan")

--local Ai = require("BP_AI")
--local MainUi = require("UMG_MainUi")
--- 全局棋盘信息
local allSlot = {}
--- 可能的胜利组合
local allPlan = {}

--- 真人玩家名
local PersonPlayerName = "player"
--- AI
local AiPlayerName = "AI"


function M:Initialize(Initializer)
    --print("hello world","22222")
end

--function M:UserConstructionScript()
    
    
--end

 function M:ReceiveBeginPlay()
    allSlot = M:ChessInitialize()
    allPlan = M:PlanInitialize(allSlot)
    print("---")

    for key, value in pairs(allSlot) do
        for key2, value2 in pairs(value) do
            value2:PrintParmValue()
        end
    end


    for key, value in pairs(allPlan) do
        value:PrintParmValue()
    end

    print("井字棋初始化结束")
 
 end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end


function M:GetAllSlot()
    return allSlot
end

function M:GetAllPlan()
    return allPlan
end

function M:GetAiName()
    return AiPlayerName
end

function M:GetPersonName()
    return PersonPlayerName
end


-- 通过id拿槽位
---@param _SlotId integer
function M:GetSlotById(_SlotId)
    for key, value in pairs(allSlot) do
        for key2, value2 in pairs(value) do
            if value2.id_ == _SlotId then
                print(value2.id_)
                value2:PrintParmValue()
                return value2
            end
        end
    end
end


-- 棋盘信息初始化
function M:ChessInitialize()
    local count = 1
    local chess = {}
    for i = 1, 3, 1 do
        chess[i] = {}
        for j = 1, 3, 1 do
            chess[i][j] = Slot:New(nil,count,i,j)
            --print(i,j)
            --print(count)
            chess[i][j]:PrintParmValue()
            count = count + 1
        end
    end
    return chess
end

-- 获取所有可能的胜利组合
---@param _chess table 
---@return table
function M:PlanInitialize(_chess)
    local all = {}

    -- 横向遍历
    for i = 1, 3, 1 do
        local a = {}
        for j = 1, 3, 1 do
            table.insert(a,_chess[i][j].id_)
            
        end
        local t = Plan:New(nil,a)
        t:PrintParmValue()
        table.insert(all,t)
        
    end

    -- 纵向遍历
    for i = 1, 3, 1 do
        local a = {}
        for j = 1, 3, 1 do
            table.insert(a,_chess[j][i].id_)
        end
        local t = Plan:New(nil,a)
        t:PrintParmValue()
        table.insert(all,t)
    end

    -- 斜向
    local t1 = Plan:New(nil,{_chess[1][1].id_,_chess[2][2].id_,_chess[3][3].id_})
    t1:PrintParmValue()
    local t2 = Plan:New(nil,{_chess[3][1].id_,_chess[2][2].id_,_chess[1][3].id_})
    t2:PrintParmValue()
    table.insert(all,t1)
    table.insert(all,t2)

    -- 价值分赋予
    for key, plan in pairs(all) do
        for key2, slotId in pairs(plan.slotIdTable_) do
            local slot = M:GetSlotById(slotId,_chess)
            slot.value_ = slot.value_ + 1
        end
    end

    return all
end

-- 获取最大完成度
function M:GetPlayerCompleteValue(_player)
    local max = 0
    -- 获取可选的方案
    for key, plan in pairs(allPlan) do
        if not plan.isImpossibleAchieve_  then
            if not plan.belongingPlayer_ or plan.belongingPlayer_ == _player then
                if plan.completeValue_ >= max then
                    max = plan.completeValue_
                end
            end
        end
    end
    return max
end

-- 获取指定玩家可选方案
function M:GetPlayerPossiblePlan(_player)
    -- 获取可选的方案
    local currentPlan = {}
    for key, plan in pairs(allPlan) do
        if not plan.isImpossibleAchieve_  then
            if plan.belongingPlayer_ == _player or not plan.belongingPlayer_  then
                table.insert(currentPlan,plan)
            end
        end
    end
    return currentPlan
end

return M
