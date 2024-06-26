#!/bin/bash

# Definirea fișierelor de input și output
input_file="in.txt"
output_file="out.txt"

# Verificarea existenței fișierului de input
if [ ! -f "$input_file" ]; then
    echo "Eroare: Fișierul de input $input_file nu există."
    exit 1
fi

# Citirea numerelor din fișierul de input
mapfile -t numbers < "$input_file"

# Verificarea dacă fișierul nu este gol
if [ ${#numbers[@]} -eq 0 ]; then
    echo "Eroare: Fișierul $input_file este gol."
    exit 1
fi

# Sortarea numerelor
sorted_numbers=($(printf "%s\n" "${numbers[@]}" | sort -n))

# Scrierea numerelor sortate în fișierul de output
printf "%s\n" "${sorted_numbers[@]}" > "$output_file"

echo "Vectorul sortat a fost scris în $output_file."

# Verificarea utilizării memoriei
echo "Utilizarea memoriei:"
free -h

# Verificarea proceselor curente
echo "Procesele curente:"
ps -e --sort=-%mem -o pid,ppid,cmd,%mem,%cpu --no-headers | head -n 10

