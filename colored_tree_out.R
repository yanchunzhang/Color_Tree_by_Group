library(getopt)
library(ape)

spec = matrix(c(
    'input', 'i', 1, 'character',
    'edgecolor', 'c', 1, 'character',
    'out', 'o', 1, 'character'
), byrow=TRUE, ncol=4)

opt = getopt(spec)

rawtree <- read.tree(file = opt$input)
color <- read.table(opt$edgecolor, header=FALSE)
myCol <- as.vector(color$V1)

pdf(opt$out)
plot(rawtree, typ="unrooted", show.tip.label=F, edge.width=0.5, edge.color=myCol, show.node.label=T)
add.scale.bar()
dev.off()

