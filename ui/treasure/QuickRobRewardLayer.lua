-- Filename: QuickRobRewardLayer.lua
-- Author: DJN
-- Date: 2014-7-18
-- Purpose: 该文件用于: 连续夺宝后抽奖的奖励展示

module ("QuickRobRewardLayer", package.seeall)
require "script/audio/AudioUtil"
require "script/ui/treasure/QuickRobData"

require "script/model/user/UserModel"
require "script/ui/item/ItemSprite"
require "script/ui/item/ItemUtil"
require "script/ui/hero/HeroPublicLua"
require "script/ui/hero/HeroPublicCC"

require "script/ui/item/ReceiveReward"


local _bgLayer       --灰色背景屏蔽层
local _touchPriority --触摸优先级
local _ZOrder        --Z轴值
local layer_zOrder   --icon的Z轴值
local m_QuickRobInfo --奖励数据
----------------------------------------初始化函数
local function init()
    _bgLayer       = nil
    _touchPriority = nil
    _ZOrder        = nil
    layer_zOrder = _ZOrder or 2100
    m_QuickRobInfo = nil
end
----------------------------------------触摸事件函数
function onTouchesHandler(eventType,x,y)
    if eventType == "began" then
        print("onTouchesHandler,began")
        return true
    elseif eventType == "moved" then
        print("onTouchesHandler,moved")
    else
        print("onTouchesHandler,else")
    end
end

local function onNodeEvent(event)
    if event == "enter" then
        _bgLayer:registerScriptTouchHandler(onTouchesHandler,false,_touchPriority,true)
        _bgLayer:setTouchEnabled(true)
    elseif event == "exit" then
        _bgLayer:unregisterScriptTouchHandler()
    end
end

----------------------------------------关闭页面回调
function closeCb()
    AudioUtil.playEffect("audio/effect/guanbi.mp3")
    --QuickRobData.UpdateSilverInCard(m_QuickRobInfo.ret)
    if(m_QuickRobInfo.ret.reward.fragNum)then
        require "script/ui/treasure/TreasureMainView"
        local treasureLayer = TreasureMainView.create()
        MainScene.changeLayer(treasureLayer,"TreasureMainView")
        TreasureMainView.updateLabel()
    else

    --RobTreasureView.createTopUI()
    end
     --刷新一下金币银币数量
    require "script/ui/treasure/RobTreasureView"
    RobTreasureView.refreshTopUi()
    _bgLayer:removeFromParentAndCleanup(true)
    _bgLayer = nil
   

end

----------------------------------------UI函数
--[[
    @des    :创建展示背景
    @param  :
    @return :
--]]
local function createBgUI()
    require "script/ui/main/MainScene"
    local bgSize = CCSizeMake(566,568)
    local bgScale = MainScene.elementScale
    
    --主黄色背景
    bgSprite = CCScale9Sprite:create("images/common/viewbg1.png")
    bgSprite:setContentSize(CCSizeMake(bgSize.width,bgSize.height))
    bgSprite:setAnchorPoint(ccp(0.5,0.5))
    bgSprite:setPosition(_bgLayer:getContentSize().width*0.5,_bgLayer:getContentSize().height*0.5)
    bgSprite:setScale(bgScale)
    _bgLayer:addChild(bgSprite)
    
    -- 顶部标题
    local titleBg= CCSprite:create("images/common/viewtitle1.png")
    titleBg:setPosition(ccp(bgSprite:getContentSize().width*0.5, bgSprite:getContentSize().height))
    titleBg:setAnchorPoint(ccp(0.5, 0.5))
    bgSprite:addChild(titleBg)

    --标题文本
    local labelTitle = CCLabelTTF:create(GetLocalizeStringBy("djn_6"), g_sFontPangWa,33)
    labelTitle:setColor(ccc3(0xff,0xe4,0x00))
    labelTitle:setAnchorPoint(ccp(0.5,0.5))
    labelTitle:setPosition(ccp(titleBg:getContentSize().width*0.5,titleBg:getContentSize().height*0.5))
    titleBg:addChild(labelTitle)

    --"恭喜主公获得"的底
    local str_line = CCScale9Sprite:create("images/common/line2.png")
    str_line:setContentSize(CCSizeMake(293,36))
    str_line:setAnchorPoint(ccp(0.5,0.5))
    str_line:setPosition(bgSprite:getContentSize().width*0.5,495)
    bgSprite:addChild(str_line)
    --“恭喜主公获得”的字
    local str = CCRenderLabel:create(GetLocalizeStringBy("key_1682"),g_sFontPangWa , 23, 1 ,ccc3(0x00,0x00,0x00), type_stroke)
    str:setAnchorPoint(ccp(0.5,0.5))
    str:setColor(ccc3(0xff,0xf6,0x00))
    str:setPosition(str_line:getContentSize().width*0.5,str_line:getContentSize().height*0.5)
    str_line:addChild(str)


    
    local bgMenu = CCMenu:create()
    bgMenu:setPosition(ccp(0,0))
    bgMenu:setTouchPriority(_touchPriority-1)
    bgSprite:addChild(bgMenu)
    -- 关闭按钮
    local closeBtn = CCMenuItemImage:create("images/common/btn_close_n.png", "images/common/btn_close_h.png")
    closeBtn:setPosition(ccp(bgSize.width*1.03,bgSize.height*1.03))
    closeBtn:setAnchorPoint(ccp(1,1))
    closeBtn:registerScriptTapHandler(closeCb)
    bgMenu:addChild(closeBtn)
    -- 确定按钮
    local confirmBtn = LuaCC.create9ScaleMenuItem("images/common/btn/btn1_d.png","images/common/btn/btn1_n.png",CCSizeMake(190, 73),GetLocalizeStringBy("key_1465"),ccc3(0xfe, 0xdb, 0x1c),30,g_sFontPangWa,1, ccc3(0x00, 0x00, 0x00))
    confirmBtn:setAnchorPoint(ccp(0.5,0))
    confirmBtn:setPosition(ccp(bgSprite:getContentSize().width*0.5,37))
    confirmBtn:registerScriptTapHandler(closeCb)
    bgMenu:addChild(confirmBtn)

end

----------------------------------------创建奖励的TableView函数
--[[
    @des    :
    @param  :
    @return :
--]]

function loadTableView (...)
    m_QuickRobInfo = QuickRobData.getQuickRobData() or {}
    local allReward = m_QuickRobInfo.ret.card
  
    local array_list = getReward(allReward)
    
    local full_rect = CCRectMake(0,0,75, 75)
    local inset_rect = CCRectMake(30,30,15,15)
    local table_view_bg = CCScale9Sprite:create("images/common/bg/bg_ng_attr.png", full_rect, inset_rect)
    table_view_bg:setPreferredSize(CCSizeMake(510, 330))
    table_view_bg:setAnchorPoint(ccp(0.5, 0))
    table_view_bg:setPosition(ccp(bgSprite:getContentSize().width * 0.5, 120))
    bgSprite:addChild(table_view_bg)
    
    local cell_icon_count = 4 
    local height = 298
    local cell_size = CCSizeMake(489, 150)
    local items = getValues(array_list)
    local h = LuaEventHandler:create(function(function_name, table_t, a1, cell)
        if function_name == "cellSize" then
            return cell_size
        elseif function_name == "cellAtIndex" then
            cell = CCTableViewCell:create()
            local start = a1 * cell_icon_count
            for i=1, 4 do
                local index = start + i
                if(index>cell_icon_count)then
                   line_num = math.ceil((index - cell_icon_count)/cell_icon_count)
                   height = height - 150 * line_num
                end  
                if index <= #items then
                    local iconSprite = ItemUtil.createGoodsIcon(items[index])
                    iconSprite:setAnchorPoint(ccp(0.5, 0.5))
                    iconSprite:setPosition(ccp(cell_size.width/cell_icon_count /2 + (i-1) * cell_size.width/cell_icon_count, cell_size.height * 0.5))
                    cell:addChild(iconSprite)
                    
                end
            end
            return cell
        elseif function_name == "numberOfCells" then
            local count = #items
            return math.ceil(count / cell_icon_count )
        elseif function_name == "cellTouched" then
        elseif (function_name == "scroll") then
        end
    end)
    local item_table_view = LuaTableView:createWithHandler(h, CCSizeMake(500, 305))
    item_table_view:ignoreAnchorPointForPosition(false)
    item_table_view:setAnchorPoint(ccp(0.5, 0))
    item_table_view:setBounceable(true)
    item_table_view:setPosition(ccp(table_view_bg:getContentSize().width * 0.5, 15 ))
    item_table_view:setVerticalFillOrder(kCCTableViewFillTopDown)
    item_table_view:setTouchPriority(_touchPriority - 2)
    table_view_bg:addChild(item_table_view)
    
    return table_view_bg
end
----------------------------------------将数次抽奖的奖励进行加和函数
--[[
    @des    :奖励数据
    @param  :
    @return :
--]]
function getReward(card)
    local array_list = {} --存放奖励
    
    for i=1,#card do

        local array_info = {}
        array_info.rob = card[i].rob
        array_info.silver = card[i].silver
        array_info.gold = card[i].gold
        array_info.soul = card[i].soul
        array_info.item = card[i].item
        array_info.hero = card[i].hero
        array_info.treasFrag = card[i].treasFrag


        for k,v in pairs(array_info) do
            --rob为抢夺的银币，算到银币中
            if(k == "rob") then 
            k = "silver"
            end
            --因为封装的方法里面没有碎片这个type，碎片用物品的接口来展示
            if(k == "treasFrag") then 
            k = "item"
            end
            local key = nil
            local item = v
            local tid = nil
            if (type(v)== "table") then
                key = string.format("%s,%s", k, item.id)
                tid = item.id
            else
                key = string.format("%s,%s",k,k)
                tid = key
            end
            local array_item = array_list[key]
            if(array_item == nil)then
                
                local num = item.num
                --银币、金币等情况，原表中没有num域
                if(num == nil)then
                    num = item
                end

                 array_item = {}
                 array_item.type = k 
                 array_item.tid = tid
                 array_item.num = num
                 array_list[key] = array_item
            else
                local num = item.num
                if(num == nil)then
                    num = item
                end
                array_item.num = tonumber(array_item.num) + tonumber(num)
                array_item.num = tostring(array_item.num)

            end

        end
    end
    return array_list
end

----------------------------------------入口函数
--[[
    @des    :
    @param  :
    @return :
--]]
function showLayer(p_touchPriority,p_ZOrder)
     init()

        _touchPriority = p_touchPriority or -550
        _ZOrder = p_ZOrder or 999

        _bgLayer = CCLayerColor:create(ccc4(0,0,0,155))
        _bgLayer:registerScriptHandler(onNodeEvent)
        local curScene = CCDirector:sharedDirector():getRunningScene()
        curScene:addChild(_bgLayer,_ZOrder)
        
        createBgUI()
        loadTableView()
    
    return _bgLayer

end






