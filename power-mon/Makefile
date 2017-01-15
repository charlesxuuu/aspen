CC = gcc

CFLAGS = -w -O2
LIBS = -lm

TARGET = rapl-bw

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $(TARGET) $(TARGET).c $(LIBS)

clean:
	$(RM) $(TARGET)
