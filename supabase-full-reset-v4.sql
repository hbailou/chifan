-- Chi-Fan v4.1.1 full reset schema
-- WARNING: This drops Chi-Fan public tables only. Delete Auth users manually in Supabase Authentication > Users if you want a completely fresh login state.

drop table if exists public.order_items cascade;
drop table if exists public.daily_orders cascade;
drop table if exists public.meals cascade;
drop table if exists public.menu_categories cascade;
drop table if exists public.restaurants cascade;
drop table if exists public.user_groups cascade;
drop table if exists public.groups cascade;
drop table if exists public.user_profiles cascade;

create extension if not exists "pgcrypto";

create table public.groups (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.user_profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique,
  name text not null,
  email text not null unique,
  phone text,
  tsmc_long_phone text,
  tsmc_short_phone text,
  role text not null default 'user' check (role in ('admin','manager','user')),
  status text not null default 'pending' check (status in ('pending','approved','rejected','inactive')),
  managed_group_id uuid references public.groups(id) on delete set null,
  is_protected boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.user_groups (
  id uuid primary key default gen_random_uuid(),
  user_profile_id uuid not null references public.user_profiles(id) on delete cascade,
  group_id uuid not null references public.groups(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique(user_profile_id, group_id)
);

create table public.restaurants (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  menu_type text not null default 'food' check (menu_type in ('food','drink')),
  phone1 text,
  phone2 text,
  address text,
  note text,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.menu_categories (
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.meals (
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  category_id uuid references public.menu_categories(id) on delete set null,
  name text not null,
  price numeric(10,2) not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.daily_orders (
  id uuid primary key default gen_random_uuid(),
  order_date date not null,
  group_id uuid not null references public.groups(id) on delete cascade,
  food_restaurant_id uuid references public.restaurants(id) on delete set null,
  drink_restaurant_id uuid references public.restaurants(id) on delete set null,
  food_active boolean not null default false,
  drink_active boolean not null default false,
  status text not null default 'open' check (status in ('draft','open','confirmed','closed','completed')),
  opened_by uuid references public.user_profiles(id) on delete set null,
  confirmed_by uuid references public.user_profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(order_date, group_id)
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  daily_order_id uuid not null references public.daily_orders(id) on delete cascade,
  user_profile_id uuid not null references public.user_profiles(id) on delete cascade,
  item_type text not null check (item_type in ('food','drink')),
  meal_id uuid references public.meals(id) on delete set null,
  status text not null default 'pending' check (status in ('pending','ordered','no_order')),
  paid boolean not null default false,
  note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(daily_order_id, user_profile_id, item_type)
);

insert into public.groups (name, description)
values ('Default Group', 'Default initial group for first setup');

insert into public.user_profiles (
  name, email, phone, tsmc_long_phone, tsmc_short_phone,
  role, status, managed_group_id, is_protected
)
select
  'Hassan Bailou', 'hassan.bailou@siemens.com', '0903609753', '0919773536', '8790233',
  'admin', 'approved', g.id, true
from public.groups g
where g.name = 'Default Group';

insert into public.user_groups (user_profile_id, group_id)
select up.id, g.id
from public.user_profiles up
join public.groups g on g.name = 'Default Group'
where up.email = 'hassan.bailou@siemens.com';

alter table public.groups enable row level security;
alter table public.user_profiles enable row level security;
alter table public.user_groups enable row level security;
alter table public.restaurants enable row level security;
alter table public.menu_categories enable row level security;
alter table public.meals enable row level security;
alter table public.daily_orders enable row level security;
alter table public.order_items enable row level security;

create policy "dev all groups" on public.groups for all using (true) with check (true);
create policy "dev all user_profiles" on public.user_profiles for all using (true) with check (true);
create policy "dev all user_groups" on public.user_groups for all using (true) with check (true);
create policy "dev all restaurants" on public.restaurants for all using (true) with check (true);
create policy "dev all menu_categories" on public.menu_categories for all using (true) with check (true);
create policy "dev all meals" on public.meals for all using (true) with check (true);
create policy "dev all daily_orders" on public.daily_orders for all using (true) with check (true);
create policy "dev all order_items" on public.order_items for all using (true) with check (true);
