# Docker won't detect changes in hard links

In this environment, `tar -ch .` will create `mod.txt` as normal file and `modify_me.txt` as hard link. It can be verified using `python -c "import tarfile; print(tarfile.open('/tmp/test.tgz').getmember('./modify_me.txt').islnk())"`. Then, docker does not detect any changes in `modify_me.txt` and cache may not be invalidated and get broken. Workaround to this is to disable hard links using `--hard-dereference` for tar.

```
$ echo 123 > modify_me.txt

$ ./build.sh
Sending build context to Docker daemon  10.24kB
Step 1/3 : FROM python:3.8.5
 ---> 28a4c88cdbbf
Step 2/3 : COPY modify_me.txt .
 ---> Using cache
 ---> 9afe93276d41
Step 3/3 : RUN cat modify_me.txt
 ---> Using cache
 ---> 2534573072b8
Successfully built 2534573072b8

$ echo 456 > modify_me.txt

$ ./build.sh
Sending build context to Docker daemon  10.24kB
Step 1/3 : FROM python:3.8.5
 ---> 28a4c88cdbbf
Step 2/3 : COPY modify_me.txt .
 ---> Using cache
 ---> 9afe93276d41
Step 3/3 : RUN cat modify_me.txt
 ---> Using cache
 ---> 2534573072b8
Successfully built 2534573072b8
```

```
$ docker version
Client: Docker Engine - Community
 Version:           20.10.7
 API version:       1.41
 Go version:        go1.13.15
 Git commit:        f0df350
 Built:             Wed Jun  2 11:56:40 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.7
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.13.15
  Git commit:       b0f5bc3
  Built:            Wed Jun  2 11:54:48 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.6
  GitCommit:        d71fcd7d8303cbf684402823e425e9dd2e99285d
 runc:
  Version:          1.0.0-rc95
  GitCommit:        b9ee9c6314599f1b4a7f497e1f1f856fe433d3b7
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

$ tar --version
tar (GNU tar) 1.29
Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by John Gilmore and Jay Fenlason.
```
