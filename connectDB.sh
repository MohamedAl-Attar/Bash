#!/usr/bin/bash

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

function showTables {
            ls | awk 'BEGIN{FS=" "} { print "- "$1 }';
         }

function dropTable {
  echo -e "Enter Table Name: \c"
  read name
  rm $name 
  rm .$name 
  if [[ $? == 0 ]]
  then
    echo "Table Dropped Successfully"
  else
    echo "Error Dropping Table $name"
  fi
}

function showMenu() {
    select choice in createTable listTable dropTable insertTable selectTable removeFromTable updateTable "Go back to main menu"; do
        case $choice in
        createTable)
            . createTable.sh
            ;;
        listTable)
            echo "listTable"
            showTables
            select choice in Goback; do
                case $choice in
                    Goback)
                    showMenu
                    ;;
                esac
            done
            ;;
        dropTable)
            echo "dropTable"
            dropTable
            select choice in Goback; do
                case $choice in
                    Goback)
                    showMenu
                    ;;
                esac
            done
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
