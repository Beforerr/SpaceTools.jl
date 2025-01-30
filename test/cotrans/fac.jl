@testitem "fac_matrix_make" begin
    using LinearAlgebra
    Itest(mat) = mat ≈ I

    r0 = [0, 3, 4]
    q = fac_matrix_make(r0)
    @test q * q' ≈ I
    @test q * r0 ≈ [0, 0, 5]
    @test q * [3, 0, 0] ≈ [3, 0, 0]

    rs = [[0, 3, 4], [0, 2, 0]]
    qs = fac_matrix_make.(rs)
    @test all(Itest.(qs .* adjoint.(qs)))
    # @test all(qs .* rs .≈ [[0, 0, 5], [3, 0, 0]])
end