# Running TLS Tools

```bash
usage: docker run [docker_option] bhendo/tlstools [option] host_name
  docker_options:
    -v $(pwd):/output : map the current directory to retrieve tool ouput
  options:
    -p  : port
    -h  : help
  example: docker run -v $(pwd):/output bhendo/tlstools -p 8443 localhost
```