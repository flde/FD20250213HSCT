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
    
    text <- gsub(" ", "~", text)
    text <- gsub("-", "*'-'*", text)
    
    return(text)
    
}

#########################
### Set factor levels ###
#########################

set_factor_levels <- function(so) {
    
    if("patient_id" %in% colnames(so@meta.data)) {so$patient_id <- factor(so$patient_id, levels=names(color$patient_id))}
    if("time_point" %in% colnames(so@meta.data)) {so$time_point <- factor(so$time_point, levels=names(color$time_point))}
    if("hto_demux_class" %in% colnames(so@meta.data)) {so$hto_demux_class <- factor(so$hto_demux_class, levels=names(color$hto_demux_class))}
    if("digestion_protocol" %in% colnames(so@meta.data)) {so$digestion_protocol <- factor(so$digestion_protocol, levels=names(color$digestion_protocol))}
    if("cc_phase_class" %in% colnames(so@meta.data)) {so$cc_phase_class <- factor(so$cc_phase_class, levels=names(color$cc_phase_class))}
    if("genotype_class" %in% colnames(so@meta.data)) {so$genotype_class <- factor(so$genotype_class, levels=names(color$genotype_class))}
    if("cell_type_leiden" %in% colnames(so@meta.data)) {so$cell_type_leiden <- factor(so$cell_type_leiden, levels=names(color$cell_type_leiden))}
    if("cell_type_leiden_subset" %in% colnames(so@meta.data)) {so$cell_type_leiden_subset <- factor(so$cell_type_leiden_subset, levels=names(color$cell_type_leiden_subset_r))}
    
    return(so)
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
    "#793644"  

) 

names(patient_id) <- c(
    
    "Patient_1",  #763
    "Patient_2",  #764
    "Patient_3",  #766
    "Patient_4",  #768
    "Patient_5",  #783
    "Patient_6",  #784
    "Patient_7",  #785
    "Patient_8",  #GVD_04
    "Patient_9",  #GVD_05
    "Patient_10", #GVD_07
    "Patient_11"  #GVD_08
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
cc_phase_class <- c(RColorBrewer::brewer.pal(8, "Accent")[1:3])
names(cc_phase_class) <- c("G1", "S", "G2M")

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

### Cluster colors resulution 1 
cell_type_leiden <- c(
    
    "#A7B34F", #HSC
    "grey50", 
    "#FF9436","#EABE5B","#FFBC82","#CF782B", #Mono-1 to -4
    "#69161E","#EC7884","#B82735", #Mac,DC-1,2
    "#CE95ED","#AE4BE3", #pDC, BC
    "#47124C", #ILCs
    "#7D2280","#80093E", #NK, Tc_NK
    "#FF5EA7","#FF127E","#80093E","#CF0E65","#803459", #TC-1 to -5
    "#805E41", #Mlc
    "#0A067D","#5B56F5","#7472B0", #lEC, vEC, Pc
    "#044526","#09914F","#225E41","#153B29","#0DDE79", #Fibro1 to -5
    "#71A3B9","#255F78" #Kc-1,2

) 

names(cell_type_leiden) <- c(
    
    "HSC", 
    "Mast cell", 
    paste0("Mono-", 1:4), 
    "Mac", paste0("DC-", 1:2), 
    "pDC", "BC", 
    "ILCs", 
    "NK", "TC_NK", 
    paste0("TC-", 1:5), 
    "Mlc", 
    "lEC", "vEC", "Pc", 
    paste0("Fibro-", 1:5), 
    paste0("Kc-", 1:2)

)

### Subsets color 
cell_type_leiden_subset <- c(
    
    "#09914F", #F ret ECM
    "#0CC96E", #F ret activate
    "#044526", #F ret immune 
    "#96FAA7", #F papa ECM
    "#097560", #F DS
    "#0B997A", #F DP
    "#255F78", #KC b
    "#71A3B9", #KC sb
    "#5B56F5", #vEC
    "#0D089E", #lEC
    "#8A88D1", #Pc
    "#53517D", #Pc immune
    "#805E41", #Mlc
    
    "#FF9EC6", #Th cm/naive 
    "#CC417B", #Th em/effector
    "#76ABA0", #Th memory/effector
    "#3A667A", #T reg
    "#B57E9F", #Tc cm/naive 
    "#96305B", #Tc em/effector
    "#0D6B58", #Tc memory/effector
    "#4F1930", #T inv
    "#AE88BA", #NK CD16-
    "#825A8F", #NK CD16+
    "#070C0D", #Cycling

    "#FFE500", #Mono Cl
    "#B39200", #Mono int
    "#FFC029", #Mono non cl
    "#F24949", #Mac
    "#BB161E", #Mac act
    "#69161E", #Mac inflm
    "#BA7900", #cDC1
    "#FF7300", #cDC2
    "#FFA196", #LC
    "#C7520A", #cDC mig
    "#948C3D"  #pDC

)

names(cell_type_leiden_subset) <- c(
    
    "$F_{ret, ECM}$",
    "$F_{ret, activated}$",
    "$F_{ret, immune}$",
    "$F_{pap, ECM}$",
    "$F_{DS}$",
    "$F_{DP}$",
    "$KC_{b}$",
    "$KC_{sb}$",
    "$vEC$",
    "$lEC$", 
    "$Pc$",
    "$Pc_{immune}$",
    "$Mlc$", 
    
    "$T_{h, cm/naive}$", 
    "$T_{h, em/effector}$",
    "$T_{h, memory/effector}$",
    "$T_{reg}$",
    "$T_{c, cm/naive}$",
    "$T_{c, em/effector}$",
    "$T_{c, memory/effector}$", 
    "$T_{inv}$",
    r"{$NK\ CD16-$}",
    r"{$NK\ CD16+$}",
    "$Cycling$", 
    
    "$Mono_{Cl}$", 
    "$Mono_{Int}$", 
    "$Mono_{nonCl}$",
    r"{$M\phi$}",
    r"{$M\phi_{Act}$}",
    r"{$M\phi_{Inf}$}",
    "$cDC1$",
    "$cDC2$",
    "$LC$",
    "$cDC_{Mig}$", 
    "$pDC$"

)

cell_type_leiden_subset_r <- c(
    
    "#09914F", #F ret ECM
    "#0CC96E", #F ret activate
    "#044526", #F ret immune 
    "#96FAA7", #F papa ECM
    "#097560", #F DS
    "#0B997A", #F DP
    "#255F78", #KC b
    "#71A3B9", #KC sb
    "#5B56F5", #vEC
    "#0D089E", #lEC
    "#8A88D1", #Pc
    "#53517D", #Pc immune
    "#805E41", #Mlc
    
    "#FF9EC6", #Th cm/naive 
    "#CC417B", #Th em/effector
    "#76ABA0", #Th memory/effector
    "#3A667A", #T reg
    "#B57E9F", #Tc cm/naive 
    "#96305B", #Tc em/effector
    "#0D6B58", #Tc memory/effector
    "#4F1930", #T inv
    "#AE88BA", #NK CD16-
    "#825A8F", #NK CD16+
    "#070C0D", #Cycling

    "#FFE500", #Mono Cl
    "#B39200", #Mono int
    "#FFC029", #Mono non cl
    "#F24949", #Mac
    "#BB161E", #Mac act
    "#69161E", #Mac inflm
    "#BA7900", #cDC1
    "#FF7300", #cDC2
    "#FFA196", #LC
    "#C7520A", #cDC mig
    "#948C3D"  #pDC

)

names(cell_type_leiden_subset_r) <- c(
    
    "F['ret, ECM']",
    "F['ret, activated']",
    "F['ret, immune']",
    "F['pap, ECM']",
    "F['DS']",
    "F['DP']",
    "KC['b']",
    "KC['sb']",
    "vEC",
    "lEC", 
    "Pc",
    "Pc['immune']",
    "Mlc", 
    
    "T['h, cm/naive']", 
    "T['h, em/effector']",
    "T['h, memory/effector']",
    "T['reg']",
    "T['c, cm/naive']",
    "T['c, em/effector']",
    "T['c, memory/effector']", 
    "T['inv']",
    "NK*' CD16-'",
    "NK*' CD16+'",
    "Cycling", 
    
    "Mono['Cl']", 
    "Mono['Int']", 
    "Mono['nonCl']",
    "M*Phi",
    "M*Phi['Act']",
    "M*Phi['Inf']",
    "cDC1",
    "cDC2",
    "LC",
    "cDC['Mig']", 
    "pDC"

) 

### Cobine colors
color <- list(
    
    patient_id=patient_id, 
    time_point=time_point, 
    hto_demux_class=hto_demux_class, 
    digestion_protocol=digestion_protocol, 
    cc_phase_class=cc_phase_class, 
    genotype_class=genotype_class,
    gvhd_class=gvhd_class, 
    cell_type_leiden=cell_type_leiden, 
    cell_type_leiden_subset=cell_type_leiden_subset, 
    cell_type_leiden_subset_r=cell_type_leiden_subset_r

)