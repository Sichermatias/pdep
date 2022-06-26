{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Text.Show.Functions

--Primera Parte

-- Punto 1

type Habilidad = String

type Planeta = String

data Personaje = Personaje {
  edad        :: Int,
  energia     :: Int,
  habilidades :: [Habilidad],
  nombre      :: String,
  planeta     :: Planeta
} deriving (Show)

type Gema = Personaje -> Personaje

data Guantelete = Guantelete {
  material :: String,
  gemas    :: [Gema]
} deriving (Show)

type Universo = [Personaje]

-- Mappers

mapEdad :: (Int -> Int) -> Personaje -> Personaje
mapEdad unaFuncion unPersonaje = unPersonaje {edad = unaFuncion . edad $ unPersonaje}

mapEnergia :: (Int -> Int) -> Personaje -> Personaje
mapEnergia unaFuncion unPersonaje = unPersonaje {energia = unaFuncion . energia $ unPersonaje}

mapHabilidades :: ([Habilidad] -> [Habilidad]) -> Personaje -> Personaje
mapHabilidades unaFuncion unPersonaje = unPersonaje {habilidades = unaFuncion . habilidades $ unPersonaje}

mapPlaneta :: (Planeta -> Planeta) -> Personaje -> Personaje
mapPlaneta unaFuncion unPersonaje = unPersonaje {planeta = unaFuncion . planeta $ unPersonaje}

-- Chasquido

chasquido :: Guantelete -> Universo -> Universo
chasquido unGuantelete unUniverso
  |puedeChasquear unGuantelete = reducirALaMitad unUniverso
  |otherwise                   = unUniverso

puedeChasquear :: Guantelete -> Bool
puedeChasquear unGuantelete = material unGuantelete == "uru" && length (gemas unGuantelete) == 6

reducirALaMitad :: Universo -> Universo
reducirALaMitad unUniverso = take (length unUniverso `div` 2) unUniverso

-- Punto 2

aptoParaPendex :: Universo -> Bool
aptoParaPendex = any esMenorDe45

esMenorDe45 :: Personaje -> Bool
esMenorDe45 = (< 45) . edad

enegiaTotalUniverso :: Universo -> Int
enegiaTotalUniverso = sum . map energia . filter tieneMasDeUnaHabilidad

tieneMasDeUnaHabilidad :: Personaje -> Bool
tieneMasDeUnaHabilidad = (> 1) . length . habilidades

-- Segunda Parte

-- Punto 3

mente :: Int -> Gema
mente = debilitar

debilitar :: Int -> Personaje -> Personaje
debilitar valor = mapEnergia (subtract valor)

alma :: Habilidad -> Gema
alma unaHabilidad = debilitar 10 . eliminarHabilidad unaHabilidad

eliminarHabilidad :: Habilidad -> Personaje -> Personaje
eliminarHabilidad unaHabilidad = mapHabilidades (filter (/= unaHabilidad))

espacio :: Planeta -> Gema
espacio unPlaneta = debilitar 20 . transportar unPlaneta

transportar :: Planeta -> Gema
transportar unPlaneta = mapPlaneta (const unPlaneta)

poder :: Gema
poder = quitarHabilidades . dejarSinEnergia

dejarSinEnergia :: Personaje -> Personaje
dejarSinEnergia = mapEnergia (const 0)

quitarHabilidades :: Personaje -> Personaje
quitarHabilidades unPersonaje
  |tieneMenosDeTresHabilidades unPersonaje = mapHabilidades (const []) unPersonaje
  |otherwise                                = unPersonaje

tieneMenosDeTresHabilidades :: Personaje -> Bool
tieneMenosDeTresHabilidades = (< 3) . length . habilidades

tiempo :: Gema
tiempo unPersonaje
  |edad unPersonaje < 18 = mapEdad (`div` 2) unPersonaje
  |otherwise             = unPersonaje

gemaLoca :: Gema -> Gema
gemaLoca unaGema = unaGema . unaGema

-- Punto 4

miGuantelete :: Guantelete
miGuantelete = Guantelete {
  material = "goma",
  gemas = [tiempo, alma "usar Mjolnir", gemaLoca (alma "programación en Haskell")]
}

-- Punto 5

utilizar :: [Gema] -> Personaje -> Personaje
utilizar unasGemas unPersonaje = foldr ($) unPersonaje unasGemas

-- Punto 6

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa unGuantelete = leSacaMasEnergia (gemas unGuantelete)

leSacaMasEnergia :: [Gema] -> Personaje -> Gema
leSacaMasEnergia [gema] _ = gema
leSacaMasEnergia (unaGema : otraGema : gemas) unPersonaje 
  |(energia . unaGema) unPersonaje < (energia . otraGema) unPersonaje = leSacaMasEnergia (unaGema : gemas) unPersonaje
  |otherwise = leSacaMasEnergia (otraGema : gemas) unPersonaje

-- Punto 7

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

punisher:: Personaje 
punisher = Personaje {
  nombre = "The Punisher",
  habilidades = ["Disparar con de todo","golpear"],
  planeta = "Tierra",
  edad = 38,
  energia = 350
}

{-

a) gemaMasPoderosa punisher guanteleteDeLocos
  Esto nunca va a terminar de ejecutarse ya que al tener una lista infinita de gemas no va a terminar nunca dee compararlas entre ellas.

b) usoLasTresPrimerasGemas guanteleteDeLocos punisher
  Esto si ejecutara ya que al tener lazy evaluation tomara las tres primeras gemas y no importaran lasinfinitas gemas demas y nos dara como resultado al personaje luego de usar estas tres gemas sobre el.

-}