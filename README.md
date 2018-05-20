# Projekt: Rubikova kocka
# Autor: Andrej Klocok
# Login: xkloco00
Program rieši hlavolam rubikovej kocky 3x3 pomocou prechádzania stavového priestoru metódou iteratívneho prehľadávania do hĺbky IDDFS.

## Názov
	flp18-log

## Preklad
	$ make

Skompilovaný program sa nachádza v aktuálnom adresáry.

## Rozhranie programu
	$ flp18-log < vstup
kde:

	[vstup] je cesta do súboru obsahujúceho formát rubíkovej kocky.

## Formát vstupu
Vstupný súbor obsahuje rubikovú kocku. Čísla reprezentujú jednotlivé farby kocky, pričom každá stena kocky má 3x3 políčok s farbou.
Jednotlivé steny sú oddelené od seba medzerou. Na prvých 3 riadkoch sa nachádza popis hornej steny na ďalších troch riadkoch sú v poradí predná, pravá, zadná a ľavá stena
oddelené medzerou. Na posledných troch riadkoch sa nachádza popis spodnej steny kocky.

Napríklad :
	
	555
	555
	555
	111 222 333 444
	111 222 333 444
	111 222 333 444
	666
	666
	666

## Formát výstupu
Výstup programu predstavuje výpis jednotlivých zložení kocky, ktoré smerujú k vyriešení problému.
Pre vstup:

	553
	553
	554
	225 322 644 111
	115 322 633 444
	115 322 633 444
	662
	661
	661
	
Program vytvorí sekvenciu zložení:

	553
	553
	554
	225 322 644 111
	115 322 633 444
	115 322 633 444
	662
	661
	661

	555
	555
	555	
	222 333 444 111
	111 222 333 444
	111 222 333 444
	666
	666
	666

	555
	555
	555
	111 222 333 444
	111 222 333 444
	111 222 333 444
	666
	666
	666

## Rozbor
Na riešenie problému rubikovej kocky je zvolené prehľadávanie stavového priestoru metódou iteratívneho prehľadávania do hĺbky IDDFS. Táto metóda má časovú zložitosť O(12^d), kde d je hĺbka zanorenia algoritmu, teda počet krokov, potrebných pre zloženie kocky. Hlavnou výhodou algoritmu je priestorová zložitosť, ktorá v podstate závisí len na hĺbke, teda O(d).
Výsledný čas závisí hlavne na prehľadávaní stavového priestoru a vetve, ktorou sa algoritmus vydá.

Algoritmus som otestoval na priložených testoch (test1.txt-test4.txt), kde číslo textu uvádza počet krokov potrebných pre vyriešenie rubikovej kocky. Výsledky sú nasledujúce:

	$./flp18-log < test1.txt

	real    0m0.043s
	user    0m0.031s
	sys     0m0.031s

	$./flp18-log < test2.txt

	real    0m0.047s
	user    0m0.000s
	sys     0m0.063s

	$./flp18-log < test3.txt

	real    0m0.054s
	user    0m0.016s
	sys     0m0.031s

	$./flp18-log < test4.txt

	real    0m0.084s
	user    0m0.063s
	sys     0m0.031s
# RubicCube
