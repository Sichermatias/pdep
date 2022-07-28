%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).


nivelDeDificultadDeLaSala(Sala, Dificultad):-
	sala(Sala, Tipo),
	nivelDeDificultadDelTipo(Tipo, Dificultad).

nivelDeDificultadDelTipo(terrorifica(CantidadDeSustos, EdadMinima), Dificultad):-
	Dificultad is CantidadDeSustos - EdadMinima.

nivelDeDificultadDelTipo(familiar(futurista, _), 15).

nivelDeDificultadDelTipo(familiar(Tematica, CantidadDeHabitaciones), CantidadDeHabitaciones):-
	Tematica \= futurista.

nivelDeDificultadDelTipo(enigmatica(Candados), CantidadDeCandados):-
	length(Candados, CantidadDeCandados).	

puedeSalir(Persona, Sala):-
	noEsClaustrofobica(Persona),
	nivelDeDificultadDeLaSala(Sala, 1).

puedeSalir(Persona, Sala):-
	noEsClaustrofobica(Persona),
	persona(Persona, Edad, _),
	Edad > 13,
	nivelDeDificultadDeLaSala(Sala, Dificultad),
	Dificultad < 5.

noEsClaustrofobica(Persona):-
	persona(Persona, _, Peculiaridades),
	not(member(claustrofobia, Peculiaridades)).

tieneSuerte(Persona, Sala):-
	puedeSalir(Persona, Sala),
	cantidadDePeculiaridades(Persona, 0).

cantidadDePeculiaridades(Persona, CantidadPeculiaridades):-
	persona(Persona, _, Peculiaridades),
	length(Peculiaridades, CantidadPeculiaridades).

esMacabra(Empresa):-
	esSalaDe(_, Empresa),
	forall(esSalaDe(Sala, Empresa), sala(Sala, terrorifica(_, _))).
	
empresaCopada(Empresa):-
	promedioDeDificultad(Empresa, Promedio),
	not(esMacabra(Empresa)),
	Promedio < 4.

promedioDeDificultad(Empresa, Promedio):-
	listaDeDificultadDeSalas(Empresa, ListaDeDificultadDeSalas),
	sum_list(ListaDeDificultadDeSalas, SumaDeDificultadDeSalas),
	length(ListaDeDificultadDeSalas, CantidadDeSalas),
	Promedio is SumaDeDificultadDeSalas / CantidadDeSalas.
	
listaDeDificultadDeSalas(Empresa, DificultadesSalas):-
	esSalaDe(_, Empresa),
	findall(Dificultad, (esSalaDe(Sala, Empresa), nivelDeDificultadDeLaSala(Sala, Dificultad)), DificultadesSalas).

esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).
sala(estrellasDePelea, familiar(videojuegos, 7)).

esSalaDe(miseriaDeLaNoche, skPista).
sala(miseriaDeLaNoche, terrorifica(150, 21)).

