#!/usr/bin/env bash
find scalable -name "*.svg" -exec svgo {} \;
