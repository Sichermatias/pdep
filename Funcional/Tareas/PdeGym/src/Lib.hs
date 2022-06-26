import Text.Show.Functions


type Ejercicio = Repeticiones -> Persona -> Persona

type EjercicioConPeso = Int -> Ejercicio

type Accion = Persona -> Persona

type Equipamiento = String

type Repeticiones = Int

data Persona = Persona {
  nombre :: String,
  calorias :: Int,
  hidratacion :: Int,
  tiempoDisponible :: Int, -- -> En minutos
  equipamientos :: [Equipamiento]
} deriving (Show, Eq)

--Mappers

mapNombre :: (String -> String) -> Persona -> Persona
mapNombre unaFuncion unaPersona = unaPersona {
  nombre = unaFuncion . nombre $ unaPersona
}

mapCalorias :: (Int -> Int) -> Persona -> Persona
mapCalorias unaFuncion unaPersona = unaPersona {
  calorias = unaFuncion . calorias $ unaPersona
}

perderCalorias :: Int -> Persona -> Persona
perderCalorias = mapCalorias . subtract

mapHidratacion :: (Int -> Int) -> Persona -> Persona
mapHidratacion unaFuncion unaPersona = unaPersona {
  hidratacion = max 0 . min 100 . unaFuncion . hidratacion $ unaPersona
}

perderHidratacion :: Int -> Persona -> Persona
perderHidratacion = mapHidratacion . subtract

mapEquipamientos :: ([Equipamiento] -> [Equipamiento]) -> Persona -> Persona
mapEquipamientos unaFuncion unaPersona = unaPersona {
  equipamientos = unaFuncion . equipamientos $ unaPersona
}

setEquipamientos :: [Equipamiento] -> Persona -> Persona
setEquipamientos = mapEquipamientos . const

-- Parte A

--Ejercicios

abdominales :: Ejercicio
abdominales repeticiones = perderCalorias (8 * repeticiones)

flexiones :: Ejercicio
flexiones repeticiones = perderCalorias (16 * repeticiones) . perderHidratacion (repeticiones `div` 10 * 2)

levantarPesas :: EjercicioConPeso
levantarPesas peso repeticiones unaPersona
  | tieneEquipamiento "pesa" unaPersona = perderCalorias (32 * repeticiones) . perderHidratacion (repeticiones `div` 10 * peso) $ unaPersona
  | otherwise = unaPersona

tieneEquipamiento :: Equipamiento -> Persona -> Bool
tieneEquipamiento equipamiento unaPersona = equipamiento `elem` equipamientos unaPersona

laGranHomeroSimpson :: Persona -> Persona
laGranHomeroSimpson = id



-- Acciones

renovarEquipo :: Accion
renovarEquipo = mapEquipamientos (map ("Nuevo " ++))

volverseYoguista :: Accion
volverseYoguista = mapCalorias (`div` 2) . mapHidratacion (min 100 . (*2)) . setEquipamientos ["colchoneta"]

volverseBodyBuilder :: Accion
volverseBodyBuilder unaPersona
  |soloTienePesas unaPersona = mapNombre (++ " BB") . mapCalorias (* 3) $ unaPersona
  |otherwise = unaPersona

soloTienePesas :: Persona -> Bool
soloTienePesas unaPersona = all (== "pesa") (equipamientos unaPersona)

comerUnSandwich :: Accion
comerUnSandwich = mapCalorias (+ 500) . mapHidratacion (+ 100)


-- Parte B

data Rutina = Rutina {
  duracion :: Int,
  ejercicios :: [Ejercicio]
} deriving (Show, Eq)

esPeligrosa :: Rutina -> Persona -> Bool
esPeligrosa unaRutina unaPersona = caloriasMenoresA 50 . hacerEjercicios (ejercicios unaRutina) $ unaPersona && hidratacionMenorA 10 . hacerEjercicios (ejercicios unaRutina) $ unaPersona

caloriasMenoresA :: Int -> Persona -> Bool
caloriasMenoresA numero unaPersona = (< numero) . calorias $ unaPersona

hidratacionMenorA :: Int -> Persona -> Bool
hidratacionMenorA numero unaPersona = (< numero) . hidratacion $ unaPersona

hacerEjercicios :: [Ejercicio] -> Persona -> Persona
hacerEjercicios unosEjercicios unaPersona = foldr ($) hacerEjercicio unaPersona unosEjercicios

esBalanceada :: Rutina -> Persona -> Bool
esBalanceada unaRutina unaPersona = 

elAbominableAbdominal = Rutina {
duracion = 60,
ejercicios = [abdominales 1, abdominales 2..]
}
