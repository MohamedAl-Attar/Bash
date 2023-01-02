#!/usr/bin/bash

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

function showTables {
    res=$(ls | awk 'BEGIN{FS=" "} { print "- "$1 }')
    if [[ $res == "" ]]; then
        echo "No Tables found"
    else
        echo $res
    fi
    showMenu
}

function dropTable {
    read -r -p "Enter Table Name: " name
    if [ -f "$name" ]; then
        read -r -p "You are going to drop table $name? Are you sure? [Y/N]: " check
        if [[ $check = "Y" || $check = "y" ]]; then
            rm $name
            rm .$name
            echo "Table Dropped Successfully"
        fi
    else
        echo "$name table is not existed!"
    fi
    showMenu

}

function showMenu() {
    select choice in createTable listTable dropTable insertTable selectTable removeFromTable updateTable "Go back to main menu"; do
        case $choice in
        createTable)
            . ../../createTable.sh
            ;;
        listTable)
            pwd
            echo "listTable"
            showTables
            showMenu
            ;;
        dropTable)
            echo "dropTable"
            dropTable
            ;;
        insertTable)
            . ../../insertTable.sh
            ;;
        selectTable)
            echo "selectTable"
            . ../../selectTable.sh
            ;;
        removeFromTable)
            echo "removeFromTable"
            . ../../deleteDataFromTable.sh
            ;;
        updateTable)
            echo "updateTable"
            ;;
        "Go back to main menu")
            cd ../..
            . main.sh
            break
            ;;
        *)
            echo "wrong input select again"
            showMenu
            ;;
        esac
    done
}

showMenu
