# Chi-Fan! v2.0

Modern live food ordering app for site offices.

## Features
- React + Vite app
- Supabase-ready live database
- English / Traditional Chinese UI
- Admin dashboard
- Team ordering page
- People management with contact details
- Restaurant/menu/category management
- Today's order with live-style structure
- Payment tracking
- LINE share link
- QR code share
- OCR menu scan page using Tesseract.js
- Local demo fallback if Supabase is not configured

## Setup
1. Install Node.js LTS.
2. Create a Supabase project.
3. Run the SQL in `supabase-schema.sql` inside Supabase SQL Editor.
4. Copy `.env.example` to `.env` and add your Supabase URL and anon key.
5. Run:

```bash
npm install
npm run dev
```

## Deploy with Vercel
1. Upload/push this folder to GitHub.
2. Import the GitHub repo in Vercel.
3. Add environment variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
4. Deploy.

## Notes
- If Supabase env variables are missing, the app runs in demo/local mode.
- For office production use, tighten Supabase Row Level Security policies.
