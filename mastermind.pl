
% Question 1

% 1)

% +Code1, +Code2, -BP cela veut donc dire que code doit être spécifié à l'inverse BP


/*
	* Prédicat nBienPlace\3 : retourne le nombre d'éléments qui sont au même endroit dans deux listes
	* Entrées : Code1, Code2
	* Sortie : N nombre de d'éléments bien placés (dans notre cas : élément = couleur)
*/

% Cas où les deux listes sont vides
nBienPlace([],[], 0).
% Cas où les têtes des deux listes sont différentes -> le compteur ne s'incrémente pas
nBienPlace([H|R1],[T|R2], BP) :- dif(H,T),nBienPlace(R1,R2, BP).
% Cas où les têtes des deux listes sont identiques -> le compteur s'incrémente
nBienPlace([H|R1],[H|R2], BP):- nBienPlace(R1,R2, BPbis), BP is BPbis + 1.


/*
	* prédicat longueur\2 : renvoie la longueur d'une liste
	* Entrées : L liste
	* Sortie : N taille de la liste
*/
longueur([],0).
longueur([H|R], N) :- longueur(R,Nbis), N is Nbis + 1.

% 2)

/*
	* prédicat gagne\2 : Renvoie true si 2 codes sont identiques
	* Entrées : Code1, Code2, listes de couleurs
*/
/*
gagne([],[]).
gagne([H|R1],[H|R2]) :- gagne(R1,R2).
gagne([H|R1],[H|R2]) :- nBienPlace(L1,L2,BP) is longueur(L1, N).
*/

gagne(Code1, Code2) :-
	longueur(Code1, Len1),
	longueur(Code2, Len2),
	nBienPlace(Code1, Code2, BP),
	BP =:= Len1,
	BP =:= Len2.

% Question 2

% 1)
%element(_,[]).
%element(E, [H|R]) :- E=H, element(E,R).
element(X,[X|_]).
element(E, [_|R]) :- element(E,R).


%concatenate([T|R], L2, [T|LTmp]) :- concatenate(R, L2, LTmp).

% Ma version de enleve --------------------
%enleve(_,[],[]).
%enleve(E, [E|R], L2) :- enleve(E,R,L2).
%enleve(E, [H|R], L2) :- dif(E,H),concatenate(H, R, L2), enleve(E,R,L2).

% 2)

% Internet version de enleve (supprimer) ----------------------

/*
	* Prédicat enleve\3 : construit une liste L2, identique à L1 privée de la première occurence de E.
	* Entrées : E nombre à retirer, L1 liste
	* Sortie : L2 liste égale à L1 mais sans la première occurence de E
*/


enleve(X,[],[]).

enleve(X,[X|L1],L1).

% ajout_tete(X,L,[X|L]).
% enleve(X,[Y|L1],L2):- dif(X,Y) , ajout_tete(Y,L3,L2), enleve(X,L1,L3).
enleve(X,[Y|L1],[Y|L2]):- dif(X,Y) , enleve(X,L1,L2). % bien plus efficace !!!

% 3)

/*
	* Prédicat enleveBP\4 : Retourne Code1Bis et Cod2Bis tel que
	* Code1Bis (resp. Code2Bis) contiennent les éléments de Code1 (resp. Code2)
	* privé des éléments bien placés (communs) avec Code2 (resp. Code1).
	* Entrées : Code1, Code2, listes d'entier codant les couleurs
	* Sorties : Code1Bis, Code2Bis, les listes Code1 et Code2 sans leurs éléments communs
*/

ajout_tete(X,L,[X|L]).
% cas où les listes sont vides
enleveBP([],[],[],[]). % enleveBP([],[],Code1Bis,Code2Bis) est faux

% cas où les têtes de listes sont égales : on enlève du résultat les têtes en communs
%enleveBP([X|L1],[X|L2],Code1Bis,Code2Bis).
enleveBP([X|L1],[X|L2],Code1Bis,Code2Bis) :- enleveBP(L1,L2,Code1Bis,Code2Bis).

% enleveBP([X|L1],[Y|L2],Code1Bis,Code2Bis) :- dif(X,Y),ajout_tete(X,L3,Code1Bis),ajout_tete(Y,L4,Code2Bis), enleveBP(L1,L2,L3,L4). pas du tout optimale

% cas où les têtes de listes ne sont pas égales : on garde les têtes dans le résultat
enleveBP([X|L1],[Y|L2],[X|Code1Bis],[Y|Code2Bis]) :- dif(X,Y), enleveBP(L1,L2,Code1Bis,Code2Bis).


% 4)
% je ne l'ai pas utilisé
/*
nMalPlacesAux([],[], 0).
nMalPlacesAux([X|L1],[Y|L2],MP) :- dif(X, Y), nMalPlacesAux(L1,L2,MPbis), MP is MPbis+1.

nMalPlaces([],[], 0).
nMalPlaces([X|L1],[X|L2],MP) :- nMalPlaces(L1,L2,MP).
nMalPlaces([X|L1],[Y|L2],MP) :- dif(X, Y), nMalPlaces(L1,L2,MPbis), MP is MPbis+1.
*/

/*
	* prédicat nMalPlacesAux\3 : Retourne le nombre de couleurs mal placés entre le code secret et le code
	* donné par l'utilisateur. Suppose que les deux codes ne contiennent aucun éléments bien placés en commun.
	* Entrées : Code1, Code2, les codes à analyser, qui ne contiennent aucun élément bien placés en commun.
	* Sortie : N le nombre d'éléments mal placés
*/

% on s'arrête quand une des liste est vide : il n'y a plus rien à comparer
nMalPlacesAux([],[],0).

% cas ou la tete de liste du Code1 est présente dans le Code2 : on incrémente le compteur
nMalPlacesAux([T1|R1],L2,N) :-
	element(T1,L2),
    enleve(T1,L2,L2bis),
    nMalPlacesAux(R1,L2bis,Nbis),
    N is Nbis + 1.

% cas ou la tete de liste du Code1 n'est pas présente dans le Code2 : on incrémente pas le compteur
% (il ne s'agit alors pas d'une couleur mal placé, juste d'une mauvaise couleur)
nMalPlacesAux([T1|R1],[T2|R2],N) :-
	\+element(T1,[T2|R2]),
    nMalPlacesAux(R1,R2,N).


/*
	* Prédicat nMalPlaces\3 : Retourne le nombre de couleurs mal placés entre le code secret et le code
	* donné par l'utilisateur.
	* Entrées : Code1, Code2, les codes à analyser
	* Sortie : N le nombre d'éléments mal placés
*/

% cas listes vides
nMalPlaces([],[],0).
% cas ou un élément de Code1 (sans les elements bien placés) appartient également à Code2 (sans les elements bien placés)
nMalPlaces(L1,L2,MP) :-
    enleveBP(L1,L2,L1bis,L2bis),
    nMalPlacesAux(L1bis,L2bis,MP).


/*
	* Prédicat listeCouleur\3 : Génère une liste contenant les entiers de Start
	* jusqu'à à M
*/

liste_couleurs(Max,Max,[Max]).

liste_couleurs(Min,Max,[Min|R]):-
    dif(Min,Max),
    MinBis is Min + 1,
    liste_couleurs(MinBis,Max,R).



/*
	* Prédicat generateAllCodes\3 : Génère tous les codes possibles de taille N
	* pour M couleurs
	* Entrées : M nombre de couleurs, N taille du code secret
	* Sortie : Liste de tous les codes possibles
*/
gen(_,0,[]).
gen(M, N, [X|R]) :-
    liste_couleurs(1,M,L),
    member(X,L),
    N>0,
    Nbis is N - 1,
    gen(M,Nbis,R).

test(_,[]).
test(Code, [prop(CodeHistorique,BPhistorique,MPhistorique)|R]) :-

    nBienPlace(Code,CodeHistorique,BPhistorique),
    nMalPlaces(Code,CodeHistorique,MPhistorique),

   % BP =:= BPhistorique,
   % MP =:= MPhistorique,

    test(Code,R).


/*
	* Prédicat solve\2 : Génère tous les codes qui sont candidats pour être
	* code secret, en fonction de l'historique des coups joués.
	* Entrées : X le code à tester, Historique, l'historique des coups sous la forme
	* liste(prop(Code, NombreBienPlace, NombreMalPlace)).
	* Sortie: Res le premier code qui est compatible
	*/


solve(M, N, Historique, Res) :-
	gen(M, N, Res),
	test(Res, Historique), !.

arbitreAuto(Prop, Sol, BP, MP) :-
	nBienPlace(Prop, Sol, BP),
	nMalPlaces(Prop, Sol, MP).

arbitreHumain(BP, MP) :-
	write("Bien place = "), nl, read(BP),
	write("Mal Place = "), nl, read(MP), nl.

main(M, N) :-
    write("Code aléatoire : 1. Oui 2. Non"),nl,
    read(Rep),
    creerCodeSecret(M,N,Rep,CodeSecret), nl,
	write("Mode Auto : 1. Actif 2. Inactif"), nl,
	read(Auto),
	Auto > 0, Auto < 3,
	jouer(M,N,CodeSecret, [], 1, Auto).

% générer un code aléatoirement
creerCodeSecret(M,0,1,[]).

creerCodeSecret(M,N,1,[Elem|RcodeSecret]):-
    random(1,M,Elem),
    Nbis is N - 1,
    creerCodeSecret(M,Nbis,1,RcodeSecret).

% générer un code manuellement
creerCodeSecret(M,N,2,CodeSecret):-
    write("Entrez un code secret de taille "),
	write(N),
	write(" avec "),
	write(M),
	write(" couleurs, sous la forme d'une liste prolog"), nl,
	read(CodeSecret).


% cas où le joueur gagne
jouer(M,N,CodeSecret,Historique,Compteur,_) :-
	solve(M, N, Historique, Res),
	gagne(CodeSecret, Res),
	write("Gagné en "),
	write(Compteur),
	write(" coups ! "),
	write(Res).

% cas où le joueur a choisit d'activer le mode Auto -> c'est la machine qui résout le code
jouer(M,N,CodeSecret,Historique,Compteur,1) :-
	solve(M, N, Historique, Res),
	\+ gagne(CodeSecret, Res),
	write("Tentative "), write(Compteur), write(" ... ["), printList(Res), write("]"),
	arbitreAuto(Res, CodeSecret, BP, MP),
	write(" Bien place = "), write(BP), write(" Mal place = "), write(MP), nl,
	concat(Historique, [prop(Res, BP, MP)], NewHist),
	Compteur2 is Compteur+1,
	jouer(M,N,CodeSecret,NewHist,Compteur2,1).

% cas où le joueur a choisit de désactiver le mode Auto -> c'est el joeur qui résout le code
jouer(M,N,CodeSecret,Historique,Compteur,2) :-
	solve(M, N, Historique, Res),
	\+ gagne(CodeSecret, Res),
	write("Tentative "), write(Compteur), write(" : ["), printList(Res), write("]"), nl,
	arbitreHumain(BP, MP),
	concat(Historique, [prop(Res, BP, MP)], NewHist),
	Compteur2 is Compteur+1,
	jouer(M,N,CodeSecret,NewHist,Compteur2,2).




concat([], L, L).
concat([T|R], L2, [T|LTmp]) :-
	concat(R, L2, LTmp).

% on affiche une liste
printList([T|R]) :-
	dif(R, []),
	format('~w,',T),
    printList(R).

% un seul élément dans ma liste
printList([T|[]]) :-
	format('~w',T).
