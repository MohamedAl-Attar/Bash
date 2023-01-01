#!/usr/bin/bash

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

function showMenu() {
    select choice in createTable listTable dropTable insertTable selectTable removeFromTable updateTable "Go back to main menu"; do
        case $choice in
        createTable)
            . createTable.sh
            ;;
        listTable)
            echo "listTable"
            ;;
        dropTable)
            echo "dropTable"
            ;;
        insertTable)
            . insertTable.sh
            ;;
        selectTable)
            echo "selectTable"
            . selectTable.sh
            ;;
        removeFromTable)
            echo "removeFromTable"
            . deleteDataFromTable.sh
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
