local wrenchos = exports["WrenchOS"]

WrenchOS = setmetatable({}, {
    __index = function(self, index)
        self[index] = function(_, ...)
            print(...)
            return wrenchos[index](nil, ...)
        end

        return self[index]
    end
})