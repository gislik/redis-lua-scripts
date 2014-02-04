#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
  ssize_t n;
  char *line = NULL;
  char *bp = NULL;
  char *chunk = NULL;
  char *err;
  char prev[8];
  size_t len = 0;
  short dots;
  unsigned int k, i;
  unsigned int ip;

  bzero(prev, sizeof(prev));
  
  while ((n = getline(&line, &len, stdin)) != -1) {
    ip = 0;
    dots = 4;
    line[n-2] = '\0';
    line[n-1] = '\0';
    if (*line == '$') {
      strncpy(prev, line, sizeof(prev));
      continue;
    }
    for (;;) {
      bp = dots == 4 ? line : NULL;
      chunk = strtok(bp, ".");
      if (chunk == NULL) break;
      k = strtol(chunk, &err, 10);
      if (chunk == err) break;
      ip = (ip << 8) | k & 0xFF;
      dots--;
    } 
    if (dots == 0) {
      printf("$8\r\n");
      printf("%08x\r\n", ip);
      bzero(prev, sizeof(prev));
    } else {
      if (*prev != '\0') {
        printf("%s\r\n", prev);
        bzero(prev, sizeof(prev));
      }
      for (bp = line; bp - line < n-2; bp++) 
        if (*bp == '\0') *bp = '.';      
      printf("%s\r\n", line);
    }
 
  }
  if (line != NULL) free(line);
  exit(EXIT_SUCCESS);
}
