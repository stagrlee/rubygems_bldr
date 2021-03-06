#!/bin/bash
# Copyright (c) 2008, Lee Thompson
# Basic MIT license

# This script is a packaging bridge between the gems package system
# and a package system other than gems.  It takes a list of gems modules
# you want and has gems retrieve them, and most importantly, all of those
# module's missing dependencies; and installs those into a staged installation
# directory.  Those staged files can be input into another package manager
# like debian, gentoo, RPM, etc.
#
#                                 Lee Thompson 08SEP08

# TODO add proxy support

myGEMS="rails hpricot prawn roo Shoulda capistrano thoughtbot-factory_girl"
mySUBDIR="lib/ruby/gems/1.8"

usage()
{
cat << EOF
usage: $0 options

This script create a pre-defined list of ruby gems.

OPTIONS:
   -h      Show this message
   -?      Show this message
   -n      Use the network to retrieve your ruby gems
   -d      The destination directory to install the gems

EOF
}

myDESTDIR=
NETWORK="no"
while getopts “hd:n” OPTION
do
    case $OPTION in
        h | \?)
            usage
            exit 0
            ;;
        d)
            myDESTDIR="$OPTARG"
            ;;
        n)
            NETWORK="yes"
            ;;
    esac
done
if [[ -z "${myDESTDIR}" ]]; then
    usage
    exit 1
fi

#
# make sure gem and ruby is installed
#
ruby --version > /dev/null 2>&1
rubystat=$?
gem --version > /dev/null 2>&1
gemstat=$?

if [[ ${rubystat} -ne 0 || ${gemstat} -ne 0 ]]; then
  echo "***"
  echo "*** Both ruby and rubygems must be installed"
  echo "***"
  exit 1
fi

#
# make sure gem is at least 1.2.0
#
gv="`gem --version`"
if [[ "${gv}" = "1.1.1" || "${gv}" = "1.1.0" || "${gv}" = "1.0.1" || "${gv}" = "1.0.0" ]]
then
  echo "***"
  echo "*** gem must be at least version 1.2.0"
  echo "***"
  exit 1
fi

#
# make sure gem is looking at github since that is where factory_girl is hosted
#
if [[ `gem sources | grep -c github` -eq 0 ]]; then
  gem sources -a http://gems.github.com
  if [[ `gem sources | grep -c github` -eq 0 ]]; then
    echo "***"
    echo "*** couldn't add github to gem sources list"
    echo "***"
    exit 1
  fi
fi

#
# can't run this on a box where the package is already installed
# so test system sanity
#
if [[ `gem list | grep -c rake` -ne 0 ]]; then
    echo "***"
    echo "*** found rake installed already, deinstall this package before"
    echo "*** generating a newer version"
    echo "***"
    exit 1
fi

mkdir -p ${myDESTDIR}
export PATH=${myDESTDIR}/bin:${PATH}

if [[ "x${NETWORK}" = "xyes" ]]; then

    gem install --development --no-rdoc --no-ri --install-dir ${myDESTDIR} \
        ${myGEMS}

else

    # The ruby gems program looks in your current directory for the gems
    cp cache/*.gem ./
    gem install --development -l --install-dir ${myDESTDIR}/${mySUBDIR} \
        ${myGEMS}
    # cleanup
    rm -f *.gem
    # move rake, rails binaries up to the bin directory
    if [[ ! -e ${myDESTDIR}/bin ]]; then
        mkdir -p ${myDESTDIR}/bin
    fi
    cp ${myDESTDIR}/${mySUBDIR}/bin/* ${myDESTDIR}/bin/

fi
