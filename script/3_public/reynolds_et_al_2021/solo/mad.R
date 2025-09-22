##############################################
# MAD analysis for doublet cluster detection #
##############################################

# Set working directory to project root
setwd("/research/peer/fdeckert/FD20220623HSCT/")

# Library

library_load <- suppressMessages(
    
    list(
        
        library(tidyverse)
        
    )
)

# Fetch command line arguments
args <- commandArgs(trailingOnly = TRUE)
file <- as.character(args)

# Read meta data file 
meta <- read.csv(file, row.names=1)

# Function to computes MAD for values of x greater the median
mad_upper <- function(x){
    
    x <- x-median(x)
    x_mad <- mad(x[x>0], center=0)
    return(x_mad)

}

# Doublet cluster 
doublet_stat <- dplyr::group_by(meta, leiden) %>% 
    dplyr::mutate(cluster_count=n()) %>% dplyr::ungroup() %>% 
    dplyr::group_by(leiden, solo_label, cluster_count) %>% 
    dplyr::summarise(doublet_ratio=n()) %>% dplyr::ungroup() %>% 
    dplyr::mutate(doublet_ratio=doublet_ratio/cluster_count) %>% 
    dplyr::filter(solo_label=="doublet")

doublet_stat$p=pnorm(doublet_stat$doublet_ratio, mean=median(doublet_stat$doublet_ratio), sd=mad_upper(doublet_stat$doublet_ratio), lower.tail=FALSE)
doublet_stat$fdr=p.adjust(doublet_stat$p, method="fdr")

# Update meta with doublet label from mad analysis 
meta$solo_mad_label <- ifelse(meta$leiden %in% doublet_stat[doublet_stat$fdr < 0.1, ][['leiden']], "doublet", "singlet")

# Write back output 
write.csv(meta, args)