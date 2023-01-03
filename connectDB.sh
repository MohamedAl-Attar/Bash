#!/usr/bin/bash

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

function showTables {
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Tables Found: 
`ls | awk 'BEGIN{FS=" "} { print "- "$1 }'`"
            #ls | awk 'BEGIN{FS=" "} { print "- "$1 }';
         }

function dropTable {
    name=$(zenity --entry \
        --width 500 \
        --title "check user" \
        --text "`-e` Enter Table Name: " );
  #echo -e "Enter Table Name: \c"
  #read name
  rm $name 
  rm .$name 
  if [[ $? == 0 ]]
  then
    zenity --info \
        --title "Info Message" \
        --width 500 \
        --height 100 \
        --text "Table Dropped Successfully"
    #echo "Table Dropped Successfully"
  else
    zenity --info \
        --title "Info Message" \
        --width 500 \
        --height 100 \
        --text "Error Dropping Table $tName"
    #echo "Error Dropping Table $tName"
  fi
}

function showMenu() {
    choice=$(zenity --list \
      --column "Select Menu" \
      createTable \
      listTable \
      dropTable \
      insertTable \
      selectTable \
      removeFromTable \
      updateTable \
      "Go back to main menu"
      )
    #select choice in createTable listTable dropTable insertTable selectTable removeFromTable updateTable "Go back to main menu"; do
        case $choice in
        createTable)
            . createTable.sh
            ;;
        listTable)
            echo "listTable"
            showTables
            showMenu
            ;;
        dropTable)
            echo "dropTable"
            dropTable
            showMenu
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
            zenity --info \
                --title "Info Message" \
                --width 500 \
                --height 100 \
                --text "wrong input select again"
            #echo "wrong input select again"
            showMenu
            ;;
        esac
    #done
}

showMenu
