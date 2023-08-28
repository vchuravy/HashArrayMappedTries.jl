using Test
using HashArrayMappedTries

@testset "basics" begin
    dict = HAMT{Int, Int}()
    @test_throws KeyError dict[1]
    @test length(dict) == 0
    @test isempty(dict)

    dict[1] = 1
    @test dict[1] == 1
    @test get(dict, 2, 1) == 1
    @test get(()->1, dict, 2) == 1

    @test (1 => 1) ∈ dict
    @test (1 => 2) ∉ dict
    @test (2 => 1) ∉ dict

    @test haskey(dict, 1)
    @test !haskey(dict, 2)

    dict[3] = 2
    delete!(dict, 3)
    @test_throws KeyError dict[3]
    @test dict == delete!(dict, 3)

    # persistent
    dict2 = insert(dict, 1, 2)
    @test dict[1] == 1
    @test dict2[1] == 2

    dict3 = delete(dict2, 1)
    @test_throws KeyError dict3[1]
    @test dict3 != delete(dict3, 1)

    dict[1] = 3
    @test dict[1] == 3
    @test dict2[1] == 2

    @test length(dict) == 1
    @test length(dict2) == 1
end

@testset "stress" begin
    dict = HAMT{Int, Int}()
    for i in 1:2048
        dict[i] = i
    end
    @test length(dict) == 2048
    length(collect(dict)) == 2048
    values = sort!(collect(dict))
    @test values[1] == (1=>1)
    @test values[end] == (2048=>2048)

    for i in 1:2048
        delete!(dict, i)
    end
    @test isempty(dict)

    dict = HAMT{Int, Int}()
    for i in 1:2048
        dict = insert(dict, i, i)
    end
    @test length(dict) == 2048
    length(collect(dict)) == 2048
    values = sort!(collect(dict))
    @test values[1] == (1=>1)
    @test values[end] == (2048=>2048)

    for i in 1:2048
        dict = delete(dict, i)
    end
    isempty(dict)

    dict = HAMT{Int, Int}()
    for i in 1:16384
        dict[i] = i
    end
    delete!(dict, 16384)
    @test !haskey(dict, 16384)

    dict = HAMT{Int, Int}()
    for i in 1:16384
        dict = insert(dict, i, i)
    end
    dict = delete(dict, 16384)
    @test !haskey(dict, 16384)
end

mutable struct CollidingHash
end
Base.hash(::CollidingHash) = UInt(0)

@testset "CollidingHash" begin
    dict = HAMT{CollidingHash, Nothing}()
    dict[CollidingHash()] = nothing
    @test_throws ErrorException dict[CollidingHash()] = nothing
end
