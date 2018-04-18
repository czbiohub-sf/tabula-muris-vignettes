find_markers <- function(tiss, annotation, min.cells = 50){
  annotations = tiss@meta.data[,annotation]
  unique_annotations = unique(annotations)
  enumerated_annotations = 0:(length(unique_annotations)-1)
  
  annotation_ident = as.factor(plyr::mapvalues(x = annotations, from = unique_annotations, to = enumerated_annotations))
  names(annotation_ident) = names(tiss@ident)
  tiss@ident = annotation_ident
  tiss.markers <- FindAllMarkers(object = tiss, only.pos = TRUE, min.pct = 0.25, thresh.use = 0.25, 
                                 min.cells = min.cells)
  
  # Add a column showing what the annotations originally were
  tiss.markers[, annotation] = as.factor(plyr::mapvalues(x=tiss.markers$cluster, from=enumerated_annotations, to=unique_annotations))
  
  return(tiss.markers)
}

create_seurat_object = function(raw.data, meta.data, method){
  
  if (method == 'droplet'){
    scale = 1e4
  } else {
    scale = 1e6
  }
  
  # Find ERCC's, compute the percent ERCC, and drop them from the raw data.
  erccs <- grep(pattern = "^ERCC-", x = rownames(x = raw.data), value = TRUE)
  percent.ercc <- Matrix::colSums(raw.data[erccs, ])/Matrix::colSums(raw.data)
  ercc.index <- grep(pattern = "^ERCC-", x = rownames(x = raw.data), value = FALSE)
  raw.data <- raw.data[-ercc.index,]
  
  # Create the Seurat object with all the data
  tiss <- CreateSeuratObject(raw.data = raw.data, project = paste0('b_cells_', method))
  tiss <- AddMetaData(object = tiss, meta.data)
  tiss <- AddMetaData(object = tiss, percent.ercc, col.name = "percent.ercc")
  
  
  # Calculate percent ribosomal genes.
  ribo.genes <- grep(pattern = "^Rp[sl][[:digit:]]", x = rownames(x = tiss@data), value = TRUE)
  percent.ribo <- Matrix::colSums(tiss@raw.data[ribo.genes, ])/Matrix::colSums(tiss@raw.data)
  tiss <- AddMetaData(object = tiss, metadata = percent.ribo, col.name = "percent.ribo")
  
  if (method == 'facs'){
    # Change default name for sums of counts from nUMI to nReads
    colnames(tiss@meta.data)[colnames(tiss@meta.data) == 'nUMI'] <- 'nReads'
    tiss <- FilterCells(object = tiss, subset.names = c("nGene", "nReads"), 
                        low.thresholds = c(500, 50000))
  } else {
    tiss <- FilterCells(object = tiss, subset.names = c("nGene", "nUMI"), 
                        low.thresholds = c(500, 1000))
  }
  
  tiss <- process_tissue(tiss, scale)
  return (tiss)
}

process_tissue = function(tiss, scale){
  tiss <- NormalizeData(object = tiss, scale.factor = scale)
  tiss <- ScaleData(object = tiss)
  tiss <- FindVariableGenes(object = tiss, do.plot = TRUE, x.high.cutoff = Inf, y.cutoff = 0.5)
  tiss <- RunPCA(object = tiss, do.print = FALSE)
  tiss <- ProjectPCA(object = tiss, do.print = FALSE)
}

# Read curated GO terms
go_data = read_csv(here('vignettes' ,'bcells', 'plasma_membrane_and_secretion_go_terms.csv'))
go_data = go_data %>% mutate(category_v2 = replace(category, "immune" %in% category, category))


co.stimulatory.immune.checkpoint.genes = c('Pvr', 'Cd226',   # CD266 & CD155 Immune checkpoint
                     "Cd40", "Cd40lg", # CD40 & CD40L 
                     "Tnfrsf4", "Tnfsf4",    # OX40 & OX40L
                     "Tnfrsf14", "TNFSF14",  # HVEM & LIGHT
                     "Cd28", "Cd80", "Cd86", # CD28 & CD80 (CD86)
                     "Tnfrsf18", "Tnfsf18",  # GITR & GITR Ligand
                     "Cd27", "Cd70",         # Cd27 & CD70
                     "Tnfrsf9", "Tnfsf9",    # 4-1BB & 4-1BBL
                     "Icos", "Icosl"         # ICOS & ICOS ligand
                     )

co.inhibitory.immune.checkpoint.genes = c("Pdcd1", "Cd274",  # PD1 & PD-L1
                                          "Ctla4", "Cd80", "Cd86",  # CTLA-4 & CD80 (CD86)
                                          "Cd276",  # B7-H3 / CD276
                                          "Vtcn1",  # B7-H4 / B7S1 / B7x
                                          "Tnfrsf14", "Btla",   # HVEM & BTLA
                                          "Tnfrsf14", "Cd160",  # HVEM & CD160
                                          "Lag3",  # LAG3 /CD233/ Lymphocyte activation gene 3
                                          "Lgals9", "Havcr2",  # Galectin-9 & TIM-3
                                          "Ido1",  # 	Indoleamine 2,3-dioxygenase/IDO
                                          "Vsir",  # 	VISTA / B7-H5 / GI24
                                          "Ceacam1",  # 	CEACAM1 / CD66a,
                                          "Sirpa", "Cd47",  # 	SIRP alpha & CD47
                                          "Cd244", "Cd48",  # 	2B4 & CD48 
                                          "Tigit", "Pvr"    # 	TIGIT & CD155
                                          )

immune.checkpoint.genes = c(co.inhibitory.immune.checkpoint.genes, co.stimulatory.immune.checkpoint.genes)


write_markers = function(markers, filename){
  # Convert to a tidy tibble
  tbl = as.tibble(markers)
  tbl[, "gene"] = rownames(markers)
  write_csv(tbl, filename)
}