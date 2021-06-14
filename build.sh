#!/bin/sh
tar -czh . | docker build - $@
