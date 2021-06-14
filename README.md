# Docker won't detect changes in hard links

In this environment, `tar -ch .` will create `mod.txt` as normal file and `modify_me.txt` as hard link. It can be verified using `python -c "import tarfile; print(tarfile.open('/tmp/test.tgz').getmember('./modify_me.txt').islnk())"`. Then, docker does not detect any changes in `modify_me.txt` and cache may not be invalidated and get broken. Workaround to this is to disable hard links using `--hard-dereference` for tar.

```
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
