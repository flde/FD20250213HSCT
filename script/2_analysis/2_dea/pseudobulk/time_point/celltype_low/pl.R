##############
### dea_vp ###
##############
dea_vp <- function(dea, log2fc_thr=1, p_adj_thr=0.05, top_label=10, title=NULL, color_neg=RColorBrewer::brewer.pal(8, "Set1")[1], color_pos=RColorBrewer::brewer.pal(8, "Set1")[2], parse_title=FALSE) {

    # Set rownames to genes
    if("gene" %in% colnames(dea)) {rownames(dea) <- dea$gene}
    
    # Annotate entries significance by log2fc_thr and p_adj_thr
    dea$p_val_adj <- ifelse(dea$p_val_adj == 0, .Machine$double.xmin, dea$p_val_adj)
    dea$sig <- ifelse(abs(dea$avg_log2FC) >= log2fc_thr & -log10(dea$p_val_adj) >= -log10(p_adj_thr), "s", "ns")
    
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
    vp <- ggplot(dea, aes(x=AveExpr, y=avg_log2FC, color=dea$color, label=label), alpha=1) + 
    
        geom_point(size=4, shape=16) + # set 1
        geom_hline(aes(yintercept=log2fc_thr), linetype="dotted", colour="black") +
        geom_hline(aes(yintercept=-log2fc_thr), linetype="dotted", colour="black") +
        ggrepel::geom_text_repel(segment.color="black", force=10, force_pull=1, max.overlaps=getOption("ggrepel.max.overlaps", default=100), size=5, alpha=1, segment.size=0.05, color="black", fontface="italic") +  # set 2
        ylim(-max(abs(dea$avg_log2FC))-1, max(abs(dea$avg_log2FC))+1) +  
        ggtitle(ifelse(parse_title, parse(text=title), title)) + xlab("average expression") + ylab("log2FC") + 
        scale_color_manual(values=color) + 
    
        guides(
            
            color=guide_legend(order=1, title="Group", size=2, keywidth=0.75, keyheight=0.75), 
            alpha="none"
            
        ) + 
    
        theme(

            legend.position="none", 
            aspect.ratio=1

        )
    
    return(vp)
    
}
##############
### vp_run ###
##############
vp_run <- function(results, p_adj_thr=0.05) {
    
    for(i in names(results)) {
    
        result <- results[[i]]

        # Make volcano plots 
        vp <- lapply(names(result), function(i) dea_vp(result[[i]], title=i, log2fc_thr=0, p_adj_thr=p_adj_thr) + theme_global_set(size_select=1))
        names(vp) <- names(result)

        # Fill in missing plots 
        grouping_var_query <- c(

            "Tx-Baseline", 
            "D14-Baseline", 
            "D100-Baseline", 
            "GVHD-Baseline", 
            "GVHD-D100"

        )

        grouping_var_failed <- grouping_var_query[!grouping_var_query %in% names(result)]

        if(length(grouping_var_failed)!=0) {

            for(n in grouping_var_failed) {

                vp[[n]] <- patchwork::plot_spacer()

            }

        }

        # Order plots                   
        vp <- vp[grouping_var_query]

        # Rename results 
        names(vp) <- c(

            "Baseline vs Tx", 
            "Baseline vs D14", 
            "Baseline vs D100", 
            "Baseline vs GVHD", 
            "D100 vs GVHD"

        )

        # Rename plots 
        vp <- lapply(names(vp), function(i) {vp_i <- vp[[i]] + ggtitle(i); return(vp_i)})

        vp <- wrap_plots(vp, ncol=7, nrow=1) + plot_annotation(title=parse(text=i))

        plot(vp)

    }
    
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

        width=unit(8*ncol(mat), "mm"), 
        height=unit(8*nrow(mat), "mm"), 

        column_title=column_title, 
        column_title_gp=gpar(fontsize=18, fontface="bold"), 

        row_names_gp=gpar(fontsize=16, fontface="plain"), 
        column_names_gp=gpar(fontsize=18, fontface="plain"), 

        cluster_rows=FALSE, 
        show_row_dend=FALSE,    
        row_split=NULL,
        row_title_gp=gpar(fontsize=16, fontface="plain"), 
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

        heatmap_legend_param=list(title=name, title_gp=gpar(fontsize=18, fontface="plain"), labels_gp=gpar(fontsize=16), legend_height=unit(5*6, "mm"), grid_width=unit(6, "mm")), 

        border=TRUE, 
        border_gp=gpar(col="black", lwd=unit(0.5, "mm")), 

        use_raster=FALSE

    ) 
    
    return(hm)
    
}

########################
### grouping_stat_df ###
########################
grouping_stat_df <- function(so, grouping_var, random_effect_var, file) {
    
    # Count grouping variables 
    grouping_stat <- lapply(so, function(so, grouping_var, random_effect_var) {
    
        grouping_stat <- data.frame(

            grouping_var=so[[grouping_var, drop=TRUE]], 
            random_effect_var=so[[random_effect_var, drop=TRUE]]

        )

        grouping_stat <- grouping_stat %>% dplyr::group_by_all() %>% dplyr::summarise(cell_n=n())

        return(grouping_stat)


    }, grouping_var=grouping_var, random_effect_var=random_effect_var

                            )
    
    # Save RDS object 
    saveRDS(grouping_stat, paste0(file, ".rds"))
    
    # Fix names 
    grouping_stat_xlsx <- grouping_stat
    names(grouping_stat_xlsx) <- gsub("\\+", "plus", names(grouping_stat_xlsx))
    names(grouping_stat_xlsx) <- gsub("\\-", "minus", names(grouping_stat_xlsx))
    names(grouping_stat_xlsx) <- tolower(gsub("\\.", "", make.names(names(grouping_stat_xlsx))))
    
    # Save XLSX file 
    openxlsx::write.xlsx(grouping_stat_xlsx, paste0(file, ".xlsx"), colNames=TRUE)
    
    return(grouping_stat)
    
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
        # name=name

        col=color_function_mat, 
        na_col="#d3d3d3", 

        width=unit(8*ncol(mat), "mm"), 
        height=unit(8*nrow(mat), "mm"), 

        column_title=column_title, 
        column_title_gp=gpar(fontsize=18, fontface="bold"), 

        row_names_gp=gpar(fontsize=16, fontface="plain"), 
        column_names_gp=gpar(fontsize=18, fontface="plain"), 

        cluster_rows=FALSE, 
        show_row_dend=FALSE,    
        row_split=NULL,
        row_title_gp=gpar(fontsize=16, fontface="plain"), 
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

        heatmap_legend_param=list(title=name, title_gp=gpar(fontsize=18, fontface="plain"), labels_gp=gpar(fontsize=16), legend_height=unit(5*6, "mm"), grid_width=unit(6, "mm")), 

        border=TRUE, 
        border_gp=gpar(col="black", lwd=unit(0.5, "mm")), 

        use_raster=FALSE

    ) 
    
    return(hm)
    
}
####################
### results_xlsx ###
####################
results_xlsx <- function(results, path, suffix) {
    
    results_fill <- function(result) {
    
        # Fill in missing plots 
        grouping_var_query <- c(

            "Tx-Baseline", 
            "D14-Baseline", 
            "D100-Baseline", 
            "GVHD-Baseline", 
            "GVHD-D100"

        )

        grouping_var_failed <- grouping_var_query[!grouping_var_query %in% names(result)]

        if(length(grouping_var_failed)!=0) {

            for(n in grouping_var_failed) {

                result[[n]] <- data.frame()

            }

        }

        # Order result                   
        result <- result[grouping_var_query]

        # Rename results 
        names(result) <- c(

            "Baseline vs Tx", 
            "Baseline vs D14", 
            "Baseline vs D100", 
            "Baseline vs GVHD", 
            "D100 vs GVHD"

        )

        return(result)
    }
    
    results <- lapply(results, results_fill)
    
    for(i in names(results)) {
        
        openxlsx::write.xlsx(results[[i]], paste0(path, "/results_", tolower(gsub("\\.", "", make.names(i))), suffix), colNames=TRUE, rowNames=TRUE)

    }
    
}