    local results={}
    local theKey=ARGV[1]..":"
    local theField=ARGV[2]
    local queryMapKey=theKey.."queryMap"
    local now=ARGV[3]
    local isExists = redis.call("HEXISTS", queryMapKey, theField)
    local queryMapCount = redis.call("HLEN", queryMapKey)
    if isExists == 1 then
        local data = redis.call("HGET", queryMapKey, theField);
        table.insert(results, data)
        table.insert(results, queryMapCount)
        local sep = "|"
        for str in string.gmatch(data, "([^"..sep.."]+)") do
            if redis.call("EXISTS", theKey..str) == 1 then
                table.insert(results, redis.call("GET", theKey..str));
            end
        end
        redis.call("HSET", theKey.."lastUsed", theField, now)
    end
    return results