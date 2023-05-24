--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Slot_C
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


    ---@ 槽位 对象
    --local Slot = {}
    ---@param _id integer 
    ---@param _positionX integer
    ---@param _positionY integer
    ---@return table
    function M:New(o,_id,_positionX,_positionY)

        o = o or {}
        setmetatable(o,self)
        -- 位置代号
        self.id_ = _id
        -- 横坐标
        self.positionX_ = _positionX
        -- 纵坐标
        self.positionY_ = _positionY
        -- 是否已经被占用
        self.isInput_ = false
        -- 如果被占用，是哪个玩家 
        self.belongingPlayer_ = nil
        -- 价值分
        self.value_ = 0
        return o
    end

    -- 打印对象字段的值
    function M:PrintParmValue()
        print("id:"..tostring(self.id_),"||X:"..tostring(self.positionX_),"||Y:"..tostring(self.positionY_),"||isInput:"..tostring(self.isInput_),"||player:"..tostring(self.belongingPlayer_),"||value:"..tostring(self.value_))
    end

return M
