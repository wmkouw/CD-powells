using ForwardDiff
using LaTeXStrings
using StatsPlots
using Plots
pyplot()

let

"""Function"""

# Objective
f(x::Vector) = -(x[1]*x[2] + x[2]*x[3] + x[1]*x[3])
Ω(x::Vector) = sum((abs.(x) .- 1).^2)
h(x::Vector) = f(x) + Ω(x)

# Minimization step
function g(x::Vector, i::Integer)

	if i == 1
		# Closed-form solution
		g_i = (1 + abs(x[2] + x[3])/2)*sign(x[2] + x[3])

	elseif i == 2
		# Closed form solution
		g_i = (1 + abs(x[1] + x[3])/2)*sign(x[1] + x[3])

	elseif i == 3
		# Closed form solution
		g_i = (1 + abs(x[1] + x[2])/2)*sign(x[1] + x[2])
	end
	return g_i
end

"""Coordinate Descent"""

# Number of iterations
K = 2

# Fix step size
α = 1.0

# Initialize coordinates
ϵ = 1e-3
x = [-1. - ϵ, 1. + ϵ/2, -1. - ϵ/4]

# Preallocate result array
global xx = zeros(K*3,3)

# Initalize visualization
scatter([x[1]], [x[2]], [x[3]],
		color="red",
		markerstrokecolor=nothing,
		label="x^0",
		xlims=(-1.5, 1.5),
		ylims=(-1.5, 1.5),
		zlims=(-1.5, 1.5),
		xlabel=L"x_1",
		ylabel=L"x_2",
		zlabel=L"x_3")

# Visualize stationary points
scatter!([+1], [+1], [+1], color="green", label="min", markerstrokecolor=nothing)
scatter!([-1], [-1], [-1], color="green", label="", markerstrokecolor=nothing)

# Loop over iterations
anim = @animate for k = 1:K*3

	# Keep track of x
	println(x)
	xx[k, :] = x

	# Update index
	i = (k-1) % 3 + 1
	println(i)

	# Update coordinate
	x[i] = g(x, i)

	# Visualization
	plot!([xx[k,1], x[1]],
	 	  [xx[k,2], x[2]],
		  [xx[k,3], x[3]],
	      color="blue",
	 	  label="",
	 	  markerstrokecolor=nothing)
end

gif(anim, "powells.gif", fps=2)

end
