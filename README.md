# Chi-Fan v4.1.5 Menu Builder

This build updates the Menus module:

- Tabs simplified to **Build Menu** and **Menu List**.
- Build Menu toggles between **Food Menu** and **Drink Menu**.
- Restaurant/store entry uses a vertical flow: name, phone numbers, address.
- `+ add phone number` supports additional visible phone fields; the database stores the first two as Phone 1 and Phone 2.
- Categories are optional.
- Items can be added under categories or without category.
- Each item can include manual selectable options such as size, spice level, ice level, etc.
- A live overview preview appears beside the form.
- Menu List shows menus as cards with nested category cards.

## Required SQL

Run this once if not already run:

```sql
alter table if exists public.meals
add column if not exists options jsonb not null default '{}'::jsonb;
```

## Run locally

```powershell
npm install --registry=https://registry.npmjs.org/
npm run dev
```

Open:

```text
http://127.0.0.1:5173/
```
