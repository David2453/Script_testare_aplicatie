#!/bin/bash

# verific numarul de parametrii
if [ "$#" -ne 2 ]; then
    echo "Utilizare: $0 <cale_catre_fisier_executabil>"
    exit 1
fi


TESTE_TRECUTE=0
TESTE_ESUEATE=0
EXECUTABIL=$1
RAPORT="raport_testare.txt"
STRACE_OUTPUT="strace_output.txt"
LTRACE_OUTPUT="ltrace_output.txt"

# sterg fisierul de raport daca este deja creat
if [ -f "$RAPORT" ]; then
    rm "$RAPORT"
fi

# sterg fisierul pt output-ul strace
if [ -f "$STRACE_OUTPUT" ]; then
    rm "$STRACE_OUTPUT"
fi

# la fel ca pt strace, dar pt ltrace
if [ -f "$LTRACE_OUTPUT" ]; then
    rm "$LTRACE_OUTPUT"
fi

# verific daca parametrul este fisier si exista
if [ ! -f "$EXECUTABIL" ]; then
    echo "Eroare: Fisierul '$EXECUTABIL' nu exista." >> "$RAPORT"
    exit 1
fi

# verific drepturile de exec
if [ ! -x "$EXECUTABIL" ]; then
    echo "Eroare: Fisierul '$EXECUTABIL' nu are permisiuni de executie." >> "$RAPORT"
    exit 1
fi

# rulez aplicatia si preiau output-ul
OUTPUT=$("$EXECUTABIL")
EXIT_CODE=$?


#echo "Aici ma intereseaza";echo;
#strace -c "$EXECUTABIL" 

#exit 10

strace -c -o "$STRACE_OUTPUT" "$EXECUTABIL" > /dev/null 2>&1

ltrace -c -o "$LTRACE_OUTPUT" "$EXECUTABIL" > /dev/null 2>&1

# numar apelurile de read si write din strace
READ_COUNT=$(egrep "read" "$STRACE_OUTPUT" | wc -l)
WRITE_COUNT=$(egrep "write" "$STRACE_OUTPUT" | wc -l)


    # executia testelor si scrierea lor in fisierul de raport
{
    echo "Test 1: Verificare executie"
    echo "---------------------------"
    echo "Iesire:"
    OUTPUT_LENGTH=${#OUTPUT}
    if [ $OUTPUT_LENGTH -eq 0 ]; then
        echo "---Aplicatia nu genereaza output in std-output.---"
        echo "ESEC"
        ((TESTE_ESUATE++))
    else
    ((TESTE_TRECUTE++))
        echo "$OUTPUT"
        echo "SUCCES"
    fi

    echo "Cod de iesire: $EXIT_CODE"

    # Test 2: verific un cuvant sau o fraza cheie daca se afla in output-ul generat de EXECUTABIL
    if echo "$OUTPUT" | grep -q "vectorul este: "; then
        echo "Test 2: Verificare iesire asteptata - SUCCES"
        ((TESTE_TRECUTE++))
    else
        echo "Test 2: Verificare iesire asteptata - ESEC"
        ((TESTE_ESUATE++))
    fi

    # Testt 3: Verificare timp de executie (max 5 secunde)
    START_TIME=$(date +%s)
    "$EXECUTABIL" > /dev/null 2>&1
    END_TIME=$(date +%s)
    EXECUTION_TIME=$((END_TIME - START_TIME))
    if [ "$EXECUTION_TIME" -le 5 ]; then
        echo "Test 3: Verificare timp de executie - SUCCES (Timp: ${EXECUTION_TIME}s)"
        ((TESTE_TRECUTE++))
    else
        echo "Test 3: Verificare timp de executie - ESEC (Timp: ${EXECUTION_TIME}s)"
        ((TESTE_ESUATE++))
    fi

    # Test 4: test cod de iesire
    EXPECTED_EXIT_CODE=0
    if [ "$EXIT_CODE" -eq "$EXPECTED_EXIT_CODE" ]; then
        echo "Test 4: Verificare cod de iesire - SUCCES"
        ((TESTE_TRECUTE++))
    else
        echo "Test 4: Verificare cod de iesire - ESEC (Cod asteptat: $EXPECTED_EXIT_CODE, Cod primit: $EXIT_CODE)"
        ((TESTE_ESUATE++))
    fi

    # Test 5: Test dimenisune output executabil (max 1000 de char)
    OUTPUT_LENGTH=${#OUTPUT}
    if [ "$OUTPUT_LENGTH" -le 1000 ]; then
        echo "Test 5: Verificare dimensiune iesire - SUCCES (Dimensiune: $OUTPUT_LENGTH caractere)"
        ((TESTE_TRECUTE++))
    else
        echo "Test 5: Verificare dimensiune iesire - ESEC (Dimensiune: $OUTPUT_LENGTH caractere)"
        ((TESTE_ESUATE++))
    fi

    # Test 6: Verificare existenta unui fisier creat de executabil
    EXPECTED_FILE="out.txt"
    if [ -f "$EXPECTED_FILE" ]; then
        echo "Test 6: Verificare existenta fisierului creat - SUCCES"
        ((TESTE_TRECUTE++))
    else
        echo "Test 6: Verificare existenta fisierului creat - ESEC"
        ((TESTE_ESUATE++))
    fi

    # Test 7: Verific continut fiser creat de executabil
    if [ -f "$EXPECTED_FILE" ]; then
        FILE_CONTENT=$(cat "$EXPECTED_FILE")
        if [ "$FILE_CONTENT" = "$(cat check_file.txt)" ]; then       
            echo "Test 7: Verificare continut fisier  - SUCCES"
            ((TESTE_TRECUTE++))
        else
            echo "Test 7: Verificare continut fisier  - ESEC"
            ((TESTE_ESUATE++))
        fi
    else
        echo "Test 7: Verificare continut fisier  - NU SE APLICA (Fisierul nu exista)"
    fi

    # Test 8: Verificare utilizare memorie (maxim 50MB)
    MEMORY_USAGE=$(ps -o rss= -p $$)
    if [ "$MEMORY_USAGE" -le 51200 ]; then
        echo "Test 8: Verificare utilizare memorie - SUCCES (Memorie: ${MEMORY_USAGE}KB)"
        ((TESTE_TRECUTE++))
    else
        echo "Test 8: Verificare utilizare memorie - ESEC (Memorie: ${MEMORY_USAGE}KB)"
        ((TESTE_ESUATE++))
    fi

    # Test 9: Numar apeluri read, write (strace)
    echo "Test 9: Numar apeluri read si write"
    echo "----------------------------------"
    echo "Numar apeluri read: $READ_COUNT"
    echo "Număr apeluri write: $WRITE_COUNT"

    if file "$EXECUTABIL" | grep -q "ELF"; then
        echo "Fisierul '$EXECUTABIL' este de tip ELF."
        echo "Test 10: Numar apeluri malloc si free"
        echo "-----------------------------------"
        ltrace -c "$EXECUTABIL" >> "$RAPORT" 2>&1
        else
            echo "Fisierul '$EXECUTABIL' NU este de tip ELF."
    fi

    echo "Numarul de teste trecute cu SUCCES: $TESTE_TRECUTE "
    echo "Numarul de teste ESUATE: $TESTE_ESUATE "


    TOTAL_TESTE=$((TESTE_TRECUTE + TESTE_ESUATE))

    if [ $TOTAL_TESTE -eq 0 ]; then
        echo "Nu exista teste pentru a calcula rata de succes."
    else
        RATA_SUCCES=$(echo "scale=2; $TESTE_TRECUTE * 100 / $TOTAL_TESTE" | bc)
        echo "Rata de succes este de $RATA_SUCCES%."
    fi

    

} >> "$RAPORT"
