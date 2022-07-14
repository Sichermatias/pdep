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

% Punto 1

nivelDeDificultadDeLaSala(Sala, Dificultad):-
    sala(Sala, Experiencia),
    dificultadPorExperiencia(Experiencia, Dificultad).

dificultadPorExperiencia(terrorifica(CantidadDeSustos, EdadMinima), Dificultad):-
    Dificultad is CantidadDeSustos - EdadMinima.

dificultadPorExperiencia(familiar(Tematica, CantidadDeHabitaciones), Dificultad):-
    dificultadPorTematica(Tematica, CantidadDeHabitaciones, Dificultad).

dificultadPorExperiencia(enigmatica(Candados), Candados).

dificultadPorTematica(futurista, _, 15).

dificultadPorTematica(Tematica, CantidadDeHabitaciones, CantidadDeHabitaciones):-
    Tematica \= futurista.


% Punto 2

puedeSalir(Nombre, Sala):-
    noEsClaustrofobica(Nombre),
    nivelDeDificultadDeLaSala(Sala, 1).

puedeSalir(Nombre, Sala):-
    persona(Nombre, Edad, _),
    noEsClaustrofobica(Nombre),
    nivelDeDificultadDeLaSala(Sala, Dificultad),
    Edad > 13,
    Dificultad < 5.

noEsClaustrofobica(Nombre):-
    persona(Nombre, _, Peculiaridades),
    not(member(claustrofobia, Peculiaridades)).
    
% Punto 3

tieneSuerte(Persona, Sala):-
    puedeSalir(Persona, Sala),
    persona(_, _, Peculiaridades),
    noTienePeculiaridades(Peculiaridades).

noTienePeculiaridades(Peculiaridades):-
    length(Peculiaridades, 0).

% Punto 4

esMacabra(Empresa):-
    forall(esSalaDe(Sala, Empresa), esTerrorifica(Sala)).

esTerrorifica(Sala):-
    sala(_, terrorifica(_, _)).
    
% Punto 5

empresaCopada(Empresa):-
    esSalaDe(Empresa, Sala),
    not(esMacabra(Sala)),
    promedioDeDificultad(Empresa, Promedio),
    Promedio < 4.

promedioDeDificultad(Empresa, Promedio):-

    
% Punto 6

%persona(Apodo, Edad, Peculiaridades).

%esSalaDe(NombreSala, Empresa).

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).

esSalaDe(estrellasDePelea, superCelula).

sala(estrellasDePelea, familiar(videojuegos, 7)).

sala(miseriaDeLaNoche, terrorifica(150, 21)).

esSalaDe(miseriaDeLaNoche, skpista).