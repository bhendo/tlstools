#!/bin/bash
set -e

HOST=""
PORT=443

usage () {
  echo "usage: docker run [docker_option] bhendo/tlstools [option] host_name"
  echo "  docker_options:"
  echo "    -v $(pwd):/output : map the current directory to retrieve tool ouput"
  echo "  options:"
  echo "    -p  : port"
  echo "    -h  : help"
  echo "  example: docker run -v $(pwd):/output bhendo/tlstools -p 8443 localhost"
}

timestamp () {
  date +"%Y-%m-%d_%H-%M-%S"
}

if [ $# == 0 ]; then
  usage
  exit 1
fi

while getopts ":hp:" opt; do
  case $opt in
    h)
      usage >&2
      exit 1
      ;;
    p)
      PORT=$OPTARG
      ;;
    \?)
      usage >&2
      exit 1
      ;;
    :)
      usage >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if [ $# == 1 ]; then
  HOST=$1
  OUTPUTDIR="/output/$HOST-$PORT-$(timestamp)"
  mkdir -p $OUTPUTDIR
  openssl s_client -connect $HOST:$PORT | openssl x509 -text | tee $OUTPUTDIR/cert_info.txt
  /tools/cipherscan/cipherscan $HOST:$PORT | tee $OUTPUTDIR/cipherscan.txt
  /tools/cipherscan/analyze.py -t $HOST:$PORT | tee $OUTPUTDIR/cipherscan_analyze.txt
  sslyze --regular $HOST:$PORT | tee $OUTPUTDIR/sslyze.txt
else
  usage
  exit 1
fi