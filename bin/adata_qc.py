# Ploting for QC
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

def plot_qc_density(adata, qc_metric, sample_col="sample_name", cutoff=None, n_cols=4, figsize=(4, 4)):
    
    # Check if sample col exists
    if sample_col not in adata.obs:
        raise ValueError(f"Sample column '{sample_col}' is missing in adata.obs.")

    samples = adata.obs[sample_col].unique()
    n_rows = int(np.ceil(len(samples) / n_cols))

    fig, axes = plt.subplots(n_rows, n_cols, figsize=(figsize[0] * n_cols, figsize[1] * n_rows), constrained_layout=True)

    for ax, sample in zip(axes.flatten(), samples):
        subset = adata.obs[adata.obs[sample_col] == sample]
        sns.kdeplot(subset[qc_metric], ax=ax, fill=True)
        if cutoff is not None:
            ax.axvline(cutoff, color="red", linestyle="--", label=f"Cutoff: {cutoff}")
        ax.set_title(sample)
        ax.set_xlabel(qc_metric)
        ax.set_ylabel("Density")
        ax.legend()

    for ax in axes.flatten()[len(samples):]:  # Hide unused subplots
        ax.set_visible(False)

    plt.show()
    
    
def plot_qc_scatter(adata, x_metric, y_metric, sample_col="sample_name", dot_size=5, x_cutoff=None, y_cutoff=None, n_cols=4, figsize=(4, 4)):
    if sample_col not in adata.obs:
        raise ValueError(f"Sample column '{sample_col}' is missing in adata.obs.")

    samples = adata.obs[sample_col].unique()
    n_rows = int(np.ceil(len(samples) / n_cols))

    fig, axes = plt.subplots(n_rows, n_cols, figsize=(figsize[0] * n_cols, figsize[1] * n_rows), constrained_layout=True)

    for ax, sample in zip(axes.flatten(), samples):
        subset = adata.obs[adata.obs[sample_col] == sample]
        sns.scatterplot(x=subset[x_metric], y=subset[y_metric], ax=ax, s=dot_size, alpha=0.5)

        # Add cutoff lines if specified
        if x_cutoff is not None:
            ax.axvline(x_cutoff, color="red", linestyle="--", label=f"X Cutoff: {x_cutoff}")
        if y_cutoff is not None:
            ax.axhline(y_cutoff, color="red", linestyle="--", label=f"Y Cutoff: {y_cutoff}")

        ax.set_title(f"Sample {sample}")
        ax.set_xlabel(x_metric)
        ax.set_ylabel(y_metric)
        # ax.legend()

    for ax in axes.flatten()[len(samples):]:  # Hide unused subplots
        ax.set_visible(False)

    plt.show()