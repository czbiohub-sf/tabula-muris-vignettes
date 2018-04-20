# Data files for R

You can download nicely aggregated data in `.rds` format for easy loading into `R`.
Simply unzip the contents of [TabulaMuris.zip](https://s3.amazonaws.com/czbiohub-tabula-muris/TabulaMuris.zip)
into the `data` folder. It can be loaded as

```R
tm.droplet.matrix = readRDS(here("data", "TM_droplet_mat.rds"))
tm.droplet.metadata = read_csv(here("data", "TM_droplet_metadata.csv"))
```

Some vignettes also assume that you have downloaded the raw data from FigShare into

`00_facs_raw_data`: gene-cell count tables for FACS smartseq2 data and metadata
`01_droplet_raw_data`: CellRanger output count files for droplet data and metadata

# Data files for Python

We have also made [AnnData](http://anndata.readthedocs.io/en/latest/)-formatted h5ad files for use in Python; you can download them [here](https://s3.amazonaws.com/czbiohub-tabula-muris/TabulaMuris.h5ad.zip). You can load them using the [Scanpy](http://scanpy.readthedocs.io/en/latest/index.html) library:

```python
import pandas
import scanpy

tm_facs_metadata = pd.read_csv('data/TM_facs_metadata.csv')
tm_facs_data = scanpy.anndata.read_h5ad('data/TM_facs_mat.h5ad')
```
