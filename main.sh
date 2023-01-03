#!/bin/bash
export PS3=">>"
export LC_COLLATE=C
shopt -s extglob

export pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"

if [ -d "$PWD/Database" ]; then
    cd "$PWD/Database" || exit
else
    mkdir "$PWD/Database"
    cd "$PWD/Database" || exit
fi

showMenu() {
    select choice in createDatabase listDatabase removeDatabase connectDatabase Exit; do
        case $choice in
        createDatabase)
            createDB
            ;;
        listDatabase)
            echo "Databases found:"
            res=$(ls -d */ | awk 'BEGIN{FS=" "} { print "- "$1 }')
            if [[ $res == "" ]]; then
                echo "No Databases found"
            else
                echo $res
            fi
            showMenu
            ;;
        removeDatabase)
            echo "removeDatabase"
            read -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                read -p "You are going to drop $name? Are you sure? [Y/N]: " check
                if [[ $check = "Y" || $check = "y" ]]; then
                    sudo rm -r "$name"
                    echo "$name Database removed successfully!"
                fi
            else
                echo "$name database is not existed!"
            fi
            showMenu
            ;;
        connectDatabase)
            pwd
            echo "connectDatabase"
            read -p "Enter a name for the database: " name
            if [ -d "$name" ]; then
                cd "$name" || exit
                echo "Connected to $name database"
                . ../../connectDB.sh
            else
                echo "$name database not exist,try another name"
            fi
            showMenu
            ;;

        Exit)
            echo "Exit"
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
    read -p "Enter a name for the database: " name
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
    showMenu
}

showMenu