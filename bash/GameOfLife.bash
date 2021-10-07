#!/bin/bash
frames=frames/

number_of_neighbors() {
    #$1:rows $2:columns
    for ((i=1;i<=$1;++i))
    do
        for ((j=1;j<=$2;++j))
        do
            k=0
            let inc_i=$((($i+$1)%$1))+1
            let inc_j=$((($j+$2)%$2))+1
            let dec_i=$((($i+$1-2)%$1))+1
            let dec_j=$((($j+$2-2)%$2))+1

            if [[ ${matrix[$inc_i,$inc_j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$inc_i,$j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$inc_i,$dec_j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$i,$inc_j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$i,$dec_j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$dec_i,$inc_j]} -eq 1 ]]
            then
                let k=$k+1
            fi

            if [[ ${matrix[$dec_i,$j]} -eq 1 ]]
            then
                let k=$k+1
            fi
            
            if [[ ${matrix[$dec_i,$dec_j]} -eq 1 ]]
            then
                let k=$k+1
            fi
            count_matrix[$i,$j]=$k
        done
    done
}

next_generation() {
    for ((i=1;i<=$1;++i))
    do
        for ((j=1;j<=$2;++j))
        do
            if [[ ${count_matrix[$i,$j]} -eq 3 ]]
            then
                matrix[$i,$j]=1;
            fi

            if [[ ${count_matrix[$i,$j]} -ne 2 && ${count_matrix[$i,$j]} -ne 3 ]]
            then
                matrix[$i,$j]=0;
            fi
        done
    done
}

write_to_file() {
    #$1:rows $2:columns $3:filename
    >$3
    for ((i=1;i<=$1;++i))
    do
        for ((j=1;j<=$2;++j))
        do
            printf "${matrix[$i,$j]} " >> $3
        done
        printf "\n" >> $3
    done
}

> tmp
if [[ $3 == "" ]]
then
    echo Incorrect number of parameters entered
    exit 1
fi

declare -A matrix
declare -A count_matrix

j=1

while read line
do
    for ((i=1;i<=$2;++i))
    do
        cell=$(awk -v ind=$i '{printf($ind)}' <<< $line)
        matrix[$j,$i]=$cell
    done
    let j=$j+1
done < input.txt

for ((i=1;i<=$2;++i))
do
    cell=$(awk -v ind=$i '{printf($ind)}' <<< $line)
    matrix[$j,$i]=$cell
done

counter=1
for ((;counter<=$3;++counter))
do
    write_to_file $1 $2 "$frames$counter"
    number_of_neighbors $1 $2
    next_generation $1 $2
done


for ((i=1;i<=$3;++i))
do
    clear
    cat $frames$i
    sleep 0.2
done
