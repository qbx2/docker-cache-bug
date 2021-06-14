#!/bin/sh
tar -ch --exclude .git . | docker build - $@
