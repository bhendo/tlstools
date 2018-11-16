#!/bin/bash
set -e

HOST=$1

openssl s_client -connect $HOST | openssl x509 -text
/app/cipherscan/cipherscan $HOST
/app/cipherscan/analyze.py -t $HOST