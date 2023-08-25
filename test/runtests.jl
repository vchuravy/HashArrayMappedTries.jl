using Test
using HashArrayMappedTries

@testset "basics" begin
    dict = HAMT{Int, Int}()
    @test_throws KeyError dict[1]
    @test length(dict) == 0

    dict[1] = 1
    @test dict[1] == 1

    # persistent
    dict2 = HAMT(dict, 1, 2)
    @test dict[1] == 1
    @test dict2[1] == 2

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
end