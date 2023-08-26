module HashArrayMappedTries

export HAMT, insert, delete

##
# A HAMT is formed by tree of levels, where at each level
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
# HAMT can be both persitent and non-persistent.
# The `path` function searches for a matching entries, and for persistency
# optionally copies the path so that it can be safely mutated.

const ENTRY_COUNT = UInt(32)
const BITMAP = UInt32
const NBITS = sizeof(UInt) * 8
@assert ispow2(ENTRY_COUNT)
const BITS_PER_LEVEL = trailing_zeros(ENTRY_COUNT)
const LEVEL_MASK = (UInt(1) << BITS_PER_LEVEL) - 1
const MAX_LEVEL = UInt(NBITS ÷ BITS_PER_LEVEL - 1) # inclusive

mutable struct Leaf{K, V}
    const key::K
    const val::V
    const h::UInt # hash-cached
end

"""
    HAMT{K,V}

A HashArrayMappedTrie that optionally supports persistence.
"""
mutable struct HAMT{K, V}
    const data::Vector{Union{Leaf{K, V}, HAMT{K, V}}}
    bitmap::BITMAP
end
HAMT{K, V}() where {K, V} = HAMT(Vector{Union{Leaf{K, V}, HAMT{K, V}}}(undef, 0), zero(UInt32))

struct BitmapIndex
    x::UInt8
    function BitmapIndex(x)
        @assert 0 <= x < 32
        new(x)
    end
end
function BitmapIndex(h::UInt, level::UInt)
    @assert level <= MAX_LEVEL
    BitmapIndex((h >> (level * BITS_PER_LEVEL)) & LEVEL_MASK)
end

Base.:(<<)(v, bi::BitmapIndex) = v << bi.x
Base.:(>>)(v, bi::BitmapIndex) = v >> bi.x

isset(trie::HAMT, bi::BitmapIndex) = isodd(trie.bitmap >> bi)
function set!(trie::HAMT, bi::BitmapIndex)
    trie.bitmap |= (UInt32(1) << bi)
    @assert count_ones(trie.bitmap) == length(trie.data)
end

function unset!(trie::HAMT, bi::BitmapIndex)
    trie.bitmap &= ~(UInt32(1) << bi)
    @assert count_ones(trie.bitmap) == length(trie.data)
end

function entry_index(trie::HAMT, bi::BitmapIndex)
    mask = (UInt32(1) << bi.x) - UInt32(1)
    count_ones(trie.bitmap & mask) + 1
end

# Local version
isempty(trie::HAMT) = trie.bitmap == 0
isempty(::Leaf) = false

"""
    path(trie, h, copyf)::(found, present, trie, i, top, level)

Internal function that walks a HAMT and finds the slot for hash.
Returns if a value is `present` and a value is `found`.

It returns the `trie` and the index `i` into `trie.data`, as well
as the current `level`.

If a copy function is provided `copyf` use the return `top` for the
new persistent tree.
"""
@inline function path(trie::HAMT{K,V}, h::UInt, copyf::F) where {K, V, F}
    level = UInt(0)
    trie = top = copyf(trie)
    while true
        bi = BitmapIndex(h, level)
        i = entry_index(trie, bi)
        if isset(trie, bi)
            next = @inbounds trie.data[i]
            if next isa Leaf{K,V}
                # equality or hash comparision?
                return (next.h == h), true, trie, i, bi, top, level # Key match
            end
            trie = copyf(next::HAMT{K,V})
        else
            # found empty slot
            return true, false, trie, i, bi, top, level
        end
        level += 1
        @assert level <= MAX_LEVEL
    end
end

Base.eltype(::HAMT{K,V}) where {K,V} = Pair{K,V}

function Base.in(key_val::Pair{K,V}, trie::HAMT{K,V}, valcmp=(==)) where {K,V}
    if isempty(trie)
        return false
    end

    key, val = key_val

    h = hash(key)
    found, present, trie, i, _, _, _ = path(trie, h, identity)
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return valcmp(val, leaf.val) && return true
    end
    return false
end

function Base.haskey(trie::HAMT{K}, key::K) where K
    h = hash(key)
    found, present, _, _, _, _, _ = path(trie, h, identity)
    return found && present
end

function Base.getindex(trie::HAMT{K,V}, key::K) where {K,V}
    if isempty(trie)
        throw(KeyError(key))
    end
    h = hash(key)
    found, present, trie, i, _, _, _ = path(trie, h, identity)
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    throw(KeyError(key))
end

function Base.get(trie::HAMT{K,V}, key::K, default::V) where {K,V}
    if isempty(trie)
        return default
    end
    h = hash(key)
    found, present, trie, i, _, _, _ = path(trie, h, identity)
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default
end

function Base.get(default::Base.Callable, trie::HAMT{K,V}, key::K) where {K,V}
    if isempty(trie)
        return default
    end
    h = hash(key)
    found, present, trie, i, _, _, _ = path(trie, h, identity)
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return leaf.val
    end
    return default()
end

struct HAMTIterationState
    parent::Union{Nothing, HAMTIterationState}
    trie::HAMT
    i::Int
end

function Base.iterate(trie::HAMT, state=nothing)
    if state === nothing
        state = HAMTIterationState(nothing, trie, 1)
    end
    while state !== nothing
        i = state.i
        if i > length(state.trie.data)
            state = state.parent
            continue
        end
        trie = state.trie.data[i]
        state = HAMTIterationState(state.parent, state.trie, i+1)
        if trie isa Leaf
            return (trie.key => trie.val, state)
        else
            # we found a new level
            state = HAMTIterationState(state, trie, 1)
            continue
        end
    end
    return nothing
end

"""

Internal function that given an obtained path, either set the value
or grows the HAMT by inserting a new trie instead.
"""
@inline function insert!(found, present, trie::HAMT{K,V}, i, bi, level, key, val, h) where {K,V}
    if found # we found a slot, just set it to the new leaf
        # replace or insert
        if present # replace
            @inbounds trie.data[i] = Leaf{K, V}(key, val, h)
        else
            Base.insert!(trie.data, i, Leaf{K, V}(key, val, h))
        end
        set!(trie, bi)
    else
        @assert present
        # collision -> grow
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        while true
            new_trie = HAMT{K, V}()
            if present
                @inbounds trie.data[i] = new_trie
            else
                i = entry_index(trie, bi)
                Base.insert!(trie.data, i, new_trie)
            end
            set!(trie, bi)

            level += 1

            bi_new = BitmapIndex(h, level)
            bi_old = BitmapIndex(leaf.h, level)
            if bi_new == bi_old # collision in new trie -> retry
                trie = new_trie
                bi = bi_new
                present = false
                continue
            end
            i_new = entry_index(new_trie, bi_new)
            Base.insert!(new_trie.data, i_new, Leaf{K, V}(key, val, h))
            set!(new_trie, bi_new)

            i_old = entry_index(new_trie, bi_old)
            Base.insert!(new_trie.data, i_old, leaf)
            set!(new_trie, bi_old)

            break
        end
    end
end

function Base.setindex!(trie::HAMT{K,V}, val::V, key::K) where {K,V}
    h = hash(key)
    found, present, trie, i, bi, _, level = path(trie, h, identity)
    insert!(found, present, trie, i, bi, level, key, val, h)
    return val
end

function Base.delete!(trie::HAMT{K,V}, key::K) where {K,V}
    h = hash(key)
    found, present, trie, i, bi, _, _ = path(trie, h, identity)
    if found && present
        deleteat!(trie.data, i)
        unset!(trie, bi)
        @assert count_ones(trie.bitmap) == length(trie.data)
    else
        throw(KeyError(key))
    end
end

"""
    insert(trie::HAMT{K, V}, key::K, val::V) where {K, V})

Persitent insertion.

```julia
dict = HAMT{Int, Int}()
dict = insert(dict, 10, 12)
```
"""
function insert(trie::HAMT{K, V}, key::K, val::V) where {K, V}
    h = hash(key)
    found, present, trie, i, bi, top, level = path(trie, h, (n::HAMT{K,V} -> HAMT{K,V}(copy(n.data), n.bitmap)))
    insert!(found, present, trie, i, bi, level, key, val, h)
    return top
end

"""
    insert(trie::HAMT{K, V}, key::K, val::V) where {K, V})

Persitent insertion.

```julia
dict = HAMT{Int, Int}()
dict = insert(dict, 10, 12)
dict = delete(dict, 10)
```
"""
function delete(trie::HAMT{K, V}, key::K) where {K, V}
    h = hash(key)
    found, present, trie, i, bi, top, _ = path(trie, h, (n::HAMT{K,V} -> HAMT{K,V}(copy(n.data), n.bitmap)))
    if found && present
        deleteat!(trie.data, i)
        unset!(trie, bi)
        @assert count_ones(trie.bitmap) == length(trie.data)
    else
        throw(KeyError(key))
    end
    return top
end

Base.length(::Leaf) = 1
Base.length(trie::HAMT) = sum((length(trie.data[entry_index(trie, BitmapIndex(i))]) for i in 0:31 if isset(trie, BitmapIndex(i))), init=0)

Base.isempty(::Leaf) = false
function Base.isempty(trie::HAMT)
    if isempty(trie)
        return true
    end
    return all(Base.isempty(trie.data[entry_index(trie, BitmapIndex(i))]) for i in 0:31 if isset(trie, BitmapIndex(i)))
end

end # module HashArrayMapTries
