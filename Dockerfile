FROM python:3.8.5
COPY modify_me.txt .
RUN cat modify_me.txt
