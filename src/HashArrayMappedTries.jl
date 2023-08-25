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
    const hash::UInt # cache
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

@inline function path(node::Node{K,V}, hash::UInt, copyf::F) where {K, V, F}
    level = UInt(0)
    node = top = copyf(node)
    while true
        i = entry_index(hash, level)
        if isset(node, i)
            next = @inbounds node.data[i]
            if next isa Leaf{K,V}
                return (next.hash == hash), node, i, top, level # Key match
            end
            node = copyf(next::Node{K,V})
        else
            # found empty slot
            return true, node, i, top, level
        end
        level += 1
        @assert level <= MAX_LEVEL
    end
end

function Base.getindex(node::Node{K,V}, key::K) where {K,V}
    hash = Base.hash(key)
    found, node, i, _, _ = path(node, hash, identity)
    if found && isset(node, i)
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return leaf.val
    end
    throw(KeyError(key))
end

function Base.get(node::Node{K,V}, key::K, default::V) where {K,V}
    hash = Base.hash(key)
    found, node, i, _, _ = path(node, hash, identity)
    if found && isset(node, i)
        leaf = @inbounds node.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default
end

@inline function insert!(update, node::Node{K,V}, i, level, key, val, hash) where {K,V}
     if update
        # replace or insert
        @inbounds node.data[i] = Leaf{K, V}(key, val, hash)
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

            i_new = entry_index(hash, level)
            i_old = entry_index(leaf.hash, level)
            if i_new == i_old
                node = new_node
                i = i_new
                level += 1
                @assert level <= MAX_LEVEL
                continue
            end
            @inbounds new_node.data[i_new] = Leaf{K, V}(key, val, hash)
            @inbounds new_node.data[i_old] = leaf
            set!(new_node, i_new)
            set!(new_node, i_old)
            break
        end
    end
end

function Base.setindex!(node::Node{K,V}, val::V, key::K) where {K,V}
    hash = Base.hash(key)
    update, node, i, _, level = path(node, hash, identity)
    insert!(update, node, i, level, key, val, hash)
    return val
end

function Base.delete!(node::Node{K,V}, key::K) where {K,V}
    hash = Base.hash(key)
    found, node, i, _, _ = path(node, hash, identity)
    if found && isset(node, i)
        unset!(node, i)
        # Can't unset node.data[i] safely
        Base.unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, pointer(node.data, i)), C_NULL)
    end
end

# persistent
function Node(node::Node{K, V}, key::K, val::V) where {K, V}
    hash = Base.hash(key)
    update, node, i, top, level = path(node, hash, (n::Node{K,V} -> Node{K,V}(copy(n.data),n.bitmap)))
    insert!(update, node, i, level, key, val, hash)
    return top
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
