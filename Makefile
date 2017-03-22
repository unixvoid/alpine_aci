OS_PERMS=sudo
ALPINE_FS=https://cryo.unixvoid.com/bin/filesystem/alpine/linux-latest-amd64.rootfs.tar.gz

all build:	build_aci

prep_aci:
	mkdir -p alpine-layout/rootfs/
	wget -O rootfs.tar.gz $(ALPINE_FS)
	tar -xzf rootfs.tar.gz -C alpine-layout/rootfs/
	cp deps/resolv.conf alpine-layout/rootfs/etc/
	cp deps/manifest.json alpine-layout/manifest
	rm rootfs.tar.gz

build_aci:	prep_aci
		actool build alpine-layout alpine.aci
		@echo "alpine.aci built"

build_travis_aci:	prep_aci
		wget https://github.com/appc/spec/releases/download/v0.8.7/appc-v0.8.7.tar.gz
		tar -zxf appc-v0.8.7.tar.gz
		# build image
		appc-v0.8.7/actool build alpine-layout alpine.aci && \
		rm -rf appc-v0.8.7*
		@echo "alpine.aci built"

run:
	$(OS_PERMS) rkt run ./alpine.aci --insecure-options=image --interactive --exec /bin/ash

clean:
	rm -rf alpine-layout
	rm -f alpine.aci
	rm -rf appc*
	rm -rf rootfs.*
