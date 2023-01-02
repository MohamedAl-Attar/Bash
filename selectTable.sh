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
            . connectDB.sh
            ;;
        *)
            echo "wrong input select again"
            selectMenu
            ;;
        esac
    done
}

function selectAll {
    read -r -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    column -t -s ':' "$name"
    echo
    selectMenu
}

function selectCol {
    read -r -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    read -r -p "Enter Column Name:" columnName
    value=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' "$name")
    # echo $value
    awk 'BEGIN{FS=":"}{print $'$value'}' "$name"
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
    read -r -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    read -r -p "Enter Column Name:" columnName
    data=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' "$name")
    # echo $data
    colType=$(awk 'BEGIN{FS=":"}{if(NR==data) print $2}' data=$((data + 1)) ."$name")
    # echo $colType
    if [[ $data == "" ]]; then
        echo "The column name you entered is not found"
        selectbyCon
    else
        if [[ $colType == "int" ]]; then
            echo "Supported Operators: [==, !=, >, <, >=, <=], Select OPERATOR:"
            read -r op
            while ! [[ $op == "==" || $op == "!=" || $op == ">" || $op == "<" || $op == ">=" || $op == "<=" ]]; do
                echo "Unsupported Operator ,enter operator again"
                read -r op
            done

            read -r -p "Enter Value:" val

            if [[ $selectRow == 1 ]]; then
                # echo "sadasdasdasdasdadasdasd"
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {   
                    print $indexx
                    if ($indexx '$op' value) print $0
                }' indexx="$data" value="$val" "$name"
            else
                # echo "zzzzzzzzzzzzzzzzzzzzzzzzzz"
                awk -v operator="$op" 'BEGIN{
                FS=":"; ORS="\n"
                }
                {

                    if ($indexx '$op' value) print $indexx
                }' indexx="$data" value="$val" "$name"
            fi

        else

            echo "Supported Operators: [==, !=], Select OPERATOR:"

            read -r op
            while ! [[ $op == "==" || $op == "!=" ]]; do
                echo "Unsupported Operator ,enter operator again"
                read -r op
            done

            read -r -p "Enter Value:" val

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
