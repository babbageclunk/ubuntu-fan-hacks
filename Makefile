.PHONY: all

CONFIG_DRIVES :=					\
	vm-co-19-config.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: user-data meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-config.iso,%,$@) -k ~/.ssh/id_rsa.pub -u user-data $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

clean:
	$(RM) $(CONFIG_DRIVES)
