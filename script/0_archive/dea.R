#####################
### Load packages ###
#####################
library_load <- suppressMessages(
    
    list(
        
        # Seurat 
        library(Seurat), 
        library(SeuratWrappers), 
        library(SCOPfunctions), # utils_big_as.matrix()
        
        # DEA 
        library(MAST), 
        library(limma), 
        library(edgeR), 
        
        # Data 
        library(tidyverse), 
        library(openxlsx),
        
        # Plotting 
        library(ggrepel)
        
    )
)

####################
### Filter genes ###
####################
feature_select <- function(so, cnt_min=3, cell_min=3, grouping_var=NULL, random_effect_var=NULL, ident_1=NULL, ident_2=NULL, check_intersect=FALSE) {
    
    if(is.null(grouping_var)) {
        
        # Get count data 
        cnt <- GetAssayData(so, assay="RNA", slot="counts")
        cnt <- cnt[rowSums(cnt>=cnt_min)>=cell_min, ]
        
        # Check if any cells presents 
        if(nrow(cnt)==0) {message("No cells left after gene filter"); return(NULL)}

        # Create fresh Seurat object with filtered count matrix
        so <- CreateSeuratObject(counts=cnt, meta.data=so@meta.data)

        # Normalize
        so <- NormalizeData(so)

        return(so)
        
    } else if (!is.null(grouping_var)) {
        
        # feature_select with groups 
        cells_logical_1 <- so@meta.data[[grouping_var]] == ident_1
        cells_logical_2 <- so@meta.data[[grouping_var]] == ident_2

        # Subset meta data 
        meta <- droplevels(so@meta.data)

        meta_1 <- meta[cells_logical_1, ]
        meta_2 <- meta[cells_logical_2, ]

        # Subset counts 
        cnt <- GetAssayData(so, assay="RNA", slot="counts")
        cnt <- cnt[rowSums(cnt>=cnt_min)>=cell_min, ]

        cnt_1 <- cnt[, cells_logical_1]
        cnt_2 <- cnt[, cells_logical_2]
        
        # Check any overlap of gene expression between grouping_var 
        if(check_intersect) {
            
            genes_1 <- cnt_1[rowSums(cnt_1>=1)>0, ] %>% rownames()
            genes_2 <- cnt_2[rowSums(cnt_2>=1)>0, ] %>% rownames()
            
            genes <- intersect(genes_1, genes_2) 
            
            message(paste("Selecting genes by any overlap between idents from grouping", grouping_var))
            message(paste("Found", length(genes_1), "expressed in", ident_1))
            message(paste("Found", length(genes_2), "expressed in", ident_2))
            message(paste("Selecting", length(genes), "from intersect"))
            
        }

        # Split counts by random_effect_var and test genes 
        cnt_1 <- split(as.data.frame(cnt_1), f=meta[[random_effect_var]])
        cnt_2 <- split(as.data.frame(cnt_2), f=meta[[random_effect_var]])

        cnt_1 <- lapply(cnt_1, t)
        cnt_2 <- lapply(cnt_2, t)

        cnt_1 <- lapply(cnt_1, function(x) {colSums(x>=cnt_min)>cell_min})
        cnt_2 <- lapply(cnt_2, function(x) {colSums(x>=cnt_min)>cell_min})

        cnt_1 <- do.call(rbind, cnt_1)
        cnt_2 <- do.call(rbind, cnt_2)

        cnt_1 <- colSums(cnt_1) >= if(nrow(cnt_1)>1) {1} else {1}
        cnt_2 <- colSums(cnt_2) >= if(nrow(cnt_2)>1) {1} else {1}

        genes_1 <- names(cnt_1)[cnt_1]
        genes_2 <- names(cnt_1)[cnt_2]
        
        genes <- union(genes_1, genes_2)
        
        # Check if any cells presents 
        if(length(genes)<2) {message("No cells left after gene filter"); return(NULL)}
        
        message(paste("Feature select yields", length(genes), "for DEA"))
        
        # Create Seurat object with gene subset 
        cnt <- GetAssayData(so, assay="RNA", slot="counts")
        cnt <- cnt[genes, , drop=FALSE]

        so <- CreateSeuratObject(counts=cnt, meta=meta)
        
        return(so)
        
    }
    
}

#####################
### Filter groups ###
#####################
group_select <- function(so, grouping_var, random_effect_var, ident_1, ident_2) {
    
    # Set cells logical for idents
    cells_logical_1 <- so@meta.data[[grouping_var]] == ident_1
    cells_logical_2 <- so@meta.data[[grouping_var]] == ident_2
    
    # Count cells of random effect variable
    random_effect_var_n_1 <- so@meta.data[[random_effect_var]][cells_logical_1] %>% table() 
    random_effect_var_n_2 <- so@meta.data[[random_effect_var]][cells_logical_2] %>% table()
    
    # Check reandom effect groups which indirectly also checks ident to be greater 1 
    check_1 <- sum(random_effect_var_n_1 >= 10)
    check_2 <- sum(random_effect_var_n_2 >= 10)
    
    # Return subset Seurat object or NULL 
    if(check_1 > 0 & check_2 > 0) {
        
        random_effect_var_n_1 <- random_effect_var_n_1[random_effect_var_n_1 >= 10] 
        random_effect_var_n_2 <- random_effect_var_n_2[random_effect_var_n_2 >= 10]

        cells_logical <- so@meta.data[[random_effect_var]] %in% c(names(random_effect_var_n_1), names(random_effect_var_n_2))

        return(subset(so, cells=colnames(so)[cells_logical]))


    } else {
        
        return(NULL)

    }
       
}

###############
### MAST RE ###
###############
mast_re <- function(so, grouping_var, random_effect_var, ident_1, ident_2) {
    
    # Normalize 
    cnt <- GetAssayData(so, assay="RNA", slot="counts")
    nrm <- t(log2((1e6 * t(cnt) / so$nCount_RNA)+1))
    so@assays$RNA@data <- as(nrm, "CsparseMatrix")
    
    # Prepare MAST SingleCellAssay 
    sca <- suppressMessages(
    
        MAST::FromMatrix(

            exprsArray=utils_big_as.matrix(GetAssayData(so, assay="RNA", slot="data"), n_slices_init=1, verbose=FALSE),
            check_sanity=TRUE,
            cData=as.data.frame(so@meta.data)
            
        )
    
    )
    
    # Set grouping variables 
    sca[[grouping_var]] <- factor(sca[[grouping_var]], levels=c(ident_2, ident_1))
    
    # Formula 
    fmla <- as.formula(object=paste0(" ~ ", grouping_var, paste(" + (1 |", random_effect_var, ")", collapse="")))
    
    # Fit model parameters
    zlm_condition <- MAST::zlm(

        formula=fmla,
        sca=sca,
        method='glmer',
        ebayes=FALSE,
        strictConvergence=FALSE

    )
    
    # Log ratio test on the fited model 
    lrt_condition <- MAST::summary(object=zlm_condition, doLRT=paste0(grouping_var, ident_1))
    
    # Get DEA results
    dea_result <- data.frame(p_value=lrt_condition$datatable[contrast==paste0(grouping_var, ident_1) & component=='H', `Pr(>Chisq)`])
    
    # Get log2 fold change
    cells_logical_1 <- so@meta.data[[grouping_var]] == ident_1
    cells_logical_2 <- so@meta.data[[grouping_var]] == ident_2

    fc_results <- FoldChange(so, colnames(so)[cells_logical_1], colnames(so)[cells_logical_2], assay="RNA", slot="data", features=NULL)
    fc_results <- fc_results[lrt_condition$datatable$primerid %>% unique(), ]
    
    # Combine results 
    dea_result <- cbind(dea_result, fc_results)
    
    dea_result$p_val_adj = p.adjust(dea_result$p_val, method="fdr", n=nrow(dea_result))
    
    return(dea_result)
    
}

#####################
### Limma voom RE ###
#####################
limma_voom_re <- function(so, grouping_var, random_effect_var, ident_1, ident_2) {
    
    # https://rdrr.io/bioc/edgeR/man/voomLmFit.html
    
    # Get Counts 
    cnt <- GetAssayData(so, assay="RNA", slot="counts")

    # Design matrix 
    group <- so[[grouping_var, drop=TRUE]]
    group <- factor(group, levels=c(ident_2, ident_1))
    design <- model.matrix(~0+group)
    colnames(design) <- gsub("group", "", colnames(design))

    # Random effect var for blocking 
    block <- so[[random_effect_var, drop=TRUE]]
    
    voom_fit <- edgeR::voomLmFit(
    
        counts=cnt, 
        design=design, 
        block=block, 
        lib.size=so$nCount_RNA, 
        sample.weights=TRUE

    )
    
    # Contrast
    contrasts <- limma::makeContrasts(contrasts=paste0(ident_1, "-", ident_2), levels=colnames(design))
    contrasts_fit <- contrasts.fit(voom_fit, contrasts=contrasts)
    
    # eBayes fit 
    efit <- limma::eBayes(contrasts_fit)
    
    # Get results 
    dea_result <- limma::topTable(efit, sort.by="P", n=Inf, p.value=1, lfc=0, coef=1)
    dea_result <- dea_result[, c("logFC", "P.Value", "adj.P.Val")]
    colnames(dea_result) <- c("avg_log2FC", "p_value", "p_val_adj")
    
    # Get log2 fold change
    cells_logical_1 <- so@meta.data[[grouping_var]] == ident_1
    cells_logical_2 <- so@meta.data[[grouping_var]] == ident_2

    fc_results <- FoldChange(so, colnames(so)[cells_logical_1], colnames(so)[cells_logical_2], assay="RNA", slot="data", features=NULL)
    fc_results <- fc_results[rownames(dea_result), c("pct.1", "pct.2")]

    # Combine results 
    dea_result <- cbind(dea_result, fc_results)
    
    return(dea_result)
    
}

################
### EdgeR PB ###
################
edger_pb <- function(so, grouping_var, random_effect_var, ident_1, ident_2) {
    
    # Get Counts 
    cnt <- GetAssayData(so, assay="RNA", slot="counts")
    
    # Make pseudobulks by suming single cell counts
    pb <- t(as.matrix(cnt))
    pb <- split(as.data.frame(pb), f=as.character(so[[random_effect_var, drop=TRUE]]))
    pb <- lapply(names(pb), function(i) {x <- data.frame(counts=colSums(pb[[i]])); colnames(x) <- i; return(x)})
    pb <- do.call(cbind, pb)
    print(head(pb))
    
    
    # Prepare met design matrix 
    design <- unique(so@meta.data[, c(random_effect_var, grouping_var)])
    rownames(design) <- design[[random_effect_var]]
    # order by pseudo bulk count matrix and group 
    design <- design[colnames(pb), grouping_var, drop=FALSE]
    design <- droplevels(design)
    
    # Formula and design matrix
    formula <- as.formula(object=paste0(" ~", grouping_var))
    design <- model.matrix(formula, data=design)
    
    print(design)
    
    if(nrow(design) <= 2) {
        
        message("Not enough samples to estime dispersion")
        return(data.frame())
    
    }
    
    # Compute norm factors
    pb <- DGEList(as.matrix(pb))
    pb <- calcNormFactors(pb, method="TMM")
    
    # Estimate dispersion 
    pb <- estimateDisp(pb, design=design)

    # Fit model and perform LRT
    fit <- glmFit(pb, design=design)
    lrt <- glmLRT(fit)
    
    # Get DEA results
    dea_result <- topTags(lrt, n = Inf)[[1]][, c(1, 4, 5)]
    colnames(dea_result) <- c("avg_log2FC", "p_value", "p_val_adj")
    
    # Get log2 fold change
    cells_logical_1 <- so@meta.data[[grouping_var]] == ident_1
    cells_logical_2 <- so@meta.data[[grouping_var]] == ident_2

    fc_results <- FoldChange(so, colnames(so)[cells_logical_1], colnames(so)[cells_logical_2], assay="RNA", slot="data", features=NULL)
    fc_results <- fc_results[rownames(dea_result), c("pct.1", "pct.2")]

    # Combine results 
    dea_result <- cbind(dea_result, fc_results)
    
    return(dea_result)
    
}

####################
### DEA workflow ###
####################
dea_seurat <- function(so, mode, file, ident,  map=NULL, grouping_var=NULL, random_effect_var=NULL, ident_1=NULL, ident_2=NULL, only_pos=FALSE, logfc_threshold=0, min_pct=0, compute=TRUE, test_use="wilcox", cnt_min=0, cell_min=0, verbose=TRUE) {
    
    # Load results only if compute FALSE
    if(!compute) {dea <- readRDS(paste0(file, ".rds")); return(dea)}
    
    # Set Ident for comparison 
    so <- SetIdent(so, value=ident)
    
    # Build dummy mapping of idents to cell_types 
    if(is.null(map)) {
        
        map <- data.frame(ident=unique(so@meta.data[[ident]]), cell_type=unique(so@meta.data[[ident]]))
        map[[ident]] <- unique(so@meta.data[[ident]])
        
    }
    
    # Filter Seurat object by counts 
    so <- feature_select(so, cnt_min=cnt_min, cell_min=cell_min)
    
    # Set Ident for comparison 
    so <- SetIdent(so, value=ident)
    
    # DEA
    dea <- list()
    for(i in 1:nrow(map)) {
        
        # Select the column of map to split the Seurat object for DEA by ident 
        ident_i <- as.character(map[, ident][i])

        # Conserved marker DEA
        if (mode=="conserved") {
            
            if(verbose) message("Run DEA mode: Conserved")
            
            so <- SetIdent(so, value=ident)
            dea_result <- FindConservedMarkers(so, ident.1=ident_i, logfc.threshold=logfc_threshold, min.pct=min_pct, grouping.var=grouping_var, only.pos=only_pos, subset.ident=NULL, test.use=test_use, verbose=verbose)
            
        }
        
        # Marker DEA
        if (mode=="marker") {
            
            if(verbose) message("Run DEA mode: Marker")
            
            so <- SetIdent(so, value=ident)
            dea_result <- RunPresto(so, ident.1=ident_i, logfc.threshold=logfc_threshold, min.pct=min_pct, group.by=grouping_var, only.pos=only_pos, subset.ident=NULL, test.use=test_use, verbose=verbose)
        
        } 
        
        # Compare groups DEA
        if (mode=="compare") {
            
            if(verbose) message("Rund DEA mode: Compare")

            so_i <- subset(so, idents=ident_i)
            so_i <- feature_select(so_i, cnt_min=cnt_min, cell_min=cell_min)
            so_i <- SetIdent(so_i, value=grouping_var)
            dea_result <- RunPresto(so_i, ident.1=ident_1, ident.2=ident_2, logfc.threshold=logfc_threshold, min.pct=min_pct, group.by=grouping_var, only.pos=only_pos, subset.ident=NULL, test.use=test_use, verbose=verbose)
        
        }
        
        if (mode=="compare_mast_re") {
            
            if(verbose) message("Rund DEA mode: Compare (MAST RE)")

            so_i <- subset(so, idents=ident_i)
            so_i <- group_select(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
            if(!is.null(so_i)) {
                
                so_i <- feature_select(so_i, cnt_min=cnt_min, cell_min=cell_min, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                if(!is.null(so_i)) {
                    
                    so_i <- SetIdent(so_i, value=grouping_var)      
                    dea_result <- mast_re(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                    
                } else {
                    
                    dea_result <- data.frame()
                    
                }
                
            } else {
                
                message(paste("Group check failed for", ident_i))
                dea_result <- data.frame()
                
            }    

        }
        
        if (mode=="limma_voom_re") {
            
            if(verbose) message("Rund DEA mode: Compare (LIMMA VOOM RE)")
            
            message(paste("Ident used:", ident_i))

            so_i <- subset(so, idents=ident_i)
            so_i <- group_select(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
            if(!is.null(so_i)) {
                
                so_i <- feature_select(so_i, cnt_min=cnt_min, cell_min=cell_min, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                if(!is.null(so_i)) {
                    
                    so_i <- SetIdent(so_i, value=grouping_var)      
                    dea_result <- limma_voom_re(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                    
                } else {
                    
                    dea_result <- data.frame()
                    
                }
                
            } else {
                
                message(paste("Group check failed for", ident_i))
                dea_result <- data.frame()
                
            }
        
        }
            
        if (mode=="edger_pb") {
            
            if(verbose) message("Rund DEA mode: Compare (Edger LRT pseudo-bulk)")
            
            message(paste("Ident used:", ident_i))

            so_i <- subset(so, idents=ident_i)
            so_i <- group_select(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
            if(!is.null(so_i)) {
                
                so_i <- feature_select(so_i, cnt_min=cnt_min, cell_min=cell_min, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                if(!is.null(so_i)) {
                    
                    so_i <- SetIdent(so_i, value=grouping_var)      
                    dea_result <- edger_pb(so_i, grouping_var=grouping_var, random_effect_var=random_effect_var, ident_1=ident_1, ident_2=ident_2)
                    
                } else {
                    
                    dea_result <- data.frame()
                    
                }
                
            } else {
                
                message(paste("Group check failed for", ident_i))
                dea_result <- data.frame()
                
            }  

        }
        
        # Annotate results 
        if(nrow(dea_result)>0) {
            
            # Add meta data to result DEA
            dea_result$gene <- rownames(dea_result)
            dea_result$ident <- ident_i
            
            # Cell type annotation 
            dea_result <- dplyr::left_join(dea_result, map, by="ident")
            
        }
        
        dea[[as.character(ident_i)]] <- dea_result
        
    }
    
    # Output
    if(!is.null(file)) {
        
        # Remove failed idents 
        dea <- dea[lapply(dea, function(x) nrow(x)>0) %>% unlist()]
        
        # Write xlsx and rds
        openxlsx::write.xlsx(dea, paste0(file, ".xlsx"), colNames=TRUE)
        saveRDS(dea, paste0(file, ".rds"))

    }

    return(dea)

}

##############
### vp_dea ###
##############
vp_dea <- function(dea, log2_thold=1, adjpvalue_thold=0.05, top_label=10, title=NULL, conserved=FALSE, color_neg=RColorBrewer::brewer.pal(8, "Set1")[1], color_pos=RColorBrewer::brewer.pal(8, "Set1")[2]) {

    if(conserved) {
        
        dea <- dea %>% 
            dplyr::filter(sign(NaCl_avg_log2FC)==sign(CpG_avg_log2FC)) %>% 
            rowwise() %>% 
            dplyr::mutate(avg_log2FC=mean(NaCl_avg_log2FC, CpG_avg_log2FC)) %>% 
            dplyr::rename(p_val_adj=minimump_p_val) %>% 
            as.data.frame()
    }
    
    # Set rownames to genes
    if("gene" %in% colnames(dea)) {rownames(dea) <- dea$gene}
    
    # Check Inf log2FC 
    if(any(is.infinite(dea$avg_log2FC))) {
        
        print(dea[is.infinite(dea$avg_log2FC), ]$gene)
        dea <- dea[!is.infinite(dea$avg_log2FC), ]
        
    }
    
    # Annotate entries significance by log2_thold and adjpvalue_thold
    dea$p_val_adj <- ifelse(dea$p_val_adj == 0, .Machine$double.xmin, dea$p_val_adj)
    dea$sig <- ifelse(abs(dea$avg_log2FC) >= log2_thold & -log10(dea$p_val_adj) >= -log10(adjpvalue_thold), "s", "ns")
    
    # Set color based on significance and direction of dea e.g. positive and negative 
    dea$color <- ifelse(dea$sig == "s" & dea$avg_log2FC > 0, "s_pos", "ns")
    dea$color <- ifelse(dea$sig == "s" & dea$avg_log2FC < 0, "s_neg", dea$color)
    
    color <- c(color_neg, "gray", "black", color_pos)
    names(color) <- c("s_pos", "ns", "black", "s_neg")
    
    # Create labels based log2FC and p_val_adj
    dea_pos <- dea[dea$avg_log2FC > 0 & dea$sig == "s", ]
    dea_neg <- dea[dea$avg_log2FC < 0 & dea$sig == "s", ]

    pos_labels_log2FC <- dea_pos[rev(order(dea_pos$avg_log2FC)), ][1:top_label, ] %>% rownames()
    neg_labels_log2FC <- dea_neg[order(dea_neg$avg_log2FC), ][1:top_label, ] %>% rownames()
    
    pos_labels_p_val_adj <- dea_pos[order(dea_pos$p_val_adj), ][1:top_label, ] %>% rownames()
    neg_labels_p_val_adj <- dea_neg[order(dea_neg$p_val_adj), ][1:top_label, ] %>% rownames()
    
    pos_labels <- c(pos_labels_log2FC, pos_labels_p_val_adj)
    neg_labels <- c(neg_labels_log2FC, neg_labels_p_val_adj)
    
    # Set labels 
    dea$label <- ifelse(rownames(dea) %in% c(pos_labels, neg_labels), rownames(dea), NA)

    # Plot
    volcano_plot <- ggplot(dea, aes(x=avg_log2FC, y=-log10(p_val_adj), fill=dea$color, label=label), alpha=1) + 
    
        geom_point(size=4, shape=21, color="white") + 
        geom_vline(aes(xintercept=log2_thold), linetype="dotted", colour="black") +
        geom_vline(aes(xintercept=-log2_thold), linetype="dotted", colour="black") +
        geom_hline(aes(yintercept=-log10(adjpvalue_thold)), linetype="dotted", colour="black") +
        geom_text_repel(segment.color="black", force=20, force_pull=1, max.overlaps=getOption("ggrepel.max.overlaps", default=100), size=5, alpha=1, guide="none", segment.size=0.1, color="black") + 
        xlim(-max(abs(dea$avg_log2FC)), max(abs(dea$avg_log2FC))) +  
        ylim(0, max(-log10(dea$p_val_adj))+5) + 
        ggtitle(title) + xlab("average log2FC") + ylab("-log10(adj. p-value)") + 
        scale_fill_manual(values=color) + 
    
        guides(
            
            color=guide_legend(order=1, title="Group", size=2, keywidth=0.75, keyheight=0.75), 
            alpha="none"
            
        ) + 
    
    theme(
        
        legend.position="none", 
        aspect.ratio=1
        
    )
    
    return(volcano_plot)
    
}