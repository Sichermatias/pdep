import Text.Show.Functions

type Carrera = [Auto]

type Color = String

data Auto = Auto {
  color :: Color,
  velocidad :: Int,
  distancia :: Int
} deriving (Show, Eq)

--Mappers

mapDistancia :: (Int -> Int) -> Auto -> Auto
mapDistancia unaFuncion unAuto = unAuto { distancia = unaFuncion . distancia $ unAuto}

-- Punto 1

estaCerca :: Auto -> Auto -> Bool
estaCerca unAuto otroAuto = abs (distancia unAuto - distancia otroAuto) < 10

vaTranquilo :: Carrera -> Auto -> Bool
vaTranquilo unaCarrera unAuto = nadieCerca unAuto unaCarrera && vaGanando unAuto unaCarrera

nadieCerca :: Auto -> Carrera -> Bool
nadieCerca unAuto = not . any (estaCerca unAuto)

vaGanando :: Auto -> Carrera -> Bool
vaGanando unAuto = not . any (> distancia unAuto) . map distancia

puesto :: Auto -> Carrera -> Int
puesto unAuto = (+ 1) . leVanGanando unAuto

leVanGanando :: Auto -> Carrera -> Int
leVanGanando unAuto = length . filter (leGana unAuto)

leGana :: Auto -> Auto -> Bool
leGana unAuto otroAuto = distancia unAuto < distancia otroAuto

-- Punto 2

type Tiempo = Int

queCorra :: Tiempo -> Auto -> Auto
queCorra unTiempo = mapDistancia ()