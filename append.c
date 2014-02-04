#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>

#define BUFLEN 8192

void error_usage(const char const *progname) 
{
  printf("Usage: %s <key-prefix>\n", progname);
  exit(9);
}

int main(int argc, char *argv[]) 
{
  const char * const line;
  const char *s;
  const char *prefix;
  char buf[BUFLEN];
  char *bp;
  size_t len;
  ssize_t n;
  int nlines = 0, pfound = 0;

  if (argc != 2)
    error_usage(argv[0]);

  prefix = argv[1];

  while ((n = getline((char **) &line, &len, stdin)) != -1) {
    if (nlines == 0) {                        assert(n > 2);
      s = line;                               assert(*s == '*');
      nlines = 2*atoi(++s)+1;                 assert(nlines > 0);
      bp = buf;
      pfound = 0;
    } 
    if (pfound == 1) {
      printf("%s", line);
    } else if (strstr(line, prefix) != NULL) {
      pfound = 1;
      *bp = '\0';
      printf("%s", buf);
      printf("%s", line);
    } else {
      strncpy(bp, line, n);
      bp += n;
    }
    nlines--;
  }

  if (line != NULL) free((char *) line);
  exit(EXIT_SUCCESS);
}
