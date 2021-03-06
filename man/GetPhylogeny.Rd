% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetPhylogeny.R
\name{GetPhylogeny}
\alias{GetPhylogeny}
\title{Get taxonomy table}
\usage{
GetPhylogeny(chip, phylogeny.version = "full", data.dir = NULL)
}
\arguments{
\item{chip}{chip type (e.g. 'HITChip')}

\item{phylogeny.version}{'full' or 'filtered' 
(latter is the basis for species/L1/L2 summarization)}

\item{data.dir}{Data directory path}
}
\value{
phylogeny mapping table
}
\description{
Get phylogeny for phylogenetic microarrays (mainly HITChip)
}
\examples{
# tax.table <- GetPhylogeny('HITChip', 'full')
}
\author{
Contact: Leo Lahti \email{microbiome-admin@googlegroups.com}
}
\references{
See citation('microbiome')
}
\keyword{utilities}

