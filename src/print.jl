const RAIL_COLORS = (
    # preserve yellow for future performance linting
    45, # light blue
    123, # light cyan
    150, # ???
    215, # orange
    231, # white
)
const N_RAILS = length(RAIL_COLORS)
const TYPE_ANNOTATION_COLOR = :light_cyan

printlnstyled(args...; kwarg...) = printstyled(args..., '\n'; kwarg...)

function print_rails(io, depth)
    for i = 1:depth
        color = RAIL_COLORS[i%N_RAILS+1]
        printstyled(io, '│'; color)
    end
end
