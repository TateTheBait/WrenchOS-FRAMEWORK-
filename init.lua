local wrenchos = exports["WrenchOS"]

WrenchOS = setmetatable({}, {
    __index = function(self, index)
        -- Capture the function from wrenchos first
        local originalFunction = wrenchos[index]
        
        -- Define the wrapper function
        self[index] = function(_, ...)
            return originalFunction(nil, ...)
        end

        return self[index]
    end
})
