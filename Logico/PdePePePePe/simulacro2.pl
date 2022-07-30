:-style_check(-discontiguous).

%quedaEn(Boliche, Localidad)
quedaEn(pachuli, generalLasHeras).
quedaEn(why, generalLasHeras).
quedaEn(chaplin, generalLasHeras).
quedaEn(masDe40, sanLuis).
quedaEn(qma, caba).

%entran(Boliche, CapacidadDePersonas)
entran(pachuli, 500).
entran(why, 1000).
entran(chaplin, 700).
entran(masDe40, 1200).
entran(qma, 800).

%sirveComida(Boliche)
sirveComida(chaplin).
sirveComida(qma).

%tematico(tematica)
%cachengue(listaDeCancionesHabituales)
%electronico(djDeLaCasa, horaQueEmpieza, horaQueTermina)

%esDeTipo(Boliche, Tipo)
esDeTipo(why, cachengue([elYYo, prrrram, biodiesel, buenComportamiento])).
esDeTipo(masDe40, tematico(ochentoso)).
esDeTipo(qma, electronico(djFenich, 2, 5)).

% Punto 1

esPiola(Boliche):-
	sirveComida(Boliche),
	quedaEn(Boliche, generalLasHeras).

esPiola(Boliche):-
	sirveComida(Boliche),
	entran(Boliche, Capacidad),
	Capacidad > 700.

% Punto 2

soloParaBailar(Boliche):-
	quedaEn(Boliche, _),
	not(sirveComida(Boliche)).

% Punto 3

podemosIrConEsa(Localidad):-
	quedaEn(_, Localidad),
	forall(quedaEn(Boliche, Localidad), esPiola(Boliche)).

% Punto 4

puntaje(Boliche, 9):-
	esDeTipo(Boliche, tematico(ochentoso)).

puntaje(Boliche, 7):-
	esDeTipo(Boliche, tematico(Tematica)),
	Tematica \= ochentoso.

puntaje(Boliche, Puntaje):-
	esDeTipo(Boliche, electronico(_, HoraQueEmpieza, HoraQueTermina)),
	Puntaje is HoraQueEmpieza + HoraQueTermina.

puntaje(Boliche, 10):-
	esDeTipo(Boliche, cachengue(ListaDeCancionesHabituales)),
	member(biodiesel, ListaDeCancionesHabituales),
	member(buenComportamiento, ListaDeCancionesHabituales).

% Punto 5

elMasGrande(UnBoliche, UnaLocalidad):-
	quedaEn(UnBoliche, UnaLocalidad),
	forall(quedaEn(Otroboliche, UnaLocalidad), esMasGrandeQue(UnBoliche, Otroboliche)).
	

esMasGrandeQue(UnBoliche, OtroBoliche):-
	entran(UnBoliche, UnaCapacidad),
	entran(OtroBoliche, OtraCapacidad),
	UnaCapacidad >= OtraCapacidad.
	

% Punto 6	

puedeAbastecer(Localidad, Cantidad):-
	capacidadPorLocalidad(Localidad, CapacidadPorLocalidad),
	sum_list(CapacidadPorLocalidad, SumaCapacidades),
	SumaCapacidades >= Cantidad.
	
capacidadPorLocalidad(Localidad, CapacidadPorLocalidad):-
	findall(Capacidad, (quedaEn(Boliche, Localidad), entran(Boliche, Capacidad)), CapacidadPorLocalidad).

% Punto 7

quedaEn(trabajamosYNosDivertimos, concordia).
entran(trabajamosYNosDivertimos, 500).
sirveComida(trabajamosYNosDivertimos).
esDeTipo(trabajamosYNosDivertimos, tematico(oficina)).

quedaEn(elFinDelMundo, ushuaia).
entran(elFinDelMundo, 1500).
esDeTipo(elFinDelMundo, electronico(djLuis, 0, 6)).

entran(misterio, 1000000).
sirveComida(misterio).