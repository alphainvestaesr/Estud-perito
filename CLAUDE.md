# Projeto: Eu Perito — site de estudo para Perito Criminal - Medicina Veterinaria (Politec-PE e outras bancas)

Dona do projeto: Ana. Objetivo: estudar com questoes reais recentes e, no futuro, vender (modulos separados + pacote "Alpha").
Responda sempre em portugues. Ana prefere que eu siga a recomendacao (sem devolver escolhas) e quer ver o plano antes de eu produzir conteudo novo.

## Estrutura atual (ja no ar)
- `index.html` — site completo (HTML/CSS/JS puro, sem build). Questoes embutidas como reserva; com login, le da tabela `questoes`.
- `brasao.png` — brasao dourado/azul marinho (logo e favicon).
- `questoes.json` — questoes no formato oficial (fonte da verdade para novos lotes).
- `schema.sql` — tabelas `questoes`, `respostas` (historico), `progresso` (estado sincronizado por usuario) + RLS. Idempotente.
- `seed_questoes.sql` — carga das questoes (insert ... on conflict do update). Regerar quando `questoes.json` mudar.
- Hospedagem: GitHub Pages (branch main, raiz) -> https://alphainvestaesr.github.io/Estud-perito/
- Supabase: projeto `estud-perito` (ref lqpgabhirusosilaktia, regiao Sao Paulo). No `index.html` fica so a chave PUBLICAVEL (sb_publishable_...). Nunca colocar a secret/service_role no codigo.
- Auth: e-mail + senha (com confirmacao por e-mail) e "continuar sem conta" (progresso so no aparelho). Tela de login e provisoria — Ana quer customizar depois.
- Sync: `progresso.estado` guarda {picks, wrong, done, updatedAt}; vence o mais recente. Cada resposta tambem vai para `respostas`.

## Regras de conteudo (nao quebrar)
- Questoes REAIS de banca (Cebraspe, AOCP, FEPESE e outras), dos ultimos 4 anos, priorizando as mais recentes. Se houver poucas questoes de um assunto, avisar.
- Formato Certo/Errado. Multipla escolha vira item C/E. Itens adaptados ficam marcados `origem: adaptada`.
- Cada questao mostra fonte: banca · concurso · ano.
- Errada: mostrar "forma correta" + justificativa + "Para fixar". Certa: justificativa + "Para fixar".
- Usar os termos tecnicos oficiais da banca.
- Numeros exatos (prazos, penas, idades, tempos, IPM, fases de putrefacao, indices de TAF): sempre conferir na lei/norma VIGENTE. Nunca "aproximadamente" quando a banca cobra exato.
- Escopo do edital (9 frentes): Portugues, Raciocinio Logico, Nocoes de Criminalistica (geral/humana), Documentos Tecnicos, Medicina Legal (geral/humana), Direito Penal, Direito Processual Penal, Estatuto dos Policiais Civis de PE, Conhecimentos Especificos de Medicina Veterinaria.
- Nao usar material de apostila comprada no produto. Base segura: provas oficiais + justificativas escritas por nos.

## Funcoes combinadas (a fazer, por partes — primeiro fechar Veterinaria)
- Abas: Objetivas, Discursivas, Mais cobrado (tema em 2+ bancas/provas), Revisar erros (volta ate acertar 2x seguidas), Meu Edital.
- Paginacao de 10 por pagina; gabarito recolhivel (seta); respondidas vao para o fim da lista; "Recomecar do inicio" com confirmacao.
- Discursivas: escritas em papel, foto enviada ao site, resumo didatico com os pontos exigidos, correcao por IA (unica funcao com custo por uso).
- Meu Edital: le edital (TAF, cronograma, contagem regressiva, notas de corte por disciplina); mapeamento questao<->item roda no navegador (dicionario de palavras-chave), sem IA.
- Agente de estudo: cronograma "minimo do dia, nunca teto"; blocos de 25-30 min com materias misturadas; pausa com sugestao variada (nao repetir no mesmo dia; sem pausa em simulado); simulado cronometrado no formato da banca.
- Diferenciais: modo audio (voz nativa do navegador), alerta de lei desatualizada, calibragem de confianca (certeza/chute/duvida), perfil da banca, nota de prontidao, mapa mental por tema.
- Acesso: celular, iPad e notebook.

## Visual aprovado (nao mudar sem pedir)
- Fonte serifada (Georgia) nos textos, sans-serif nos rotulos/botoes. Rotulos pequenos em CAIXA ALTA; resto em Titulo/Frase.
- Tema claro por padrao, com botao Claro/Escuro; NUNCA seguir o sistema automaticamente. Card da questao sempre com fundo claro e texto escuro (mesmo no tema escuro). Fundo escuro = preto puro (#000).
- Card: borda preta pura; barra do tema preta com texto branco (tema claro) / azul marinho #001f54 com texto branco (tema escuro); selo banca·prova·ano branco com texto preto.
- Aba ativa: azul marinho #001f54 com texto amarelo (#ffff00); inverte no tema escuro. Detalhes dourados (#c9a227) combinando com o brasao.
- "Voce marcou": icone check verde se acertou, X vermelho se errou. "Gabarito": verde neon (#39ff14). "Forma correta": rotulo vermelho.
- Textos secundarios sobre o fundo da pagina usam cor propria que clareia no tema escuro (nada "transparente").

## Como adicionar questoes
1. Acrescentar no `questoes.json` (mesmo formato).
2. Regerar `seed_questoes.sql` e rodar no SQL Editor do Supabase (atualiza sem duplicar).
3. (Opcional) atualizar a lista embutida no `index.html`, que serve de reserva para quem usa sem conta.
