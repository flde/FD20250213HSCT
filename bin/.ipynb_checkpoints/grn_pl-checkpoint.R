hm_grn <- function(res, column_title=NULL, cluster_columns=TRUE, p_val_adj_thr=0.01, avg_log2FC_thr=0.25, rank_thr=50, top_thr=NULL, width=1.0, height=1.0, fontsize_select=1) {

    # Set font size 
    fontsize <- list(size_1=c(16, 18), size_2=c(6, 8))[[fontsize_select]]
    fontsize_scale <- c(1, 0.5)[[fontsize_select]]

    # Get modules 
    if(is.null(top_thr)) {

        module <- res %>% dplyr::filter(p_val_adj <= p_val_adj_thr & abs(avg_log2FC) >= avg_log2FC_thr & (rank_1 <= rank_thr | rank_2 <= rank_thr)) %>% pull(module) %>% unique()
        
    } else {

        module_1 <- res %>% dplyr::filter(p_val_adj <= p_val_adj_thr) %>% dplyr::filter(avg_log2FC>0) %>% dplyr::arrange(desc(avg_log2FC)) %>% slice_head(n=top_thr) %>% dplyr::pull(module)
        module_2 <- res %>% dplyr::filter(p_val_adj <= p_val_adj_thr) %>% dplyr::filter(avg_log2FC<0) %>% dplyr::arrange(avg_log2FC) %>% slice_head(n=top_thr) %>% dplyr::pull(module)

        module <- c(module_1, rev(module_2)) %>% unique()
        
    }
    
    # Subset res 
    res <- res %>% dplyr::select(contrast, module, p_val_adj, avg_log2FC)

    # Get log2FC and adj p-value matrix 
    mat_1 <- res %>% dplyr::select(-p_val_adj) %>% dplyr::distinct() %>% tidyr::pivot_wider(., names_from=module, values_from=avg_log2FC, values_fill=0) %>% tibble::column_to_rownames("contrast")
    mat_2 <- res %>% dplyr::select(-avg_log2FC) %>% dplyr::distinct() %>% tidyr::pivot_wider(., names_from=module, values_from=p_val_adj, values_fill=1) %>% tibble::column_to_rownames("contrast")
    

    # Subset matrix by candidate modules
    mat_1 <- mat_1[, module, drop=FALSE]
    mat_2 <- mat_2[, module, drop=FALSE]

    # Set color 
    color_ramp_mat <- c(rev(RColorBrewer::brewer.pal(11,"RdBu"))[1], "#ffffff", rev(RColorBrewer::brewer.pal(11,"RdBu"))[11])
    breaks_mat <- c(-2, 0, 2)
    color_function_mat <- circlize::colorRamp2(breaks_mat, color_ramp_mat) 
    
    # GRNA heatmap 
    hm <- Heatmap(
    
        matrix=mat_1, 
    
        col=color_function_mat, 
            
        width=fontsize_scale*5*ncol(mat_1)*unit(width, "mm"),
        height=fontsize_scale*5*nrow(mat_1)*unit(height, "mm"), 
    
        row_title_gp=gpar(fontsize=fontsize[1], fontface="bold"), 
    
        column_title=parse(text=column_title), 
        column_title_gp=gpar(fontsize=fontsize[1], fontface="bold"), 
    
        row_names_gp=gpar(fontsize=fontsize[1], fontface="plain"), 
        column_names_gp=gpar(fontsize=fontsize[1], fontface="plain"), 
            
        cluster_rows=FALSE, 
        # row_labels=NULL, 
        cluster_row_slices=FALSE, 
        show_row_dend=FALSE,   
        row_split=NULL, 
        row_title=NULL , 
        row_gap=unit(0.5, "mm"),
        show_row_names=TRUE,
        row_names_side="left",
    
        cluster_columns=cluster_columns,
        clustering_distance_columns="pearson", 
        cluster_column_slices=FALSE, 
        show_column_dend=FALSE, 
        column_split=NULL,
        column_gap=unit(0.5, "mm"), 
        column_dend_height=unit(fontsize_scale*3, "mm"), 
        show_column_names=TRUE, 
    
        # top_annotation=top_annotation, 
    
        heatmap_legend_param=list(title="log2FC", at=c(min(breaks_mat), 0, max(breaks_mat)), title_gp=gpar(fontsize=fontsize[1], fontface="plain"), labels_gp=gpar(fontsize=fontsize[1]), legend_height=unit(fontsize_scale*15, "mm"), grid_width=unit(fontsize_scale*3, "mm")), 
    
        border=TRUE, 
        rect_gp=gpar(col="black", lwd=unit(fontsize_scale*2*0.6667, "pt")), 
        border_gp=gpar(col="black", lwd=unit(fontsize_scale*3*0.6667, "pt")),
    
        use_raster=FALSE, raster_by_magick=TRUE, raster_resize_mat=mean, 
    
        cell_fun=function(j, i, x, y, w, h, fill) {
                
            if(mat_2[i, j] <= p_val_adj_thr) {
                    
                grid.text("*", x, y-unit(fontsize_scale*1, "mm"), gp=gpar(fontsize=fontsize[1]))
                
            }
            
        }
    
    )

    return(hm)

}