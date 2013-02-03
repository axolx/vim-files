.PHONY: submodules

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  submodules       Update submodules"

submodules:
	git submodule foreach git pull
	git status
