viveEnLaMansion(tiaAgata).
viveEnLaMansion(mayordomo).
viveEnLaMansion(charles).

odia(tiaAgata, Persona) :-
	viveEnLaMansion(Persona),
	Persona \= mayordomo.

odia(mayordomo, Persona) :-
	odia(tiaAgata, Persona).

odia(charles, Persona) :-
	viveEnLaMansion(Persona),
	not(odia(tiaAgata, Persona)).

esMasRico(Persona, tiaAgata) :-
	not(odia(mayordomo, Persona)),
	viveEnLaMansion(Persona).

mata(Asesino, Victima) :-
	odia(Asesino, Victima),
	not(esMasRico(Asesino, Victima)),
	viveEnLaMansion(Asesino).


%	Punto 1

% ?- mata(Asesino, tiaAgata).
% Asesino = tiaAgata ;
% false.

%	Punto 2

% Si existe alguien que odie a milhouse.
% ?- odia(_, milhouse).
% false.

% A quién odia charles.
% ?- odia(charles, Persona).       
% Persona = mayordomo ;
% false.

% El nombre de quien odia a tía Ágatha.
% ?- odia(Persona, tiaAgata).      
% Persona = tiaAgata ;
% Persona = mayordomo ;
% false.

% Todos los odiadores y sus odiados.
% ?- odia(Odiador, Odiado).
% Odiador = Odiado,
% Odiado = tiaAgata ;

% Odiador = tiaAgata,
% Odiado = charles ;

% Odiador = mayordomo,
% Odiado = tiaAgata ;

% Odiador = mayordomo,
% Odiado = charles ;

% Odiador = charles,
% Odiado = mayordomo ;

% false.

% Si es cierto que el mayordomo odia a alguien.
% ?- odia(mayordomo, _).      
% true ;
% true.