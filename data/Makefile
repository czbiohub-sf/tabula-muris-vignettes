RMDS := $(wildcard *.Rmd)
VIGNETTE_RMDS := $(wildcard *Vignette*.Rmd)
CORES=32

all: clean
	for RMD in $(RMDS); do \
		echo $$RMD; \
		echo "rmarkdown::render('$$RMD', clean=TRUE)" | R --slave > $$RMD.out 2>$$RMD.err & \
	done

clean:
	rm -rf *.out *.err *_files

