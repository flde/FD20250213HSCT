#########################
### Fetch DEA results ###
#########################
dea_res_fetch <- function(dea_res, row_order, p_adj_thr=0.05, column_title=NULL, name=NULL, grouping_var_query=NULL, grouping_var_names=NULL) {

    if(is.null(grouping_var_query)) {
        
        grouping_var_query <- c(
            
            "Tx-Baseline", 
            "D14-Baseline", 
            "D100-Baseline", 
            "GVHD-Baseline"
        
        )
    }

    if(is.null(grouping_var_names)) {
        
        grouping_var_names <- c(
            
            "Tx", 
            "D14", 
            "D100", 
            "GVHD"
        
        )
        
    }
    
    results_n <- lapply(dea_res, function(result) {
    
        # Count significant DEA results 
        dea_res_n <- lapply(result, function(x) {nrow(x[x$p_val_adj <= p_adj_thr, ])})
        
        grouping_var_failed <- grouping_var_query[!grouping_var_query %in% names(dea_res_n)]
    
        if(length(grouping_var_failed)!=0) {
    
            for(n in grouping_var_failed) {

                dea_res_n[[n]] <- NA

            }

        }

        # Order results 
        dea_res_n <- dea_res_n[grouping_var_query]
        
        # Rename results 
        names(dea_res_n) <- grouping_var_names
        
        dea_res_n <- do.call(rbind, dea_res_n)
        
        return(dea_res_n)

    }
                       )

    mat <- do.call(cbind, results_n)
    colnames(mat) <- names(dea_res)
    
    # Normalize and transform count matrix
    mat <- t(mat)
    
    # Order rows 
    return(mat)
    
}

#################################
### Plot heatmap DEA results ####
#################################
dea_res_hm <- function(mat, fontsize_select=1) {

    # Set font size 
    fontsize <- list(size_1=c(16, 18), size_2=c(6, 8))[[fontsize_select]]
    fontsize_scale <- c(1, 0.5)[[fontsize_select]]
    
    color_ramp_mat <- c("white", rev(RColorBrewer::brewer.pal(11,"RdBu"))[11])
    breaks_mat <- seq(0,  max(mat, na.rm=TRUE), length.out=length(color_ramp_mat))
    color_function_mat <- circlize::colorRamp2(breaks_mat, color_ramp_mat) 
    
    row_labels <- parse(text = rownames(mat))

    breaks <- round(max(breaks_mat))
    if (breaks %% 2 != 0) breaks <- breaks + 1
    
    hm <- Heatmap(
        
        mat,
    
        col=color_function_mat, 
        na_col="#d3d3d3", 
        
        width=fontsize_scale*5*ncol(mat)*unit(1, "mm"),
        height=fontsize_scale*5*nrow(mat)*unit(1, "mm"), 
    
        row_names_gp=gpar(fontsize=fontsize[1], fontface="plain"), 
        column_names_gp=gpar(fontsize=fontsize[1], fontface="plain"), 
        
        cluster_rows=FALSE,
        show_row_names=TRUE,
        row_names_side="left",
        row_labels=row_labels, 
        
        cluster_columns=FALSE,
        show_column_names=TRUE, 
    
        show_heatmap_legend=TRUE, 

        heatmap_legend_param=list(title="log10(DEG)", at=c(0, breaks/2, breaks), title_gp=gpar(fontsize=fontsize[1], fontface="plain"), labels_gp=gpar(fontsize=fontsize[1]), legend_height=unit(fontsize_scale*15, "mm"), grid_width=unit(fontsize_scale*3, "mm")), 
        
        border=TRUE, 
        rect_gp=gpar(col="black", lwd=unit(fontsize_scale*2*0.6667, "pt")), 
        border_gp=gpar(col="black", lwd=unit(fontsize_scale*3*0.6667, "pt"))

    )

    return(hm)
}

########################
### grouping_stat_hm ###
########################
grouping_stat_hm <- function(grouping_stat, stat, row_order, column_title=NULL, name=NULL) {
    
    # Summaries random effect var and cell counts 
    grouping_summary <- lapply(grouping_stat, function(grouping_stat) {
    
        grouping_stat <- grouping_stat %>% dplyr::group_by(grouping_var) %>% dplyr::summarise(random_effect_var_n=n(), cell_mean=mean(cell_n))

        return(grouping_stat)

    }

                            )
    
    # Add ident to grouping summary 
    grouping_summary <- lapply(seq_along(grouping_summary), function(i) {
    
        grouping_summary_i <- grouping_summary[[i]]
        grouping_summary_i$ident <- names(grouping_summary)[i]

        return(grouping_summary_i)

    }

                              )
    
    # Convert to data frame 
    grouping_summary <- do.call(rbind, grouping_summary)
    
    # Build matrix from stat variable 
    mat <- reshape2::dcast(grouping_summary, grouping_var ~ ident, value.var=stat) %>%  tibble::column_to_rownames("grouping_var") %>% t()
    
    # Normalize and set color
    if(stat=="cell_mean") {
        
        mat <- log2(mat)
    
        # Color function
        color_ramp_mat <- viridis::mako(100)
        breaks_mat <- seq(0,  max(mat, na.rm=TRUE), length.out=length(color_ramp_mat))
        color_function_mat <- circlize::colorRamp2(breaks_mat, color_ramp_mat) 
        
    }
    
    if(stat=="random_effect_var_n") {
        
        # Color function
        color_ramp_mat <- viridis::mako(max(mat, na.rm=TRUE)+1)
        breaks_mat <- seq(0,  max(mat, na.rm=TRUE), length.out=length(color_ramp_mat))
        
        color_function_mat = rev(structure(color_ramp_mat, names=breaks_mat))
        
    }
    
    # Order rows 
    mat <- mat[row_order, ]
    
    # Heat map 
    hm <- ComplexHeatmap::Heatmap(
        
        matrix=mat, 
        # name=name,  

        col=color_function_mat, 
        na_col="#d3d3d3", 

        width=unit(3*ncol(mat), "mm"), 
        height=unit(3*nrow(mat), "mm"), 

        column_title=column_title, 
        column_title_gp=gpar(fontsize=8, fontface="bold"), 

        row_names_gp=gpar(fontsize=6, fontface="plain"), 
        column_names_gp=gpar(fontsize=6, fontface="plain"), 

        cluster_rows=FALSE, 
        show_row_dend=FALSE,    
        row_split=NULL,
        row_title_gp=gpar(fontsize=6, fontface="plain"), 
        row_labels=parse(text=rownames(mat)), 
        row_gap=unit(2, "mm"),
        show_row_names=TRUE,
        row_names_side="left",

        cluster_columns=FALSE,
        cluster_column_slices=FALSE, 
        show_column_dend=FALSE, 
        column_gap=unit(2, "mm"), 
        show_column_names=TRUE, 

        rect_gp=gpar(col=NA, lwd=0, alpha=1), 

        heatmap_legend_param=list(title=name, title_gp=gpar(fontsize=6, fontface="plain"), labels_gp=gpar(fontsize=4), grid_height=unit(2, "mm"), legend_width=unit(12, "mm"), direction="horizontal", title_position="topcenter"), 

        border=TRUE, 
        border_gp=gpar(col="black", lwd=unit(0.5, "mm")), 

        use_raster=FALSE

    ) 
    
    return(hm)
    
}

####################
### results_n_hm ###
####################
results_n_hm <- function(results, row_order, p_adj_thr=0.05, column_title=NULL, name=NULL) {
    
    
    results_n <- lapply(results, function(result) {
    
        # Count significant DEA results 
        result_n <- lapply(result, function(x) {nrow(x[x$p_val_adj <= p_adj_thr, ])})
    
        # Fill failed comparisons 
        grouping_var_query <- c(
            
            "Tx-Baseline", 
            "D14-Baseline", 
            "D100-Baseline", 
            "GVHD-Baseline", 
            "GVHD-D100"
        
        )
        
        grouping_var_failed <- grouping_var_query[!grouping_var_query %in% names(result_n)]
    
        if(length(grouping_var_failed)!=0) {
    
            for(n in grouping_var_failed) {

                result_n[[n]] <- NA

            }

        }

        # Order results 
        result_n <- result_n[grouping_var_query]
        
        # Rename results 
        names(result_n) <- c(
            
            "Baseline vs Tx", 
            "Baseline vs D14", 
            "Baseline vs D100", 
            "Baseline vs GVHD", 
            "D100 vs GVHD"
        
        )
        
        
        
        result_n <- do.call(rbind, result_n)
        
        return(result_n)

    }
                       )

    results_n <- do.call(cbind, results_n)
    colnames(results_n) <- names(results)
    
    # Normalize and transform count matrix
    mat <- t(results_n)
    
    # Color function - DEG count
    color_ramp_mat <- viridis::mako(100)
    breaks_mat <- seq(0,  quantile(as.double(mat), 0.99, na.rm=TRUE), length.out=length(color_ramp_mat))
    color_function_mat <- circlize::colorRamp2(breaks_mat, color_ramp_mat) 
    
    # Order rows 
    mat <- mat[row_order, ]
    
    # Heat map 
    hm <- ComplexHeatmap::Heatmap(
        
        matrix=mat, 
        # name=name,  

        col=color_function_mat, 
        na_col="#d3d3d3", 

        width=unit(3*ncol(mat), "mm"), 
        height=unit(3*nrow(mat), "mm"), 

        column_title=column_title, 
        column_title_gp=gpar(fontsize=8, fontface="bold"), 

        row_names_gp=gpar(fontsize=6, fontface="plain"), 
        column_names_gp=gpar(fontsize=6, fontface="plain"), 

        cluster_rows=FALSE, 
        show_row_dend=FALSE,    
        row_split=NULL,
        row_title_gp=gpar(fontsize=6, fontface="plain"), 
        row_labels=parse(text=rownames(mat)), 
        row_gap=unit(2, "mm"),
        show_row_names=TRUE,
        row_names_side="left",

        cluster_columns=FALSE,
        cluster_column_slices=FALSE, 
        show_column_dend=FALSE, 
        column_gap=unit(2, "mm"), 
        show_column_names=TRUE, 

        rect_gp=gpar(col=NA, lwd=0, alpha=1), 

        heatmap_legend_param=list(title=name, title_gp=gpar(fontsize=6, fontface="plain"), labels_gp=gpar(fontsize=4), grid_height=unit(2, "mm"), legend_width=unit(12, "mm"), direction="horizontal", title_position="topcenter"), 

        border=TRUE, 
        border_gp=gpar(col="black", lwd=unit(0.5, "mm")), 

        use_raster=FALSE

    ) 
    
    return(hm)
    
}
