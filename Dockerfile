FROM python:3.8.5
COPY some_dir/ some_dir/
RUN cat some_dir/modify_me.txt
