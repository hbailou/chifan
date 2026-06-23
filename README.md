# Chi-Fan v4.1.2 Supabase-style UI

This package is a clean v4 build with admin user/group management.

## Fresh setup

1. In Supabase, delete old test users:
   Authentication > Users > delete test users.

2. In Supabase SQL Editor, run:
   `supabase-full-reset-v4.sql`

3. Create `.env` in the project root:

```env
VITE_SUPABASE_URL=https://YOUR_PROJECT.supabase.co
VITE_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

4. Run locally:

```powershell
npm install --registry=https://registry.npmjs.org/
npm run dev
```

5. Open:

```text
http://127.0.0.1:5173/
```

6. Register the first admin:

- Name: Hassan Bailou
- Email: hassan.bailou@siemens.com
- Password: 12345678
- Phone: 0903609753
- TSMC Long Phone: 0919773536
- TSMC Short Phone: 8790233
- Group: Default Group

The app automatically protects this admin account.

## Important note about Admin-created users

With a frontend-only Supabase app, the admin can create and approve the user profile, assign groups, and assign roles. The user still needs to register once with the same email address to create their actual Supabase Auth password. The app then links that login to the existing profile by email.

## v4.1.2 changes

- Admin can add user profiles.
- Admin can edit user details.
- Admin can approve/reject/inactivate users.
- Admin can assign multiple groups to users.
- Admin can set role: User / Manager / Admin.
- Admin can assign one managed group to a manager.
- Admin can add/edit/archive/restore groups.
- Protected Hassan Bailou admin cannot be removed, demoted, or deactivated.
