###############################
### Project global plotting ###
###############################
library_load <- suppressMessages(
    
    list(
        
        library(ggplot2)
        
    )
    
)

theme_global_set <- function(size_select=2) {
    
    size <- data.frame(
    
        size_1=c(16, 18, 20),
        size_2=c(10, 12, 16),
        size_3=c(8, 10, 12), 
        size_4=c(6, 6, 8)
        
    )

    size <- size[, size_select]
    
    library(ggplot2, quietly=TRUE)
  
    theme(
        
        panel.background=element_blank(), 
        panel.spacing=unit(0.2, "lines"),

        plot.title=element_text(size=size[3], face="plain", margin=margin(t=0, r=0, b=10, l=0), color="black"), 
        plot.subtitle=element_text(size=size[2], face="plain", margin=margin(t=0, r=0, b=10, l=0), color="black"), 
    
        axis.title.y=element_text(size=size[2], face="plain", margin=margin(t=0, r=5, b=0, l=0), angle=90, color="black"), 
        axis.title.x=element_text(size=size[2], face="plain", margin=margin(t=5, r=0, b=0, l=0), color="black"),
        axis.text.y=element_text(size=size[1], face="plain", margin=margin(t=0, r=2, b=0, l=0), color="black"),
        axis.text.x=element_text(size=size[1], face="plain", margin=margin(t=2, r=0, b=0, l=0), color="black"),
      
        axis.ticks=element_line(color="black", size=unit(1/2.141959, "pt")), 
        axis.line=element_line(color="black", size=unit(1/2.141959, "pt")), 
      
        legend.key.height=unit(0.5, "cm"), 
        legend.key.width=unit(0.5, "cm"),
        legend.key.size=unit(0.5, "cm"),
      
        legend.title=element_text(size=size[2], face="plain", color="black"),
        legend.text=element_text(size=size[1], face="plain", color="black"), 
        legend.key=element_rect(fill = "transparent", colour = "transparent"), 
        
        legend.text.align=0, 
        
        strip.text=element_text(size=size[2], margin=margin(t=2, r=2, b=2, l=2), face="plain", color="black"), 
        strip.background=element_rect(fill="white", color="black", size=unit(1/2.141959, "pt"))
        
    )

}

##############################################################
### Helper function to convert string to expression format ###
##############################################################
expression_convert <- function(text) {
    
    # Replace unicode greek letters with latin letters
    greek_symbols <- c(
        
        "\u0391" = "alpha", "\u0392" = "Beta", "\u0393" = "Gamma", "\u0394" = "Delta",
        "\u0395" = "Epsilon", "\u0396" = "Zeta", "\u0397" = "Eta", "\u0398" = "Theta",
        "\u0399" = "Iota", "\u039A" = "Kappa", "\u039B" = "Lambda", "\u039C" = "Mu",
        "\u039D" = "Nu", "\u039E" = "Xi", "\u039F" = "Omicron", "\u03A0" = "Pi",
        "\u03A1" = "Rho", "\u03A3" = "Sigma", "\u03A4" = "Tau", "\u03A5" = "Upsilon",
        "\u03A6" = "Phi", "\u03A7" = "Chi", "\u03A8" = "Psi", "\u03A9" = "Omega",
  
        "\u03B1" = "alpha", "\u03B2" = "beta", "\u03B3" = "gamma", "\u03B4" = "delta",
        "\u03B5" = "epsilon", "\u03B6" = "zeta", "\u03B7" = "eta", "\u03B8" = "theta",
        "\u03B9" = "iota", "\u03BA" = "kappa", "\u03BB" = "lambda", "\u03BC" = "mu",
        "\u03BD" = "nu", "\u03BE" = "xi", "\u03BF" = "omicron", "\u03C0" = "pi",
        "\u03C1" = "rho", "\u03C3" = "sigma", "\u03C4" = "tau", "\u03C5" = "upsilon",
        "\u03C6" = "phi", "\u03C7" = "chi", "\u03C8" = "psi", "\u03C9" = "omega"
       
    )

    for (symbol in names(greek_symbols)) {
        
        text <- gsub(symbol, tolower(greek_symbols[[symbol]]), text)  
        
    }
    
    # Make exception for for some Greek letters being part of longer words 
    greek_in_word <- c(
    
        "kappaB"="kappa*B"    
    
    )
    
    for (symbol in names(greek_in_word)) {

        text <- gsub(symbol, greek_in_word[[symbol]], text)
    
    }
    
    # text <- gsub(" ", "~", text)
    # text <- gsub("-", "*"-"*", text)
    
    return(text)
    
}

######################
### Color settings ###
######################

### Patient ID 
patient_id = c(
    
    "#003B3B",
    "#006E6E",
    "#43E0E0",
    "#00DEA6",
    "#3AC2A0",
    "#00A87E",
    "#007558",
    "#CE677D",
    "#C42749",
    "#911D36",
    "#793644",
    "#912154"


) 

names(patient_id) <- c(
    
    "Patient_1",  #763 HSCT
    "Patient_2",  #764 HSCT
    "Patient_3",  #766 HSCT
    "Patient_4",  #768 HSCT
    "Patient_5",  #783 HSCT
    "Patient_6",  #784 HSCT and aGVHD 116
    "Patient_7",  #785 HSCT
    "Patient_8",  #04 aGVHD
    "Patient_9",  #07 aGVHD
    "Patient_10", #08 aGVHD
    "Patient_11", #09 aGVHD
    "Patient_12"  #117 aGVHD
)

### Time point 
time_point <- c(
    
    "#74ABAB",
    "#6E5E0B",
    "#BA9E09",
    "#006E6E",
    "#B3254D"

)

names(time_point) <- c(
    
    "Baseline", 
    "Tx", 
    "D14", 
    "D100", 
    "GVHD"
    
)

### HTO demux
hto_demux_class <- c(
    
    "#6E0B53", 
    "#006E6E", 
    "#5A5A5A", 
    "#5A5A5A"

)
names(hto_demux_class) <- c(
    
    "Blood", 
    "Skin", 
    "Doublet", 
    "Negative"

)

### Digestion_protocol
digestion_protocol <- c(RColorBrewer::brewer.pal(7, "Set1")[1], RColorBrewer::brewer.pal(7, "Set1")[2])
names(digestion_protocol) <- c("old", "new")

### Cell cycle phase 
msCC_label <- c(RColorBrewer::brewer.pal(8, "Accent")[1:3])
names(msCC_label) <- c("G1", "S", "G2M")

### Genotype class 
genotype_class = c(
    
    "#00B0AD", 
    "#C21398", 
    "#5A5A5A", 
    "#D3D3D3"
    
) 
names(genotype_class) <- c(
    
    "Host", 
    "Donor", 
    "unassigned", 
    "doublet"

)

gvhd_class <- c(

    "#74ABAB", 
    "#B3254D"
    
)

names(gvhd_class) <- c(

    "GVHD_free", 
    "GVHD_dev"
    
)

### Celltype colors for python 
celltype_low <- c(
    
    "#96FAA7", #F1
    "#09914F", #F2
    "#044526", #F3
    "#0CC96E", #F4

    "#625CD1", #vEC
    "#0D089E", #lEC

    "#8A88D1", #Pc1
    "#53517D", #Pc2
    
    "#255F78", #KC b
    "#71A3B9", #KC sb
    
    "#805E41", #Mlc
    
    "#FF9EC6", #Th cm/naive 
    "#96305B", #Th em/effector
    "#76ABA0", #Th memory/effector
    "#CC417B", #Treg
    "#B57E9F", #Tc cm/naive 
    "#D6065C", #Tc em/effector
    "#0D6B58", #Tc memory/effector
    "#4F1930", #T inv
    "#C4EA57", #B cell
    "#D8EBA5", #Plasma cell 

    "#825A8F", #NK CD16+
    "#AE88BA", #NK CD16-

    "#FFE500", #Mono Cl
    "#B39200", #Mono int
    "#FFC029", #Mono non cl
    "#BB161E", #Mac
    "#BA7900", #cDC1
    "#FF7300", #cDC2
    "#FFA196", #LC
    "#C7520A", #cDC mig
    
    "#94AA72", #pDC

    "#652191", #Mast cell
    "#858077"  #HSC/MPP

)

names(celltype_low) <- c(
    
    "$F1$",
    "$F2$",
    "$F3$",
    "$F4$",
    "$vEC$",
    "$lEC$",
    "$Pc1$",
    "$Pc2$",
    "$KC_{b}$",
    "$KC_{sb}$",
    "$Mlc$",
    
    "$T_{h}\\ N/CM$",
    "$T_{h}\\ E/EM$",
    "$T_{h}\\ RM$",
    "$T_{reg}$",
    "$T_{c}\\ N/CM$",
    "$T_{c}\\ E/EM$",
    "$T_{c}\\ RM$",

    "$T_{inv}$",

    "$B\\ cells$", 
    "$Plasma\\ cells$",
    
    "$NK\\ CD16+$",
    "$NK\\ CD16-$",

    "$Mono_{c}$",
    "$Mono_{int}$",
    "$Mono_{nc}$",
    
    "$M\\phi$",
    "$cDC1$",
    "$cDC2$",
    "$LC$", 
    "$cDC_{Mig}$",
    
    "$pDC$",
    
    "$Mast\\ cells$", 

    "$HSC/MPP$"

)

celltype_high <- c(
    
    "#09914F", #Fibroblasts
    "#0D089E", #Endothelial
    "#8A88D1", #Pericytes
    "#255F78", #Epithelial

    "#FF9EC6", #T cell 
    "#BB161E", #B cell
    "#825A8F", #NK cells 

    "#FFE500", #Mono
    "#F24949", #Mac
    "#BA7900", #Dendritic cells 

    "#9C4F00", #Mast cell
    "#DE00C3" #HSC/MPP

)

names(celltype_high) <- c(
    
    "$Fibroblasts$",
    "$Endothelial\\ cells$",
    "$Pericytes$",
    "$Epithelial\\ cells$", 
    
    "$T\\ cells$",
    "$B\\ cells$",
    "$NK\\ cells$",

    "$Monocytes$",
    "$Macrophages$",    
    "$Dendritic\\ cells$",
    
    "$Mast\\ cells$", 

    "$HSC/MPP$"

)

celltype_domain <- c(
    
    "#9D02D7", #Non-hematopoetic
    
    "#FA8775" #Immune cell

)

names(celltype_domain) <- c(
    
    "$Non-hematopoetic$", 
    
    "$Immune\\ cells$"

)


# TRM subset 
t_cell_subset <- c(
    
    "#F24949", 
    "#097560", 
    
    "#F24949", 
    "#097560"
    
)

names(t_cell_subset) <- c(

    # CD4+ 
    "Th17hi",
    "Th17lo", 

    # CD8+ 
    "Tc17hi",
    "Tc17lo"
    
)

### Celltype colors for R
celltype_low_r <- celltype_low 

names(celltype_low_r) <- c(
    
    "F1",
    "F2",
    "F3",
    "F4",
    "vEC",
    "lEC",
    "Pc1",
    "Pc2",
    "KC['b']",
    "KC['sb']",
    "Mlc",
    
    "T['h']*' N/CM'",
    "T['h']*' E/EM'",
    "T['h']*' RM'",
    "T['reg']",
    "T['c']*' N/CM'",
    "T['c']*' E/EM'",
    "T['c']*' RM'",
    
    "T['inv']",
    
    "B~cells",
    "Plasma~cells",
    
    "NK*' CD16+'",
    "NK*' CD16-'",
    
    "Mono['c']",
    "Mono['int']",
    "Mono['nc']",
    "M*phi",
    "cDC1",
    "cDC2",
    "LC", 
    "cDC['Mig']",
    
    "pDC",
    
    "Mast~cells",
    
    "HSC/MPP"

)

celltype_high_r <- celltype_high 

names(celltype_high_r) <- c(

    "Fibroblasts", 
    "Endothelial~cells",
    "Pericytes",
    "Epithelial~cells",
    
    "T~cells",
    "B~cells",
        
    "NK~cells",
        
    "Monocytes",
    "Macrophages",
        
    "Dendritic~cells",
        
    "Mast~cells",
        
    "HSC/MPP"

)

celltype_domain_r <- celltype_domain

names(celltype_domain_r) <- c(
    
    "'Non-hematopoetic'", 
    
    "Immune~cells"

)

### Cobine colors
color <- list(
    
    patient_id=patient_id, 
    time_point=time_point, 
    hto_demux_class=hto_demux_class, 
    digestion_protocol=digestion_protocol, 
    msCC_label=msCC_label, 
    genotype_class=genotype_class,
    gvhd_class=gvhd_class, 
    celltype_low=celltype_low, 
    celltype_high=celltype_high, 
    celltype_domain=celltype_domain, 
    t_cell_subset=t_cell_subset, 
    celltype_low_r=celltype_low_r, 
    celltype_high_r=celltype_high_r, 
    celltype_domain_r=celltype_domain_r

)