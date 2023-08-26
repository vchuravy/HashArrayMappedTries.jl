# HashArrayMappedTries.jl

A [HashArrayMappedTrie](https://en.wikipedia.org/wiki/Hash_array_mapped_trie) or
HAMT for short, is a data-structure that can be used efficient persistent hash tables.

## Usage

```julia
dict = HAMT{Int, Int}()
dict[1] = 1
delete!(dict, 1)
```

### Persitency

```julia
dict = HAMT{Int, Int}()
dict = insert(dict, 1, 1)
dict = delete(dict, 1)
```
