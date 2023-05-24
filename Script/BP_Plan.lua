--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Plan_C
local M = UnLua.Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

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

    -- 可选落子方案
    --local M = {}
    ---@param _slotIdTable table 
    ---@return table
    function M:New(o,_slotIdTable)
        o = o or {}
        setmetatable(o,self)
        -- 槽位ID列表
        self.slotIdTable_ = _slotIdTable
        -- 完成度
        self.completeValue_ = 0
        -- 是否已经不可能达成
        self.isImpossibleAchieve_ = false
        -- 所属玩家
        self.belongingPlayer_ = nil
    
        return o
    end

    function M:PrintParmValue()
        local slotIdString = ""
        for key, slotId in pairs(self.slotIdTable_) do
            slotIdString = slotIdString..","..tostring(slotId)
        end
        print("SlotIDTable:"..slotIdString,"||CompleteValue:"..tostring(self.completeValue_),"||isImpossibleAchieve:"..tostring(self.isImpossibleAchieve_),"||player:"..tostring(self.belongingPlayer_))
    end


    ---插槽是否在方案内
    ---@param _SlotId integer
    ---@return boolean
    function M:IsSlotIdInPlan(_SlotId)
        for key, value in pairs(self.slotIdTable_) do
            if _SlotId == value then
                return true
            else
                return false
            end
        end
    end
return M
