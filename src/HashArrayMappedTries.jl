module HashArrayMappedTries

export HAMT, insert, delete

##
# A Node is formed by tree of levels, where at each level
# we use a portion of the bits of the hash for indexing
#
# We use a branching width (ENTRY_COUNT) of 32, giving us
# 5bits of indexing per level
# 0000_00000_00000_00000_00000_00000_00000_00000_00000_00000_00000_00000
# L11  L10   L9    L8    L7    L6    L5    L4    L3    L2    L1    L0
#
# At each level we use a 32bit bitmap to store which elements are occupied.
# Since our storage is "sparse" we need to map from index in [0,31] to
# the actual storage index. We mask the bitmap wiht (1 << i) - 1 and count
# the ones in the result. The number of set ones (+1) gives us the index
# into the storage array.
#
# Node can be both persitent and non-persistent.
# The `path` function searches for a matching entries, and for persistency
# optionally copies the path so that it can be safely mutated.

# TODO:
# When `trie.data` becomes empty we could remove it from it's parent,
# but we only know so fairly late. Maybe have a compact function?

const ENTRY_COUNT = UInt(32)
const BITMAP = UInt32
const NBITS = sizeof(UInt) * 8
@assert ispow2(ENTRY_COUNT)
const BITS_PER_LEVEL = trailing_zeros(ENTRY_COUNT)
const LEVEL_MASK = (UInt(1) << BITS_PER_LEVEL) - 1
# Before we rehash
const MAX_SHIFT = (NBITS ÷ BITS_PER_LEVEL - 1) *  BITS_PER_LEVEL

mutable struct Leaf{K, V}
    const key::K
    const val::V
end

"""
    Node{K,V}

A HashArrayMappedTrie that optionally supports persistence.
"""
mutable struct Node{K, V}
    const data::Vector{Union{Node{K, V}, Leaf{K, V}}}
    bitmap::BITMAP
end
Node{K, V}() where {K, V} = Node(
    Vector{Union{Leaf{K, V}, Node{K, V}}}(undef, 0),
    zero(UInt32))

const Layer{K,V} = Vector{Union{Node{K, V}, Leaf{K, V}}}
mutable struct HAMT{K,V}
    const layer::Layer{K,V}
    t::Int # size = 2^t
    function HAMT(layer::Layer{K,V}) where {K,V}
        N = length(data)
        @assert ispow2(N)
        t = trailing_zeros(N)
        return new(layer, t)
    end
end
HAMT{K,V}() = HAMT(Layer{K,V}(undef, 2^BITS_PER_LEVEL))

function resize!(hamt::HAMT{K,V})
    t = hamt.t + BITS_PER_LEVEL
    layer = Layer{K,V}(undef, 2^t)
    i = 1
    for iL in 1:length(hamt.layer)
        if isdefined(hamt.layer, iL)
            entry = hamt.layer[iL]
            if entry isa Leaf{K,V}
                layer[i] = entry
                i += ENTRY_COUNT  # skip
            else
                node = entry::Node{K,T}
                for j in 0:(ENTRY_COUNT-1)
                    bI = BitmapIndex(j)
                    if isset(node, bI)
                        layer[i] = node.data[entry_index(node, bI)]
                    end
                    i += 1
                end
            end
        else
            i += ENTRY_COUNT
        end
    end 
    hamt = HAMT(layer)
    @assert hamt.t == t
    return hamt
end

struct BitmapIndex
    x::UInt8
    function BitmapIndex(x)
        @assert 0 <= x < 32
        new(x)
    end
end

Base.:(<<)(v, bi::BitmapIndex) = v << bi.x
Base.:(>>)(v, bi::BitmapIndex) = v >> bi.x

isset(trie::Node, bi::BitmapIndex) = isodd(trie.bitmap >> bi)
function set!(trie::Node, bi::BitmapIndex)
    trie.bitmap |= (UInt32(1) << bi)
    @assert count_ones(trie.bitmap) == length(trie.data)
end

function unset!(trie::Node, bi::BitmapIndex)
    trie.bitmap &= ~(UInt32(1) << bi)
    @assert count_ones(trie.bitmap) == length(trie.data)
end

function entry_index(trie::Node, bi::BitmapIndex)
    mask = (UInt32(1) << bi.x) - UInt32(1)
    count_ones(trie.bitmap & mask) + 1
end

# Local version
isempty(trie::Node) = trie.bitmap == 0
isempty(::Leaf) = false

struct HashState{K}
    key::K
    hash::UInt
    depth::Int
    shift::Int
end
HashState(key)= HashState(key, hash(key), 0, 0)
# Reconstruct
HashState(key, depth, shift) = HashState(key, hash(key, UInt(depth ÷ BITS_PER_LEVEL)), depth, shift)


function next(h::HashState)
    depth = h.depth + 1
    shift = h.shift + BITS_PER_LEVEL
    if shift > MAX_SHIFT
        h_hash = hash(h.key, UInt(depth ÷ BITS_PER_LEVEL))
    else
        h_hash = h.hash
    end
    return HashState(h.key, h_hash, depth, shift)
end

BitmapIndex(h::HashState) = BitmapIndex((h.hash >> h.shift) & LEVEL_MASK)

"""
    path(trie, h, copyf)::(found, present, trie, i, top, level)

Internal function that walks a Node and finds the slot for hash.
Returns if a value is `present` and a value is `found`.

It returns the `trie` and the index `i` into `trie.data`, as well
as the current `level`.

If a copy function is provided `copyf` use the return `top` for the
new persistent tree.
"""
@inline function path(trie::Node{K,V}, h::HashState, copy=false) where {K, V}
    if copy
        trie = top = Node{K,V}(Base.copy(trie.data), trie.bitmap)
    else
        trie = top = trie
    end
    while true
        bi = BitmapIndex(h)
        i = entry_index(trie, bi)
        if isset(trie, bi)
            next = @inbounds trie.data[i]
            if next isa Leaf{K,V}
                # Check if key match if not we will need to grow.
                found = (next.key === h.key || isequal(next.key, h.key))
                return found, true, trie, i, bi, top, h
            end
            if copy
                next = Node{K,V}(Base.copy(next.data), next.bitmap)
                @inbounds trie.data[i] = next
            end
            trie = next::Node{K,V}
        else
            # found empty slot
            return true, false, trie, i, bi, top, h
        end
        h = HashArrayMappedTries.next(h)
    end
end

Base.eltype(::Node{K,V}) where {K,V} = Pair{K,V}

function Base.in(key_val::Pair{K,V}, trie::Node{K,V}, valcmp=(==)) where {K,V}
    if isempty(trie)
        return false
    end

    key, val = key_val

    found, present, trie, i, _, _, _ = path(trie, HashState(key))
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return valcmp(val, leaf.val) && return true
    end
    return false
end

function Base.haskey(trie::Node{K}, key::K) where K
    found, present, _, _, _, _, _ = path(trie, HashState(key))
    return found && present
end

function Base.getindex(trie::Node{K,V}, key::K) where {K,V}
    if isempty(trie)
        throw(KeyError(key))
    end
    found, present, trie, i, _, _, _ = path(trie, HashState(key))
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    throw(KeyError(key))
end

function Base.get(trie::Node{K,V}, key::K, default::V) where {K,V}
    if isempty(trie)
        return default
    end
    found, present, trie, i, _, _, _ = path(trie, HashState(key))
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default
end

function Base.get(default::Base.Callable, trie::Node{K,V}, key::K) where {K,V}
    if isempty(trie)
        return default
    end
    found, present, trie, i, _, _, _ = path(trie, HashState(key))
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default()
end

struct NodeIterationState
    parent::Union{Nothing, NodeIterationState}
    trie::Node
    i::Int
end

function Base.iterate(trie::Node, state=nothing)
    if state === nothing
        state = NodeIterationState(nothing, trie, 1)
    end
    while state !== nothing
        i = state.i
        if i > length(state.trie.data)
            state = state.parent
            continue
        end
        trie = state.trie.data[i]
        state = NodeIterationState(state.parent, state.trie, i+1)
        if trie isa Leaf
            return (trie.key => trie.val, state)
        else
            # we found a new level
            state = NodeIterationState(state, trie, 1)
            continue
        end
    end
    return nothing
end

"""

Internal function that given an obtained path, either set the value
or grows the Node by inserting a new trie instead.
"""
@inline function insert!(found, present, trie::Node{K,V}, i, bi, h, val) where {K,V}
    if found # we found a slot, just set it to the new leaf
        # replace or insert
        if present # replace
            @inbounds trie.data[i] = Leaf{K, V}(h.key, val)
        else
            Base.insert!(trie.data, i, Leaf{K, V}(h.key, val))
        end
        set!(trie, bi)
    else
        @assert present
        # collision -> grow
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        leaf_h = HashState(leaf.key, h.depth, h.shift) # Reconstruct state
        if leaf_h.hash == h.hash
            error("Perfect hash collision detected")
        end
        while true
            new_trie = Node{K, V}()
            if present
                @inbounds trie.data[i] = new_trie
            else
                i = entry_index(trie, bi)
                Base.insert!(trie.data, i, new_trie)
            end
            set!(trie, bi)

            h = next(h)
            leaf_h = next(leaf_h)
            bi_new = BitmapIndex(h)
            bi_old = BitmapIndex(leaf_h)
            if bi_new == bi_old # collision in new trie -> retry
                trie = new_trie
                bi = bi_new
                present = false
                continue
            end
            i_new = entry_index(new_trie, bi_new)
            Base.insert!(new_trie.data, i_new, Leaf{K, V}(h.key, val))
            set!(new_trie, bi_new)

            i_old = entry_index(new_trie, bi_old)
            Base.insert!(new_trie.data, i_old, leaf)
            set!(new_trie, bi_old)

            break
        end
    end
end

function Base.setindex!(trie::Node{K,V}, val::V, key::K) where {K,V}
    h = HashState(key)
    found, present, trie, i, bi, _, h = path(trie, h)
    insert!(found, present, trie, i, bi, h, val)
    return val
end

function Base.delete!(trie::Node{K,V}, key::K) where {K,V}
    h = HashState(key)
    found, present, trie, i, bi, _, _ = path(trie, h)
    if found && present
        deleteat!(trie.data, i)
        unset!(trie, bi)
        @assert count_ones(trie.bitmap) == length(trie.data)
    end
    return trie
end

"""
    insert(trie::Node{K, V}, key::K, val::V) where {K, V})

Persitent insertion.

```julia
dict = Node{Int, Int}()
dict = insert(dict, 10, 12)
```
"""
function insert(trie::Node{K, V}, key::K, val::V) where {K, V}
    h = HashState(key)
    found, present, trie, i, bi, top, h = path(trie, h, true)
    insert!(found, present, trie, i, bi, h, val)
    return top
end

"""
    insert(trie::Node{K, V}, key::K, val::V) where {K, V})

Persitent insertion.

```julia
dict = Node{Int, Int}()
dict = insert(dict, 10, 12)
dict = delete(dict, 10)
```
"""
function delete(trie::Node{K, V}, key::K) where {K, V}
    h = HashState(key)
    found, present, trie, i, bi, top, _ = path(trie, h, true)
    if found && present
        deleteat!(trie.data, i)
        unset!(trie, bi)
        @assert count_ones(trie.bitmap) == length(trie.data)
    end
    return top
end

Base.length(::Leaf) = 1
Base.length(trie::Node) = sum((length(trie.data[entry_index(trie, BitmapIndex(i))]) for i in 0:31 if isset(trie, BitmapIndex(i))), init=0)

Base.isempty(::Leaf) = false
function Base.isempty(trie::Node)
    if isempty(trie)
        return true
    end
    return all(Base.isempty(trie.data[entry_index(trie, BitmapIndex(i))]) for i in 0:31 if isset(trie, BitmapIndex(i)))
end

end # module HashArrayMapTries
