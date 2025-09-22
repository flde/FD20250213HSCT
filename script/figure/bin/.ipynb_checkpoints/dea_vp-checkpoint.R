dea_vp <- function(dea, log2fc_thr=0, p_adj_thr=0.05, top_label=15, title=NULL, color_neg=RColorBrewer::brewer.pal(8, "Set1")[1], color_pos=RColorBrewer::brewer.pal(8, "Set1")[2], parse_title=TRUE, label=NULL, label_size=2) {

    # Set rownames to genes
    if("gene" %in% colnames(dea)) {rownames(dea) <- dea$gene}
    
    # Annotate entries significance by log2fc_thr and p_adj_thr
    dea$p_val_adj <- ifelse(dea$p_val_adj == 0, .Machine$double.xmin, dea$p_val_adj)
    dea$sig <- ifelse(abs(dea$avg_log2FC) >= log2fc_thr & dea$p_val_adj <= p_adj_thr, "s", "ns")
    
    # Set color based on significance and direction of dea e.g. positive and negative 
    dea$color <- ifelse(dea$sig == "s" & dea$avg_log2FC > 0, "s_pos", "ns")
    dea$color <- ifelse(dea$sig == "s" & dea$avg_log2FC < 0, "s_neg", dea$color)
    
    color <- c(color_neg, "gray", color_pos)
    names(color) <- c("s_neg", "ns", "s_pos")
    
    # Create labels based log2FC and p_val_adj
    dea_pos <- dea[dea$avg_log2FC > 0 & dea$sig == "s", ]
    dea_neg <- dea[dea$avg_log2FC < 0 & dea$sig == "s", ]

    pos_labels_log2FC <- dea_pos[rev(order(dea_pos$avg_log2FC)), ][1:top_label, ] %>% rownames()
    neg_labels_log2FC <- dea_neg[order(dea_neg$avg_log2FC), ][1:top_label, ] %>% rownames()
    
    # pos_labels_p_val_adj <- dea_pos[order(dea_pos$p_val_adj), ][1:top_label, ] %>% rownames()
    # neg_labels_p_val_adj <- dea_neg[order(dea_neg$p_val_adj), ][1:top_label, ] %>% rownames()
    
    # pos_labels <- c(pos_labels_log2FC, pos_labels_p_val_adj)
    # neg_labels <- c(neg_labels_log2FC, neg_labels_p_val_adj)
    
    pos_labels <- pos_labels_log2FC
    neg_labels <- neg_labels_log2FC
    
    # Set labels 
    dea$label <- ifelse(rownames(dea) %in% c(pos_labels, neg_labels), rownames(dea), NA)
    
    # Set labels if provided 
    if(!is.null(label)) {
        
        dea$label <- ifelse(rownames(dea) %in% label, rownames(dea), NA)
        
    }


    # Set plotting order 
    dea$color <- factor(dea$color, levels=rev(c("ns", "s_neg", "s_pos")))
    dea <- dea[order(dea$color, decreasing = TRUE), ]
    
    # Plot
    vp <- ggplot(dea, aes(x=AveExpr, y=avg_log2FC, color=color, label=label), alpha=1) + 
    
        geom_point(size=1, shape=16) + # set 1
        geom_hline(aes(yintercept=0), linetype="dotted", colour="black") +
        ggrepel::geom_text_repel(segment.color="black", force=10, force_pull=1, max.overlaps=getOption("ggrepel.max.overlaps", default=100), size=label_size, alpha=1, segment.size=0.05, color="black", fontface="italic") +  # set 2
        ylim(-max(abs(dea$avg_log2FC))-1, max(abs(dea$avg_log2FC))+1) +  
        ggtitle(ifelse(parse_title, parse(text=title), title)) + xlab("average expression") + ylab("log2FC") + 
        scale_color_manual(values=rev(color[c(3, 1, 2)])) + 
    
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

# Function to arrange ggplots in a grid and save to a PDF in A4 format with margins
save_plots_to_pdf <- function(plot_list, nrow, ncol, file_name, margin=0.25) {
    
    pdf(file_name, width=8.27, height=11.69)  # A4 dimensions in inches
    num_plots <- length(plot_list)
    pages <- ceiling(num_plots / (nrow * ncol))
  
    for (i in seq_len(pages)) {
        
        grid_plots <- plot_list[((i-1) * nrow * ncol + 1):min(i * nrow * ncol, num_plots)]
        grid_plots <- lapply(grid_plots, function(plot) {plot + theme(plot.margin=unit(rep(margin, 4), "inches"))})

        gridExtra::grid.arrange(grobs=grid_plots, nrow=nrow, ncol=ncol)

      }
    
    dev.off()
    
}