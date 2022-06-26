{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
import Text.Show.Functions

-- Modelado

type Idioma = String

data Turista = Turista {
  cansancio :: Int,
  stress :: Int,
  viajaSolo :: Bool,
  idiomas :: [Idioma]
} deriving (Show, Eq)

-- Mappers

mapCansancio :: (Int -> Int) -> Turista -> Turista
mapCansancio unaFuncion unTurista = unTurista { cansancio = unaFuncion . cansancio $ unTurista}

bajarCansancio :: Int -> Turista -> Turista
bajarCansancio n = mapCansancio (subtract n)

subirCansancio :: Int -> Turista -> Turista
subirCansancio n = mapCansancio (+ n)

mapStress :: (Int -> Int) -> Turista -> Turista
mapStress unaFuncion unTurista = unTurista { stress = unaFuncion . stress $ unTurista}

bajarStress :: Int -> Turista -> Turista
bajarStress n = mapStress (subtract n)

subirStress :: Int -> Turista -> Turista
subirStress n = mapStress (+ n)

mapIdioma :: ([Idioma] -> [Idioma]) -> Turista -> Turista
mapIdioma unaFuncion unTurista = unTurista { idiomas = unaFuncion . idiomas $ unTurista}

aprendeIdioma :: Idioma -> Turista -> Turista
aprendeIdioma unIdioma = mapIdioma (++ [unIdioma])

mapViajaSolo :: (Bool -> Bool) -> Turista -> Turista
mapViajaSolo unaFuncion unTurista = unTurista { viajaSolo = unaFuncion . viajaSolo $ unTurista}

setViajasolo :: Bool -> Turista -> Turista
setViajasolo valor = mapViajaSolo (const valor)

-- Excursiones

type Excursion = Turista -> Turista

irALaPlaya :: Excursion
irALaPlaya unTurista
  |viajaSolo unTurista = bajarCansancio 5 unTurista
  |otherwise = bajarStress 1 unTurista

apreciar :: String -> Excursion
apreciar loQueSeAprecia = bajarStress (length loQueSeAprecia)

--                        (Turista -> Turista)
hablarIdioma :: Idioma -> Excursion
hablarIdioma unIdioma = setViajasolo False . aprendeIdioma unIdioma

caminar :: Int -> Excursion
caminar minutos = subirCansancio (intensidad minutos) . bajarStress (intensidad minutos)

intensidad :: Int -> Int
intensidad minutos = minutos `div` 4

type Marea = String

paseoEnBarco :: Marea -> Excursion
paseoEnBarco "fuerte"     = subirStress 6 . subirCansancio 10
paseoEnBarco "moderada"   = id
paseoEnBarco "tranquila"  = hablarIdioma "aleman" . apreciar "mar" . caminar 10

-- Punto 1

ana :: Turista
ana = Turista {
  cansancio = 0,
  stress = 25,
  viajaSolo = False,
  idiomas= ["espaniol"]
  }

beto :: Turista
beto = Turista {
  cansancio = 15,
  stress = 15,
  viajaSolo = True,
  idiomas= ["aleman"]
  }

cathi :: Turista
cathi = Turista {
  cansancio = 15,
  stress = 15,
  viajaSolo = True,
  idiomas= ["aleman", "catalan"]
  }

-- Punto 2

-- Punto A

--                          (Turista -> Turista)
hacerExcursion :: Turista -> Excursion -> Turista
hacerExcursion unTurista unaExcursion = bajarStress (diezPorcientoDeStress unTurista) . unaExcursion $ unTurista

diezPorcientoDeStress :: Turista -> Int
diezPorcientoDeStress = (`div` 10) . stress

-- Punto B

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = (Turista -> Int)

deltaExcursionSegun :: Indice -> Turista -> Excursion -> Int
deltaExcursionSegun unaFuncion unTurista unaExcursion = unaFuncion unTurista - unaFuncion (hacerExcursion unTurista unaExcursion)

-- Punto C

-- Punto i

esEducativa :: Turista -> Excursion -> Bool
esEducativa unTurista unaExcursion = length (idiomas unTurista) < length (idiomas (unaExcursion unTurista))

-- Punto ii

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes unTurista = filter (reduceTresOMasDeStress unTurista)

reduceTresOMasDeStress :: Turista -> Excursion -> Bool
reduceTresOMasDeStress unTurista unaExcursion = stress unTurista - stress (hacerExcursion unTurista unaExcursion) <= (-3)

-- Tours

type Tour = [Excursion]

completo :: Tour
completo = [caminar 20, apreciar "cascada", caminar 40, irALaPlaya, hablarIdioma "melmacquiano"]

ladoB :: Excursion -> Tour
ladoB unaExcursion = [paseoEnBarco "tranquilo", unaExcursion, caminar 120]

islaVecina :: Marea -> [Excursion]
islaVecina "fuerte" = [paseoEnBarco "fuerte", apreciar "lago", paseoEnBarco "fuerte"]
islaVecina unaMarea = [paseoEnBarco unaMarea, irALaPlaya, paseoEnBarco unaMarea]

-- Punto A

hacerTour :: Tour -> Turista -> Turista
hacerTour unTour = hacerExcursiones unTour . subirStress (length unTour)

hacerExcursiones :: Tour -> Turista -> Turista
hacerExcursiones unTour unTurista = foldl hacerExcursion unTurista unTour

-- Punto B

tourConvincente :: Turista -> [Tour] -> Bool
tourConvincente unTurista = any (esConvincente unTurista)

esConvincente :: Turista -> Tour -> Bool
esConvincente unTurista = any (loDejaAcompaniado unTurista) . excursionesDesestresantes unTurista

loDejaAcompaniado :: Turista -> Excursion -> Bool
loDejaAcompaniado unTurista = viajaSolo . hacerExcursion unTurista

-- Punto C

--          [Excursion]

efectividad :: Tour -> [Turista] -> Int
efectividad unTour = sum . map (espiritualidad unTour) . filter (`esConvincente` unTour)

espiritualidad :: Tour -> Turista -> Int
espiritualidad unTour unTurista = deltaTourSegun stress unTurista unTour + deltaTourSegun cansancio unTurista unTour


deltaTourSegun :: Indice -> Turista -> Tour -> Int
deltaTourSegun unaFuncion unTurista unTour = unaFuncion unTurista - unaFuncion (hacerTour unTour unTurista)


-- Ultimo Punto
-- a)
tourInfinitasPlayas :: Tour
tourInfinitasPlayas = repeat irALaPlaya

{-
b) 
  Con ana si va a ser convincente ya que ella viaja acompañada e ir a la playa es desestresante

  Para beto que no esta acompañado ir a la playa le bajara el cansancio pero no el stress

c) Solo se puede conocer si le pasamos la lista vacia de turistas, y da 0

-}