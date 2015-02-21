#!/bin/sh

usage ()
{
    echo "usage: rs [-h] [-un] [-l length]"
    echo "	-h: show this help message"
    echo "	-u: uppercase letters"
    echo "	-n: numbers"
    echo "	-l n: string of n length"
    exit 1
}

LENGTH=10
STR='a-z'

while test "$1" != ""
do
    case $1 in
        -h) usage;;

        -u) STR="${STR}A-Z"
            shift;;

        -n) STR="${STR}0-9"
            shift;;

        -l) test "$2" = "" && usage
            LENGTH=$2
            shift 2;;

        *) usage
    esac
done

cat /dev/urandom | tr -dc $STR | fold -w $LENGTH | head -n 1
