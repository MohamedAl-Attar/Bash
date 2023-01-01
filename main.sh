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
    select choice in createDatabase listDatabase removeDatabase connectDatabase Exit; do
        case $choice in
        createDatabase)
            createDB
            ;;
        listDatabase)
            echo "Databases found:"
            # ls -F | grep /
            ls -d */
            # showChoices
            showMenu
            ;;
        removeDatabase)
            echo "removeDatabase"
            read -r -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                read -r -p "You are going to drop $name? Are you sure? [Y/N]: " check
                if [[ $check = "Y" || $check = "y" ]]; then
                    sudo rm -r "$name"
                    echo "$name Database removed successfully!"
                fi
            else
                echo "$name database is not existed!"
            fi
            # showChoices
            showMenu
            ;;
        connectDatabase)
            echo "connectDatabase"
            read -r -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                cd "$name" || exit
                echo "Connected to $name database"
                . connectDB.sh
            else
                echo "$name database not exist,try another name"
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
            echo "wrong input select again"
            showMenu
            ;;
        esac
    done
}

createDB() {

    echo "createDatabase"
    read -r -p "Enter a name for the database: " name
    echo "$name"
    if [[ -n $name ]]; then
        if [[ $name =~ $pat ]]; then
            if [[ -d "$name" ]]; then
                echo 'Database already exists,try another name'
            else
                mkdir "$name"
                echo "$name" database created succsessfully!!!
            fi
        else
            echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
        fi
    else
        echo "zero string,try another name"
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
