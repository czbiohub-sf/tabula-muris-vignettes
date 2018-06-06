all:
	upload

rds:
	cd data && make

zip: rds
	zip -j TabulaMuris.zip data/*

upload:
	aws s3 cp --acl public-read TabulaMuris.zip s3://czbiohub-tabula-muris
