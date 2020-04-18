SRC_DIR = src
BUILD_DIR = build
RELEASE_DIR = build/release
DATA_DIR = data
TARGET_NAME = ld46

HAXEFLAGS = --class-path ${SRC_DIR} --main Main --library heaps -D resourcesPath=data/assets

HX_FILES = $(shell find $(SRC_DIR) -name "*.hx")
ASSET_FILES = $(shell find $(DATA_DIR)/assets -type f)

###   Web development   ###
WEB_TARGET = ${BUILD_DIR}/web/${TARGET_NAME}.js
${WEB_TARGET}: ${HX_FILES} ${ASSET_FILES}
	haxe ${HAXEFLAGS} --js ${WEB_TARGET} -debug

WEB_INDEX = ${BUILD_DIR}/web/index.html
${WEB_INDEX}: $(BUILD_DIR)/%: $(DATA_DIR)/%
	cp $^ $@

###   Web release   ###
RELEASE_WEB_TARGET = ${RELEASE_DIR}/web/${TARGET_NAME}.js
${RELEASE_WEB_TARGET}: ${HX_FILES} ${ASSET_FILES}
	haxe ${HAXEFLAGS} --js ${RELEASE_WEB_TARGET}

RELEASE_WEB_INDEX = ${RELEASE_DIR}/web/index.html
${RELEASE_WEB_INDEX}: $(RELEASE_DIR)/%: $(DATA_DIR)/%
	cp $^ $@

###   Hashlink   ###
HL_TARGET = ${BUILD_DIR}/hl/${TARGET_NAME}.hl
${HL_TARGET}: ${HX_FILES} ${ASSET_FILES}
	haxe ${HAXEFLAGS} --library hlsdl --hl ${HL_TARGET}

###   Native linux   ###
LINUX_BIN_DIR = ${BUILD_DIR}/linux/bin
LINUX_SRC_DIR = ${BUILD_DIR}/linux/src
HDLL_FILES = /usr/lib/sdl.hdll /usr/lib/openal.hdll /usr/lib/ui.hdll /usr/lib/fmt.hdll
CPPFLAGS = -O3 -I ${LINUX_SRC_DIR} -std=c11
LINKER_FLAGS = -lm -lhl -lSDL2 -lGL

LINUX_TARGET = ${LINUX_BIN_DIR}/${TARGET_NAME}
${LINUX_TARGET}: ${HX_FILES} ${ASSET_FILES}
	mkdir -p ${LINUX_BIN_DIR}
	haxe ${HAXEFLAGS} --library hlsdl --hl ${LINUX_SRC_DIR}/main.c
	gcc ${HDLL_FILES} ${LINUX_SRC_DIR}/main.c ${CPPFLAGS} ${LINKER_FLAGS} -o ${LINUX_TARGET}

###   Commands   ###
.PHONY:
web: ${WEB_TARGET} ${WEB_INDEX}
release-web: ${RELEASE_WEB_TARGET} ${RELEASE_WEB_INDEX}
hl: ${HL_TARGET}
linux: ${LINUX_TARGET}

run-web: web
	firefox ${WEB_INDEX} &
run-release-web: release-web
	firefox ${RELEASE_WEB_INDEX} &
run-hl: hl
	hl ${HL_TARGET}
run-linux: linux
	${LINUX_TARGET}
