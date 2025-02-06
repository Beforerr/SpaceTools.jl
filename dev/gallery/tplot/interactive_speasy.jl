using Speasy
spz = speasy()

using Dates
using SpaceTools
using CairoMakie

t0 = DateTime("2008-09-05T10:00:00")
t1 = DateTime("2008-09-05T22:00:00")
tvars = [
    "cda/OMNI_HRO_1MIN/flow_speed",
    "cda/OMNI_HRO_1MIN/E",
    "cda/OMNI_HRO_1MIN/Pressure"
]
f, axes = tplot(tvars, t0, t1)

dt = Hour(12)

record(f, "assets/interactive_speasy.mp4", 1:5; framerate=1) do n
    tlims!(t0 - n * dt, t1 + n * dt)
    sleep(1)
end;

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl
