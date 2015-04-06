#!/bin/sh

INACTIVE="0x`qxr color0`"
ACTIVE="0x`qxr color2`"
FILE=/tmp/xtags
touch $FILE


lvar ()
{
    # Is the variable in the file?
    # if so, export the value
    # if not, unset the variable

    grep -q "^$2=.*" $FILE\
    && var=`grep $2 -F $FILE | cut -d"=" -f2`\
    && export $1=$var\
    || unset $1
}

svar ()
{
    # Is the variable name in the file?
    # if so, replace it
    # if not, append it

    grep -q "^$1=" $FILE\
    && sed "s/^$1=.*/$1=$2/" -i $FILE\
    || echo "$1=$2" >> $FILE
}

rvar ()
{
    sed "/^$1=.*/d" -i $FILE
}


map_tag ()
{
    while IFS="=" read win tag
    do
        if test "$tag" = "$2"
        then
            $1 $win
        fi
    done < $FILE
}

show_win ()
{
    if wattr $1
    then
        mapw -m $1
        focusd $1
    else
        rvar $1
    fi
}

hide_win ()
{
    if test "`pfw`" = "$1"
    then
        focusd prev
    fi

    chwb -c $INACTIVE -s 5 $1
    mapw -u $1
}

flip_win ()
{
    wattr m $1\
    && hide_win $1\
    || show_win $1
}


echo_win ()
{
    echo `wname $1`
}


case $1 in
    # tag window
    set) svar $3 $2;;

    # untag window
    unset) rvar $2;;

    # print tag of window
    print) map_tag echo_win $2;;

    show) map_tag show_win $2;;
    hide) map_tag hide_win $2;;
    flip) map_tag flip_win $2;;

    *) exit 1;;
esac
