CC = gcc
CFLAGS = -Wall -g
TARGET = word_ladder

OBJ = word_ladder.o

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

word_ladder.o: word_ladder.c
	$(CC) $(CFLAGS) -c word_ladder.c

clean:
	rm -f *.o $(TARGET)
