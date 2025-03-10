"""
Core functionality for time series plotting.
This file contains the main `tplot` function and its variants.
"""

"""
    tplot(f, tas; legend=(; position=Right()), link_xaxes=true, link_yaxes=false, rowgap=5, transform=transform_pipeline, kwargs...)

Lay out multiple time series across different panels (rows) on one Figure / GridPosition `f`

If `legend` is `nothing`, no legend will be added to the plot. Otherwise, `legend` can be a `NamedTuple` containing options for legend placement and styling.
By default, the time series are transformed via `transform_pipeline`, which is extensible via `transform`.

See also: [`tplot_panel`](@ref), [`transform_pipeline`](@ref), [`transform`](@ref)
"""
function tplot(f::Drawable, tas, args...; legend=(; position=Right()), link_xaxes=true, link_yaxes=false, rowgap=5, transform=transform_pipeline, axis=(;), kwargs...)
    tas = transform(tas)
    palette = [(i, 1) for i in 1:length(tas)]
    gaps = map(palette, tas) do pos, ta
        gp = f[pos...]
        pap = tplot_panel(gp, ta, args...; axis=axis_attributes(ta; axis...), kwargs...)
        # Hide redundant x labels
        link_xaxes && pos[1] != length(tas) && hidexdecorations!.(pap.axis, grid=false)
        pap
    end

    axs = reduce(vcat, getproperty.(gaps, :axis))
    link_xaxes && linkxaxes!(axs...)
    link_yaxes && linkyaxes!(axs...)

    !isnothing(legend) && add_legend!.(gaps; legend...)

    !isnothing(rowgap) && rowgap!(f.layout, rowgap)
    FigureAxes(f, axs)
end

tplot(f::Drawable, ta::SupportTypes, args...; kwargs...) = tplot(f, (ta,), args...; kwargs...)
tplot(tas, args...; figure=(;), kwargs...) = tplot(Figure(; figure...), tas, args...; kwargs...)

function tplot! end
