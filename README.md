# Script_testare_aplicatie

Ziua 1: Alegerea temei proiectului
Tema aleasa: 10 - Script pentru testarea unei aplicații(timp de execuție, input-output, apeluri de sistem(strace), apeluri de biblioteca(ltrace). Modularizat.
Am ales aceasta tema deoarece cred ca scripting-ul este o caracteristica definitorie in abilitatile unui inginer software si vreau sa stiu mai multe despre bash scripting.

Ziua 2: Informare despre comenzi
În a doua zi a proiectului, am dedicat timp pentru a mă informa cu privire la comenzile ltrace și strace. Pentru a obține o înțelegere detaliată a acestor comenzi, am vizionat următoarele videoclipuri educaționale:

Jacob Sorber - Intro to ltrace and strace
Mark McNally - Debugging with strace and ltrace
Aceste videoclipuri mi-au oferit o perspectivă clară asupra modului în care aceste comenzi funcționează și cum pot fi utilizate eficient pentru a monitoriza și depana programele.

Am vizitat site-ul "PackageCloud" unde am gasit mai multe informatii pentru realizarea temei alese.
link: https://blog.packagecloud.io/how-does-ltrace-work/

Ziua 3,4: Scrierea proiectului

In ultimele 2 zile am inceput scrierea script-ului si am avansat cu realizarea proiectului.

Ziua 7: Scrierea proiectului
Avansarea proiectului pana intr-o faza in care mai sunt de facut cateva adaugari si retusuri.
Am rezolvat problema comenzii ltrace cu ajutorul doamnei profesoare Vaman si domnului profesor Avram.
Primul commit cu tot ce am lucrat pana acum. 
Proiectul include in momentul asta:
test_app.sh --SCRIPTUL DE TEST AL APLICATIILOR--
sort_numbers.c --APLICATIE IN C (pt a avea un ELF file) DE SORATRE A UNUI VECTOR
mySortApp.sh --SCRIPT CARE SORTEAZA UN VECTOR CITIT DINTR-UN FISIER SI SCRIE REZULATUL INTR-UN ALTUL
in.txt --FISIER DE INPUT--
out.txt --FISIER DE OUTPUT--
output_CProg.txt --FISIER DE OUTPUT PT PROGRAMUL IN C--
strace,ltrace _output.txt --FISIERELE DE OUTPUT PENTRU COMENZILE MENTIONATE--
check_file.txt --FISIER CARE VERIFICA UN OUTPUT--
raport_testare.txt --FISIER DE RAPORT AL COMPORTAMENTULUI APLICATIEI--


Ziua 8: Scrierea proiectului si aducerii de noi functionalitati

Acum script-ul de test al monitorizarii unei aplicatii genereaza automat un director cu numele aplicatiei testate care contine cele 3 fisiere de raport. 
Fiecare director de aceste fel este localizat in directorul 'rapoarte'. 
O alta functionalitate este accesarea fisierelor de raport, modificarea si stergerea lor cu ajutorul unei interfete web. Am realizat acest aspect folosind Flask.




