require "tinyclass"

Node = Class(function(self, data)
    self.data = data
    self.prev = nil
    self.next = nil
end)

List = Class(function(self, fn)
    self.head = nil
    self.tail = nil
    self.length = 0
    self.fn = fn
end)

function List:Insert(node)
    if self.length == 0 then
        self.head = node
        self.tail = node
    else
        local iter = self:Iterator()
        while iter.next() do
            local currentNode = iter.current
            if self.fn(currentNode, node) then
                if currentNode == self.tail then
                    currentNode.next = node
                    node.prev = currentNode
                    self.tail = node
                    break
                end
            else
                if currentNode == self.head then
                    node.next = currentNode
                    currentNode.prev = node
                    self.head = node
                else
                    local prevNode = currentNode.prev
                    prevNode.next = node
                    node.next = currentNode
                    currentNode.prev = node
                    node.prev = prevNode
                end
                break
            end
        end
    end
    self.length = self.length + 1
end

function List:Iterator()
    local iter = {}
    iter.current = nil
    iter.next = function()
        if iter.current then
            iter.current = iter.current.next
        else
            iter.current = self.head
        end
        return iter.current
    end
    return iter
end

function List:Remove(node)
    local prev = node.prev
    local next = node.next
    if prev then
        if next then
            prev.next = next
            next.prev = prev
        else
            self.tail = prev
            self.tail.next = nil
        end
    else
        if next then
            self.head = next
            self.head.prev = nil
        else
            self.head = nil
            self.tail = nil
        end
    end
    node.data = nil
    node.prev = nil
    node.next = nil
    self.length = self.length - 1
end

local function TestList()
    local fn = function(node1, node2)
        return node1.data < node2.data
    end
    local list = List(fn)
    local n1 = Node(1)
    local n2 = Node(2)
    local n3 = Node(3)
    local n4 = Node(4)
    list:Insert(n3)
    list:Insert(n2)
    list:Insert(n4)
    list:Insert(n1)
    local iter = list:Iterator()
    while iter.next() do
        print(iter.current.data)
    end
    print("----------------", list.length)
    list:Remove(n2)
    iter = list:Iterator()
    while iter.next() do
        print(iter.current.data)
    end
    print("----------------", list.length)
    list:Remove(n1)
    list:Remove(n3)
    iter = list:Iterator()
    while iter.next() do
        print(iter.current.data)
    end
    print("----------------", list.length)
    list:Remove(n4)
    iter = list:Iterator()
    while iter.next() do
        print(iter.current.data)
    end
    print("----------------", list.length)
end

--TestList()