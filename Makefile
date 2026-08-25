.PHONY: default preview html pdf powerpoint images clean

default: powerpoint

preview:
	marp -p -s .

html:
	marp presentation.md

pdf:
	marp presentation.md --pdf --allow-local-files	

powerpoint:
	marp presentation.md --pptx --allow-local-files

images:
	marp presentation.md --images png --allow-local-files

clean:
	rm -f presentation.pdf
	rm -f presentation.html
	rm -f presentation.pptx
	rm -rf presentation.*.png