CC ?= cc

CFLAGS = -O2 -s
LDFLAGS = -O2 -s -lm -ldl

CFLAGS += -ILuaJIT/src -Isrc/lib/compat-5.3 `sdl2-config --cflags`
LDFLAGS += -LuaJIT/src `sdl2-config --libs`

SRC := src/main.c src/rencache.c src/renderer.c \
	src/xalloc.c src/api/api.c src/api/renderer.c \
	src/api/renderer_font.c src/api/system.c \
	src/lib/stb/stb_truetype.c src/lib/compat-5.3/lutf8lib.c \
  src/lib/compat-5.3/compat-5.3.c

OBJ := $(SRC:.c=.o)

all: lite

lite: $(OBJ) libluajit.a
	$(CC) -o $@ $^ $(LDFLAGS)

lite.exe: $(OBJ) libluajit.a res.res
	$(CC) -o $@ $^ $(LDFLAGS)

libluajit.a:
	$(MAKE) -C LuaJIT/src BUILDMODE=static libluajit.a
	cp LuaJIT/src/libluajit.a .

res.res: res.rc
	windres $^ -O coff -o $@

clean:
	rm -f lite lite.exe libluajit.a $(OBJ)
	$(MAKE) -C LuaJIT/src clean

.PHONY: clean lite.exe libluajit.a
