-- Eu Perito — estrutura do banco (Supabase / Postgres)
-- Rodar no SQL Editor do Supabase. Pode rodar de novo sem problema (idempotente).

create table if not exists questoes (
  id               text primary key,
  disciplina       text not null,
  assunto          text not null,
  banca            text not null,
  concurso         text not null,
  ano              int  not null,
  origem           text not null default 'original' check (origem in ('original','adaptada')),
  enunciado        text not null,
  gabarito         char(1) not null check (gabarito in ('C','E')),
  forma_correta    text,
  justificativa    text not null,
  para_fixar       text,
  para_fixar_chips jsonb,
  para_fixar_nota  text,
  criado_em        timestamptz not null default now()
);

-- Histórico de todas as respostas (base de estatísticas / desempenho)
create table if not exists respostas (
  id            bigint generated always as identity primary key,
  user_id       uuid not null default auth.uid() references auth.users(id) on delete cascade,
  questao_id    text not null references questoes(id) on delete cascade,
  marcou        char(1) not null check (marcou in ('C','E')),
  acertou       boolean not null,
  respondida_em timestamptz not null default now()
);
create index if not exists respostas_user_idx on respostas (user_id, questao_id, respondida_em desc);

-- Estado atual do usuário (respondidas, erros para revisar) — sincroniza celular, iPad e notebook
create table if not exists progresso (
  user_id       uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  estado        jsonb not null default '{}'::jsonb,
  atualizado_em timestamptz not null default now()
);

-- Última resposta de cada questão por usuário
create or replace view ultima_resposta with (security_invoker = true) as
select distinct on (user_id, questao_id) user_id, questao_id, marcou, acertou, respondida_em
from respostas
order by user_id, questao_id, respondida_em desc;

alter table questoes  enable row level security;
alter table respostas enable row level security;
alter table progresso enable row level security;

drop policy if exists "questoes_leitura" on questoes;
create policy "questoes_leitura" on questoes for select to authenticated using (true);

drop policy if exists "respostas_leitura_propria" on respostas;
create policy "respostas_leitura_propria" on respostas for select to authenticated using (user_id = auth.uid());
drop policy if exists "respostas_insercao_propria" on respostas;
create policy "respostas_insercao_propria" on respostas for insert to authenticated with check (user_id = auth.uid());

drop policy if exists "progresso_leitura_propria" on progresso;
create policy "progresso_leitura_propria" on progresso for select to authenticated using (user_id = auth.uid());
drop policy if exists "progresso_insercao_propria" on progresso;
create policy "progresso_insercao_propria" on progresso for insert to authenticated with check (user_id = auth.uid());
drop policy if exists "progresso_update_proprio" on progresso;
create policy "progresso_update_proprio" on progresso for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());

grant select on questoes to authenticated;
grant select, insert on respostas to authenticated;
grant select, insert, update on progresso to authenticated;
grant select on ultima_resposta to authenticated;
