module HashArrayMappedTries

const ENTRY_COUNT = UInt(32)
const NBITS = sizeof(UInt) * 8
@assert ispow2(ENTRY_COUNT)
const BITS_PER_LEVEL = trailing_zeros(ENTRY_COUNT)
const LEVEL_MASK = (UInt(1) << BITS_PER_LEVEL) - 1
const MAX_LEVEL = UInt(NBITS ÷ BITS_PER_LEVEL - 1) # inclusive

entry_index(h::UInt, level::UInt) = UInt((h >> (level * BITS_PER_LEVEL)) & LEVEL_MASK) + 1

mutable struct Leaf{K, V}
    const key::K
    const val::V
    const h::UInt # hash-cached
end

mutable struct Node{K, V}
    const data::Vector{Union{Leaf{K, V}, Node{K, V}}}
    bitmap::UInt32
end
Node{K, V}() where {K, V} = Node(Vector{Union{Leaf{K, V}, Node{K, V}}}(undef, ENTRY_COUNT), zero(UInt32))

isset(n::Node, i) = isodd(n.bitmap >> (i-1))
function set!(n::Node, i) 
    @assert 1 <= i <= 32
    n.bitmap |= (UInt32(1) << (i-1))
end

function unset!(n::Node, i) 
    @assert 1 <= i <= 32
    n.bitmap &= ~(UInt32(1) << (i-1))
end

# Local version
isempty(n::Node) = n.bitmap == 0
isempty(::Leaf) = false

"""
    path(node, h, copyf)::(found, present, node, i, top, level)

Internal function that walks a HAMT and finds the slot for hash.
Returns if a value is `present` and a value is `found`.

It returns the `node` and the index `i` into `node.data`, as well
as the current `level`.

If a copy function is provided `copyf` use the return `top` for the
new persistent tree.
"""
@inline function path(node::Node{K,V}, h::UInt, copyf::F) where {K, V, F}
    level = UInt(0)
    node = top = copyf(node)
    while true
        i = entry_index(h, level)
        if isset(node, i)
            next = @inbounds node.data[i]
            if next isa Leaf{K,V}
                return (next.h == h), true, node, i, top, level # Key match
            end
            node = copyf(next::Node{K,V})
        else
            # found empty slot
            return true, false, node, i, top, level
        end
        level += 1
        @assert level <= MAX_LEVEL
    end
end

Base.eltype(::Node{K,V}) where {K,V} = Pair{K,V}

function Base.in(key_val::Pair{K,V}, node::Node{K,V}, valcmp=(==)) where {K,V}
    if isempty(node)
        return false
    end
    
    key, val = key_val

    h = hash(key)
    found, present, node, i, _, _ = path(node, h, identity)
    if found && present
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return valcmp(val, leaf.val) && return true
    end
    return false
end

function Base.haskey(node::Node{K}, key::K) where K
    h = hash(key)
    found, present, _, _, _, _ = path(node, h, identity)
    return found && present
end

function Base.getindex(node::Node{K,V}, key::K) where {K,V}
    if isempty(node)
        throw(KeyError(key))
    end
    h = hash(key)
    found, present, node, i, _, _ = path(node, h, identity)
    if found && present
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return leaf.val
    end
    throw(KeyError(key))
end

function Base.get(node::Node{K,V}, key::K, default::V) where {K,V}
    if isempty(node)
        return default
    end
    h = hash(key)
    found, present, node, i, _, _ = path(node, h, identity)
    if found && present
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default
end

function Base.get(default::Base.Callable, node::Node{K,V}, key::K) where {K,V}
    if isempty(node)
        return default
    end
    h = hash(key)
    found, present, node, i, _, _ = path(node, h, identity)
    if found && present
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default()
end

struct HAMTIterationState
    parent::Union{Nothing, HAMTIterationState}
    node::Node
    i::Int
end

function Base.iterate(node::Node, state=nothing)
    if state === nothing
        state = HAMTIterationState(nothing, node, 1)
    end
    # find the next valid index
    while state !== nothing
        i = state.i
        while (i <= 32)
            if isset(state.node, i)
                node = state.node.data[i]
                state = HAMTIterationState(state.parent, state.node, i+1)
                if node isa Leaf
                    return (node.key => node.val, state)
                else
                    # we found a new level
                    state = HAMTIterationState(state, node, 1)
                    break # exit inner while loop
                end
            end
            i += 1
        end
        if i > 32
            # go back up a level
            state = state.parent
        end
    end
    return nothing
end

"""

Internal function that given an obtained path, either set the value
or grows the HAMT by inserting a new node instead.
"""
@inline function insert!(found, node::Node{K,V}, i, level, key, val, h) where {K,V}
     if found # we found a slot, just set it to the new leaf
        # replace or insert
        @inbounds node.data[i] = Leaf{K, V}(key, val, h)
        set!(node, i)
    else
        # collision -> grow
        leaf = @inbounds node.data[i]::Leaf{K,V}
        while true
            new_node = Node{K, V}()
            @inbounds node.data[i] = new_node
            set!(node, i)

            level += 1
            @assert level <= MAX_LEVEL

            i_new = entry_index(h, level)
            i_old = entry_index(leaf.h, level)
            if i_new == i_old
                node = new_node
                i = i_new
                level += 1
                @assert level <= MAX_LEVEL
                continue
            end
            @inbounds new_node.data[i_new] = Leaf{K, V}(key, val, h)
            @inbounds new_node.data[i_old] = leaf
            set!(new_node, i_new)
            set!(new_node, i_old)
            break
        end
    end
end

function Base.setindex!(node::Node{K,V}, val::V, key::K) where {K,V}
    h = hash(key)
    found, _, node, i, _, level = path(node, h, identity)
    insert!(found, node, i, level, key, val, h)
    return val
end

function Base.delete!(node::Node{K,V}, key::K) where {K,V}
    h = hash(key)
    found, present, node, i, _, _ = path(node, h, identity)
    if found && present
        unset!(node, i)
        # Can't unset node.data[i] safely
        Base.unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, pointer(node.data, i)), C_NULL)
        # TODO: If `node` is empty we might want to unlink it.
    end
end

# persistent
function Node(node::Node{K, V}, key::K, val::V) where {K, V}
    h = hash(key)
    found, _, node, i, top, level = path(node, h, (n::Node{K,V} -> Node{K,V}(copy(n.data), n.bitmap)))
    insert!(found, node, i, level, key, val, h)
    return top
end

function Node(node::Node{K, V}, key::K) where {K, V}
    h = hash(key)
    found, present, node, i, top, _ = path(node, h, (n::Node{K,V} -> Node{K,V}(copy(n.data), n.bitmap)))
    if found && present
        unset!(node, i)
        # Can't unset node.data[i] safely
        Base.unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, pointer(node.data, i)), C_NULL)
        # TODO: If `node` is empty we might want to unlink it.
    end
    return top
end

Base.length(::Leaf) = 1
Base.length(n::Node) = sum((length(n.data[i]) for i in 1:32 if isset(n, i)), init=0)

Base.isempty(::Leaf) = false
function Base.isempty(n::Node)
    if isempty(n)
        return true
    end
    return all(Base.isempty(n.data[i]) for i in 1:32 if isset(n, i))
end

const HAMT = Node
export HAMT

end # module HashArrayMapTries
