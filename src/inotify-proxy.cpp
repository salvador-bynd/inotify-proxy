#include <ftw.h>      // http://man7.org/linux/man-pages/man3/ftw.3.html
#include <utime.h>    // http://linux.die.net/man/2/utime
#include <chrono>
#include <cstring>    // strlen
#include <iostream>
#include <string>
#include <thread>
#include <unordered_map>

std::unordered_map<std::string, int> filemap;

static int display_info(const char* fpath, const struct stat* sb, int tflag, struct FTW *ftwbuf) {
  if (tflag == FTW_F) {
    std::string filepath(fpath, strlen(fpath)); // Convert the reused pointer to a permanent value
    timespec mtime = sb->st_mtim;

    if (filemap.count(filepath)){
      if (filemap[filepath] != mtime.tv_sec) {
        std::cout << filepath << " has changed at " << mtime.tv_sec << std::endl;

        // Touch the file to trigger an inotify event
        int success = utime(fpath, 0);
        if (success != 0) {
          std::cout << "error touching " << filepath << std::endl;
        }

        // Get the time that the file now says it was modified
        struct stat attrib;
        stat(fpath, &attrib);

        // Update map to the new time
        filemap[filepath] = attrib.st_mtime;
      }
    } else {
      filemap.emplace(filepath, mtime.tv_sec);
      std::cout << filepath << ' ' << mtime.tv_sec << std::endl;
    }
  }
  return 0;           /* To tell nftw() to continue */
}

int main(int argc, char *argv[]) {
  std::cout << "watching:" << std::endl;

  int flags = 0;
  int success;

  while(success != -1){
    success = nftw(".", display_info, 20, flags);
    std::this_thread::sleep_for(std::chrono::milliseconds(1000));
  }

  return success == -1 ? 1 : 0;
}
