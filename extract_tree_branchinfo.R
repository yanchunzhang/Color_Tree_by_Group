library("getopt")
library("ape")

spec = matrix(c(
    'input', 'i', 1, "character",
    'label', 'l', 1, "character",
    'edge',  'e', 1, "character"
), byrow=TRUE, ncol=4)

opt = getopt(spec)

#print(opt$input)
#print(opt$label)
if ( is.null(opt$label) ) {opt$label_out = "tree.tiplabel"}
if ( is.null(opt$edge) ) { opt$edge_out = "tree.edge"}

tree <- read.tree(file = opt$input)

sink(opt$label)
as.matrix(tree$tip.label)
sink()

sink(opt$edge)
tree$edge
sink()

