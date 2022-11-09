TARGET := timeplanner

SRC := $(shell find src -name '*.c')

OBJ := $(SRC:.c=.o)


CFLAGS := -Wall -Wextra -Wpedantic

LIBGIT2DIRPATH := ./lib/libgit2/build

LIBGIT2LIB := git2

LIBGIT2_PATH := ./lib/libgit2/build/libgit2.so

LDFLAGS := -L  -lgit2

CC?=gcc

build: $(TARGET)

$(TARGET): $(OBJ) $(LIBGIT2_PATH)
	$(CC) $(OBJ) $(LDFLAGS) -o $(TARGET)

install: build
	mv $(TARGET) /usr/local/bin/
	mv src/timeplanner.py /usr/local/bin/

$(LIBGIT2_PATH): lib/libgit2/
	command -v cmake || (echo "Install cmake" && exit 1)
	git submodule update --recursive --init
	cd ./lib/libgit2/ && mkdir build && cd build && cmake .. && cmake --build .

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf ./lib/libgit2/build
	rm -rf $(TARGET)

re: fclean all
