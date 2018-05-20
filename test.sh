#!/bin/bash

for file in tests/*.txt
do
   time cat $file | ./flp18-log
done
