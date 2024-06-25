#include <stdio.h>
#include <stdlib.h>

int compare(const void *a, const void *b) {
    return (*(int *)a - *(int *)b);
}

int main(int argc, char *argv[]) {
    if (argc != 1) {
        fprintf(stderr, "Utilizare: %s <input_file>\n", argv[0]);
        return 1;
    }

    const char *input_file = argv[0];
    const char *output_file = "output_CProg.txt";

    FILE *input = fopen(input_file, "r");
    if (input == NULL) {
        perror("Nu se poate deschide fișierul de input");
        return 1;
    }

    int *numbers = NULL;
    int count = 0;
    int capacity = 10;
    numbers = (int *)malloc(capacity * sizeof(int));
    if (numbers == NULL) {
        perror("Nu se poate aloca memorie");
        fclose(input);
        return 1;
    }

    while (fscanf(input, "%d", &numbers[count]) == 1) {
        count++;
        if (count >= capacity) {
            capacity *= 2;
            numbers = (int *)realloc(numbers, capacity * sizeof(int));
            if (numbers == NULL) {
                perror("Nu se poate realoca memorie");
                fclose(input);
                return 1;
            }
        }
    }

    fclose(input);

    qsort(numbers, count, sizeof(int), compare);

    FILE *output = fopen(output_file, "w");
    if (output == NULL) {
        perror("Nu se poate deschide fișierul de output");
        free(numbers);
        return 1;
    }

    for (int i = 0; i < count; i++) {
        fprintf(output, "%d\n", numbers[i]);
    }

    fclose(output);
    free(numbers);

    return 0;
}

