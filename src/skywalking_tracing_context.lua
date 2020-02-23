local _M = {}

--TODO 模拟值，正常应该通过application_code从服务端换取

-- id生成器
-- 参考官方协议及sw java agent实现：org.apache.skywalking.apm.agent.core.context.ids.ID
_M.global_id_generator = {}
_M.global_id_generator.generate = function()
    if skywalking_config.get_instance_id() == 0 then
        ngx.log(ngx.ERR, "skywalking instance_id未同步，链路id生成失败.")
        return ""
    end

    ngx.update_time()
    local r1= math.random(1,10000) --产生1到100之间的随机数
    local r2 = math.random(1,10000) --产生1到100之间的随机数
    local r3 = math.random(0,9) --产生0到9之间的随机数

    local part1 = skywalking_config.get_instance_id() * 100000 + r1
    local part2 = r2
    local part3 = ngx.now() * 1000 * 10+ r3

    local trace_id = part1.."."..part2.."."..part3

    return trace_id
end

_M.related_global_trace_id = ""
_M.trace_segment_id = ""


function _M:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return _M;