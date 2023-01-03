#!/usr/bin/bash
function selectMenu {
    select choice in "Select all" "Select column" "Use conditions" "Go back to table Menu"; do
        case $choice in
        "Select all")
            selectAll
            ;;
        "Select column")
            selectCol
            ;;
        "Use conditions")
            selectbyCon
            ;;
        "Go back to table Menu")
            . ../../connectDB.sh
            ;;
        *)
            echo "wrong input select again"
            selectMenu
            ;;
        esac
    done
}

function selectAll {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectMenu
    fi
    column -t -s ':' "$name"
    echo
    selectMenu
}

function selectCol {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    read -p "Enter Column Name:" columnName
    value=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' "$name")
    if [[ $value == "" ]]; then
        echo "The Name you entered is not exist, try again"
    else
        awk 'BEGIN{FS=":"}{print $'$value'}' "$name"
    fi
    selectMenu

}

function selectbyCon {
    select choice in "Select Rows Matching Condition" "Select Specific Column Matching Condition" "Go back To Select Menu"; do
        case $choice in
        "Select Rows Matching Condition")
            selectRow=1
            selectwithCond
            ;;
        "Select Specific Column Matching Condition")
            selectRow=0
            selectwithCond
            ;;
        "Go back To Select Menu")
            selectMenu
            ;;
        *)
            echo "wrong input select again"
            selectbyCon
            ;;
        esac
    done
}

function selectwithCond {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    read -p "Enter Column Name:" columnName
    data=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' "$name")
    colType=$(awk 'BEGIN{FS=":"}{if(NR==data) print $2}' data=$((data + 1)) ."$name")
    if [[ $data == "" ]]; then
        echo "The column name you entered is not found"
        selectbyCon
    else
        if [[ $colType == "int" ]]; then
            echo "Supported Operators: [==, !=, >, <, >=, <=], Select OPERATOR:"
            read op
            while ! [[ $op == "==" || $op == "!=" || $op == ">" || $op == "<" || $op == ">=" || $op == "<=" ]]; do
                echo "Unsupported Operator ,enter operator again"
                read op
            done

            read -p "Enter Value:" val

            if [[ $selectRow == 1 ]]; then
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {   
                    if ($indexx '$op' value) print $0
                }' indexx="$data" value="$val" "$name"
            else
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {

                    if ($indexx '$op' value) print $indexx
                }' indexx="$data" value="$val" "$name"
            fi

        else

            echo "Supported Operators: [==, !=], Select OPERATOR:"

            read op
            while ! [[ $op == "==" || $op == "!=" ]]; do
                echo "Unsupported Operator ,enter operator again"
                read op
            done

            read -p "Enter Value:" val

            if [[ $selectRow == 1 ]]; then
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {

                    if ($indexx '$op' value) print $0
                }' indexx="$data" value="$val" "$name"
            else
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {

                    if ($indexx '$op' value) print $indexx
                }' indexx="$data" value="$val" "$name"
            fi

        fi

    fi

    selectbyCon
}

selectMenu
