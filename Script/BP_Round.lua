--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Round_C
local M = UnLua.Class()

local MainUi = require("UMG_MainUi")
local Ai = require("BP_AI")
local Init = require("BP_Initialize")


local round = ""
local roundNum = 0
local currentDiffcult = 2
local isPlayerFirst = true
-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

--function M:ReceiveBeginPlay()
    --print("模拟下棋开始--------------")
    --print("2222")
    
    --MainUi:PieceAction(1,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --
    --MainUi:PieceAction(9,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --Ai:AiDecisionMaking(currentDiffcult)
    --MainUi:PieceAction(4,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --Ai:AiDecisionMaking(currentDiffcult)
    
--end

-- function M:ReceiveEndPlay()
-- end

function M:ReceiveTick(DeltaSeconds)
    --print("tick")
    if MainUi:GetIsDone() then
        local slotid = Ai:AiDecisionMaking(currentDiffcult)
        if slotid == 1 then
            self:UIReact_1()
        elseif slotid == 2 then 
            self:UIReact_2()
        elseif slotid == 3 then 
            self:UIReact_3()
        elseif slotid == 4 then 
            self:UIReact_4()
        elseif slotid == 5 then 
            self:UIReact_5()
        elseif slotid == 6 then 
            self:UIReact_6()
        elseif slotid == 7 then 
            self:UIReact_7()
        elseif slotid == 8 then 
            self:UIReact_8()
        elseif slotid == 9 then 
            self:UIReact_9()
        end
        MainUi:SetIsDone(false)

    end
    if MainUi:GetE() == 1 then
        self:Drawing()
    elseif MainUi:GetE() == 2 then
        self:AIWin()
    elseif MainUi:GetE() == 3 then
        self:PlayerWin()
    end
end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

return M
