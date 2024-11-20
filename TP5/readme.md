## Análisis inicial:
1. Llave primaria candidata: La combinación de los campos {dniCliente, codHotel, fechaInicioHospedaje, #Habitacion} parece ser la clave compuesta, ya que:

+ Un cliente puede alojarse en varias habitaciones del mismo hotel.
+ Una habitación puede estar reservada por el cliente en una fecha específica.

2. Problemas encontrados:

+ Hay dependencias funcionales que generan redundancia, como:
codHotel → cantidadHabitaciones, direccionHotel, ciudadHotel, dniGerente, nombreGerente
dniGerente → nombreGerente
dniCliente → nombreCliente, ciudadCliente
+ Existen campos que dependen parcialmente de la clave compuesta.


## 1NF (Primera Forma Normal):
El esquema ya está en 1NF porque todos los valores son atómicos y no hay grupos repetidos.

## 2NF (Segunda Forma Normal):
Se eliminaron las dependencias funcionales parciales, es decir, aquellos atributos que dependen solo de una parte de la clave compuesta.

Divisiones necesarias:

Tabla: CLIENTE
Se agrupo información dependiente exclusivamente de dniCliente.
```
CLIENTE(dniCliente, nombreCliente, ciudadCliente)
```

Tabla: HOTEL
Se agrupo la info exclusivaemnte de codHotel.
```
HOTEL(codHotel, direccionHotel, ciudadHotel, cantidadHabitaciones, dniGerente)
```

Tabla: GERENTE
Aquí solo información relacionada con el gerente que depende exclusivamente de dniGerente.
```
GERENTE(dniGerente, nombreGerente)
```

Tabla: ESTADIA
Quedan las dependencias directas de la clave completa.
```
ESTADIA(dniCliente, codHotel, fechaInicioHospedaje, #Habitacion, cantDiasHospedaje)
```

## 3NF (Tercera Forma Normal):
Se eliminaron dependencias transitivas, es decir, cuando un atributo no clave depende de otro atributo no clave.

Análisis:
codHotel → dniGerente → nombreGerente: ya está resuelto al separar la tabla GERENTE.
No quedan más dependencias transitivas.
El esquema ya cumple con 3NF.

Esquema Normalizado Final:

CLIENTE
```
CLIENTE(dniCliente, nombreCliente, ciudadCliente)
```

HOTEL
```
HOTEL(codHotel, direccionHotel, ciudadHotel, cantidadHabitaciones, dniGerente)
```

GERENTE
```
GERENTE(dniGerente, nombreGerente)
```

ESTADIA
```
ESTADIA(dniCliente, codHotel, fechaInicioHospedaje, #Habitacion, cantDiasHospedaje)
```

## CLaves Primarias

#### Justificación:
- Cada clave primaria garantiza la unicidad en la tabla correspondiente.
- Se derivan directamente de las dependencias funcionales establecidas tras la normalización.
- Se alinean con las restricciones del modelo.

|Tabla  |Clave Primaria|
|-------|-------------|
|CLIENTE|dniCliente |
|HOTEL	|codHotel    |
|GERENTE|	dniGerente |
|ESTADIA|	{dniCliente, codHotel, fechaInicioHospedaje, #Habitacion} |
