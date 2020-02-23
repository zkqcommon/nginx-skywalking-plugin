local _M = {}

--- 分割字符串，忽略所有空串
function _M.split(str,delimiter)
    local dLen = string.len(delimiter)
    local newDeli = ''
    for i=1,dLen,1 do
        newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
    end

    local locaStart,locaEnd = string.find(str,newDeli)
    local arr = {}
    local n = 1
    while locaStart ~= nil
    do
        if locaStart>0 then
            local sub = string.sub(str,1,locaStart-1)
            if #sub >0 then
                arr[n] = sub
                n = n + 1
            end
        end

        str = string.sub(str,locaEnd+1,string.len(str))
        locaStart,locaEnd = string.find(str,newDeli)
    end
    if str ~= nil and #str > 0 then
        arr[n] = str
    end
    return arr
end

return _M