#ifndef COMMAND_H
#define COMMAND_H

typedef struct Command {
    int type; // 1=MOVE,2=LEFT,3=RIGHT,4=STOP,5=REPEAT
    int value;
    struct Command** subcommands;
    int subcount;
} Command;

#endif
