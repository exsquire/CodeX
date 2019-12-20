#!/bin/bash
echo Running Assignment 4 Master Script

./copyExomes.sh
echo ----------------
./createCrisprReady.sh
echo ----------------
./identifyCrisprSite.sh
echo ----------------
./editGenome.sh
echo ----------------
./summary.py
