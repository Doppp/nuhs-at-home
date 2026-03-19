# NUHS@Home Static Site

This repo contains:

- a public reference scrape of the AH homepage and core static assets in `reference/ah/`
- source copies of current NUHS@Home pages in `reference/nuhs/`
- a standalone static `NUHS@Home` landing page in `index.html`
- locally mirrored copies of linked NUHS@Home pages under `patient-care/`

## Refresh source assets

```bash
./scripts/fetch_sources.sh
```

## Run locally

```bash
python3 -m http.server 4173
```

Then open `http://127.0.0.1:4173/`.
