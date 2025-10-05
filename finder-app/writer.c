/*
 * writer.c
 *
 * Usage:
 *   writer <file> "<string>"
 *
 * Writes the provided string to the specified file
 * and logs all actions using syslog with LOG_USER.
 *
 * Returns:
 *   0 on success
 *   1 on argument error
 *   2 on I/O error
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <file> \"<string>\"\n", argv[0]);
        return 1;
    }

    const char *filepath = argv[1];
    const char *text = argv[2];

    /* open syslog for LOG_USER */
    openlog("writer", LOG_CONS | LOG_PID | LOG_NDELAY, LOG_USER);

    syslog(LOG_DEBUG, "Writing \"%s\" to %s", text, filepath);

    FILE *fp = fopen(filepath, "w");
    if (!fp) {
        syslog(LOG_ERR, "fopen(%s) failed: %s", filepath, strerror(errno));
        closelog();
        return 2;
    }

    if (fprintf(fp, "%s\n", text) < 0) {
        syslog(LOG_ERR, "fprintf(%s) failed: %s", filepath, strerror(errno));
        fclose(fp);
        closelog();
        return 2;
    }

    if (fflush(fp) != 0) {
        syslog(LOG_ERR, "fflush(%s) failed: %s", filepath, strerror(errno));
        fclose(fp);
        closelog();
        return 2;
    }

    int fd = fileno(fp);
    if (fd == -1) {
        syslog(LOG_ERR, "fileno(%s) failed: %s", filepath, strerror(errno));
        fclose(fp);
        closelog();
        return 2;
    }

    if (fsync(fd) != 0) {
        syslog(LOG_ERR, "fsync(%s) failed: %s", filepath, strerror(errno));
        fclose(fp);
        closelog();
        return 2;
    }

    if (fclose(fp) != 0) {
        syslog(LOG_ERR, "fclose(%s) failed: %s", filepath, strerror(errno));
        closelog();
        return 2;
    }

    syslog(LOG_DEBUG, "Successfully wrote \"%s\" to %s", text, filepath);
    closelog();
    return 0;
}
