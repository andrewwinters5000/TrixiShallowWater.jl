module TestExamplesUpstream

using Test
using TrixiShallowWater

include("test_trixi.jl")

EXAMPLES_DIR = pkgdir(TrixiShallowWater, "examples")

# Start with a clean environment: remove output directory if it exists
outdir = "out"
isdir(outdir) && rm(outdir, recursive = true)

# Run upstream tests for each mesh and dimension to test compatibility with Trixi.jl
@testset "Upstream tests" begin
#! format: noindent

# Run tests for TreeMesh
# Shallow water wet/dry 1D
@trixi_testset "elixir_shallowwater_ec.jl" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "tree_1d_dgsem",
                                 "elixir_shallowwater_ec.jl"),
                        l2=[
                            0.24476140682560343,
                            0.8587309324660326,
                            0.07330427577586297
                        ],
                        linf=[
                            2.1636963952308372,
                            3.8737770522883115,
                            1.7711213427919539
                        ],
                        tspan=(0.0, 0.25))
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end

@trixi_testset "TreeMesh1D: elixir_shallowwater_well_balanced_nonperiodic.jl with wall boundary" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "tree_1d_dgsem",
                                 "elixir_shallowwater_well_balanced_nonperiodic.jl"),
                        l2=[
                            1.7259643614361866e-8,
                            3.5519018243195145e-16,
                            1.7259643530442137e-8
                        ],
                        linf=[
                            3.844551010878661e-8,
                            9.846474508971374e-16,
                            3.844551077492042e-8
                        ],
                        tspan=(0.0, 0.25),
                        boundary_condition=boundary_condition_slip_wall)
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end

# Shallow water wet/dry 2D
# TreeMesh2D
@trixi_testset "TreeMesh2D: elixir_shallowwater_conical_island.jl" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "tree_2d_dgsem",
                                 "elixir_shallowwater_conical_island.jl"),
                        l2=[
                            0.045928568956367245,
                            0.16446498697148945,
                            0.16446498697148945,
                            0.0011537702354532694
                        ],
                        linf=[
                            0.21098104635388315,
                            0.9501826412445212,
                            0.9501826412445218,
                            0.021790250683516282
                        ],
                        tspan=(0.0, 0.025))
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end
# Unstructured2D
@trixi_testset "Unstructured2D: elixir_shallowwater_wall_bc_shockcapturing.jl" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "unstructured_2d_dgsem",
                                 "elixir_shallowwater_wall_bc_shockcapturing.jl"),
                        l2=[
                            0.04444388691670699,
                            0.1527771788033111,
                            0.1593763537203512,
                            6.225080476986749e-8
                        ],
                        linf=[
                            0.6526506870169639,
                            1.980765893182952,
                            2.4807635459119757,
                            3.982097158683473e-7
                        ],
                        tspan=(0.0, 0.05),
                        surface_flux=(FluxHydrostaticReconstruction(FluxHLL(min_max_speed_naive),
                                                                    hydrostatic_reconstruction_audusse_etal),
                                      flux_nonconservative_audusse_etal))
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end
# Structured2D
@trixi_testset "Structured2D: elixir_shallowwater_conical_island.jl" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "structured_2d_dgsem",
                                 "elixir_shallowwater_conical_island.jl"),
                        l2=[
                            0.04592856895636503,
                            0.16446498697148132,
                            0.16446498697148126,
                            0.0011537702354532122
                        ],
                        linf=[
                            0.21098104635388404,
                            0.950182641244522,
                            0.950182641244521,
                            0.021790250683516296
                        ],
                        tspan=(0.0, 0.025))
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end
# P4estMesh2D
@trixi_testset "P4estMesh2D: elixir_shallowwater_perturbation_amr.jl" begin
    @test_trixi_include(joinpath(EXAMPLES_DIR, "p4est_2d_dgsem",
                                 "elixir_shallowwater_perturbation_amr.jl"),
                        l2=[
                            0.02263230105470324,
                            0.09090425233020173,
                            0.09124622065757255,
                            0.0011045848311422332
                        ],
                        linf=[
                            0.3118823726810007,
                            0.7855402508435719,
                            0.7401368273982774,
                            0.011669083581857587
                        ],
                        tspan=(0.0, 0.025))
    # Ensure that we do not have excessive memory allocations
    # (e.g., from type instabilities)
    let
        t = sol.t[end]
        u_ode = sol.u[end]
        du_ode = similar(u_ode)
        @test (@allocated Trixi.rhs!(du_ode, u_ode, semi, t)) < 1000
    end
end

# Clean up afterwards: delete output directory
@test_nowarn rm(outdir, recursive = true)
end # Upstream tests

end # module
