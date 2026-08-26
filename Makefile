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
	rm -f secrets.yaml
	rm -f controlplane.yaml
	rm -f worker.yaml
	rm -f talosconfig
	rm -f kubeconfig
	rm -f kubelet-patch.yaml
	find tofu -type f -name "*.tfplan" -delete -print

clean-all: clean
	rm -rf tofu/environments/aws-demo/.terraform/