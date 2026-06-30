# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

Jogo point-click 2D em Godot 4.6 para alunos do 5º ano da BNCC de computação (EF15CO03). Um personagem em um mundo preto e branco resolve enigmas de lógica computacional para colorir o mundo.

### Mecânica atual

Cada cenário principal tem **portas coloridas** (vermelha, verde, azul) que levam a cavernas. Dentro de cada caverna existe um **totem** com o desafio lógico embutido:

- Ao entrar na caverna, o jogador pode receber uma **mensagem de dica** explicando como resolver o desafio presente naquele totem.
- O totem exibe um enigma de lógica computacional (múltipla escolha, carregado de `enigmas.json`).
- Ao acertar o enigma, o jogador recebe uma **flor** da cor da caverna (vermelha, verde ou azul) — ela **não fica no inventário**, é registrada em `Global` e aparece diretamente no **totem final** da cena principal.
- O totem final só é completado quando todas as flores necessárias forem coletadas.

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

### Sistema de enigmas e flores

- Os enigmas ficam em `enigmas.json` (frases de lógica proposicional + resposta correta).
- `riddle_box.tscn` / `riddle_box.gd` é o componente do totem de desafio: carrega um enigma aleatório, exibe 4 botões de resposta e, ao acertar, chama `mostrar_recompensa()`.
- `mostrar_recompensa()` seta o flag da flor em `Global` (ex: `Global.flor_azul = true`) e exibe o sprite da flor no `CanvasLayer/Control` do próprio `riddle_box`.
- As flores **não ficam em inventário** — o estado persiste via `Global` e o totem final lê esses flags para exibir as flores recebidas.
- `area_enigma.gd` é o `Area2D` que detecta o clique no totem e chama `riddle_box.abrir()` com a cor correspondente.

### Estado global (`Global.gd`)

Autoload único (`Global="*res://scripts/Global.gd"`). Persiste:
- `target_door_name: String` — porta de destino para posicionamento do player ao trocar de cena
- `flor_azul: bool`, `flor_verde: bool`, `flor_vermelha: bool` — flags das flores coletadas em cada caverna
- `color_channels: Dictionary` — canais R/G/B para colorização do mundo

Adicione aqui qualquer estado que precise atravessar trocas de cena.

### Player

`CharacterBody2D` com script `player.gd`. Pertence ao grupo `"player"` — use `get_tree().get_first_node_in_group("player")` para referenciá-lo a partir de outros scripts (como fazem as portas). Movimento é ponto-a-clique: o jogador anda até o X clicado no chão.

### Fade/Transição

`FadeLayer.tscn` (instanciado em cada sala) delega para `canvas_layer.gd`, que anima um `ColorRect` preto via `AnimationPlayer` (animação `fade_in`, 1 segundo) e então chama `get_tree().change_scene_to_file()`.

## Regras de código

- Seguir orientação a objetos com reutilização via cenas prefab (como `Door.tscn`, `riddle_box.tscn`) — evitar duplicar lógica entre salas.
- O `riddle_box.tscn` é o componente reutilizável de desafio; cada caverna instancia um e configura a cor da recompensa.
- Mensagens de dica ao entrar na caverna devem usar o sistema de diálogo (`dialog.gd`) antes de liberar interação com o totem.
- Flores não têm representação em inventário — o estado vai para `Global` e o totem final lê de lá.
- Novos estados de jogo devem morar em `Global.gd`.
- Textos e diálogos em português (pt-BR).
