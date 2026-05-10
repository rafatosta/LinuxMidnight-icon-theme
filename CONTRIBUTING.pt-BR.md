# Guia de Contribuição (Português-BR)

## Objetivo

Este projeto busca manter uma linguagem visual consistente para o **LinuxDark-icon-theme**, tornando as contribuições simples e previsíveis.

## Estrutura do Repositório

- `scalable/apps/` → ícones de aplicativos (SVG).
- `scalable/places/` → ícones de pastas/locais (SVG).
- `scalable/status/` → ícones de status (SVG).
- `templates/` → templates SVG reutilizáveis.
- `aliases/*.txt` → arquivos de definição de aliases usados pelo `scripts/install-dev.sh` para gerar nomes alternativos via links simbólicos (compatibilidade com apps/desktops).
- `scripts/install-dev.sh` → instalador de desenvolvimento que valida a estrutura do projeto, gera symlinks de aliases a partir de `aliases/*.txt`, instala em `~/.local/share/icons` e atualiza o cache de ícones.
- `install.sh` / `uninstall.sh` → scripts padrão de instalação e remoção.

## Regras Atuais de Padronização

### Ícones redondos (regra oficial atual)

Para **ícones redondos**, use o padrão:

1. Utilizar o template do projeto como base (`templates/app-template-black.svg`).
2. Manter o ícone **centralizado** no template.
3. Usar **40 mm de largura** e **40 mm de altura** como área de referência de composição.

> Observação: Esta é a única padronização formal definida no projeto até o momento.

## Como Contribuir

1. Faça um fork do repositório.
2. Crie uma branch de feature (exemplo: `feat/new-icon-name`).
3. Adicione ou edite arquivos SVG na pasta correta.
4. Atualize os arquivos de alias em `aliases/` quando forem necessários nomes de compatibilidade.
5. Abra um Pull Request informando:
   - O que foi alterado.
   - Qual categoria de ícones foi afetada.
   - Se o padrão de ícones redondos (40x40 mm, centralizado) foi seguido.

## Checklist para Pull Request

- [ ] Ícone na pasta de categoria correta.
- [ ] SVG limpo (sem metadados/camadas desnecessárias).
- [ ] Ícone redondo centralizado no template.
- [ ] Composição do ícone redondo seguindo referência 40 mm x 40 mm.
- [ ] Alias atualizado (se necessário para compatibilidade).
- [ ] Validação visual feita no ambiente desktop.

## Sugestões de Nomenclatura

- Prefira nomes alinhados às convenções de desktop/aplicativos (exemplo: `google-chrome.svg`, `user-home.svg`).
- Mantenha nomes em minúsculo e com hífen.
- Evite nomes duplicados e variações inconsistentes.
