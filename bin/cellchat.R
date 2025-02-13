#########################
### Heat map net slot ###
#########################
hm_net <- function(cellchat, slot, title, diff=NULL, celltype=NULL) {
    
    if(is.null(diff)) {
        
        mat <- cellchat@net[[slot]]
        if(!is.null(celltype)) {mat <- mat[celltype, celltype]}
        mat_name <- "Count"
        mat_color <- viridis::magma(100)
        mat_breaks <- seq(0, max(mat), length.out=length(mat_color))
        mat_color_function <- circlize::colorRamp2(mat_breaks, mat_color) 
        
    } else {
        
        mat_1 <- cellchat@net[[1]][["count"]]
        mat_2 <- cellchat@net[[2]][["count"]]
        
        mat_1 <- mat_1[intersect(rownames(mat_1), rownames(mat_2)), intersect(rownames(mat_1), rownames(mat_2))]
        mat_2 <- mat_2[intersect(rownames(mat_1), rownames(mat_2)), intersect(rownames(mat_1), rownames(mat_2))]
        
        mat <- log2((mat_2+1)/(mat_1+1))
        if(!is.null(celltype)) {mat <- mat[celltype, celltype]}
        
        mat_name <- "log2FC"
        mat_color <- c(rev(RColorBrewer::brewer.pal(11,"RdBu"))[1:5], "#ffffff", rev(RColorBrewer::brewer.pal(11,"RdBu"))[7:11])
        mat_breaks <- seq(-max(abs(mat)), max(abs(mat)), length.out=length(mat_color))
        mat_color_function <- circlize::colorRamp2(mat_breaks, mat_color) 
        
    }
    
    
    
    
    hm <- ComplexHeatmap::Heatmap(
    
        matrix=mat,
        name=mat_name, 
        
        col=mat_color_function, 
        
        width=ncol(mat)*unit(6, "mm"), 
        height=ncol(mat)*unit(6, "mm"), 
        
        column_title=title, 
        column_title_gp=gpar(fontsize=18, fontface="bold"), 
        
        row_names_gp=gpar(fontsize=18, fontface="plain"), 
        column_names_gp=gpar(fontsize=18, fontface="plain"), 
        
        row_labels=parse(text=rownames(mat)), 
        column_labels=parse(text=colnames(mat)), 
        
        border=FALSE, 
        
        cluster_rows=TRUE, 
        cluster_columns=TRUE,
        
        show_row_names=TRUE,
        show_column_names=TRUE, 
        
        row_gap=unit(1, "mm"), 
        column_gap=unit(1, "mm"), 
        
        row_title_rot=90, 
    
        rect_gp=gpar(col="white", lwd=1), 
        
        heatmap_legend_param=list(title_gp=gpar(fontsize=18, fontface="plain"), labels_gp=gpar(fontsize=16), legend_height=unit(5*6, "mm"), grid_width=unit(6, "mm"))

    )

    return(hm)
}