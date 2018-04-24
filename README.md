# tabula-muris-vignettes

## What's this?

This is a collection of analysis vignettes showcasing the possibilities and challenges provided by recent organism-wide single-cell sequencing projects on the mouse.

There are three datasets, two from CZ Biohub's [Tabula Muris](http://tabula-muris.ds.czbiohub.org/) and one from the Guo lab's [Mouse Cell Atlas](http://bis.zju.edu.cn/MCA/). They each cover 12-20 different organs, and provide different technical profiles, in terms of cell sorting, lysis, barcoding, and library preparation, and cover from 12-20 different organs.

We believe that these datasets provide sufficient breadth and diversity to serve
as model systems for:

* cell type annotation and reannotation at various levels of ontological depth
* building and validating cell type classifiers
* manifold alignment and batch-effect-aware analyses
* assessing the variability in gene expression of cell types present in many organs, like immune cells, endothelial cells, and epithelial cells.
* measuring sex differences in gene expression (Tabula Muris is sex-balanced)
* measuring the variability in biological claims (like which genes are differentially expressed between populations) to be expected between studies

## How to use

Instructions on how to download the datasets are in the `data` directory in the repo. Given those instructions (and sufficient installed dependencies), all notebooks in the `vignettes` should run.

## How to contribute

Contributed posts are welcome! We are working out the details of publication (likely through a blog driven by this repo), but the basic workflow to make a post is:

1. Make a new branch
2. Put all notebooks and generated html in the `vignettes`  folder
3. Submit a PR for review

## Vignettes

* [The Hazards of Regression](http://htmlpreview.github.io/?https://github.com/czbiohub/tabula-muris-vignettes/blob/master/vignettes/regression/Regression_Hazards.nb.html): What happens when you try to remove technical confounders that are correlated with cell type?
