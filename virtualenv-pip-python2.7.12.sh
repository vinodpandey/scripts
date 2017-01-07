#!/bin/bash
# >> If using vagrant, for python installation, place this script in ~/ instead of /vagrant <<
# cd ~
# wget --no-check-certificate -O virtualenv-pip-python2.7.12.sh https://raw.github.com/vinodpandey/scripts/master/virtualenv-pip-python2.7.12.sh
# chmod +x virtualenv-pip-python2.7.12.sh
# sudo ./virtualenv-pip-python2.7.12.sh
# # creating virtual environment
# virtualenv-2.7 --no-site-packages .
# # activating virtualenv
# source bin/activate
# # deactivating virtualenv
# deactivate
#!/bin/bash
die () {
	echo "ERROR: $1. Aborting!"
	exit 1
}

#Absolute path to this script
SCRIPT=$(readlink -f $0)
#Absolute path this script is in
SCRIPTPATH=$(dirname $SCRIPT)

#check for root user
if [ "$(id -u)" -ne 0 ] ; then
	echo "You must run this script as root. Sorry!"
	exit 1
fi

# check python version, if version 2.7.12 not present, install it
if [[ $(python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))') != 2.7.* ]]; then
    echo "Installing Python 2.7.12"
    yum -y install sqlite-devel zlib zlib-devel gcc httpd-devel bzip2-devel openssl openssl-devel
    cd /usr/local/src
    wget -O Python-2.7.12.tgz http://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
   
    if [ ! -f "Python-2.7.12.tgz" ]; then
	    die "Not able to download Python-2.7.12"
	    exit 1
    fi    
    
    tar zxvf Python-2.7.12.tgz

    if [ ! -d "Python-2.7.12" ]; then
        die "Directory Python-2.7.12 not created"
        exit 1
    else
	    cd Python-2.7.12
        ./configure --prefix=/usr/local --with-threads --enable-shared --with-zlib=/usr/include
        make
        make altinstall
        cd ..
        rm -rf Python-2.7.12
        echo "/usr/local/lib" > python2.7.conf
        mv python2.7.conf /etc/ld.so.conf.d/python2.7.conf
        /sbin/ldconfig
        ln -sfn /usr/local/bin/python2.7 /usr/bin/python2.7	
    fi
else
   echo "Python $(python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))') present"
fi

# check pip, if not present, install it
if [[ $(pip2.7 --version) != pip* ]]; then
    echo "Installing pip" 
    cd /usr/local/src
    wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
    
    if [ ! -f "get-pip.py" ]; then
        die "Not able to download get-pip.py"
        exit 1
    else
        chmod +x get-pip.py
        python2.7 get-pip.py
        rm -f get-pip.py
        ln -sfn /usr/local/bin/pip2.7 /usr/bin/pip2.7
    fi
else
   echo "pip2.7 present"
fi


#check if virtualenv is present, otherwise install it
if [[ $(virtualenv-2.7 --version) != 15.1.0* ]]; then
    pip2.7 install virtualenv==15.1.0
    ln -sfn /usr/local/bin/virtualenv /usr/bin/virtualenv-2.7
else
    echo "virtualenv-2.7 v15.1.0 present"
fi


echo "Installation successful!"
exit 0
