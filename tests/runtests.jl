using Test
using AMR

@testset "ptp" begin
  a = rand(3,3)
  b = rand(3,3)
  c = a + 1.0im * b
  @test ptp(c,1) == ptp(a,1) + 1.0im * ptp(b,1)
end
