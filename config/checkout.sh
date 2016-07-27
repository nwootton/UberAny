#!/bin/bash

#Exit immediately if any of this stuff returns a non-zero status.
set -e

#Check for username
if [ -z "$username" ]; then
    echo "git username not provided"
    exit 1
else
    USER=$username
fi

#Check for password
if [ -z "$password" ]; then
    echo "git password not provided"
    exit 1
else
    PASS=$password
fi

#Check for branch
if [ -z "$branch" ]; then
    echo "Defaulting to MASTER branch"
    BRANCH="master"
else
    echo "Using requested branch - $branch"
    BRANCH=$branch
fi

#Check if git url provided
if [ ! -z "$giturl" ]; then

    #Build git repo address
    BODY=${giturl/'https://'/}
    URL='https://'$USER':'$PASS'@'$BODY

    #Check if directory exists, if not create it and checkout git
    if [ ! -d "/home/project" ]; then
        echo "directory does not exist"
        mkdir /home/project

        git clone --branch $BRANCH --depth 1 $URL /home/project

        #Check for and execute build.sh if present
        if [ -e /home/project/build.sh ]; then
            echo "Found build file"
            cd /home/project
            chmod +x build.sh
            ./build.sh
        else
            echo "Did not find build file"
        fi
    fi

    #Execute the run.sh
    if [ -e /home/project/run.sh ]; then
        echo "Found run file"
        cd /home/project
        chmod +x run.sh
        ./run.sh
    else
        echo "Did not find run file"
    fi
else
    echo "No giturl provided"
    exit 1
fi
