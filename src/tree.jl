@with_kw mutable struct Node
	dim::Int = 0
	children::Vector{Node} = []
	domain::Tuple{Vector{Float64}, Vector{Float64}} = ([], [])
end

function Node(xmin::Vector{Float64}, xmax::Vector{Float64})
	dim = length(xmin)
	@assert dim == length(xmax)
	return Node(dim=dim, domain=(xmin, xmax))
end

Base.show(io::IO, node::Node) = print(io, "Node")

AbstractTrees.children(t::Node) = t.children
# Base.getindex(t::Node, i::Integer) = children(t)[i]
# Base.getindex(t::Node, i::Integer, is::Integer...) = t[i][is...]
# isleaf(t::Node) = isempty(children(t))

function branch!(node::Node)
	children = repeat([deepcopy(node)], 2^node.dim)
	node.children = children
end

"""
Builds a uniform tree
"""
function buildtree(depth::Int, xmin::Vector{Float64}, xmax::Vector{Float64})
	tree = Node(xmin, xmax)

	for i in 1:depth
		for leaf in AbstractTrees.Leaves(AbstractTrees.Tree(tree))
			branch!(leaf.x)
		end
	end

	return tree
end