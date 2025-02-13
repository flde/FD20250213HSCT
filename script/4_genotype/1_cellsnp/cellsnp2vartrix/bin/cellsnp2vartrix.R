####################
### load_cellsnp ###
####################
load_cellsnp <- function(cellsnp_in_dir) {
    
    # Load files 
    vcf <- read.delim(paste0(cellsnp_in_dir, "/cellSNP.base.vcf.gz"), header=FALSE, comment.char="#", stringsAsFactors=FALSE)
    cell_id <- read.delim(paste0(cellsnp_in_dir, "/cellSNP.samples.tsv"), header=FALSE)

    ALT_COUNTS <- Matrix::readMM(paste0(cellsnp_in_dir, "/cellSNP.tag.AD.mtx")) # Counts for ALT alleles
    ALT_REF_COUNTS <- Matrix::readMM(paste0(cellsnp_in_dir, "/cellSNP.tag.DP.mtx")) # Counts for ALT + REF alleles
    OTHER_COUNTS <- Matrix::readMM(paste0(cellsnp_in_dir, "/cellSNP.tag.OTH.mtx")) # Counts for other alleles except ALT and REF

    # Set row and colnames 
    colnames(ALT_COUNTS) <- colnames(ALT_REF_COUNTS) <- colnames(OTHER_COUNTS) <- cell_id[, 1]
    rownames(ALT_COUNTS) <- rownames(ALT_REF_COUNTS) <- rownames(OTHER_COUNTS) <- vcf[, 2]
    
    # Compute REF and TOTAL counts
    REF_COUNTS <- ALT_REF_COUNTS-ALT_COUNTS # Counts for REF alleles 
    TOTAL_COUNTS <- REF_COUNTS+ALT_COUNTS+OTHER_COUNTS # Counts for total alleles
    
    # Compute frequencies 
    REF_RATIO <- Matrix::rowSums(REF_COUNTS) / Matrix::rowSums(TOTAL_COUNTS) # Frequency of REF alleles
    ALT_RATIO <- Matrix::rowSums(ALT_COUNTS) / Matrix::rowSums(TOTAL_COUNTS) # Frequency of ALT alleles 
    OTHER_RATIO <- Matrix::rowSums(OTHER_COUNTS) / Matrix::rowSums(TOTAL_COUNTS) # Frequency of OTHER alleles 

    return(list(cellsnp_in_dir=cellsnp_in_dir, vcf=vcf, cell_id=cell_id, TOTAL_COUNTS=TOTAL_COUNTS, REF_RATIO=REF_RATIO, ALT_RATIO=ALT_RATIO, OTHER_RATIO=OTHER_RATIO, ALT_COUNTS=ALT_COUNTS, REF_COUNTS=REF_COUNTS, ALT_REF_COUNTS=ALT_REF_COUNTS, OTHER_COUNTS=OTHER_COUNTS))
    
}

###################
### cllsnp_plot ###
###################
cllsnp_plot <- function(cellsnp) {
    
    p_1 <- ggplot(data.frame(TOTAL_COUNTS=log10(Matrix::rowSums(cellsnp$TOTAL_COUNTS))), aes(x=TOTAL_COUNTS)) + geom_histogram(bins=50) + scale_y_log10() + ggtitle("Total counts", subtitle=basename(cellsnp$cellsnp_in_dir))
    p_2 <- ggplot(data.frame(REF_RATIO=cellsnp$REF_RATIO), aes(x=REF_RATIO)) + geom_histogram(bins=50) + geom_histogram(bins=50) + scale_y_log10() + ggtitle("Frequency REF", subtitle=basename(cellsnp$cellsnp_in_dir))
    p_3 <- ggplot(data.frame(ALT_RATIO=cellsnp$ALT_RATIO), aes(x=ALT_RATIO)) + geom_histogram(bins=50) + geom_histogram(bins=50) + scale_y_log10() + ggtitle("Frequency ALT", subtitle=basename(cellsnp$cellsnp_in_dir))
    p_4 <- ggplot(data.frame(OTHER_RATIO=cellsnp$OTHER_RATIO), aes(x=OTHER_RATIO)) + geom_histogram(bins=50) + geom_histogram(bins=50) + scale_y_log10() + ggtitle("Frequency OTH", subtitle=basename(cellsnp$cellsnp_in_dir))
    p_5 <- ggplot(data.frame(REF_RATIO=cellsnp$REF_RATIO, ALT_RATIO=cellsnp$ALT_RATIO), aes(x=REF_RATIO, y=ALT_RATIO)) + geom_point() + ggtitle("Frequency REF vs ALT", subtitle=basename(cellsnp$cellsnp_in_dir))
    p_6 <- ggplot(data.frame(REF_RATIO=cellsnp$REF_RATIO, OTHER_RATIO=cellsnp$OTHER_RATIO), aes(x=REF_RATIO, y=OTHER_RATIO)) + geom_point() + ggtitle("Frequency REF vs OTHER", subtitle=basename(cellsnp$cellsnp_in_dir))
    
    p <- p_1 + p_2 + p_3 + p_4 + p_5 + p_6 + plot_layout(nrow=1)
    
    return(p)
    
}

###################
#### set_select ###
###################
set_select <- function(x) {
    
    select <- c(NA, NA, NA)
    ratio <- x[1:3]
    counts <- x[4:6]
    
    # Order ratios for testing 
    ref_ratio <- sort(ratio, decreasing=TRUE)[1]
    alt_ratio <- sort(ratio, decreasing=TRUE)[2]
    oth_ratio <- sort(ratio, decreasing=TRUE)[3]
    
    # Case 1
    if((sum(ratio==ref_ratio)==1) & (sum(ratio==alt_ratio)==1) & (sum(ratio==oth_ratio)==1)) {
        
        select[which(ratio==ref_ratio)] <- "REF"
        select[which(ratio==alt_ratio)] <- "ALT"
        select[which(ratio==oth_ratio)] <- "OTH"
        
        return(select)
    
    } 
    
    # Case 2 
    else if (sum(ratio==ref_ratio)==2) {
        
        counts[which(ratio!=ref_ratio)] <- NA
        
        ref_counts <- sort(counts, decreasing=TRUE, na.last=TRUE)[1]
        alt_counts <- sort(counts, decreasing=TRUE, na.last=TRUE)[2]
        
        if(ref_counts!=alt_counts) {
            
            select[which(counts==ref_counts)] <- "REF"
            select[which(counts==alt_counts)] <- "ALT"
            select[which(is.na(counts))] <- "OTH"
            
            return(select)
            
            
        }
        
        else if (ref_counts==alt_counts) {
            
            select[which(ratio==ref_ratio)[1]] <- "REF"
            select[which(ratio==alt_ratio)[2]] <- "ALT"
            select[which(is.na(counts))] <- "OTH"
            
            return(select)
            
        }
        
    }
    
    # Case 3 
    else if (sum(ratio==alt_ratio)==2) {
        
        counts[which(ratio!=alt_ratio)] <- NA
        
        alt_counts_1 <- sort(counts, decreasing=TRUE, na.last=TRUE)[1]
        alt_counts_2 <- sort(counts, decreasing=TRUE, na.last=TRUE)[2]
        
        if(alt_counts_1!=alt_counts_2) {
            
            select[which(ratio==ref_ratio)] <- "REF"
            select[which(counts==alt_counts_1)] <- "ALT"
            select[which(counts==alt_counts_2)] <- "OTH"
            
            return(select)
            
        }
        
        else if (alt_counts_1==alt_counts_2) {
            
            select[which(ratio==ref_ratio)] <- "REF"
            select[which(ratio==alt_ratio)[1]] <- "ALT"
            select[which(ratio==alt_ratio)[2]] <- "OTH"
            
            return(select)
            
        }
        
    }
    
    # Case 4
    else {
        
        message("All variants equal")
        
        select[1] <- "REF"
        select[2] <- "ALT"
        select[3] <- "OTH"
        
        return(select)
        
    }
    
}

###################
### get_select ####
###################
get_select <- function(SELECT, MAT, mode) {
    
    INDEX_1 <- which(SELECT[, 1]==mode)
    INDEX_2 <- which(SELECT[, 2]==mode)
    INDEX_3 <- which(SELECT[, 3]==mode)
    
    MAT_1 <- MAT[[1]][INDEX_1, ]
    MAT_2 <- MAT[[2]][INDEX_2, ]
    MAT_3 <- MAT[[3]][INDEX_3, ]
    
    MAT <- rbind(MAT_1, MAT_2, MAT_3)
    
    # Order Matrix 
    MAT <- MAT[order(c(INDEX_1, INDEX_2, INDEX_3)), ]
    
    return(MAT)
    
}

################################
#### vartrix_cellsnp_vartrix ###
################################
vartrix_cellsnp_vartrix <- function(cellsnp, cellsnp_out_dir, minMAF=NULL) {
    
    # Check if out dir identical to in dir  
    if (cellsnp$cellsnp_in_dir == cellsnp_out_dir) {
        
        stop("Error: output dir should not be the input dir!")
    
    }
    
    # Check if out dir excists 
    if (!dir.exists(cellsnp_out_dir)) {
        
        dir.create(cellsnp_out_dir, recursive=TRUE)
    
    }
    
    # Select REF and ALT 
    RATIO <- data.frame(REF_RATIO=cellsnp$REF_RATIO, ALT_RATIO=cellsnp$ALT_RATIO, OTHER_RATIO=cellsnp$OTHER_RATIO)
    COUNTS <- data.frame(REF_COUNTS=Matrix::rowSums(cellsnp$REF_COUNTS), ALT_COUNTS=Matrix::rowSums(cellsnp$ALT_COUNTS), OTHER_COUNTS=Matrix::rowSums(cellsnp$OTHER_COUNTS))
    SELECT <- apply(cbind(RATIO, COUNTS), 1, set_select, simplify=TRUE) %>% t()
    
    # Extract Data
    MAT <- list(REF_COUNTS=cellsnp$REF_COUNT, ALT_COUNTS=cellsnp$ALT_COUNTS, OTHER_COUNTS=cellsnp$OTHER_COUNTS)
    REF_MAT <- get_select(SELECT, MAT, mode="REF")
    ALT_MAT <- get_select(SELECT, MAT, mode="ALT")
    OTH_MAT <- get_select(SELECT, MAT, mode="OTH")
    
    # SET VCF file 
    VCF <- cellsnp[["vcf"]]
    VCF$V8 <- paste0("AD=", Matrix::rowSums(ALT_MAT), ";DP=", Matrix::rowSums(ALT_MAT)+Matrix::rowSums(REF_MAT), ";OTH=", Matrix::rowSums(OTH_MAT))
    
    # Filter by minMAF
    if(!is.null(minMAF)) {
        
        minMAF_FILTER <- Matrix::rowSums(ALT_MAT)/(Matrix::rowSums(REF_MAT)+Matrix::rowSums(ALT_MAT)) >= minMAF
        
        REF_MAT <- REF_MAT[minMAF_FILTER, , drop=FALSE]
        ALT_MAT <- ALT_MAT[minMAF_FILTER, , drop=FALSE]
        OTH_MAT <- OTH_MAT[minMAF_FILTER, , drop=FALSE]
        
        VCF <- VCF[minMAF_FILTER, , drop=FALSE]
        
    }
    
    # Write output files 
    write.table(cellsnp$cell_id, file=paste0(cellsnp_out_dir, "/barcodes.tsv"), row.names=FALSE, col.names=FALSE, sep="\t")
    
    Matrix::writeMM(REF_MAT, file=paste0(cellsnp_out_dir, "/ref.mtx")) # Counts for REF alleles
    Matrix::writeMM(ALT_MAT, file=paste0(cellsnp_out_dir, "/alt.mtx")) # Counts for ALT alleles
    Matrix::writeMM(OTH_MAT, file=paste0(cellsnp_out_dir, "/oth.mtx")) # Counts for OTH alleles
    
    colnames(VCF) <- c("#CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "INFO")
    write.table(VCF, file=paste0(cellsnp_out_dir, "/cellSNP.base.vcf"), quote=FALSE, sep="\t", row.names=FALSE)
    
}