# Chi-Fan! v3.3

Live production refinement version of the live site lunch ordering app.

## What changed in v3.3

- More professional visual design and table styling
- Subtle low-emphasis Edit / Remove actions
- Sticky table headers, row hover states, zebra-striping
- Cleaner action column behavior
- Better focus states for form inputs
- Keeps the v2.3 editable people, restaurant, category, and meal workflow
- Keeps bilingual English / Traditional Chinese support
- Keeps Supabase live database support

## Run locally with PowerShell

```powershell
npm install --registry=https://registry.npmjs.org/
npm run dev
```

If replacing an older folder:

```powershell
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item -Force package-lock.json -ErrorAction SilentlyContinue
npm cache clean --force
npm install --registry=https://registry.npmjs.org/
npm run dev
```

## Environment

Create a `.env` file:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_or_publishable_key
```

## Database

Run `supabase-schema.sql` in Supabase SQL Editor if your database is not created yet.


## v3.1 quick update
- Pending users are converted to No order when an order is confirmed.
- Withdraw confirmation is now a low-emphasis text action.
- Summary tables now show the selected restaurant for the day.
