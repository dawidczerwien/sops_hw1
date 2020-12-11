#!/bin/bash

#
#       Ścieżka do pliku gdzie zapisujemy informacje
#

PLIK=./t.txt

function dodaj
{
        #
        # zapisuje ścieżkę, nazwę pliku oraz komentarz do pliku o nazwie $PLIK
        #
        echo "$(realpath $1)"    "$1"    "$2" >> ./$PLIK
}

function sprawdzDostepnosc
{
        #
        # funkcja sprawdza czy dany plik lub katalog istnieje w systemie
        #
        count=0;
        while read word _; do
                let "count+=1";
                if [ -e "$word" ]; then
                        echo $count" $word      istnieje;"
                else
                        echo $count" $word      nie istnieje;";
                        znacznik=$count;
                fi
        done < $PLIK
}

function usun
{
        #
        # funkcja usuń usuwa rekordy z bazy nieistniejących plików lub katalogów
        #

        #licznik linii
        count=0;

        flaga=0;
        flaga2=1;
        while [ $flaga2 -eq  1 ]; do
                flaga=0;
                count=0;
                while read word _; do
                        let "count+=1";
                        if ! [[ -e "$word" ]]; then
                                echo $count"$word nie istnieje";
                                znacznik=$count;
                                flaga=1;
                        fi
                done < $PLIK

                if [ $flaga -eq 1 ]
                then
                        echo "Usunięto linie: "$znacznik;
                        sed -i $znacznik'd' $PLIK;
                        flaga=0;
                else
                        echo "Wszystkie są pliki aktualne";
                        flaga2=0;
                fi
        done
}

function pomoc 
{
        str=(
"################################################################"
"	Wbudowany manual dla skryptu $1"
""
"Użycie: $1 [przełącznik] [nazwapliku] [komentarz]"
"#"
"Przełączniki:"
"    -add nazwapliku \"komentarz\"		nazwa pliku lub katalogu którego ścieżkę chcemy zapisać \"komentarz do pliku\""
"    -find PATTERN			komenda która wyodrębni nam linie zawierającą podany ciąg znaków"
"    -a					sprawdza dostępność zapisanych plików w bazie"
"    -d					usuwa wszystkie niedostępne już lokalizacje"
"#"
"Konkretne przykłady użycia przełączników:"
"    $1 -add pliktest.txt \"testowy komentarz do pliktest.txt\" "
"       #informacje o plikach zapisywane są w $PLIK:"
"       ŚCIEŻKA    NAZWAPLIKU    OPCJONALNY KOMENTARZ"
"    $1 -find pliktest.txt"
"    $1 -a"
"    $1 -d"
""
"################################################################"

)

        printf "%s\n" "${str[@]}"
}

case "$1" in
        -add)
                dodaj $2 "$3"
                ;;
        -find)
                 grep "$2" $PLIK
                ;;
        -a)
                sprawdzDostepnosc
                ;;
        -d)
                usun
                ;;
        --help | -h)
                pomoc $0
                ;;
        *) echo "type: $0 --help"
        ;;
esac

