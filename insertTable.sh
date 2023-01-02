#!/usr/bin/bash
echo "insertTable"
read -r -p "Enter a name for the table: " name
if [[ -f "$name" ]]; then
    colsNum=$(awk 'END{print NR}' ."$name")
    sep=":"
    rSep="\n"
    for ((i = 2; i <= colsNum - 1; i++)); do
        colName=$(awk 'BEGIN{FS=":"}{ if(NR=='$i') print $1}' ."$name")
        colType=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $2}' ."$name")
        colKey=$(awk 'BEGIN{FS=":"}{if(NR=='$i') print $3}' ."$name")
        echo $colName
        echo $colType
        echo $colKey
        echo -e "Enter value for $colName = "
        read -r data
        # ValidateDatatype
        if [[ $colType == "int" && $colKey == "PK" ]]; then
            echo "duk"
            duplicateData="1"
            while ! [[ $data =~ ^[0-9]+$ && $duplicateData == "0" ]]; do
                if [[ $data =~ ^[0-9]+$ ]]; then
                    duplicateData=$(awk '
                                BEGIN{
                                    FS=":"
                                }
                                {
                                    if(VARIABLE == $1){
                                        print 1;
                                        exit
                                    }
                                }
                                ' VARIABLE=$data $name)
                    echo "dasdsadasd $duplicateData"
                    if [[ $duplicateData == 1 ]]; then
                        echo "The data you enter is not unique"
                        echo -e "Enter value for $colName = "
                        read -r data
                    else
                        duplicateData="0"
                    fi
                else
                    echo -e "invalid DataType !!"
                    echo -e "Enter value for $colName = "
                    read -r data
                fi
            done
        elif [[ $colType == "int" ]]; then
            while ! [[ $data =~ ^[0-9]*$ ]]; do
                echo -e "invalid DataType !!"
                echo -e "$colName ($colType) = \c"
                read -r data
            done
        fi

        if [[ $i == $((colsNum - 1)) ]]; then
            row="$row$data"
        else
            row="$row$data:"
        fi
    done
    echo "$row" >>"$name"
    if [[ $? == 0 ]]; then
        echo "Data Inserted Successfully"
    else
        echo "Error Inserting Data into Table $name"
    fi
    row=""
else
    echo "$name table not exist,try another name"
fi
showMenu
