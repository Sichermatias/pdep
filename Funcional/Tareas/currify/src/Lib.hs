import Text.Show.Functions ()

--Modelos

type Efecto = Cancion -> Cancion

type Genero = String

data Cancion = Cancion {
  titulo    :: String,
  genero    :: Genero,
  duracion  :: Int
  } deriving (Show)

data Artista = Artista {
  nombre    :: String,
  canciones :: [Cancion],
  efectoPreferido :: Efecto
  } deriving (Show)

--Mappers

mapTitulo :: (String -> String) -> Cancion -> Cancion
mapTitulo unaFuncion unaCancion = unaCancion { titulo = unaFuncion . titulo $ unaCancion }

mapGenero :: (Genero -> Genero) -> Cancion -> Cancion
mapGenero unaFuncion unaCancion = unaCancion { genero = unaFuncion . genero $ unaCancion }

mapDuracion :: (Int -> Int) -> Cancion -> Cancion
mapDuracion unaFuncion unaCancion = unaCancion { duracion = unaFuncion . duracion $ unaCancion }

mapCanciones :: ([Cancion] -> [Cancion]) -> Artista -> Artista
mapCanciones unaFuncion unArtista = unArtista { canciones = unaFuncion . canciones $ unArtista }

--Punto A

acortar :: Efecto
acortar = mapDuracion (max 0 . subtract 60)

remixar :: Efecto
remixar = mapTitulo (++" remix"). mapDuracion (*2) . mapGenero (const "remixado")

acustizar :: Int -> Efecto
acustizar nuevaDuracion cancion
  | genero cancion /= "acustico" = mapGenero (const "acustico") . mapDuracion (const nuevaDuracion) $ cancion
  | otherwise = cancion

metaEfecto :: [Efecto] -> Efecto
metaEfecto unosEfectos unaCancion = foldr ($) unaCancion unosEfectos

cafeParaDos :: Cancion
cafeParaDos = Cancion "Cafe para dos" "rock melancolico" 146

fuiHastaAhi :: Cancion
fuiHastaAhi = Cancion "Fui hasta ahi" "rock" 279

rocketRacoon :: Cancion
rocketRacoon = Cancion "Rocket Racoon" "rock" 200

mientrasMiBateriaFesteja :: Cancion
mientrasMiBateriaFesteja = Cancion "Mientras mi Bateria Festeja" "rock" 230

tomateDeMadera :: Cancion
tomateDeMadera = Cancion "Tomate de Madera" "rock" 220

losEscarabajos :: Artista
losEscarabajos = Artista {nombre = "Los Escarabajos", canciones = [rocketRacoon, mientrasMiBateriaFesteja, tomateDeMadera], efectoPreferido = acortar }

teAcordas :: Cancion
teAcordas = undefined

unPibeComoVos :: Cancion
unPibeComoVos = undefined

daleMechaALaLluvia :: Cancion
daleMechaALaLluvia = undefined

adela :: Artista
adela = Artista  "Adela" [teAcordas, unPibeComoVos, daleMechaALaLluvia] remixar

elTigreJoaco :: Artista
elTigreJoaco = Artista {nombre = "El tigre Joaco", canciones = [], efectoPreferido = acustizar (6 * 60)}
--Ambas formas de definir estan bien!

--Punto B

esCancionCorta :: Cancion -> Bool
esCancionCorta = (< 150) . duracion

vistazo :: Artista -> [Cancion]
vistazo = take 3 . filter esCancionCorta . canciones

esDeGenero :: Genero -> Cancion -> Bool
esDeGenero unGenero = (== unGenero) . genero

playlist :: Genero -> [Artista] -> [Cancion]
playlist = concatMap . cancionesDelGenero

cancionesDelGenero :: Genero -> Artista -> [Cancion]
cancionesDelGenero unGenero = filter (esDeGenero unGenero) . canciones

--Parte C

hacerseDJ :: Artista -> Artista
hacerseDJ unArtista = mapCanciones (map $ efectoPreferido unArtista)  unArtista

tieneGustoHomogeneo :: Artista -> Bool
tieneGustoHomogeneo = sonTodosIguales . map genero . canciones

sonTodosIguales :: Eq a => [a] -> Bool
sonTodosIguales unaLista = all (== head unaLista) unaLista



formarBanda :: String -> [Artista] -> Artista
formarBanda nombreBanda listaDeArtistas = Artista {
  nombre = nombreBanda,
  canciones = concatMap canciones listaDeArtistas,
  efectoPreferido = metaEfecto . map efectoPreferido $ listaDeArtistas
  }



obraMaestraProgresiva :: Artista -> Cancion
obraMaestraProgresiva unArtista = Cancion {
  titulo = concatMap titulo . canciones $ unArtista,
  duracion = sum . map duracion . canciones $ unArtista,
  genero = foldl1 generoSuperador . map genero . canciones $ unArtista
}

generoSuperador :: Genero -> Genero -> Genero
generoSuperador _ "rock" = "rock"
generoSuperador "rock" _ = "rock"
generoSuperador "reggaeton" unGenero = unGenero
generoSuperador unGenero "reggaeton" = unGenero
generoSuperador unGenero otroGenero = elMasLargo unGenero otroGenero

elMasLargo :: Genero -> Genero -> Genero
elMasLargo unGenero otroGenero
  |length unGenero > length otroGenero = unGenero
  |otherwise = otroGenero


{-
Parte D

1. Si puede hacerse dj

2. Si tiene al menos 3 canciones cortas si se puede

3. Si la puede crear

-}