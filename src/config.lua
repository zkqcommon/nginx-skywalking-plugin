---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zkq.
--- DateTime: 2019/12/24 12:30 PM
---

local _M = {version = "1.0.0"}

-- 启动时创建一次
_M.agent_uuid = uuid()

-- skywalking服务端连接，按需配置
 _M.collector_server_url = "http://127.0.0.1:12800"
--_M.collector_server_url = "http://naming.sw.res.yqxiu.cn:12801"
-- 配置skywalking识别agent的全局唯一标识
_M.application_code = "nginx-client-pro-1"


-- 以下配置固定，请勿修改
_M.agent_application_registry_uri = "/application/register"
_M.agent_instance_registry_uri = "/instance/register"
_M.instance_heartbeat_uri = "/instance/heartbeat"


-- 从共享内存中获取application_id
_M.get_application_id = function()
 local value = skywalking_dict:get("application_id")

 if value ~= nil then
  return value
 else
  return 0
 end
end

-- 设置application_id到共享内存中
_M.set_application_id = function(value)
 local success, err = skywalking_dict:set("application_id",value)
 if not success then
  ngx.log(ngx.ERR, "failed to set_application_id: "..value, err)
 end
end

-- 从共享内存中获取instance_id
_M.get_instance_id = function()
 local value = skywalking_dict:get("instance_id")

 if value ~= nil then
  return value
 else
  return 0
 end
end

-- 设置instance_id到共享内存中
_M.set_instance_id = function(value)
 local success, err = skywalking_dict:set("instance_id",value)
 if not success then
  ngx.log(ngx.ERR, "failed to set_instance_id: "..value, err)
 end
end

return _M