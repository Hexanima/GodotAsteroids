# GODOT ASTEROIDS

Una recreación del juego Asteroids usando Godot

# Mecánicas

Usado para anotar mecanicas u observaciones a recrear, como una CRC Card del libro C# Players Guide

Es mas facil programar autodestruccion que programar destruccion ajena, asi que cada elemento es responsable de su eliminacion segun corresponda

## Asteroide

### Tamaño

- Cuenta con diferentes tamaños
    - Pequeño
    - Mediano
    - Grande

### Movimiento

- Tiene velocidad constante
- Dirección aleatoria
- La velocidad es mayor mientras mas chico sea

### Colisión

- Asteroides pueden colisionar con naves y proyectiles
- Cuando un asteroide colisiona con algo:
    - Si el asteroide es de tamaño mas grande a pequeño, genera dos asteroides de un tamaño menos
    - Se destruye el asteroide

## Nave

### Movimiento

- Controles de tanque, con lo que su movimiento consta de:
    - Girar hacia los lados
    - Moverse hacia donde apunta
- Tiene un efecto deslizamiento, cuando deja de acelerar hacia adelante, patina como hielo, teniendo aun una velocidad pero que disminuye lentamente

### Ataque

- Puede disparar un proyectil común hacia donde apunta

### Colisión

- Cuando colisiona con algo, se destruye la nave

## Nave enemiga

### Tamaños

- Puede tener dos tamaños
    - Pequeña
    - Grande

### Movimiento

- Se mueve de manera aleatoria, yendo en una direccion por unos segundos hasta cambiar de sentido despues, el patron se repite constantemente
- Menor sea el tamaño, mas rapido se mueve

### Ataque

- Dispara proyectiles de manera aleatoria

### Colisión

- Cuando colisiona con un objeto que NO sea una nave de jugador, se destruye la nave enemiga

## Proyectil

### Movimiento

- Se mueve de manera rectilinea
- Su velocidad es la velocidad de la nave que la genera + velocidad propia

### Tiempo de vida

- Si no colisiona con nada, se elimina despues de un tiempo

### Colision

- Cuando colisiona con algo, se destruye el proyectil
