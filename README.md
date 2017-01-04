# aerospike-centos
Docker image of Aerospike Server (Community) on CentOS 7.

Based on the Ubuntu dockerfile written by Aerospike and available [here](https://github.com/aerospike/aerospike-server.docker).

For a simple test you can run the image as follows:

`docker run -tid --name aerospike -v $(pwd)/aerospike.conf:/etc/aerospike/aerospike.conf:ro brunneis/aerospike-centos`
