import Text.Show.Functions

-- Punto 1

type Item = String

data Persona = Persona {
  edad :: Int,
  items :: [Item],
  experiencia :: Int
}

type Debilildad = Persona -> Bool

data Criatura = Criatura {
  peligrosidad :: Int,
  debilidad :: Debilidad
}

-- Mappers

mapExperiencia :: (Int -> Int) -> Persona -> Persona
mapExperiencia unaFuncion unaPersona = unaPersona {
  experiencia = unaFuncion . experiencia $ unaPersona
}

-- Criaturas

siempreDetras :: Criatura
siempreDetras = Criatura {
  peligrosidad = 0,
  paraDeshacerse = []
}

gnomos :: Int -> Criatura
gnomos cantidad = Criatura {
  peligrosidad = 2 ^ cantidad,
  paraDeshacerse = elem "sopladorDeHojas"
}

fantasmas :: Int -> [Accion] -> Criatura
fantasmas poder unasAcciones = Criatura {
  peligrosidad = poder * 20,
  paraDeshacerse = unasAcciones
}

-- Punto 2

enfrentarseOHuir :: Criatura -> Persona -> Persona
enfrentarseOHuir unaCriatura unaPersona
  |puedeDeshacerse unaCriatura unaPersona = aumentarExperiencia (peligrosidad unaCriatura) unaPersona
  |otherwise = aumentarExperiencia 1 unaPersona

aumentarExperiencia :: Int -> Persona -> Persona
aumentarExperiencia valor = mapExperiencia (+ valor)

puedeDeshacerse :: Criatura -> Persona -> Bool
puedeDeshacerse unaCriatura unaPersona = 