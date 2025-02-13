def harmony_integrate(adata, hvg, key, n_comps=100):
    
    # Subset count matrix 
    adata = adata[:, (adata.X>3).sum(axis=0)>=1]
    
    # Normalize data 
    sc.pp.normalize_total(adata)
    sc.pp.log1p(adata)
    
    # Scale 
    sc.pp.scale(adata, zero_center=False, max_value=10)
    
    # Subset by hvg 
    adata = adata[:, adata.var_names.isin(hvg)]
    
    # PCA 
    sc.pp.pca(adata, n_comps=n_comps, zero_center=False, svd_solver='arpack', use_highly_variable=False)
    
    # Harmony 
    sc.external.pp.harmony_integrate(adata, key=key, basis='X_pca', adjusted_basis='X_harmony', max_iter_harmony=50, verbose=False)
    
    # Reset full gene matrix 
    adata_raw = adata.raw.to_adata()
    
    adata = adata.raw.to_adata()
    adata.raw = adata_raw
    
    return(adata)