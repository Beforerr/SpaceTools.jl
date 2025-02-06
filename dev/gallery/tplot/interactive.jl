using Dates
using DimensionalData
using SpaceTools
using CairoMakie

t0 = DateTime(2000)
t1 = DateTime(2000, 1, 10)

function func(t0, t1)
    x = t0:Day(1):t1
    y = sin.(1:length(x))
    DimArray(y, Ti(x))
end

f, axes = tplot(func, t0, t1)

dt = Day(1)

record(f, "assets/interactive.mp4", 1:5; framerate=2) do n
    tlims!(t0 - n * dt, t1 + n * dt)
    sleep(0.5)
end;

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
