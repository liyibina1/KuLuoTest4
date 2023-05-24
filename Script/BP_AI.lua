--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AI_C
local M = UnLua.Class()
local Init = require("BP_Initialize")
local MainUi = require("UMG_MainUi")
--- AI难度
local AiCorrect = 2
local AiNormal = 1


function M:Initialize(Initializer)
    --print("-----------90909090---")
end

function M:UserConstructionScript()
    --print("-----------90909090---")
end

--function M:ReceiveBeginPlay()
    --print("模拟下棋开始--------------")
    --MainUi:PieceAction(1,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --M:AiDecisionMaking()
    --MainUi:PieceAction(9,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --M:AiDecisionMaking()
    --MainUi:PieceAction(4,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --M:AiDecisionMaking()
    --MainUi:PieceAction(4,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --M:AiDecisionMaking()
    --MainUi:PieceAction(9,Init:GetAllSlot(),Init:GetPersonName(),Init:GetAllPlan())
    --M:AiDecisionMaking()
--end

 function M:ReceiveEndPlay()
    --print("--------------")
 end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end



-- 根据完成度从plan表获取plan
function M:GetPlanByCompleteValue(_completeValue,_planTable)
    --print("@@",_completeValue,_planTable)
    local planTable = {}
    for key, plan in pairs(_planTable) do
        if plan.completeValue_ == _completeValue then
            table.insert(planTable,plan)
        end
    end
    return planTable
end

--- 在给定计划表内获取最高分的插槽
function M:GetMaxValueSlotId(_planTable)
    local maxValue = 0
    local returnTable = {}
    for key, plan in pairs(_planTable) do
        for key2, slotId in pairs(plan.slotIdTable_) do
            local slot = Init:GetSlotById(slotId)
            if not slot.isInput_ and slot.value_ >= maxValue then
                maxValue = slot.value_
            end
        end
    end

    for key, plan in pairs(_planTable) do
        for key2, slotId in pairs(plan.slotIdTable_) do
            local slot = Init:GetSlotById(slotId)
            --print("11",slot.value_)
            if slot.value_ == maxValue  then
                --print("22",slotId)
                local is = false
                for key3, value3 in pairs(returnTable) do
                    if value3 == slotId then
                        is = true
                    end
                end
                if  not is then
                    table.insert(returnTable,slotId)
                end
            end
        end
    end
    --print(returnTable[1])
    return returnTable      
end

--AI决策 根据完成度确定方案
function M:AiDecisionMaking(_AiDifficulty)
    -- Ai当前最大完成度
    local aiPoint = Init:GetPlayerCompleteValue(Init:GetAiName())
    --print("Ai当前最大完成度",aiPoint)
    -- Ai可选plan
    local aiPlan = Init:GetPlayerPossiblePlan(Init:GetAiName())
    --print(aiPlan,#aiPlan)

    -- 真人玩家当前最大完成度
    local personPoint = Init:GetPlayerCompleteValue(Init:GetPersonName())
    -- 真人玩家可选方案
    local personPlan = Init:GetPlayerPossiblePlan(Init:GetPersonName())


    if _AiDifficulty == AiNormal  then
        --print("000000000000000000000000")
        --- 即将获得胜利的情况
        if aiPoint == 2 then
            print("AI WIN COMING")
            local planTable = M:GetPlanByCompleteValue(aiPoint,aiPlan)
            for key, plan in pairs(planTable) do
                for key2, slotId in pairs(plan.slotIdTable_) do
                    local slot = Init:GetSlotById(slotId)
                    if not slot.isInput_ then
                        MainUi:PieceAction(slotId,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                        return slotId
                    end
                end
            end
        --- 真人玩家即将获得胜利的情况
        elseif personPoint == 2 then
            --- 预测真人玩家下一步
            print("PLAYER WIN COMING")
            local planTable = M:GetPlanByCompleteValue(personPoint,personPlan)
            for key, plan in pairs(planTable) do
                for key2, slotId in pairs(plan.slotIdTable_) do
                    local slot = Init:GetSlotById(slotId)
                    if not slot.isInput_ then
                        MainUi:PieceAction(slotId,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                        return slotId
                    end
                end
            end
        --- 在自己最高完成度的组合中，尽量往价值分最高的槽位走,如果最高分不止1个,则预测真人玩家的下一步，看看是否有封锁匹配，如果没有，随机1个
        else
            local planTable = M:GetPlanByCompleteValue(aiPoint,aiPlan)
            --[[
            for key, value in pairs(planTable) do
                value:PrintParmValue(value)
            end
            --]]
            --print(#planTable)
            local maxSlotIdTable = M:GetMaxValueSlotId(planTable)
            --[[
            for key, value in pairs(maxSlotIdTable) do
                print(key, value)
            end
            --]]
            --print("333",#maxSlotIdTable)
            --print("w",#maxSlotIdTable)
            if #maxSlotIdTable == 1 then
                print("only one")
                MainUi:PieceAction(maxSlotIdTable[1],Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                return maxSlotIdTable[1]
            else
                local personPlanTable = M:GetPlanByCompleteValue(personPoint,personPlan)
                local personMaxSlotIdTable = M:GetMaxValueSlotId(personPlanTable)
                for key, slotId1 in pairs(maxSlotIdTable) do
                    for key2, slotId2 in pairs(personMaxSlotIdTable) do
                        if  slotId1 == slotId2 then
                            MainUi:PieceAction(slotId1,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                            return slotId1
                        end
                    end
                end
                if #maxSlotIdTable >= 1 then
                    local c = maxSlotIdTable[math.random(1,#maxSlotIdTable)]
                    MainUi:PieceAction(c,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return c
                else
                    -- 已成平局
                    for index1, value in ipairs(Init:GetAllSlot()) do
                        for index2, value2 in ipairs(value) do
                            if  not value2.isInput_  then
                                MainUi:PieceAction(value2.id_,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                                return value2.id_
                            end
                        end
                    end
                end
                
            end
        end
    elseif _AiDifficulty == AiCorrect or not _AiDifficulty then
        --- 即将获得胜利的情况
        if aiPoint == 2 then
            print("AI WIN COMING")
            local planTable = M:GetPlanByCompleteValue(aiPoint,aiPlan)
            for key, plan in pairs(planTable) do
                for key2, slotId in pairs(plan.slotIdTable_) do
                    local slot = Init:GetSlotById(slotId)
                    if not slot.isInput_ then
                        MainUi:PieceAction(slotId,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                        return slotId
                    end
                end
            end
        --- 真人玩家即将获得胜利的情况
        elseif personPoint == 2 then
            --- 预测真人玩家下一步
            print("PLAYER WIN COMING")
            local planTable = M:GetPlanByCompleteValue(personPoint,personPlan)
            for key, plan in pairs(planTable) do
                for key2, slotId in pairs(plan.slotIdTable_) do
                    local slot = Init:GetSlotById(slotId)
                    if not slot.isInput_ then
                        MainUi:PieceAction(slotId,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                        return slotId
                    end
                end
            end
        elseif aiPoint == 0 and not Init:GetSlotById(5).isInput_ then
            MainUi:PieceAction(5,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
            return 5

        --- 预判穷举:避免出现真人玩家下一步棋导致2个或以上的plan到达完成度2 槽位重复且可选;若有多个选择，则优先选择提升自己胜利组合里的
        elseif   Init:GetSlotById(5).isInput_ and Init:GetSlotById(5).belongingPlayer_ == Init:GetPersonName() then
            --print("90909909090")
            local PlanNum = 0
            local tablePerson = {}
            local tableAi = {}

            for key, value in pairs(personPlan) do
                for key2, value2 in pairs(value.slotIdTable_) do
                    --print(value2,value.completeValue_)
                end
            end
            
            for key, plan in pairs(personPlan) do
                if plan.completeValue_ >= 1 then
                    PlanNum = PlanNum + 1
                end
            end
            for i = 1, 9, 1 do
                tablePerson[i] = 0
                tableAi[i] = 0
            end
            if PlanNum >= 2 then
                for key, plan in pairs(personPlan) do
                    if plan.completeValue_ ~= 0 then
                        for key,slotId  in pairs(plan.slotIdTable_) do
                            local slot = Init:GetSlotById(slotId)
                            if not slot.isInput_ then
                                tablePerson[slotId] = tablePerson[slotId] + 1
                            end
                        end
                    end
                end

                
                --print("66")
                for i = 1, 9, 1 do
                    --print("pp",i,tablePerson[i])
                end
                -- 完成度即将大于2 的数量
                local num = 0
                local num2 = 0
                local key1 = {}
                local key2 = {}
                for i = 1, 9, 1 do
                    if tablePerson[i] >= 2  then
                        table.insert(key2,i)
                        num = num + 1
                    end
                end

                if num >= 2 then
                    for key, plan in pairs(aiPlan) do
                        if plan.completeValue_ ~= 0 then
                            for key,slotId  in pairs(plan.slotIdTable_) do
                                local slot = Init:GetSlotById(slotId)
                                if not slot.isInput_ then
                                    tableAi[slotId] = tableAi[slotId] + 1
                                end
                            end
                        end
                    end
                    for i = 1, #tableAi, 1 do
                        --print("pp",i,tableAi[i])
                    end

                    for i = 1, 9, 1 do
                        if tableAi[i] >= 1  then
                            table.insert(key1,i)
                            num2 = num2 + 1
                        end
                    end

                    local last = {}
                    for index, value in ipairs(key2) do
                        for index2, value2 in ipairs(key1) do
                            if value == value2 then
                                table.insert(last,value2)
                            end
                        end
                    end

                    local random = math.random(1,#last)
                    local random2 = last[random]
                    --print("pp",random2)
                    --print("敌人站5")
                    MainUi:PieceAction(random2,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return random2
                else
                    local c = {1,3,7,9}
                    local num1 = math.random(1,4)
                    local d = c[num1]
                    MainUi:PieceAction(d,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return d
                end
            end      
        else
            local PlanNum = 0
            local table = {}
           
            for key, value in pairs(personPlan) do
                for key2, value2 in pairs(value.slotIdTable_) do
                    print(value2,value.completeValue_)
                end
            end
            
            for key, plan in pairs(personPlan) do
                if plan.completeValue_ >= 1 then
                    PlanNum = PlanNum + 1
                end
            end
            for i = 1, 9, 1 do
                table[i] = 0
            end
            if PlanNum >= 2 then
                for key, plan in pairs(personPlan) do
                    if plan.completeValue_ ~= 0 then
                        for key,slotId  in pairs(plan.slotIdTable_) do
                            local slot = Init:GetSlotById(slotId)
                            if not slot.isInput_ then
                                table[slotId] = table[slotId] + 1
                            end
                        end
                    end
                end
                --print("66")
                for i = 1, 9, 1 do
                    --print(i,table[i])
                end
                -- 完成度即将大于2 的数量
                local num = 0
                local key1 = 0
                local key2 = 0
                for i = 1, 9, 1 do
                    if table[i] >= 2  then
                        num = num + 1
                        key2 = i
                    elseif table[i] == 1 then
                        key1 = i
                    end
                end
                
                if num >= 2   then
                    print("predict Piece,1")
                    MainUi:PieceAction(key1,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return key1
                elseif num == 1 then
                    print("predict Piece,2")
                    MainUi:PieceAction(key2,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return key2
                else
                    print("other options")
                end
            else
                local c = {1,3,7,9}
                local num = math.random(1,4)
                local d = c[num]
                MainUi:PieceAction(d,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                return d
            end
            
            local planTable = M:GetPlanByCompleteValue(aiPoint,aiPlan)
            local maxSlotIdTable = M:GetMaxValueSlotId(planTable)
            if #maxSlotIdTable == 1 then
                print("only one")
                MainUi:PieceAction(maxSlotIdTable[1],Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                return maxSlotIdTable[1]
            else
                local personPlanTable = M:GetPlanByCompleteValue(personPoint,personPlan)
                local personMaxSlotIdTable = M:GetMaxValueSlotId(personPlanTable)
                for key, slotId1 in pairs(maxSlotIdTable) do
                    for key2, slotId2 in pairs(personMaxSlotIdTable) do
                        if  slotId1 == slotId2 then
                            MainUi:PieceAction(slotId1,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                            return slotId1
                        end
                    end
                end
                if #maxSlotIdTable >= 1 then
                    local c = maxSlotIdTable[math.random(1,#maxSlotIdTable)]
                    MainUi:PieceAction(c,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                    return c
                else
                    -- 已成平局
                    for index1, value in ipairs(Init:GetAllSlot()) do
                        for index2, value2 in ipairs(value) do
                            if  not value2.isInput_  then
                                MainUi:PieceAction(value2.id_,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
                                return value2.id_
                            end
                        end
                    end
                end
            end

        end
        
        local c = {}
        for key, value in pairs(Init:GetAllSlot()) do
            for key2, value2 in pairs(value) do
                if  not value2.isInput_ then
                    table.insert(c,value2.id_)
                end
            end
        end
        local num = math.random(1,#c)
        local d = c[num]
        MainUi:PieceAction(d,Init:GetAllSlot(),Init:GetAiName(),Init:GetAllPlan())
        return d
    end
end
return M
