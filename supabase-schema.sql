-- Chi-Fan v2.0 Supabase schema
create extension if not exists "uuid-ossp";

create table if not exists people (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  team text,
  phone text,
  tsmc_phone_full text,
  tsmc_phone_short text,
  email text,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists restaurants (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  phone1 text,
  phone2 text,
  address text,
  note text,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists menu_categories (
  id uuid primary key default uuid_generate_v4(),
  restaurant_id uuid references restaurants(id) on delete cascade,
  name text not null,
  sort_order int default 0,
  created_at timestamptz default now()
);

create table if not exists meals (
  id uuid primary key default uuid_generate_v4(),
  restaurant_id uuid references restaurants(id) on delete cascade,
  category_id uuid references menu_categories(id) on delete cascade,
  name text not null,
  price numeric default 0,
  note text,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists daily_orders (
  id uuid primary key default uuid_generate_v4(),
  order_date date unique not null,
  restaurant_id uuid references restaurants(id),
  status text default 'open', -- open / confirmed / closed
  created_at timestamptz default now()
);

create table if not exists order_items (
  id uuid primary key default uuid_generate_v4(),
  daily_order_id uuid references daily_orders(id) on delete cascade,
  person_id uuid references people(id),
  meal_id uuid references meals(id),
  meal_name text,
  price numeric default 0,
  status text default 'pending', -- pending / ordered / no_order
  paid boolean default false,
  note text,
  updated_at timestamptz default now(),
  unique(daily_order_id, person_id)
);

alter table people enable row level security;
alter table restaurants enable row level security;
alter table menu_categories enable row level security;
alter table meals enable row level security;
alter table daily_orders enable row level security;
alter table order_items enable row level security;

-- Development/demo policies: anyone can read/write with anon key.
-- Tighten these before serious company use.
do $$ begin
create policy "public people all" on people for all using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
create policy "public restaurants all" on restaurants for all using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
create policy "public menu_categories all" on menu_categories for all using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
create policy "public meals all" on meals for all using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
create policy "public daily_orders all" on daily_orders for all using (true) with check (true);
exception when duplicate_object then null; end $$;
do $$ begin
create policy "public order_items all" on order_items for all using (true) with check (true);
exception when duplicate_object then null; end $$;
