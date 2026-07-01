# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

Jogo point-click 2D em Godot 4.6 para alunos do 5º ano da BNCC de computação (EF15CO03). Um personagem em um mundo preto e branco resolve enigmas de lógica computacional para colorir o mundo.

### Mecânica atual

Cada cenário principal tem **portas** (vermelha, verde, azul) com efeito visual de portal animado via shader que levam a cavernas. Dentro de cada caverna existe um **totem** (cena `Area2D` com `area_enigma.gd`):

- Ao entrar na caverna pela **primeira vez**, exibe um diálogo introdutório narrativo (tom sombrio) explicando o mundo e o sistema de erros.
- Ao clicar no totem pela **primeira vez**, exibe um diálogo explicando o operador lógico daquela caverna (¬, ∧ ou ∨).
- O totem abre o `riddle_box`, que exibe enigmas de lógica proposicional (múltipla escolha, 3 acertos necessários).
- Ao concluir, uma **flor animada** voa do centro da tela até o jogador, o totem faz fade-out, e um diálogo de conclusão aparece.
- A flor é registrada em `Global` e aparece no **totem principal** da cena principal para colorir o mundo.
- Cada erro escurece o mundo progressivamente (overlay preto em `Global`). Com 3 erros ocorre game over: mundo reseta ao cinza, flores e `color_channels` são zerados.

Os arquivos do jogo ficam na raiz do repositório (projeto Godot aponta para `project.godot` na raiz).

## Como rodar

Abra o projeto no Godot 4.6 apontando para `project.godot` na raiz do repositório. Para rodar, use **F5** (rodar projeto) ou **F6** (rodar cena atual). Não há CLI de build/test separada.

## Arquitetura

### Estrutura de pastas

```
cenas_principais/         # Salas/níveis do jogo
  main.tscn               # Cena principal com totem final e 3 portas
  caverna-azul.tscn       # Caverna do operador ¬ (negação)
  caverna-verde.tscn      # Caverna do operador ∨ (disjunção)
  caverna-vermelha.tscn   # Caverna do operador ∧ (conjunção)

cenas_reutilizaveis/      # Prefabs reutilizáveis
  Door.tscn               # Porta com shader de portal animado
  FadeLayer.tscn          # Fade/transição de cena
  DialogBox.tscn          # Caixa de diálogo reutilizável
  ColorFilter.tscn        # Filtro de cor para colorizar o mundo
  Cloud.tscn              # Nuvem decorativa
  FlorAnimada.tscn        # Flor que voa até o jogador ao completar desafio

scripts/
  Global.gd               # Autoload singleton — todo estado entre cenas
  player.gd               # Controlador do jogador (point-click)
  caverna.gd              # Script da cena caverna: diálogo intro + chave
  area_enigma.gd          # Area2D do totem: detecta clique, diálogo do operador, abre riddle box
  totem_principal.gd      # Lógica do totem final: exibe flores, coloriza mundo
  door.gd                 # Script da porta: cor do portal, next_scene, target_door_name
  door_portal.gdshader    # Shader do efeito de portal (ondulação + transparência)
  flor_animada.gd         # Animação da flor voando até o jogador + fade-out do totem
  dialog_box.gd           # Engine do sistema de diálogo (mostrar, avançar, sinal terminou)
  color_filter.gd         # Aplica color_channels do Global no shader do mundo
  canvas_layer.gd         # Fade/transição de cena
  cloud.gd                # Movimento das nuvens
  FadeLayer.gd            # Script do FadeLayer
  doorCenter/
    area_2d.gd            # Detecta clique na porta, chama player.move_to_door(get_parent(), x)

riddle_box.tscn           # UI do desafio lógico (painel de perguntas)
riddle_box.gd             # Lógica do desafio: carrega enigmas, valida respostas, anima recompensa
enigmas-azul.json         # Enigmas de negação (¬P)
enigmas-verde.json        # Enigmas de disjunção (P ∨ Q)
enigmas-vermelha.json     # Enigmas de conjunção (P ∧ Q)
assets/                   # Sprites (characters/, backgrounds/, objects/, sounds/)
```

### Sistema de portas

`Door.tscn` tem `door.gd` na raiz. Exports:
- `cor_portal: Color` — cor do shader do portal (setada por instância para cada caverna)
- `opacidade: float` — transparência do portal
- `next_scene: String` — cena de destino
- `target_door_name: String` — nome do nó `Door` de chegada na cena de destino

`door.gd._ready()` duplica o `ShaderMaterial` (para cada instância ter cor independente) e aplica os parâmetros ao shader e às partículas.

`area_2d.gd` detecta clique → `player.move_to_door(get_parent(), x)` (passa o nó raiz `Door`, não o `Area2D`).

### Sistema de diálogos

`DialogBox.tscn` + `dialog_box.gd`: recebe `Array` de strings em `mostrar(falas)`, exibe linha a linha com botão "Próximo", emite sinal `terminou` ao final. Bloqueia `player.can_move` enquanto ativo.

Há três camadas de diálogo:
1. **Intro da caverna** (`caverna.gd`): aparece uma única vez (chave `"intro_caverna"` em `Global.dialogos_vistos`) na primeira caverna visitada. Texto narrativo sombrio embutido no script.
2. **Diálogo do operador** (`area_enigma.gd`): aparece ao clicar no totem pela primeira vez (chave `"caverna_azul/verde/vermelha"`). Explica o operador lógico. Ao terminar, abre o `riddle_box`.
3. **Diálogo de conclusão** (`riddle_box.gd`): aparece após a animação da flor. Tom sombrio de parabéns + instrução de voltar ao totem principal.

Todos os diálogos verificam `Global.dialogos_vistos[chave]` antes de exibir — nunca repetem na mesma sessão.

### Sistema de enigmas e flores

- `area_enigma.gd` seta `riddle_box.recompensa`, `riddle_box.totem` e chama `riddle_box.abrir()`.
- `riddle_box.gd` exige 3 acertos. Acerto toca `hit.wav`, erro toca `error.mp3` e chama `Global.registrar_erro()`.
- Ao completar: painel some → `FlorAnimada` instanciada voa do centro da tela até o jogador → totem faz fade-out (2s) → diálogo de conclusão → CanvasLayer fecha → player liberado → `Global.tem_flor_para_entregar = true`.
- Flores registradas em `Global.flor_azul/verde/vermelha`.

### Entrega de flores no totem principal

Ao retornar à cena principal com `tem_flor_para_entregar = true`, o jogador não pode mais entrar em outras cavernas (`area_2d.gd` bloqueia cliques em portas cujo `next_scene` contém `"caverna"` e exibe diálogo de aviso). O fluxo ao clicar no totem principal:

1. `totem_principal.gd._colocar_flores()` congela o jogador.
2. Para cada flor pendente (sequencialmente): instancia `FlorAnimada`, ela voa de 160px acima do nó `FlorX` até ele.
3. Ao chegar: `FlorX.show()` + `color_filter.unlock_color_animado(cor)` inicia fade-in do canal de cor.
4. Após todas as flores: diálogo de agradecimento via `DialogBox`.
5. Ao fechar o diálogo: player liberado, `tem_flor_para_entregar = false`.

`color_filter.gd` tem `unlock_color_animado(color, duracao)` que usa `tween_method(_set_canal.bind(color), 0.0, 1.0, duracao)` para animar o canal gradualmente. `_restaurar_flores()` em `_ready()` re-exibe `FlorX` nodes para flores já entregues em sessões anteriores (lê `color_channels >= 1.0`).

### Estado global (`Global.gd`)

Autoload (`Global="*res://scripts/Global.gd"`). Persiste entre cenas:
- `target_door_name: String` — porta de chegada para posicionar o player
- `flor_azul/verde/vermelha: bool` — flores coletadas nas cavernas
- `color_channels: Dictionary` — canais R/G/B (0.0–1.0) para colorização
- `dialogos_vistos: Dictionary` — chaves de diálogos já exibidos (nunca reseta)
- `erros: int` — contador de erros (game over em 3)
- `tem_flor_para_entregar: bool` — bloqueia entrada em cavernas até entregar no totem principal

No `game_over()`: reseta `erros`, flores, `color_channels` e `tem_flor_para_entregar` para 0/false. **Não** reseta `dialogos_vistos`.

### Player

`CharacterBody2D` + `player.gd`, grupo `"player"`. Referência via `get_tree().get_first_node_in_group("player")`. Movimento point-click: anda até o X clicado. Expõe `can_move: bool` para diálogos e UI bloquearem o movimento.

### Colorização do mundo

`ColorFilter.tscn` instanciado na `main.tscn`. `color_filter.gd` lê `Global.color_channels` e aplica via shader (`red_amount`, `green_amount`, `blue_amount`). Métodos disponíveis:
- `unlock_color(color)` — seta canal para 1.0 instantaneamente (usado em `_restaurar_flores`)
- `unlock_color_animado(color, duracao)` — anima o canal de 0.0 → 1.0 via tween (usado na entrega ao totem)

## Regras de código

- Reutilizar cenas prefab (`Door.tscn`, `riddle_box.tscn`, `DialogBox.tscn`, `FlorAnimada.tscn`) — não duplicar lógica entre salas.
- Todo estado entre cenas mora em `Global.gd`.
- Diálogos usam `DialogBox.tscn` via `mostrar(Array)` + sinal `terminou`. Verificar `Global.dialogos_vistos` antes de exibir.
- Textos e diálogos em português (pt-BR), tom levemente sombrio/lúdico.
- Flores não têm inventário visual — estado em `Global`, visual no totem principal.
- Ao criar nova caverna: instanciar `DialogBox.tscn`, `RiddleBox`, totem com `area_enigma.gd`, `FadeLayer.tscn`, porta de retorno com `Door.tscn`. Adicionar chave em `_DIALOGOS` de `area_enigma.gd` e arquivo `enigmas-<cor>.json`.
