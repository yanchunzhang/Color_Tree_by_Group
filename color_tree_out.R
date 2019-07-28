library(getopt)
library(ape)

spec = matrix(c(
    'input', 'i', 1, 'character',
    'edgecolor', 'c', 1, 'character',
    'out', 'o', 1, 'character',
    'type', 't', 1, 'character',
    'nodelabel', 'n', 1, 'character',
    'leaf', 'l', 1, 'character',
    'width', 'w', 1, 'numeric',
    'height', 'h', 1, 'numeric'
), byrow=TRUE, ncol=4)

opt = getopt(spec)

rawtree <- read.tree(file = opt$input)
color <- read.table(opt$edgecolor, header=FALSE)
myCol <- as.vector(color$V1)

if (is.null(opt$type)) {
    opt$type="phylogram"
}

if(is.null(opt$nodelabel)) {
    opt$nodelabel <- (1 > 2)
} else{
    opt$nodelabel <- as.logical(opt$nodelabel)
}

if(is.null(opt$leaf)) {
    opt$leaf <- FALSE
} else {
    opt$leaf <- as.logical(opt$leaf)
}

if(is.null(opt$width)) {
    opt$width <- 100
}

if(is.null(opt$width)) {
    opt$height <- 40
}

pdf(opt$out, width=opt$width, height = opt$height)
plot(rawtree, typ=opt$type, show.tip.label=opt$leaf, edge.width=0.5, edge.color=myCol, show.node.label=opt$nodelabel)
add.scale.bar()
dev.off()
