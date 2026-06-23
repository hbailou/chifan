-- Chi-Fan v4.1.4 optional menu item properties
-- Safe to run more than once.
alter table if exists public.meals
add column if not exists options jsonb not null default '{}'::jsonb;
