#!/bin/sh
tar --hard-dereference -ch --exclude .git . | docker build - $@
