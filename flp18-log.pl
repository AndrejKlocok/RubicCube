% projekt: Rubikova kostka
% autor: Andrej Klocok
% login: xkloco00

%Reads line from stdin, terminates on LF or EOF.
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),% atom_codes(C,[Cd]),
		[C|LL] = L).

%Tests if character is EOF or LF.
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).

read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).


% rozdeli radek na podseznamy
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1

% vstupem je seznam radku (kazdy radek je seznam znaku)
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

% myWrite/1
% Vypis zoznamu na riadok
myWrite([]).
myWrite([H|S]):-
	write(H),
	myWrite(S).

% printCube/1
% Formatovany vypis kocky
printCube([
	[U1 ,U2, U3],
	[F1, F2, F3],
	[R1, R2, R3],
	[B1, B2, B3],
	[L1, L2, L3],
	[D1, D2, D3]]):-
		myWrite(U1), nl,
		myWrite(U2), nl,
		myWrite(U3), nl,
		myWrite(F1), write(' '), myWrite(R1), write(' '), myWrite(B1), write(' '), myWrite(L1), nl,
		myWrite(F2), write(' '), myWrite(R2), write(' '), myWrite(B2), write(' '), myWrite(L2), nl,
		myWrite(F3), write(' '), myWrite(R3), write(' '), myWrite(B3), write(' '), myWrite(L3), nl,
		myWrite(D1), nl,
		myWrite(D2), nl,
		myWrite(D3), nl.

% printWay/1
% Vypis zoznamu krokov zlozenia kocky
printWay([]).
printWay([H | Rest]):-
	printCube(H),
	nl,
	printWay(Rest).

% createCube/2
% reprezentacia kocky pomocou zoznamov
% U1				[	[ U1 U2 U3 ]
% U2					[ F1 F2 F3 ]
% U3					[ R1 R2 R3 ]
% F1 R1 B1 L1			[ B1 B2 B3 ]
% F2 R2 B2 L2   ->		[ L1 L2 L3 ]
% F3 R3 B3 L3			[ D1 D2 D3 ]
% D1				]
% D2
% D3
createCube(
		[
			[U1], [U2], [U3],
			[F1, R1, B1, L1],
			[F2, R2, B2, L2],
			[F3, R3, B3, L3],
			[D1], [D2], [D3]
		],
		[
			[U1, U2, U3],
			[F1, F2, F3],
			[R1, R2, R3],
			[B1, B2, B3],
			[L1, L2, L3],
			[D1, D2, D3]
		]).
% verticalFrontClockWise/2
% Otocenie prednej steny kocky (F) v smere hodinovych ruciciek
verticalFrontClockWise(		
	[
		[ U1, U2, [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11| R1], [R21| R2], [R31| R3] ],
		[B1, B2, B3],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], D2, D3]
	],
	[
		[U1, U2, [L33, L23, L13] ],
		[ [F31, F21, F11], [F32, F22, F12], [F33, F23, F13] ],
		[ [ U31| R1], [U32| R2], [U33| R3] ],
		[B1, B2, B3],
		[ [L11, L12, D11], [L21, L22, D12], [L31, L32, D13] ],
		[ [R31, R21, R11], D2, D3]
	]).
% verticalFrontCounterClocWise/2
% Otocenie prednej steny kocky (F) proti smeru hodinovych ruciciek
verticalFrontCounterClocWise(		
	[
		[ U1, U2, [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11| R1], [R21| R2], [R31| R3] ],
		[B1, B2, B3],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], D2, D3]
	],
	[
		[U1, U2, [R11, R21, R31] ],
		[ [F13, F23, F33], [F12, F22, F32], [F11, F21, F31] ],
		[ [ D13| R1], [D12| R2], [D11| R3] ],
		[B1, B2, B3],
		[ [L11, L12, U33], [L21, L22, U32], [L31, L32, U31] ],
		[ [L13, L23, L33], D2, D3]
	]).
% verticalRightClocWise/2
% Otocenie pravej steny kocky (R) v smere hodinovych ruciciek
verticalRightClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U11, U12, F13], [U21, U22, F23], [U31, U32, F33] ],
		[ [F11, F12, D13], [F21, F22, D23], [F31, F32, D33] ],
		[ [R31, R21, R11], [R32, R22, R12], [R33, R23, R13] ],
		[ [U33, B12, B13], [U23, B22, B23], [U13, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, B11], [D21, D22, B21], [D31, D32, B31] ]
	]).
% verticalRightCounterClocWise/2
% Otocenie pravej steny kocky (R) proti smeru hodinovych ruciciek
verticalRightCounterClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U11, U12, B31], [U21, U22, B21], [U31, U32, B11] ],
		[ [F11, F12, U13], [F21, F22, U23], [F31, F32, U33] ],
		[ [R13, R23, R33], [R12, R22, R32], [R11, R21, R31] ],
		[ [D33, B12, B13], [D23, B22, B23], [D13, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, F13], [D21, D22, F23], [D31, D32, F33] ]
	]).
% verticalUpperClocWise/2
% Otocenie vrchnej steny kocky (U) v smere hodinovych ruciciek
verticalUpperClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U31, U21, U11], [U32, U22, U12], [U33, U23, U13] ],
		[ [R11, R12, R13], [F21, F22, F23], [F31, F32, F33] ],
		[ [B11, B12, B13], [R21, R22, R23], [R31, R32, R33] ],
		[ [L11, L12, L13], [B21, B22, B23], [B31, B32, B33] ],
		[ [F11, F12, F13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	]).
% verticalUpperCounterClocWise/2
% Otocenie vrchnej steny kocky (U) proti smeru hodinovych ruciciek
verticalUpperCounterClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U13, U23, U33], [U12, U22, U32], [U11, U21, U31] ],
		[ [L11, L12, L13], [F21, F22, F23], [F31, F32, F33] ],
		[ [F11, F12, F13], [R21, R22, R23], [R31, R32, R33] ],
		[ [R11, R12, R13], [B21, B22, B23], [B31, B32, B33] ],
		[ [B11, B12, B13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	]).
% verticalDownClocWise/2
% Otocenie spodnej steny kocky (D) v smere hodinovych ruciciek
verticalDownClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [L31, L32, L33] ],
		[ [R11, R12, R13], [R21, R22, R23], [F31, F32, F33] ],
		[ [B11, B12, B13], [B21, B22, B23], [R31, R32, R33] ],
		[ [L11, L12, L13], [L21, L22, L23], [B31, B32, B33] ],
		[ [D31, D21, D11], [D32, D22, D12], [D33, D23, D13] ]
	]).
% verticalDownCounterClocWise/2
% Otocenie spodnej steny kocky (D) proti smeru hodinovych ruciciek
verticalDownCounterClocWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [R31, R32, R33] ],
		[ [R11, R12, R13], [R21, R22, R23], [B31, B32, B33] ],
		[ [B11, B12, B13], [B21, B22, B23], [L31, L32, L33] ],
		[ [L11, L12, L13], [L21, L22, L23], [F31, F32, F33] ],
		[ [D13, D23, D33], [D12, D22, D32], [D11, D21, D31] ]
	]).
% verticalLeftClockWise/2
% Otocenie lavej steny kocky (L) v smere hodinovych ruciciek
verticalLeftClockWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [B33, U12, U13], [B23, U22, U23], [B13, U32, U33] ],
		[ [U11, F12, F13], [U21, F22, F23], [U31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, D31], [B21, B22, D21], [B31, B32, D11] ],
		[ [L31, L21, L11], [L32, L22, L12], [L33, L23, L13] ],
		[ [F11, D12, D13], [F21, D22, D23], [F31, D32, D33] ]
	]).
% verticalLeftCounterClockWise/2
% Otocenie lavej steny kocky (L) proti smeru hodinovych ruciciek
verticalLeftCounterClockWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [F11, U12, U13], [F21, U22, U23], [F31, U32, U33] ],
		[ [D11, F12, F13], [D21, F22, F23], [D31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, U31], [B21, B22, U21], [B31, B32, U11] ],
		[ [L13, L23, L33], [L12, L22, L32], [L11, L21, L31] ],
		[ [B33, D12, D13], [B23, D22, D23], [B13, D32, D33] ]
	]).
% verticalBackClockWise/2
% Otocenie zadnej steny kocky (B) v smere hodinovych ruciciek
verticalBackClockWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [R13, R23, R33], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, D33], [R21, R22, D32], [R31, R32, D31] ],
		[ [B31, B21, B11], [B32, B22, B12], [B33, B23, B13] ],
		[ [U13, L12, L13], [U12, L22, L23], [U11, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [L11, L21, L31] ]
	]).
% verticalBackCounterClockWise/2, 
% Otocenie zadnej steny kocky (B) proti smeru hodinovych ruciciek
verticalBackCounterClockWise(		
	[
		[ [U11, U12, U13], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, R13], [R21, R22, R23], [R31, R32, R33] ],
		[ [B11, B12, B13], [B21, B22, B23], [B31, B32, B33] ],
		[ [L11, L12, L13], [L21, L22, L23], [L31, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [D31, D32, D33] ]
	],
	[
		[ [L31, L21, L11], [U21, U22, U23], [U31, U32, U33] ],
		[ [F11, F12, F13], [F21, F22, F23], [F31, F32, F33] ],
		[ [R11, R12, U11], [R21, R22, U12], [R31, R32, U13] ],
		[ [B13, B23, B33], [B12, B22, B32], [B11, B21, B31] ],
		[ [D31, L12, L13], [D32, L22, L23], [D33, L32, L33] ],
		[ [D11, D12, D13], [D21, D22, D23], [R33, R23, R13] ]
	]).

% step/2
% Rotacia kocky z kroku CubeInit do CubeOut.
step(CubeInit, CubeOut):- verticalFrontClockWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalRightClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalUpperClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalLeftClockWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalDownClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalBackClockWise(CubeInit, CubeOut).

step(CubeInit, CubeOut):- verticalFrontCounterClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalRightCounterClocWise(CubeInit, CubeOut).					
step(CubeInit, CubeOut):- verticalUpperCounterClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalDownCounterClocWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalLeftCounterClockWise(CubeInit, CubeOut).
step(CubeInit, CubeOut):- verticalBackCounterClockWise(CubeInit, CubeOut).
% test/2
% Test na zhodnost prvkov zoznamu.
test(_, []).
test(H, [H | T]):-!, test(H, T).

% testCubeStep/1
% Test zhodnosti farieb vsetkych stran, ktory implikuje spracne zlozenu kocku
testCubeStep(		
	[
		[U1, U2, U3],
		[F1, F2, F3],
		[R1, R2, R3],
		[B1, B2, B3],
		[L1, L2, L3],
		[D1, D2, D3]
	]):-	
	test(U, U1), test(U, U2), test(U, U3),
	test(F, F1), test(F, F2), test(F, F3),
	test(R, R1), test(R, R2), test(R, R3),
	test(B, B1), test(B, B2), test(B, B3),
	test(L, L1), test(L, L2), test(L, L3),
	test(D, D1), test(D, D2), test(D, D3).

% dynamicke predikaty
% cubeStart - reprezentuje pociatocny stav
:- dynamic cubeStart/1.

% dls/3
% hladanie do hlbky s obmadzenym zanorenim
dls(Step , [Step], 0):-
    testCubeStep(Step).
dls(Step, [Step | Way], Depth):-
    Depth>0,
    step(Step, CubeNewStep),
    DepthN is Depth -1,
	dls(CubeNewStep, Way, DepthN). 
dls([], _, _):- false.

%callDls/3
% Iterativne vola dls so zvysujucou sa hlbou zanorenia
callDls(Init, Way, Depth):-
    (dls(Init, Way, Depth) ) ->
    % Najdena hodnota
    (true);
    % Volanie dls
    (
        DepthN is  Depth +1,
        callDls(Init, Way, DepthN)
    ).
% Predikat inicializuje volanie Algoritmu na 0
solveCube(CubeInit, CubeWay):-
	assert(cubeStart(CubeInit)),
	callDls(CubeInit, CubeWay, 0),
	retractall(cubeStart(_)).

start :-
		prompt(_, ''),
		read_lines(LL),
		split_lines(LL,S),
		createCube(S, Cube),
		solveCube(Cube, CubeWay),
		printWay(CubeWay),
		halt.