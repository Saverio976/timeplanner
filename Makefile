TARGET := timeplanner

SRC := $(shell find src -name '*.c')

OBJ := $(SRC:.c=.o)


CFLAGS := -Wall -Wextra -Wpedantic

CC?=gcc

build: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

install: build
	mv $(TARGET) /usr/local/bin/
	mv src/timeplanner.py /usr/local/bin/

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(TARGET)

re: fclean all
