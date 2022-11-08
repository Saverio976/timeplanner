TARGET := timeplanner

SRC := $(shell find src -name '*.c')

OBJ := $(SRC:.c=.o)


CFLAGS := -Wall -Wextra -Wpedantic

CC?=gcc

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $(TARGET)

clean:
	rm -rf $(OBJ)

fclean: clean
	rm -rf $(TARGET)

re: fclean all
