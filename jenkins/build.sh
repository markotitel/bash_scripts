#!/usr/bin/env bash

VAGRANT_BOX_UP=$(vagrant status |grep running)
ANSIBLE_YES=$(git log --name-status HEAD^..HEAD | grep provision/ | wc -l)
VAGRANT_YES=$(git log --name-status HEAD^..HEAD | grep Vagrantfile | wc -l)

if [[ $? -eq 1 ]]
then
    vagrant up
fi

if [[ $VAGRANT_YES -gt 0 ]]
then
    vagrant reload
elif [[ $ANSIBLE_YES -gt 0 ]]
then
    vagrant provision
else
    echo "No changes to Vagrantfile or provision actions, moving on..."
fi
