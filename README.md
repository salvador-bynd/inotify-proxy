# Changewatcher

A utility to help with development within Docker containers on OSX.

Containers run on OSX through docker-machine or boot2docker are running within a VirtualBox virtual machine. Files can be shared between OSX and the container through shared volumes. This allows the developer to continue to use their editor of choice while building and running their code inside the container.

Unfortunately, Virtual Box does not trigger inotify events within the container when a file is modified on the OSX host. This issue is described here:
https://www.virtualbox.org/ticket/10660
https://www.virtualbox.org/ticket/14234

Workflows that rely on inotify events to trigger build processes are limited by this issue.

Changewatcher is a small utility to restore these build processes. It polls for filechanges, then touches those files again _inside_ the container, triggering the necessary inotify events.

## Usage

Changewatcher must be run inside a container. It will monitor all files and descendents of the directory it is run from.

Given the following directory structure within a container named myapp_web_1

```
app
  assets
    javascript
      index.js
      libs
        jquery.js
bin
  changewatcher
```
Changes within the javascript folder (including within the libs folder) can be monitored with:

```
$ docker exec -ti myapp_web_1 /bin/bash
$$ cd app/assets/javascript
$$ ../../../bin/changewatcher
```

Once running, changewatcher will initially list all of the files it is monitoring. When one of those files changes the name of the changed file will be displayed. Any build processes running in that container and listening for changes on that file will be triggered.

To reduce the overhead of polling for changes, polling is only run once per second.
