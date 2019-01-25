#!/bin/bash
## version 1.0
## Put current temperature in CSV file along with date,
## and the temperature of core 0 for the sake of easy looking and graphing
##
## Yes I should correctly escape quotation marks,
## and yes I should use collectd and grafana
## but this is 4 lines in a crontab run every
## 30 minutes just for this weekend.

now=$(date "+%m/%d/%Y %H:%M")
quote='"'
temz=$(sensors -u)

echo "$quote$now$quote,$quote$(echo "$temz" | head -n4 | tail -n1 | cut -d' ' -f4)$quote,"$quote$temz$quote
