#!/bin/bash
#
# This script setups Python 3.6 alternate installation
# on CentOS 6
# Usage: wget -O python3-centos-6.sh https://raw.githubusercontent.com/vinodpandey/scripts/master/python3-centos-6.sh
# chmod +x python3-centos-6.sh
# ./python3-centos-6.sh

# Format inspired from https://github.com/getredash/redash/blob/master/setup/ubuntu/bootstrap.sh
# License: https://github.com/getredash/redash/blob/master/LICENSE

DIR=/tmp
VERSION=3.6.6
URL="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"
TARBALL=/tmp/Python-${VERSION}.tgz

cd $DIR

verify_root() {
    # Verify running as root:
    if [ "$(id -u)" != "0" ]; then
        if [ $# -ne 0 ]; then
            echo "Failed running with sudo. Exiting." 1>&2
            exit 1
        fi
        echo "This script must be run as root. Trying to run with sudo."
        sudo bash "$0" --with-sudo
        exit 0
    fi
}

check_python_version() {
    if [[ $(python3.6 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))') == 3.6.* ]]; then
    	SYS_VERSION=$(python3.6 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')
    	echo Python $SYS_VERSION already installed
    	exit 1
	fi
}

install_system_packages() {
	yum -y install gcc openssl-devel bzip2-devel
}

extract_python_source() {
	wget "$URL" -O "$TARBALL"
	tar -C "$DIR" -xvf "$TARBALL"
}
 
install_python() {
	cd Python-${VERSION}
	./configure --enable-optimizations
    make altinstall
}

verify_root
check_python_version
install_system_packages
extract_python_source
install_python

