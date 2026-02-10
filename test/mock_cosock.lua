local mock_cosock = {}

mock_cosock.socket = {
    tcp = function()
        return {
            settimeout = function() end
        }
    end,
    sleep = function() end
}

mock_cosock.http = {
    request = function(req)
        -- To be overridden in tests
        return nil, 500
    end
}

mock_cosock.asyncify = function(lib)
    if lib == 'socket.http' then
        return mock_cosock.http
    end
    return lib
end

return mock_cosock
