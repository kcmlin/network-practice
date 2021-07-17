#######################################
# Practice Visualizing Networks Using Selected Publication Data
#
# Katherine Schaughency
# 16 July 2021
# ----------------------------------- #
# Reference: 
# https://kateto.net/netscix2016.html
#######################################

#---------------------------------------------------------------------------#
#
# SECTION 1: GLOVAL ENVIRONMENT ----
#
#---------------------------------------------------------------------------#

# --------------------------------- #
# Clean R console - Remove all current objects

rm(list = ls()) 

# --------------------------------- #
# load R package

library(igraph)  # create networks

#---------------------------------------------------------------------------#
#
# SECTION 2: PRACTICE USING EXAMPLES & ADD MY NOTES ----
#
#---------------------------------------------------------------------------#

# --------------------------------- #
# Network Example 1

# create network
g1 <- graph(edges=c(1,2,      # 1 and 2 are connected
                    2,3,      # 2 and 3 are connected
                    3,1),     # 3 and 1 are connected
            n=3,              # 3 nodes
            directed=FALSE)   # not directional (default: directional) 

# preview data
g1

E(g1) # list edges
V(g1) # list vertices (nodes)

g1[]  # directly examine the network matrix. 
      # NOTE: since it's not directional, both sides of the triangles are filled (see: 1->3 and 3->1)

# plot
plot(g1) 

# --------------------------------- #
# Network Example 2

# create network
g2 <- graph(edges=c(1,2, 2,3, 3, 1), # 1 to 2, 2 to 3, 3 to 1
            n=10)                    # 10 nodes (node 4 to node 10 are not connected)
                                     # directed = TRUE (default)

# preview data
g2

E(g2) # list edges
V(g2) # list vertices (nodes)

g2[]  # directly examine the network matrix. 
      # NOTE: since it's directional, NOT both sides of the triangles are filled (see: 1->2 and 2->1)

# plot
plot(g2)   


# --------------------------------- #
# Network Example 3

# create network
# NOTE: When the edge list has vertex names, the number of nodes is not needed
# NOTE: node: not specified; directed = TRUE (default)
g3 <- graph( c("John", "Jim",   # edges is the first argument, "edges =" was assumed
               "Jim",  "Jill", 
               "Jill", "John")) 

# preview data
g3

E(g3) # list edges
V(g3) # list vertices (nodes)
g3[]  # directly examine the network matrix. 

# plot
plot(g3)   

# --------------------------------- #
# Network Example 4

# create network
# NOTE: total number of nodes is not specified because we are using vertex names (nodes)
# NOTE: to add additional nodes (not connected), we can specify isolates
g4 <- graph( edges = c("John", "Jim", 
                       "Jim", "Jack",     # NOTE: Jim points to John twice
                       "Jim", "Jack", 
                       "John", "John"),   # NOTE: John points to himself
             isolates=c("Jesse", "Janis", "Jennifer", "Justin") )  

# preview data
# NOTE: It does not list isolates. interesting!
g4   

E(g4)  # list edges
V(g4)  # list vertices (nodes)
g4[]   # directly examine the network matrix. 
g4[1,] # pull the first row of the network matrix

# add attributes to nodes and edges
V(g4)$name   # automatically generated when using vertex names (nodes) to create the network (edges).
             # this includes the isolates.
             # [1] "John"     "Jim"      "Jack"     "Jesse"    "Janis"    "Jennifer"     "Justin"  

V(g4)$gender <- c("male",   # John
                  "male",   # Jim
                  "male",   # Jack
                  "male",   # Jesse
                  "female", # Janis
                  "female", # Jennifer
                  "male")   # Justin

E(g4)$type <- "Team A" # Create an edge attribute called "type", assign "Team A" to all edges.
                       # NOTE: Isolates do NOT have edges (lines/arrows)

E(g4)$weight <- 10    # Create an edge weight, setting all existing edges to 10.
                      # NOTE: Isolates do NOT have edges (lines/arrows). Hence, no weights.

# preview attributes
edge_attr(g4)
vertex_attr(g4)
graph_attr(g4)

# plot
plot(g4)   

# modify plot
plot(g4, 
     edge.arrow.size=.5, 
     edge.curved=0.2,
     vertex.color="gold", 
     vertex.size=15, 
     vertex.frame.color="gray", 
     vertex.label.color="black", 
     vertex.label.cex=0.8, 
     vertex.label.dist=2)

# modify plot
plot(g4, 
     edge.arrow.size=.5, 
     vertex.color=c("pink", "skyblue")[1+(V(g4)$gender=="male")], 
                                               # That is -- male: sky blue; female: pink
                                               # Background --
                                               #     V(g4)$gender=="male"
                                               #         [1]  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
                                               #     as.numeric((V(g4)$gender=="male"))
                                               #         [1] 1 1 1 1 0 0 1
                                               #  Hence --
                                               #     1+(V(g4)$gender=="male")
                                               #         [1] 2 2 2 2 1 1 2
                                               #  Therefore --
                                               #     2 = skyblue and 1 = pink
     vertex.label.color="black", 
     vertex.label.dist=1.5) 

# modify graph
# NOTE from the source website:
#       "The graph g4 has two edges going from Jim to Jack, and a loop from John to himself. 
#        We can simplify our graph to remove loops & multiple edges between the same nodes. 
#        Use edge.attr.comb to indicate how edge attributes are to be combined - possible 
#        options include sum, mean, prod (product), min, max, first/last (selects the first/last 
#        edge’s attribute). Option “ignore” says the attribute should be disregarded and dropped.

g4s <- simplify(g4,                       # the original network example 4
                remove.multiple = TRUE,   # the original network: Jim to Jack appeared twice
                remove.loops = FALSE,     # the original network: John points to John (himself)
                edge.attr.comb=c(weight="sum", type="ignore"))

plot(g4s, vertex.label.dist=1.5)
      
# --------------------------------- #
# Network Example 5
# NOTE: Small graphs can also be generated with a description of this kind: 
#       - for undirected tie, 
#       +- or -+ for directed ties pointing left & right, 
#       ++ for a symmetric tie, and 
#       “:” for sets of vertices.

# plot networks
plot(graph_from_literal(a---b, b---c))  # the number of dashes doesn't matter
plot(graph_from_literal(a--+b, b+--c))
plot(graph_from_literal(a+-+b, b+-+c)) 
plot(graph_from_literal(a:b:c---c:d:e))                    # this one is interesting
plot(graph_from_literal(a-b-c-d-e-f, a-g-h-b, h-e:f:i, j)) # this one is really interesting



#---------------------------------------------------------------------------#
#
# SECTION 3: PRACTICE USING SELECTED PUBLICATION ----
#
#---------------------------------------------------------------------------#


