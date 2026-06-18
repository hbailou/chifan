# Chi-Fan! v3.4 UX Polish

Commercial UX polish version for the live site lunch ordering app.

## Run locally with PowerShell

```powershell
npm install --registry=https://registry.npmjs.org/
npm run dev
```

Open:

```text
http://127.0.0.1:5173/
```

## Deploy

Push the project to GitHub. Vercel will build with:

```text
npm run build
```

Output directory:

```text
dist
```

## Notes

Do not upload `node_modules`, `dist`, or `.env` to GitHub. Use `.env.example` as the template.
