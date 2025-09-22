labels <- function(x) {
    
    label <- scales::scientific_format()(x)
    
    # substitute for exact zeros
    label[label=="0e+00"] <- "0"
    
    # regex: [+]?  = "zero or one occurrences of '+'"
    label <- gsub("e[+]?", "*'x'*10^", label)
    
    label[1] <- "0"
    
    parse(text=label)

}
    


lp_time_point <- function(data, title="", xlab="", ylab="", legend_title="Genotype", dodge_width=0.3, line_size=0.5, point_size=1.0, errorbar_width=0.5, filter_errorbar="Donor", log_breaks=FALSE) {
    
    # Since y axis is not log scale we need to select a sensible max threshold in order to not round to much 
    max_1 <- strsplit(scales::scientific_format()(max(data$mean)), split="e")[[1]][[1]] %>% as.double() %>% ceiling()
    # if(!(max_1 %% 2) == 0) {max_1=max_1+1} 
    max_2 <- strsplit(scales::scientific_format()(max(data$mean)), split="e")[[1]][[2]] %>% as.double() %>% ceiling()
    y_max <- max_1 * 10^max_2
    
    breaks <- c(0, y_max/2, y_max)
    
    lp <- ggplot(data, aes(x=time_point, y=mean, color=genotype_class, group=genotype_class)) + 

        # Geome line 
        geom_line(data=data[data$time_point %in% c("Baseline", "Tx", "D14") & data$genotype_class=="Donor", ], size=line_size, linetype="dotted", position=position_dodge(dodge_width)) + 
        geom_line(data=data[!(data$time_point %in% c("Baseline", "Tx") & data$genotype_class=="Donor"), ], size=line_size, linetype="solid", position=position_dodge(dodge_width)) + 

        # Geom point mean
        geom_point(shape=16, size=point_size, position=position_dodge(dodge_width)) + 

        # Error bar SEM
        geom_errorbar(data=data[!(data$time_point %in% c("Baseline", "Tx") & data$genotype_class=="Donor"), ], aes(ymin=ymin, ymax=ymax), width=errorbar_width, size=line_size, position=position_dodge(preserve="single", dodge_width)) + 

        # Label 
        xlab(xlab) + ylab(parse(text=ylab)) + ggtitle(title) + 

        # Color 
        scale_fill_manual(values=color$genotype_class) + 
        scale_color_manual(values=color$genotype_class) + 
    
        # Aesthetics 
        guides(color=guide_legend(ncol=1, override.aes=list(alpha=1, size=1.5), keywidth=0, keyheight=0.1, default.unit="cm", title=legend_title, reverse=TRUE)) + 

        theme(

            axis.text.x=element_text(angle=90, vjust=0.5, hjust=1), 
            axis.text.y=element_text(vjust=0.5, hjust=1)

        )
    
    # log_breaks 
    if(log_breaks) {
        
        
        lp <- lp + scale_y_continuous(breaks=breaks, labels=labels(breaks))
        
    }
                       
    return(lp)                   
    
}

lp_time_point_ratio <- function(data, title="", xlab="", ylab="", legend_title="Genotype", dodge_width=0.3, line_size=0.5, point_size=1.0, errorbar_width=0.5, filter_errorbar="Donor") {
    
    lp <- ggplot(data, aes(x=time_point, y=mean, color=genotype_class, group=genotype_class)) + 

        # Geome line 
        geom_line(data=data[data$time_point %in% c("Baseline", "Tx", "D14") & data$genotype_class=="Donor", ], size=line_size, linetype="dotted", position=position_dodge(dodge_width)) + 
        geom_line(data=data[!(data$time_point %in% c("Baseline", "Tx") & data$genotype_class=="Donor"), ], size=line_size, linetype="solid", position=position_dodge(dodge_width)) + 

        # Geom point mean
        geom_point(shape=16, size=point_size, position=position_dodge(dodge_width)) + 

        # Error bar SEM
        geom_errorbar(data=data[!(data$time_point %in% c("Baseline", "Tx") & data$genotype_class=="Donor"), ], aes(ymin=ymin, ymax=ymax), width=errorbar_width, size=line_size, position=position_dodge(preserve="single", dodge_width)) + 

        # Label 
        xlab(xlab) + ylab(parse(text=ylab)) + ggtitle(title) + 

        # Color 
        scale_fill_manual(values=color$genotype_class) + 
        scale_color_manual(values=color$genotype_class) + 
    
        # Aesthetics 
        guides(color=guide_legend(ncol=1, override.aes=list(alpha=1, size=1.5), keywidth=0, keyheight=0.1, default.unit="cm", title=legend_title, reverse=TRUE)) + 

        theme(

            axis.text.x=element_text(angle=90, vjust=0.5, hjust=1), 
            axis.text.y=element_text(vjust=0.5, hjust=1)

        )
    
              
    return(lp)                   
    
}