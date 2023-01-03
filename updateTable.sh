#!/usr/bin/bash
function updateTable {
    read -p "Enter Table Name:" name
    if ! [ -f "$PWD/$name" ]; then
        echo "Table not found,try again"
        . ../../connectDB.sh
    fi
    read -p "Enter Column Name:" columnName

    value=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++){if($i=="'$columnName'") print i}}}' $name)
    if [[ $value == "" ]]; then
        echo "Table not Found"
        . ../../connectDB.sh
    else
        read -p "Enter the value you want to change:" val
        res=$(awk 'BEGIN{FS=":"}{if ($'$value'=="'$val'") print $'$value'}' $name 2>>./.error.log)
        if [[ $res == "" ]]; then
            echo "Value Not Found"
            . ../../connectDB.sh
        else
            read -p "Enter FIELD name to set:" setField
            setvalue=$(
                awk 'BEGIN{FS=":"}
                    {
                        if(NR==1){
                            for(i=1;i<=NF;i++){
                                if($i=="'$setField'"){
                                    print i
                                    exit
                                }
                            }
                        }
                    }' $name
            )

            fieldName=$(
                awk 'BEGIN{FS=":"}
                    {
                        if(NR==1){
                            for(i=1;i<=NF;i++){
                                if($i=="'$setField'"){
                                    print $i
                                    exit
                                }
                            }
                        }
                    }' $name
            )
            if [[ $setvalue == "" ]]; then
                echo "Not Found"
                . ../../connectDB.sh
            else
                colType=$(
                    awk 'BEGIN{FS=":"}
                    {
                        if($1=="'$fieldName'") print $2
                    }' ."$name"
                )
                colKey=$(
                    awk 'BEGIN{FS=":"}
                    {
                        if($1=="'$fieldName'") print $3
                    }' ."$name"
                )

                read -p "Enter the new value:" newValue
                if [[ $colType == "int" && $colKey == "PK" ]]; then
                    duplicateData="1"
                    while ! [[ $newValue =~ ^[0-9]+$ && $duplicateData == "0" ]]; do
                        if [[ $newValue =~ ^[0-9]+$ ]]; then
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
                                ' VARIABLE=$newValue $name)
                            if [[ $duplicateData == 1 ]]; then
                                echo "The data you enter is not unique"
                                echo "Enter value again"
                                read newValue
                            else
                                duplicateData="0"
                            fi
                        else
                            echo "invalid DataType !!"
                            echo "Enter value again"
                            read newValue
                        fi
                    done
                elif [[ $colType == "int" ]]; then
                    while ! [[ $newValue =~ ^[0-9]*$ ]]; do
                        echo "invalid DataType !!"
                        echo "Enter value again"
                        read newValue
                    done
                fi

                NR=($(awk 'BEGIN{FS=":"}{if ($'$value' == "'$val'") print NR}' $name))
                for i in "${NR[@]}"; do
                    oldValue=$(awk 'BEGIN{FS=":"}
                                    {
                                        if(NR=='${i}')
                                        {
                                            for(i=1;i<=NF;i++)
                                            {
                                                if(i=='$setvalue'){
                                                    print $i
                                                }
                                            }
                                        }
                                    }' $name)
                    cut -d ":" -f "$value" "$name" | sed -n "${i}p" | sed -i "s/$oldValue/$newValue/I" "$name"

                done

                echo "Row Updated Successfully"
                . ../../connectDB.sh
            fi
        fi
    fi
}

updateTable
