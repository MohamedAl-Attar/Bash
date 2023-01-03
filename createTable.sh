#!/usr/bin/bash
pat="^[a-zA-Z]+[a-zA-Z0-9[:space:]]*"
pat2="^[0-9]+"
echo "createTable"
read -p "Enter a name for the table: " name
if [[ -z $name ]]; then
    echo "zero string,try again"
    showMenu
fi
if [[ $name =~ $pat ]]; then
    if [[ -f "$name" ]]; then
        echo "table already existed ,choose another name"
        showMenu
    fi
    read -p "Enter number of Columns: " columnNumbers
    if [[ $columnNumbers =~ $pat2 ]]; then
        sep=":"
        primarykeycheck="0"
        metaData="Field${sep}Type${sep}key\n"

        for ((i = 1; i <= columnNumbers; i++)); do
            read -p "Enter name of Column $i: " columnName
            if [[ -n $columnName ]]; then
                if [[ $columnName =~ $pat ]]; then
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
                else
                    echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
                    . ../../connectDB
                fi
            else
                echo "zero string,try another name"
                . ../../connectDB
            fi

        done

        touch .$name
        echo -e $metaData >>.$name
        touch $name
        echo -e $temp >>$name
        if [[ $? == 0 ]]; then
            echo "Table $name Created Successfully"
            showMenu
        else
            echo "Error Creating Table $name"
            showMenu
        fi

    else
        pwd
        echo "invalid data type, use int only"
        . ../../connectDB.sh
    fi

else
    echo 'Error naming the file, make sure to not start with number,special char and space,try another name'
    showMenu
fi
