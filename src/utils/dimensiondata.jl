using DimensionalData.Lookups

const timeDimType = (Dim{:time}, Ti)

meta(da::AbstractDimArray) = metadata(da)

function standardize(x::AbstractDimArray; floatify=true)
    # Convert integer values to floats
    floatify && eltype(x) <: Integer && (x = modify(float, x))
    # Check if any of the dimensions match our time dimension types
    x = any(d -> d isa Dim{:time}, dims(x)) ? set(x, Dim{:time} => Ti) : x
end
tdim(t) = Ti(t)
tdim(t::DD.Dimension) = t

"""
    nt2ds(nt_arr, dim; fields=propertynames(first(nt_arr)))

Convert a NamedTuple array to a DimStack of DimArrays.
"""
function nt2ds(nt_arr, dim; fields=propertynames(first(nt_arr)))
    DimStack([
        DimArray(getfield.(nt_arr, field), dim; name=field)
        for field in fields
    ])
end

function nt2ds(nt_arr; sym=:time)
    dim = Dim{sym}(getfield.(nt_arr, sym))
    # filter the time dimension
    fields = propertynames(first(nt_arr))
    fields = filter(field -> field != sym, fields)
    nt2ds(nt_arr, dim; fields)
end

function rename(da::AbstractDimArray, new_name)
    rebuild(da; name=new_name)
end

modify_meta!(da; kwargs...) = (da.metadata = merge(da.metadata, kwargs))

function modify_meta(da, args...; kwargs...)
    meta = da.metadata

    # Create a dictionary from both positional pair arguments and keyword arguments
    pair_args = filter(arg -> arg isa Pair, collect(args))
    added_meta = merge(Dict(pair_args...), kwargs)

    new_meta = meta isa NoMetadata ? added_meta : merge(meta, added_meta)
    rebuild(da; metadata=new_meta)
end

"""
    amap(f, a, b)

Apply a function `f` to the intersection of `a` and `b`.

https://github.com/rafaqz/DimensionalData.jl/issues/914
"""
function amap(f, a::AbstractDimArray, b::AbstractDimArray)
    shared_selectors = DimSelectors(a)[DimSelectors(b)]
    f(a[shared_selectors], b[shared_selectors])
end