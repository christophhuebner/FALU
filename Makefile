all: macro copy-final

PDK_ROOT ?= ~/.ciel
PDK ?= ihp-sg13g2

RUN_TAG = $(shell ls librelane/runs/ -1 | tail -n 1)

# Macro - LibreLane

macro:
	cd librelane; librelane config.yaml --pdk $(PDK)
.PHONY: macro

macro-openroad:
	cd librelane; librelane config.yaml --pdk $(PDK) --last-run --flow OpenInOpenROAD
.PHONY: macro-openroad

macro-klayout:
	cd librelane; librelane config.yaml --pdk $(PDK) --last-run --flow OpenInKLayout
.PHONY: macro-klayout

copy-macro:
	mkdir -p macro/
	rm -rf macro/*
	cp -r librelane/runs/${RUN_TAG}/final/* macro/
.PHONY: copy-macro
