RMDS := $(wildcard *.Rmd)
VIGNETTE_RMDS := $(wildcard *Vignette*.Rmd)
CORES=32

all: clean ../tabula-muris/00_data_ingest/00_facs_raw_data
	for RMD in $(RMDS); do \
		echo $$RMD; \
		echo "rmarkdown::render('$$RMD', clean=TRUE)" | R --slave > $$RMD.out 2>$$RMD.err & \
	done

clean:
	rm -rf *.out *.err *_files

../tabula-muris/00_data_ingest/00_facs_raw_data:
	cd ../tabula-muris
	make download_data
