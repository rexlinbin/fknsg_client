module("config", package.seeall)
loginInfoTable = {}
function getFlag( ... )
	return "gamesky"
end


function getPidUrl( sessionid )
	local url = Platform.getDomain() .. "phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .."?sid=" .. Platform.sdkLoginInfo.sid .. "&comefrom=" .. Platform.sdkLoginInfo.comefrom .. Platform.getUrlParam() .."&bind=" .. g_dev_udid
 	return postString
end 

function getAppId( ... )
	return "fknsg001"
end

function getAppKey( ... )
	return "MzMyQzFBMDBBNEE1NEVBNkZEQ0JEN0M4NkMxRTc5MEE="
end

function getName( ... )
	return "游戏天空"
end
function  getInitParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(getAppId()),"appId")
	dict:setObject(CCString:create(getAppKey()),"appKey")
	return dict
end

function getPayParam( coins )
	local dict = CCDictionary:create()
	local groupid = CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")
	dict:setObject(CCString:create(coins),"coins")
	dict:setObject(CCString:create(BTUtil:getSvrTimeInterval()),"serverTime")
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	dict:setObject(CCString:create(Platform.getPid()),"pid")

	if(Platform.isDebug()) then
		dict:setObject(CCString:create("http://124.205.151.82/phone/exchange?"..Platform.getUrlParam2()),"resulturl") 
	else
		dict:setObject(CCString:create(Platform.getDomain() .. "phone/exchange?"..Platform.getUrlParam2()),"resulturl") 
	end

	return dict
end

function getUserInfoParam(gameState)
	require "script/model/user/UserModel"
    require "script/ui/login/ServerList"
    local dict = CCDictionary:create()
    dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
    dict:setObject(CCString:create(ServerList.getSelectServerInfo().name),"groupName")
    dict:setObject(CCString:create(loginInfoTable.newuser),"newuser")
    if(tonumber(gameState) == 1)then
	    -- 下面的appUid和appUname暂时获取不到，先不用
	    dict:setObject(CCString:create(UserModel.getUserUid()),"appUid")
	    dict:setObject(CCString:create(UserModel.getUserName()),"appUname")
	    dict:setObject(CCString:create(UserModel.getUserUtid()),"appUtid")
	    dict:setObject(CCString:create(UserModel.getHeroLevel()),"appUlevel")
	end

	return dict
end

function setLoginInfo( xmlTable )
	loginInfoTable.uid = xmlTable:find("uid")[1]
	loginInfoTable.newuser = xmlTable:find("newuser")[1]
end

function getGroupParam( ... )
	local dict = CCDictionary:create()
	dict:setObject(CCString:create(CCUserDefault:sharedUserDefault():getStringForKey("lastLoginGroup")),"groupId")
	return dict
end

--debug conifg
function getServerListUrl_debug( ... )
 	return "http://124.205.151.82/phone/serverlistnotice/?".. Platform.getUrlParam()
end 

function getPidUrl_debug( sessionid )
	local url = "http://124.205.151.82/phone/login/"
 	if(sessionid == nil)then
        sessionid = Platform.getSdk():callStringFuncWithParam("getSessionId",nil)
    end
	local postString = url .."?sid=" .. Platform.sdkLoginInfo.sid .. "&comefrom=" .. Platform.sdkLoginInfo.comefrom .. Platform.getUrlParam() .."&bind=" .. g_dev_udid
 	return postString
end 

function getAppId_debug( ... )
	return getAppId()
end

function getAppKey_debug( ... )
	return getAppKey()
end