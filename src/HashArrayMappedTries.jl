module HashArrayMappedTries

const ENTRY_COUNT = UInt(32)
const NBITS = sizeof(UInt) * 8
@assert ispow2(ENTRY_COUNT)
const BITS_PER_LEVEL = trailing_zeros(ENTRY_COUNT)
const LEVEL_MASK = (UInt(1) << BITS_PER_LEVEL) - 1
const MAX_LEVEL = UInt(NBITS ÷ BITS_PER_LEVEL - 1) # inclusive

entry_index(hash::UInt, level::UInt) = UInt((hash >> (level * BITS_PER_LEVEL)) & LEVEL_MASK) + 1

mutable struct Leaf{K, V}
    const key::K
    const val::V
end

mutable struct Node{K, V}
    bitmap::UInt32
    data::Vector{Union{Leaf{K, V}, Node{K, V}}}
end
Node{K, V}() where {K, V} = Node(zero(UInt32), Vector{Union{Leaf{K, V}, Node{K, V}}}(undef, ENTRY_COUNT))

isset(n::Node, i) = isodd(n.bitmap >> (i-1))
function set!(n::Node, i) 
    @assert 1 <= i <= 32
    n.bitmap |= (UInt32(1) << (i-1))
end

function Base.getindex(node::Node{K,V}, key::K) where {K,V}
    hash = Base.hash(key)
    level = UInt(0)
    while !(node isa Leaf{K,V})
        i = entry_index(hash, level)
        if isset(node, i)
            node = @inbounds node.data[i]
        else
            throw(KeyError(key))
        end
        level += 1
    end
    leaf = node::Leaf{K,V}
    if Base.hash(leaf.key) !== hash
        throw(KeyError(key))
    end
    return leaf.val
end

function Base.setindex!(node::Node{K,V}, val::V, key::K) where {K,V}
    hash = Base.hash(key)
    level = UInt(0)
    previous = node
    previous_i = ~UInt(0)
    while !(node isa Leaf{K,V})
        i = entry_index(hash, level)
        if isset(node, i) 
            previous = node
            previous_i = i
            node = @inbounds node.data[i]
        else
            @inbounds node.data[i] = Leaf{K, V}(key, val)
            set!(node, i)
            return
        end
        level += 1
        @assert level <= MAX_LEVEL
    end
    leaf = node::Leaf{K,V}
    # check if keys are ident
    if Base.hash(leaf.key) === hash
        # replace
        @assert isset(previous, previous_i)
        @inbounds previous.data[previous_i] = Leaf{K, V}(key, val)
    else
        # collision grow
        while true
            new_node = Node{K, V}()
            @inbounds previous.data[previous_i] = new_node
            set!(previous, previous_i)

            i_new = entry_index(hash, level)
            i_old = entry_index(Base.hash(leaf.key), level)
            if i_new == i_old
                previous = new_node
                previous_i = i_new
                level += 1
                @assert level <= MAX_LEVEL
                continue
            end
            @inbounds new_node.data[i_new] = Leaf{K, V}(key, val)
            @inbounds new_node.data[i_old] = leaf
            set!(new_node, i_new)
            set!(new_node, i_old)
            break
        end
    end
    return leaf.val
end

# persistent
function get(node::Node{K, V}, key::K, val::V) where {K, V}
    hash = Base.hash(key)
    level = UInt(0)

    # We always own node, we copy nodes along our search path
    node = previous = persistent = Node{K,V}(node.bitmap, copy(node.data))
    previous_i = ~UInt(0)
    while !(node isa Leaf{K,V})
        i = entry_index(hash, level)
        if isset(node, i)
            previous = node
            previous_i = i

            shared_node = @inbounds node.data[i]
            if shared_node isa Node
                node = Node{K,V}(shared_node.bitmap, copy(shared_node.data))
            else
                node = shared_node
            end
        else
            @inbounds node.data[i] = Leaf{K, V}(key, val)
            set!(node, i)
            return
        end
        level += 1
        @assert level <= MAX_LEVEL
    end
    leaf = node::Leaf{K,V}
    # check if keys are ident
    if Base.hash(leaf.key) === hash
        # replace
        @assert isset(previous, previous_i)
        @inbounds previous.data[previous_i] = Leaf{K, V}(key, val)
    else
        # collision grow
        while true
            new_node = Node{K, V}()
            @inbounds previous.data[previous_i] = new_node
            set!(previous, previous_i)

            i_new = entry_index(hash, level)
            i_old = entry_index(Base.hash(leaf.key), level)
            if i_new == i_old
                previous = new_node
                previous_i = i_new
                level += 1
                @assert level <= MAX_LEVEL
                continue
            end
            @inbounds new_node.data[i_new] = Leaf{K, V}(key, val)
            @inbounds new_node.data[i_old] = leaf
            set!(new_node, i_new)
            set!(new_node, i_old)
            break
        end
    end
    return persistent
end

Base.length(::Leaf) = 1
Base.length(n::Node) = sum((length(n.data[i]) for i in 1:32 if isset(n, i)), init=0)

function collect(n::Node{K,V}, accum::Vector{Pair{K, V}}) where {K, V}
    for i in 1:32
        if isset(n, i)
            child = n.data[i]
            if child isa Leaf{K,V}
                push!(accum, child.key => child.val)
                continue
            end
            collect(child, accum)
        end
    end
    return accum
end

Base.collect(n::Node{K,V}) where {K,V} = collect(n, Pair{K, V}[])

using AbstractTrees

AbstractTrees.children(n::Node) = [n.data[i] for i in i:32 if isset(n, i)]
AbstractTrees.nodevalue(n::Node) = nothing

AbstractTrees.children(n::Leaf) = []
AbstractTrees.nodevalue(n::Leaf) = n.key => n.val

const HAMT = Node
export HAMT

end # module HashArrayMapTries
