PDFS := $(wildcard *.pdf)
PNGS := $(subst .pdf,.png,$(PDFS))

pngs: $(PNGS)

%.png: %.pdf
	pdftoppm $^ $(subst .png,,$@) -png -singlefile
	mv $@ ./png/.

info:
	$(info $(PDFS))
	$(info $(PNGS))

# $@ todo lo que está a la izquierda de :
# $^ todo lo que está a la derecha de :
