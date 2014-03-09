##
## @@FNAME@@ for @@PNAME@@ in @@FPATH@@
## 
## Made by @@AUTHOR@@
## Login   <@@AUTHORMAIL@@>
## 
## Started on  @@CDATE@@ @@AUTHOR@@
## Last update Tue Feb 05 10:40:37 2013 fabien casters
##

NAME    = 

CFLAGS  = -Werror -Wextra -Wall -W
LDFLAGS = -Werror -Wextra -Wall -W

SRC     = 

OBJ     = $(SRC:.c=.o)

CC      = gcc

RM      = rm -f

$(NAME): $(OBJ)
    $(CC) -o $(NAME) $(OBJ) $(LDFLAGS)

all: $(NAME)

clean:
    $(RM) $(OBJ)

fclean: clean
    $(RM) $(NAME)

re: fclean all

.PHONY: all clean re fclean
