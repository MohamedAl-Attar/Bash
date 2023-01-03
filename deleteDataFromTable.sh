#!/usr/bin/bash
function selectMenu {
    select choice in "Delete All Data" "Delete specfic column" "Go back to table menu"; do
        case $choice in
        "Delete All Data")
            DeleteAll
            ;;
        "Delete specfic column")
            deleteSpecificData
            ;;
        "Go back to table menu")
            showMenu
            ;;
        *)
            echo "wrong input, select a valid input"
            selectMenu
            ;;
        esac
    done
}

function deleteSpecificData {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        showMenu
    fi
    read -p "Enter Column Name:" columnName
    data=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' $name)
    if [[ $data == "" ]]; then
        echo "Not Found"
        showMenu
    else
        read -p "Enter Condition Value:" val
        res=$(awk 'BEGIN{FS=":"}{if ($'$data'=="'$val'") print $'$data'}' $name)
        if [[ $res == "" ]]; then
            echo "Value Not Found"
            showMenu
        else
            NR=($(awk 'BEGIN{FS=":"}{if ($'$data'=="'$val'") print NR}' $name))
            echo "${NR[@]}"
            for i in "${NR[@]}"; do

                sed -i "${i}d" $name

            done

            echo "Row Deleted Successfully"
            showMenu
        fi
    fi
}

function DeleteAll {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        selectbyCon
    fi
    sed -i '2,$d' "$name"
    echo "Rows Deleted Successfully"
    selectMenu
}

selectMenu
