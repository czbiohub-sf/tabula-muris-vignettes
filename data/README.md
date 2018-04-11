# Data

You can also download nicely aggregated data in `.rds` format for easy loading into `R`.
Simply unzip the contents of [TabulaMuris.zip](https://s3.amazonaws.com/czbiohub-tabula-muris/TabulaMuris.zip)
into the `data` folder. It can be loaded as

```
tm.droplet.matrix = readRDS(here("data", "TM_droplet_mat.rds"))
tm.droplet.metadata = read_csv(here("data", "TM_droplet_metadata.csv"))
```

Some vignettes also assume that you have downloaded the raw data from FigShare into

`00_facs_raw_data`: gene-cell count tables for FACS smartseq2 data and metadata
`01_droplet_raw_data`: CellRanger output count files for droplet data and metadata
