#!/bin/sh
set -e

PATH=/usr/local/sbin:$PATH
export PATH

tac_plus-ng -d 2 cp-tacplus.cfg
