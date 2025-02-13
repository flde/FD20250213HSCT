def scanorama_integrate(adata, hvg, key, dimred=100, file=None):
    
    # Subset genes
    adata = adata[:, (adata.X>=3).sum(axis=0)>=3]
    
    # Normalize data 
    sc.pp.normalize_total(adata)
    sc.pp.log1p(adata)
    
    # Scale 
    sc.pp.scale(adata, zero_center=True)
    
    # Subset by hvg 
    adata = adata[:, adata.var_names.isin(hvg)]
    
    # Subset data by i  
    adata_key = dict()
    for i in adata.obs[key].unique():

        adata_key[i] = adata[adata.obs[key]==i]
        
    adata_key = list(adata_key.values())
    
    # Scanorama with count matrix correction 
    scanorama.integrate_scanpy(adata_key, dimred=dimred, verbose=False)
    adata = ad.concat(adata_key, join="inner")
    
    # Set colors
    adata = set_color(adata, list(color.keys()))
    
    # Reset full gene matrix 
    adata_raw = adata.raw.to_adata()
    
    adata = adata.raw.to_adata()
    adata.raw = adata_raw
    
    # wirte output 
    if file is not None: 
        adata.write_h5ad(file)
    
    return(adata)