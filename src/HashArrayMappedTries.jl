module HashArrayMappedTries

export HAMT, insert, delete

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

"""
    HAMT{K,V}

A HashArrayMappedTrie that optionally supports persistence.
"""
mutable struct HAMT{K, V}
    const data::Vector{Union{Leaf{K, V}, HAMT{K, V}}}
    bitmap::UInt32
end
HAMT{K, V}() where {K, V} = HAMT(Vector{Union{Leaf{K, V}, HAMT{K, V}}}(undef, ENTRY_COUNT), zero(UInt32))

isset(trie::HAMT, i) = isodd(trie.bitmap >> (i-1))
function set!(trie::HAMT, i) 
    @assert 1 <= i <= 32
    trie.bitmap |= (UInt32(1) << (i-1))
end

function unset!(trie::HAMT, i) 
    @assert 1 <= i <= 32
    trie.bitmap &= ~(UInt32(1) << (i-1))
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
        i = entry_index(h, level)
        if isset(trie, i)
            next = @inbounds trie.data[i]
            if next isa Leaf{K,V}
                return (next.h == h), true, trie, i, top, level # Key match
            end
            trie = copyf(next::HAMT{K,V})
        else
            # found empty slot
            return true, false, trie, i, top, level
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
    found, present, trie, i, _, _ = path(trie, h, identity)
    if found && present
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        return valcmp(val, leaf.val) && return true
    end
    return false
end

function Base.haskey(trie::HAMT{K}, key::K) where K
    h = hash(key)
    found, present, _, _, _, _ = path(trie, h, identity)
    return found && present
end

function Base.getindex(trie::HAMT{K,V}, key::K) where {K,V}
    if isempty(trie)
        throw(KeyError(key))
    end
    h = hash(key)
    found, present, trie, i, _, _ = path(trie, h, identity)
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
    found, present, trie, i, _, _ = path(trie, h, identity)
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
    found, present, trie, i, _, _ = path(trie, h, identity)
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
    # find the next valid index
    while state !== nothing
        i = state.i
        while (i <= 32)
            if isset(state.trie, i)
                trie = state.trie.data[i]
                state = HAMTIterationState(state.parent, state.trie, i+1)
                if trie isa Leaf
                    return (trie.key => trie.val, state)
                else
                    # we found a new level
                    state = HAMTIterationState(state, trie, 1)
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
or grows the HAMT by inserting a new trie instead.
"""
@inline function insert!(found, trie::HAMT{K,V}, i, level, key, val, h) where {K,V}
     if found # we found a slot, just set it to the new leaf
        # replace or insert
        @inbounds trie.data[i] = Leaf{K, V}(key, val, h)
        set!(trie, i)
    else
        # collision -> grow
        leaf = @inbounds trie.data[i]::Leaf{K,V}
        while true
            new_trie = HAMT{K, V}()
            @inbounds trie.data[i] = new_trie
            set!(trie, i)

            level += 1
            @assert level <= MAX_LEVEL

            i_new = entry_index(h, level)
            i_old = entry_index(leaf.h, level)
            if i_new == i_old
                trie = new_trie
                i = i_new
                level += 1
                @assert level <= MAX_LEVEL
                continue
            end
            @inbounds new_trie.data[i_new] = Leaf{K, V}(key, val, h)
            @inbounds new_trie.data[i_old] = leaf
            set!(new_trie, i_new)
            set!(new_trie, i_old)
            break
        end
    end
end

function Base.setindex!(trie::HAMT{K,V}, val::V, key::K) where {K,V}
    h = hash(key)
    found, _, trie, i, _, level = path(trie, h, identity)
    insert!(found, trie, i, level, key, val, h)
    return val
end

function Base.delete!(trie::HAMT{K,V}, key::K) where {K,V}
    h = hash(key)
    found, present, trie, i, _, _ = path(trie, h, identity)
    if found && present
        unset!(trie, i)
        # Can't unset trie.data[i] safely
        Base.unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, pointer(trie.data, i)), C_NULL)
        # TODO: If `trie` is empty we might want to unlink it.
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
    found, _, trie, i, top, level = path(trie, h, (n::HAMT{K,V} -> HAMT{K,V}(copy(n.data), n.bitmap)))
    insert!(found, trie, i, level, key, val, h)
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
    found, present, trie, i, top, _ = path(trie, h, (n::HAMT{K,V} -> HAMT{K,V}(copy(n.data), n.bitmap)))
    if found && present
        unset!(trie, i)
        # Can't unset trie.data[i] safely
        Base.unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, pointer(trie.data, i)), C_NULL)
        # TODO: If `trie` is empty we might want to unlink it.
    else
        throw(KeyError(key))
    end
    return top
end

Base.length(::Leaf) = 1
Base.length(trie::HAMT) = sum((length(trie.data[i]) for i in 1:32 if isset(trie, i)), init=0)

Base.isempty(::Leaf) = false
function Base.isempty(trie::HAMT)
    if isempty(trie)
        return true
    end
    return all(Base.isempty(trie.data[i]) for i in 1:32 if isset(trie, i))
end

end # module HashArrayMapTries
