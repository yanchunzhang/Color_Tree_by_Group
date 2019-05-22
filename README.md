# Color_Tree_by_Group
Assign edge color of one phylogenetic tree based on group information of samples, then output the colored tree by R.

First, start with a phylogenetic tree in .nwk format, we read the tree in R and extract the tip(sample) and edge(branch) information from the tree.

Rscript extract_tree_info.R --

Then we will get two files named tip.info and edge.info, in which content are like:


Second, suppose we have a file containing the group information of all samples, samples without a certain group can be treated as mixed then assigned as gray color. Then we can assign group or color for each node in the tree based on color of all its child nodes. If all child nodes have a same certain group or color, then the node inherit directly the same color of its children; else the node would be assigned as gray. For all edges(branches), its color is determined by the two node at its both ends.

perl color_tree_by_group.pl --

Third, read tree and color information of edges in R and draw the tree.

Rscript draw.tree.R

