# Dashboard PV Empreendimentos - publicacao online

Este pacote transforma o arquivo do Desktop em um site estatico pronto para publicar.

## Arquivos

- `docs/index.html`: copia publicavel do dashboard para GitHub Pages.
- `atualizar-dashboard.ps1`: sincroniza o HTML original do Desktop para `public/index.html`.
- `netlify.toml`: configuracao para Netlify.
- `vercel.json`: configuracao para Vercel.

## Opcao recomendada: GitHub Pages

1. Crie um repositorio publico no GitHub, por exemplo `pv-bpo`.
2. Envie esta pasta para o repositorio.
3. No GitHub, acesse `Settings > Pages`.
4. Em `Build and deployment`, escolha:
   - Source: `Deploy from a branch`
   - Branch: `main`
   - Folder: `/docs`
5. O link final ficara neste formato:
   - `https://Irikami.github.io/pv-bpo/`

## Atualizar depois que editar o dashboard

Rode este comando dentro desta pasta:

```powershell
powershell -ExecutionPolicy Bypass -File .\atualizar-dashboard.ps1 -Push
```

O script copia o HTML do Desktop para `docs/index.html`, inclui `noindex,nofollow`, cria um commit e faz `git push` se existir um remote `origin`.

Se voce publicar manualmente por drag-and-drop, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\atualizar-dashboard.ps1 -OpenFolder
```

Depois envie a pasta `public` novamente no painel do provedor.

## Observacao sobre privacidade

GitHub Pages deixa o conteudo publico para quem tiver o link. Este pacote inclui `noindex,nofollow` para desencorajar indexacao por buscadores, mas isso nao equivale a senha. Se o dashboard tiver dados sensiveis que nao podem ser vistos por terceiros, use hospedagem com autenticacao.
