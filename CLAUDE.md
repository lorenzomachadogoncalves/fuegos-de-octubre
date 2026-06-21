# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

Jogo point-click 2D em Godot 4.6 para alunos do 5º ano da BNCC de computação (EF15CO03). Um personagem em um mundo preto e branco resolve enigmas de lógica computacional para colorir o mundo. Cada cenário tem portas (R, G, B) que levam a desafios lógicos — ao completar o desafio, o jogador recebe um bloco de cor. Esse bloco deve ser inserido no **totem** do cenário para avançar.

Os arquivos do jogo ficam em: `snap/godot-4/common/fuegos-de-octubre/`

## Como rodar

Abra o projeto no Godot 4.6 apontando para `snap/godot-4/common/fuegos-de-octubre/project.godot`. Para rodar, use **F5** (rodar projeto) ou **F6** (rodar cena atual) no editor. Não há CLI de build/test separada — o desenvolvimento ocorre dentro do editor Godot.

## Arquitetura

### Estrutura de pastas (dentro de `snap/godot-4/common/fuegos-de-octubre/`)

```
cenas_principais/      # Salas/níveis do jogo (main.tscn, blue_room.tscn, green_room.tscn)
cenas_reutilizaveis/   # Prefabs reutilizáveis (Door.tscn, FadeLayer.tscn)
scripts/               # Toda a lógica GDScript
  Global.gd            # Autoload singleton
  player.gd            # Controlador do jogador
  canvas_layer.gd      # Gerenciador de fade/transição de cena
  doorCenter/
    area_2d.gd         # Lógica de clique nas portas
assets/                # Sprites (characters/, backgrounds/, objects/)
dialog.gd              # Sistema de diálogo (CanvasLayer no player)
```

### Sistema de portas (padrão reutilizável central)

`Door.tscn` é o componente base instanciado em todas as salas. Cada instância expõe:
- `next_scene: String` — caminho da cena de destino
- `target_door_name: String` — nome do nó `Door` na cena de destino onde o jogador vai aparecer

Fluxo ao clicar em uma porta:
1. `area_2d.gd._input_event()` detecta o clique e chama `player.move_to_door(self, x)`
2. O jogador caminha até a porta e chama `vai_para_a_cena_da_porta()`
3. `Global.target_door_name` é gravado com o nome da porta de destino
4. `FadeLayer` executa fade e troca de cena
5. Na nova cena, `player._ready()` lê `Global.target_door_name` para posicionar o jogador

Para adicionar uma nova sala: instancie `Door.tscn`, configure `next_scene` e `target_door_name`, adicione `FadeLayer.tscn`, e instancie o player com o script `player.gd`.

### Estado global (`Global.gd`)

Autoload único (`Global="*res://scripts/Global.gd"`). Atualmente persiste:
- `target_door_name: String` — porta de destino para posicionamento do player ao trocar de cena

Adicione aqui qualquer estado que precise atravessar trocas de cena (ex: blocos coletados, cor do mundo em cada sala).

### Player

`CharacterBody2D` com script `player.gd`. Pertence ao grupo `"player"` — use `get_tree().get_first_node_in_group("player")` para referenciá-lo a partir de outros scripts (como fazem as portas). Movimento é ponto-a-clique: o jogador anda até o X clicado no chão.

### Fade/Transição

`FadeLayer.tscn` (instanciado em cada sala) delega para `canvas_layer.gd`, que anima um `ColorRect` preto via `AnimationPlayer` (animação `fade_in`, 1 segundo) e então chama `get_tree().change_scene_to_file()`.

## Regras de código

- Seguir orientação a objetos com reutilização via cenas prefab (como `Door.tscn`) — evitar duplicar lógica entre salas.
- Novos tipos de desafio/puzzle devem ser cenas independentes que podem ser abertas por qualquer porta, recebendo a cor via `Global`.
- Novos estados de jogo (blocos coletados, progresso de cor) devem morar em `Global.gd`.
- Textos e diálogos em português (pt-BR).
