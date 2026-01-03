# Godot Asteroids - AI Coding Agent Instructions

## Architecture Overview

Este es un juego Asteroids implementado en Godot 4.5+ usando GDScript. El juego sigue un patrón de **"auto-destrucción"** donde cada elemento es responsable de su propia eliminación según las mecánicas del juego.

### Estructura de Componentes

- **`scenes/game.tscn`** - Escena principal que conecta todos los handlers
- **Handler Pattern** - Cada tipo de entidad tiene su handler correspondiente:
  - `scripts/ship_handler.gd` - Gestiona nave del jugador y respawn
  - `scripts/projectile_handler.gd` - Gestiona disparos
  - `scripts/asteroid_handler.gd` - Gestiona asteroides
- **Entity Scripts** - Cada entidad maneja su comportamiento y auto-destrucción:
  - `scripts/ship.gd` - Controles tipo tanque con deslizamiento
  - `scripts/asteroid.gd` - Movimiento constante con rotación aleatoria
  - `scripts/projectile.gd` - Movimiento rectilíneo con tiempo de vida

## Convenciones Críticas del Proyecto

### Patrón de Auto-Destrucción
```gdscript
# Cada entidad emite signal collision() cuando debe morir
signal collision()

# Detecta colisiones y notifica a ambos objetos
func _on_area_2d_body_entered(body: Node2D) -> void:
    if (body is not Asteroid && body.collision != null && body != self):
        body.collision.emit()
        collision.emit()
```

### Sistema de Audio con Auto-Eliminación
Use `scenes/self_deleting_sound.tscn` para efectos de sonido que se eliminan automáticamente:
```gdscript
var death_sound = SELF_DELETING_SOUND.instantiate()
death_sound.stream = ASTEROID_EXPLODE
death_sound.position = position
parent.add_child(death_sound)
```

### Patrón de Movimiento Direccional
Todas las entidades móviles usan este patrón estándar:
```gdscript
func calc_direction():
    var vec = Vector2(0,-1).rotated(rotation)
    return vec
```

## Inputs y Debug

### Controles Definidos
- `left/right` - Rotación de nave (A/D, flechas)
- `forward` - Propulsión (W, flecha arriba)
- `shoot` - Disparar (Espacio)
- `debug_spawn_asteroid` - Debug para crear asteroides (T)

### Debugging
- Use el input `debug_spawn_asteroid` para testing rápido
- Camera sigue automáticamente a la nave con suavizado

## Integración Discord RPC

El proyecto incluye `addons/discord-rpc-gd/` para Rich Presence:
- **Autoload:** `DiscordRPCLoader` se ejecuta automáticamente
- **Activación:** Habilitar plugin en Project Settings > Plugins
- **Reinicio:** Requiere 2 reinicios del editor para funcionar completamente

## Flujo de Datos Clave

### Shooting Pipeline
1. `ship.gd` detecta input y emite `on_shoot(direction, position)`
2. `ship_handler.gd` re-emite como `ship_shooting(dir, pos)`
3. `game.gd` recibe y llama `projectile_handler.shoot_projectile()`
4. `projectile_handler.gd` instancia y posiciona el proyectil

### Death & Respawn Cycle
1. Entidad emite `collision()` signal al morir
2. `ship_handler.gd` captura death de nave
3. Reproduce sonido de muerte y inicia timer
4. Después del timer, instancia nueva nave con `new_ship()`

## Estructura de Archivos

- **`scripts/`** - Toda la lógica de juego en GDScript
- **`scenes/`** - Archivos .tscn para cada entidad y handler
- **`assets/`** - Sprites y sonidos separados por tipo
- **`testing/`** - Scripts de prueba para mecánicas específicas

## Notas de Implementación

### Escalado de Asteroides
Los asteroides usan un sistema de tamaño basado en `_size` (1-3):
```gdscript
func handle_size() -> void:
    var scale_factor = _size * (1.0 / 3.0)
    asteroid.scale = Vector2(scale_factor, scale_factor)
    # Aplicar mismo scale a collision shapes
```

### Camera Following
La cámara sigue la nave con interpolación, ajustando velocidad según estado:
```gdscript
# Suavizado normal: 10, Durante muerte: 2
camera.position_smoothing_speed = 2  # Al morir
camera.position_smoothing_speed = 10 # Al respawnear
```

### Performance Notes
- Use `queue_free()` para eliminación segura de nodos
- Los handlers instancian entidades con `instantiate()` desde scenes precargadas
- Sonidos se auto-eliminan usando `extends AudioStreamPlayer2D`
