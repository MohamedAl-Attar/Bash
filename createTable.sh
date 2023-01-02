#!/usr/bin/bash

echo "createTable"
read -r -p "Enter a name for the table: " name
if [[ -z $name ]]; then
    echo "zero string,try again"
    showMenu
fi
if [[ $name =~ $pat ]]; then
    if [[ -f "$name" ]]; then
        echo "table already existed ,choose another name"
        showMenu
    fi
    read -r -p "Enter number of Columns: " columnNumbers
    sep=":"
    primarykeycheck="0"
    metaData="Field${sep}Type${sep}key\n"

    for ((i = 1; i <= columnNumbers; i++)); do
        read -r -p "Enter name of Column $i: " columnName
        echo "Enter type of Column $columnName:"
        select choice in "int" "str"; do
            case $choice in
            int)
                columnType="int"
                break
                ;;
            str)
                columnType="str"
                break
                ;;
            *)
                echo "Wrong Choice,try again"
                ;;
            esac
        done
        if [[ $primarykeycheck == "0" ]]; then
            echo "Make PrimaryKey ?"
            select choice in "yes" "no"; do
                case $choice in
                yes)
                    primarykeycheck="1"
                    columnKey="PK"
                    metaData+="$columnName$sep$columnType$sep$columnKey\n"
                    break
                    ;;
                no)
                    columnKey="FK"
                    metaData+="$columnName$sep$columnType$sep$columnKey\n"
                    break
                    ;;
                *) echo "Wrong Choice" ;;
                esac
            done
        else
            columnKey="FK"
            metaData+="$columnName$sep$columnType$sep$columnKey\n"
        fi
        if [[ $i == $columnNumbers ]]; then
            temp+=$columnName
        else
            temp+=$columnName$sep
        fi
    done
    touch .$name
    echo -e $metaData >>.$name
    touch $name
    echo $temp >>$name
    if [[ $? == 0 ]]; then
        echo "Table $name Created Successfully"
        showMenu
    else
        echo "Error Creating Table $name"
        showMenu
    fi
else
    echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
    showMenu
fi
