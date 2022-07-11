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

esPiola(Boliche) :-
	quedaEn(Boliche, generalLasHeras).

esPiola(Boliche) :-
  entran(Boliche, CantidadDePersonas),
  CantidadDePersonas > 700.

soloParaBailar(Boliche) :-
  not(sirveComida(Boliche)).
  
podemosIrConEsa(Localidad) :-
  quedaEn(_, Localidad),
  forall(Boliche, esPiola(Boliche)).
  
%elMasGrande(Boliche, Localidad) :-

puntaje(Boliche, Puntaje).


