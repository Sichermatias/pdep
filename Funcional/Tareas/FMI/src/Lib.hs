import Text.Show.Functions

-- Punto 1

-- Punto A

type Recurso = String

data Pais = Pais {
  ingresoPerCapita :: Int,
  puestosPublicos :: Int,
  puestosPrivado :: Int,
  recursosNaturares :: [Recurso],
  deuda :: Int
} deriving (Show, Eq)

-- Mappers

mapDeuda :: (Int -> Int) -> Pais -> Pais
mapDeuda unaFuncion unPais = unPais {
  deuda = unaFuncion . deuda $ unPais
}

mapPuestosPublicos :: (Int -> Int) -> Pais -> Pais
mapPuestosPublicos unaFuncion unPais = unPais {
  puestosPublicos = unaFuncion . puestosPublicos $ unPais
}

setDeuda :: Int -> Pais -> Pais
setDeuda valor = mapDeuda (const valor)

-- Punto B

namibia :: Pais
namibia = Pais {
  ingresoPerCapita =4140,
  puestosPublicos = 400000,
  puestosPrivado = 650000,
  recursosNaturares = ["mineria", "ecoturismo"],
  deuda = 50000000
}

-- Punto 2

type Estrategia = Pais -> Pais

prestarle :: Int -> Estrategia
prestarle valor = setDeuda (valor * 150 `div` 100)

reducirXPuestosPublicos :: Int -> Estrategia
reducirXPuestosPublicos valor unPais
  |valor > 100 =  . reduccionPuestosPublicos
  |otherwise

reduccionPuestosPublicos :: Int -> Pais -> Pais
reduccionPuestosPublicos valor = mapPuestosPublicos (subtract valor)