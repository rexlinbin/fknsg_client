-- Filename: GuildSkillAdminCell.lua
-- Author: lgx
-- Date: 2016-03-08
-- Purpose: 军团科技管理Cell

module("GuildSkillAdminCell", package.seeall)

require "script/ui/guild/guildskill/GuildSkillController"

--[[
	@desc:	创建军团科技TableView Cell
	@param: pData 科技数据
--]]
function createCell( pData )
    local cell = CCTableViewCell:create()

    -- Cell背景
    local fullRect = CCRectMake(0,0,116,157)
    local insetRect = CCRectMake(50,43,16,6)
    local cellBg = CCScale9Sprite:create("images/everyday/cell_bg.png",fullRect, insetRect)
    cellBg:setContentSize(CCSizeMake(590,180))
    cellBg:setAnchorPoint(ccp(0,0))
    cellBg:setPosition(ccp(0,0))
    cell:addChild(cellBg)

    -- 名称背景
    local fullRect = CCRectMake(0,0,31,41)
    local insetRect = CCRectMake(8,17,2,2)
    local nameBg = CCScale9Sprite:create("images/common/b_name_bg.png", fullRect, insetRect)
    nameBg:setContentSize(CCSizeMake(268,44))
    nameBg:setAnchorPoint(ccp(0,1))
    nameBg:setPosition(ccp(0,cellBg:getContentSize().height))
    cellBg:addChild(nameBg)

    -- 名称
    local nameLabel = CCRenderLabel:create("" .. pData.name , g_sFontPangWa, 24, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    nameLabel:setColor(ccc3(0xff, 0xe4, 0x00))

    -- 等级
    local curLevel = GuildDataCache.getGuildGroupSkillLv(pData.id)
    local maxLevel = GuildSkillData.getMaxGuildSkillLevel(pData.id)
    local upgradeItemStr  = "lgx_1011"
    local curAttrStr = GetLocalizeStringBy("lgx_1015")
    local nextAttrStr = GetLocalizeStringBy("lgx_1017")
    local costStr = GetLocalizeStringBy("lgx_1017")

    local curAttrNum = GuildSkillData.getAttrNumBySkillId(pData.id,curLevel)
    local nextAttrNum = GuildSkillData.getAttrNumBySkillId(pData.id,curLevel+1)
    local costTab = string.split(GuildSkillData.getUpgradeCostGuildExp(pData.id,curLevel+1), "|")
   	local costNum = tonumber(costTab[#costTab])

    if (curLevel <= 0) then
        -- 未研发
        upgradeItemStr  = "lgx_1010"
	    nextAttrStr = string.format(pData.des," +"..nextAttrNum)
    	costStr = costNum..GetLocalizeStringBy("key_1592")
    elseif (curLevel >= maxLevel) then
        -- 已升满
	    curAttrStr = string.format(pData.des," +"..curAttrNum)
    else
        -- 升级中
	    curAttrStr = string.format(pData.des," +"..curAttrNum)
        nextAttrStr = string.format(pData.des," +"..nextAttrNum)
        costStr = costNum..GetLocalizeStringBy("key_1592")
    end

    local lvLabel = CCRenderLabel:create("（" .. curLevel.."/"..maxLevel.."）" , g_sFontPangWa, 24, 1, ccc3(0x00, 0x00, 0x00), type_stroke)
    lvLabel:setColor(ccc3(0xff, 0xe4, 0x00))

    local nVlabel = BaseUI.createHorizontalNode({nameLabel, lvLabel})
    nVlabel:setAnchorPoint(ccp(0, 0.5))
    nVlabel:setPosition(ccp(30,nameBg:getContentSize().height*0.5))
    nameBg:addChild(nVlabel,2)

    -- 属性描述背景
    local textBg = CCScale9Sprite:create("images/copy/fort/textbg.png")
    textBg:setContentSize(CCSizeMake(405,112))
    textBg:setAnchorPoint(ccp(0,0))
    textBg:setPosition(ccp(32,22))
    cellBg:addChild(textBg,1,1)

    -- 图标
    local iconSprite = CCSprite:create("images/item/bg/itembg_4.png")
    iconSprite:setAnchorPoint(ccp(0,0.5))
    iconSprite:setPosition(ccp(10,textBg:getContentSize().height*0.5))
    textBg:addChild(iconSprite)

    local iconPath = "images/athena/skill_icon/"..pData.icon
	local skillIcon = CCSprite:create(iconPath)
	skillIcon:setAnchorPoint(ccp(0.5,0.5))
	skillIcon:setPosition(ccp(iconSprite:getContentSize().width*0.5,iconSprite:getContentSize().height*0.5))
	iconSprite:addChild(skillIcon)

    -- 属性描述
    local curAttrLabel = CCRenderLabel:create(GetLocalizeStringBy("lic_1515") , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    curAttrLabel:setColor(ccc3(0xff,0xe4,0x00))
    curAttrLabel:setPosition(114,75)
    curAttrLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(curAttrLabel)

    local curAttrDesLabel = CCRenderLabel:create(curAttrStr , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    curAttrDesLabel:setColor(ccc3(0xff,0xff,0xff))
    curAttrDesLabel:setPosition(ccp(curAttrLabel:getPositionX()+curAttrLabel:getContentSize().width,curAttrLabel:getPositionY()))
    curAttrDesLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(curAttrDesLabel)

    local nextAttrLabel = CCRenderLabel:create(GetLocalizeStringBy("zzh_1306") , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    nextAttrLabel:setColor(ccc3(0xff,0xe4,0x00))
    nextAttrLabel:setPosition(114,45)
    nextAttrLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(nextAttrLabel)

    local nextAttrDesLabel = CCRenderLabel:create(nextAttrStr , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    nextAttrDesLabel:setColor(ccc3(0xff,0xff,0xff))
    nextAttrDesLabel:setPosition(ccp(nextAttrLabel:getPositionX()+nextAttrLabel:getContentSize().width,nextAttrLabel:getPositionY()))
    nextAttrDesLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(nextAttrDesLabel)

    -- 消耗资源
    local costLabel = CCRenderLabel:create(GetLocalizeStringBy("key_2794") , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    costLabel:setColor(ccc3(0xff,0xe4,0x00))
    costLabel:setPosition(114,15)
    costLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(costLabel)

    local costNumLabel = CCRenderLabel:create(costStr , g_sFontName,18,1, ccc3(0x00,0x00,0x00), type_stroke)
    costNumLabel:setColor(ccc3(0xff,0xff,0xff))
    costNumLabel:setPosition(ccp(costLabel:getPositionX()+costLabel:getContentSize().width,costLabel:getPositionY()))
    costNumLabel:setAnchorPoint(ccp(0,0))
    textBg:addChild(costNumLabel)

    -- 研发/提升按钮
    local upgradeMenu = CCMenu:create()
    upgradeMenu:setPosition(ccp(0,0))
    upgradeMenu:setTouchPriority(-866)
    cellBg:addChild(upgradeMenu,2,2)

    local upgradeItem = CCMenuItemImage:create("images/common/btn/btn_blue_n.png","images/common/btn/btn_blue_h.png")
    upgradeItem:setAnchorPoint(ccp(0.5,0.5))
    upgradeItem:setPosition(cellBg:getContentSize().width-80,80)
    upgradeItem:registerScriptTapHandler(upgradeSkillCallback)
    upgradeMenu:addChild(upgradeItem,1,tonumber(pData.id))

    local upgradeLab = CCRenderLabel:create(GetLocalizeStringBy(upgradeItemStr) , g_sFontPangWa, 30, 1, ccc3( 0x00, 0x00, 0x00), type_stroke)
    upgradeLab:setColor(ccc3(0xfe, 0xdb, 0x1c))
    upgradeLab:setAnchorPoint(ccp(0.5,0.5))
    upgradeLab:setPosition(ccp(upgradeItem:getContentSize().width*0.5,upgradeItem:getContentSize().height*0.5))
    upgradeItem:addChild(upgradeLab)

    return cell
end

--[[
	@desc:	研发/提升按钮回调
	@param:	pTag 按钮tag值
	@param:	pItem 按钮本身
--]]
function upgradeSkillCallback( pTag , pItem )
	AudioUtil.playEffect("audio/effect/zhujiemian.mp3")
    print("skillId:"..pTag.." skillType:"..2)
    GuildSkillController.promoteByAdmin(pTag)
end