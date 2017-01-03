#!/bin/bash
# >> If using vagrant, for python installation, place this script in ~/ instead of /vagrant <<
# cd ~
# wget --no-check-certificate -O virtualenv-pip-python2.7.12.sh https://raw.github.com/vinodpandey/scripts/master/virtualenv-pip-python2.7.12.sh
# chmod +x virtualenv-pip-python2.7.12.sh
# ./virtualenv-pip-python2.7.12.sh
# # creating virtual environment
# virtualenv-2.7 --no-site-packages .
# # activating virtualenv
# source bin/activate
# # deactivating virtualenv
# deactivate

# check python version, if version 2.7.12 not present, install it

if [[ $(python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))') != 2.7.* ]]; then
    echo "Installing Python 2.7.12"
    sudo yum -y install sqlite-devel zlib zlib-devel gcc httpd-devel bzip2-devel openssl openssl-devel
    mkdir -p temp
    cd temp
    wget http://www.python.org/ftp/python/2.7.12/Python-2.7.12.tgz
    tar zxvf Python-2.7.12.tgz
    cd Python-2.7.12
    ./configure --prefix=/usr/local --with-threads --enable-shared --with-zlib=/usr/include
    make
    sudo make altinstall
    cd ..
    cd ..
    rm -rf temp
    sudo echo "/usr/local/lib" > python2.7.conf
    sudo mv python2.7.conf /etc/ld.so.conf.d/python2.7.conf
    sudo /sbin/ldconfig
    sudo ln -sfn /usr/local/bin/python2.7 /usr/bin/python2.7
else
   echo "Python $(python2.7 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))') present"
fi

# check pip, if not present, install it
if [[ $(pip2.7 --version) != pip* ]]; then
    echo "Installing pip" 
    wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
    chmod +x get-pip.py
    sudo python2.7 get-pip.py 
    sudo rm -f get-pip.py 
    sudo ln -sfn /usr/local/bin/pip2.7 /usr/bin/pip2.7
else
   echo "pip2.7 present"
fi


# check if virtualenv is present, otherwise install it
if [[ $(virtualenv-2.7 --version) != 15.1.0* ]]; then
    sudo pip2.7 install virtualenv==15.1.0
    sudo ln -sfn /usr/local/bin/virtualenv /usr/bin/virtualenv-2.7
else
    echo "virtualenv-2.7 v15.1.0 present"
fi

