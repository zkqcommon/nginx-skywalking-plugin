---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zkq.
--- DateTime: 2019/12/24 12:32 PM
---
--package.cpath = package.cpath .. ';/Users/zkq/Library/Application Support/IntelliJIdea2018.2/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9966)
--dbg.waitIDE()
--dbg.breakHere()

uuid = require 'skywalking5.resty.jit-uuid'
uuid.seed()

local config = require "skywalking5.test"

-- 注册application id和instance id
if 0 == ngx.worker.id() then
    config.data = 120
end
print("ngx.worker.id()------>"..ngx.worker.id().."    ========>"..tostring(config).."   "..config.data)