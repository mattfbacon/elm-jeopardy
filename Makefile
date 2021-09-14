.PHONY: build

ELM_FILES := \
	Board.elm \
	Config.elm \
	Main.elm \
	MsgModel.elm \
	Position.elm
LESS_FILES := \
	index.less
STATIC_FILES := \
	index.html \
	Korinna-Regular.otf

DIR_SRC := src
DIR_LESS := less
DIR_STATIC := static
DIR_DIST := dist

ELM := elm
LESSC := lessc

ELM_FLAGS := --optimize
LESS_FLAGS := -x

$(DIR_DIST)/:
	mkdir -p $(DIR_DIST)
$(DIR_DIST)/%.css: $(DIR_LESS)/%.less | $(DIR_DIST)/
	$(LESSC) $(LESS_FLAGS) $< $@
$(DIR_DIST)/index.js: $(addprefix $(DIR_SRC)/,$(ELM_FILES)) | $(DIR_DIST)/
	$(ELM) make $(ELM_FLAGS) --output="$@" $(DIR_SRC)/Main.elm
$(DIR_DIST)/%: $(DIR_STATIC)/% | $(DIR_DIST)/
	cp $< $@

build: $(DIR_DIST)/index.js $(patsubst %.less,$(DIR_DIST)/%.css,$(LESS_FILES)) $(patsubst %,$(DIR_DIST)/%,$(STATIC_FILES))
.DEFAULT_GOAL = build
