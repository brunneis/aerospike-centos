# Aerospike Server (Community) over CentOS 7.
# Copyright (C) 2016 Rodrigo Martínez <dev@brunneis.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

FROM centos:7.2.1511
MAINTAINER "Rodrigo Martínez" <dev@brunneis.com>

################################################
# AEROSPIKE SERVER
################################################

ENV AEROSPIKE_VERSION 3.9.1.1
ENV ARCHIVE aerospike-server-community-${AEROSPIKE_VERSION}-el7.tgz
ENV ARCHIVE_URL "https://www.aerospike.com/artifacts/aerospike-server-community/${AEROSPIKE_VERSION}/$ARCHIVE"

# UTF-8 locale
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

# Install Aerospike
RUN \
  yum update -y \
  &&  yum install -y wget logrotate ca-certificates \
  && wget $ARCHIVE_URL \
  && wget $ARCHIVE_URL".sha256" -O sha256 \
  && cat sha256 | sha256sum -c - \
  && mkdir aerospike \
  && tar xzf $ARCHIVE --strip-components=1 -C aerospike \
  && rpm -i aerospike/aerospike-server-*.rpm \
  && mkdir -p /var/log/aerospike/ \
  && mkdir -p /var/run/aerospike/ \
  && rm -rf $ARCHIVE aerospike /var/lib/apt/lists/*
COPY entrypoint.sh /entrypoint.sh

# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]
VOLUME ["/etc/aerospike"]

# Expose Aerospike ports
# - 3000: service port, for client connections
# - 3001: fabric port, for cluster communication
# - 3002: mesh port, for cluster heartbeat
# - 3003: info port

EXPOSE 3000 3001 3002 3003

# Execute the run script in foreground mode
ENTRYPOINT ["/entrypoint.sh"]
CMD ["asd"]
