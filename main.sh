#!/bin/bash
export PS3=">>"
export LC_COLLATE=C
shopt -s extglob

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

DBpath=$PWD
cd ..

if [ -d "$PWD/Database" ]; then
    echo "im here1"
    cd "$PWD/Database" || exit
else
    echo "im here2"
    cd "$DBpath" || exit
    if [ -d "$PWD/Database" ]; then
        cd "$PWD/Database" || exit
    else
        mkdir "$PWD/Database"
        cd "$PWD/Database" || exit
    fi
fi

showMenu() {
    choice=$(zenity --list \
      --column "Select Menu" \
      createDatabase \
      listDatabase \
      removeDatabase \
      connectDatabase \
      Exit
      )
    #select choice in createDatabase listDatabase removeDatabase connectDatabase Exit; do
        case $choice in
        createDatabase)
            createDB
            ;;
        listDatabase)
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Databases found: 
`ls -d */`"
            #echo "Databases found:"
            # ls -F | grep /
            #ls -d */
            # showChoices
            showMenu
            ;;
        removeDatabase)
            #echo "removeDatabase"
            name=$(zenity --entry \
                --width 500 \
                --title "check user" \
                --text "Enter the user name");
            #read -r -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                zenity --question \
                    --title "Info Message" \
                    --width 500 \
                    --height 100 \
                    --text "You are going to drop $name? Are you sure? [Y/N]: " 
                #read -r -p "You are going to drop $name? Are you sure? [Y/N]: " check
                #if [[ $check = "Y" || $check = "y" ]]; then
                    sudo rm -r "$name"
                    zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name Database removed successfully!"
                    #echo "$name Database removed successfully!"
                #fi
            else
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name database is not existed!"
                #echo "$name database is not existed!"
            fi
            # showChoices
            showMenu
            ;;
        connectDatabase)
            echo "connectDatabase"
            name=$(zenity --entry \
                --width 500 \
                --title "check user" \
                --text "Enter a name for the database: " );
            #read -r -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                cd "$name" || exit
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Connected to $name database"
                #echo "Connected to $name database"
                . connectDB.sh
            else
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name database not exist,try another name"
                #echo "$name database not exist,try another name"
            fi
            # main.sh
            showMenu
            ;;
            
        Exit)
            echo "Exit"
            # break
            exit
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

createDB() {

    echo "createDatabase"
    name=$(zenity --entry \
                --width 500 \
                --title "check user" \
                --text "Enter a name for the database: " );
    #read -r -p "Enter a name for the database: " name
    #echo "$name"
    if [[ -n $name ]]; then
        if [[ $name =~ $pat ]]; then
            if [[ -d "$name" ]]; then
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Database already exists,try another name"
                #echo 'Database already exists,try another name'
            else
                mkdir "$name"
                zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "$name database created succsessfully!!!"
                #echo "$name database created succsessfully!!!"
            fi
        else
            zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "Error naming the file, make sure to not start with number,special char and space,try another name"
            #echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
        fi
    else
        zenity --info \
                        --title "Info Message" \
                        --width 500 \
                        --height 100 \
                        --text "zero string,try another name"
        #echo "zero string,try another name"
    fi
    # showChoices
    # cd ..
    # . main.sh
    showMenu
}

showMenu







#  createTable listTable dropTable insertTable selectTable removeTable updateTable Exit;

# createTable)
#         echo "createTable"
#         ;;
#     listTable)
#         echo "listTable"
#         ;;
#     dropTable)
#         echo "dropTable"
#         ;;
#     insertTable)
#         echo "insertTable"
#         ;;
#     selectTable)
#         echo "selectTable"
#         ;;
#     removeTable)
#         echo "removeTable"
#         ;;
#     updateTable)
#         echo "updateTable"
#         ;;
#     Exit)
#         echo "Exit"
#         break
#         ;;
#     *)
#         echo "wrong input select again"
#         main.sh
#         ;;

# export PS3=">>"
# export LC_COLLATE=C
# shopt -s extglob

# export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

# x=$PWD
# cd ..
# if [ -d "$PWD/Database" ]; then
#     # echo "im here1"
#     cd "$PWD/Database" || exit
# else
#     # echo "im here2"
#     cd "$x" || exit
#     if [ -d "$PWD/Database" ]; then
#         cd "$PWD/Database" || exit
#     else
#         mkdir "$PWD/Database"
#         cd "$PWD/Database" || exit
#     fi
# fi

# select choice in createDatabase listDatabase removeDatabase connectDatabase Exit; do
#     case $choice in
#     createDatabase)
#         echo "createDatabase"
#         read -r -p "Enter a name for the database: " name
#         echo "$name"
#         if [[ -n $name ]]; then
#             if [[ $name =~ $pat ]]; then
#                 if [[ -d "$name" ]]; then
#                     echo 'Database already exists,try another name'
#                 else
#                     mkdir "$name"
#                     echo "$name" database created succsessfully!!!
#                 fi
#             else
#                 echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
#             fi
#         else
#             echo "zero string,try another name"
#         fi
#         main.sh
#         ;;
#     listDatabase)
#         echo "Databases found:"
#         # ls -F | grep /
#         ls -d */
#         main.sh
#         ;;
#     removeDatabase)
#         echo "removeDatabase"
#         read -r -p "Enter a name for the database: " name
#         if [[ -n $name ]]; then
#             if [[ $name =~ $pat ]]; then
#                 if [ -d "$name" ]; then
#                     read -r -p "You are going to drop $name? Are you sure? [Y/N]: " check
#                     if [[ $check = "Y" || $check = "y" ]]; then
#                         sudo rm -r "$name"
#                         echo "$name Database removed successfully!"
#                     fi
#                 else
#                     echo "$name database is not existed!"
#                 fi
#             else
#                 echo 'Error file name, make sure to not start with number,special char and space,try another name'
#             fi
#         else
#             echo "zero string,try another name"
#         fi
#         main.sh
#         ;;
#     connectDatabase)
#         echo "connectDatabase"
#         read -r -p "Enter a name for the database: " name
#         if [[ -n $name ]]; then
#             if [[ $name =~ $pat ]]; then
#                 if [ -d "$name" ]; then
#                     cd "$name" || exit
#                     echo "Connected to $name database"
#                 else
#                     echo "$name database not exist,try another name"
#                 fi
#             else
#                 echo 'Error file name, make sure to not start with number,special char and space,try another name'
#             fi
#         else
#             echo "zero string,try another name"
#         fi
#         main.sh
#         ;;
#     Exit)
#         echo "Exit"
#         break
#         ;;
#     *)
#         echo "wrong input select again"
#         main.sh
#         ;;
#     esac
# done
