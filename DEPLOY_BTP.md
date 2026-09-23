# Deploy to SAP BTP (Cloud Foundry + SAP HANA Cloud)

## What gets deployed (`mta.yaml`)

| Module / Resource | Type | Purpose |
|---|---|---|
| `cap-demo-srv` | nodejs | CAP OData V4 service at `/fleet` (uses HANA in production) |
| `cap-demo-db-deployer` | hdb | Creates tables/views in the HDI container **and loads the mock data** from `db/data/*.csv` |
| `cap-demo` | approuter | Entry URL, XSUAA login, forwards to the service |
| `cap-demo-db` | hana / hdi-shared | HDI container on your HANA Cloud instance |
| `cap-demo-auth` | xsuaa / application | Authentication (`xs-security.json`) |

**Mock data:** `cds build --production` converts every CSV in `db/data/` into a `.hdbtabledata`
file. The HDI deployer imports them on each deploy, replacing the rows of those tables with the
CSV content. Edit the CSVs and redeploy to refresh the data.

## Prerequisites

1. BTP subaccount with **Cloud Foundry** enabled and a space.
2. A **SAP HANA Cloud** instance, **running**, mapped to that CF org/space
   (HANA Cloud Central → instance → *Manage Configuration* → *Instance Mapping*),
   or created directly inside the space.
3. Entitlements: `hana` → `hdi-shared`, `xsuaa` → `application`.
4. Tools: `cf` CLI + MultiApps plugin (`cf install-plugin multiapps`) and `mbt`
   (`npm i -g mbt`). Both are preinstalled in SAP Business Application Studio.

## Deploy

```bash
npm install                 # updates node_modules
cf login -a https://api.cf.us10-001.hana.ondemand.com/
mbt build -t mta_archives   # or: npm run build:mta
cf deploy mta_archives/cap-demo_1.0.0.mtar   # or: npm run deploy
```

When it finishes, open the approuter URL (`cf apps` → `cap-demo`), log in with your BTP user,
and go to `/fleet/Equipments`.

Check that the data was loaded: `cf logs cap-demo-db-deployer --recent` should list the
`.hdbtabledata` files being deployed.

## Local development

- `cds watch` → SQLite in memory, `dummy` auth (no login prompt), same CSV data.
- Test against the real HANA from BAS: `cds bind -2 cap-demo-db` then `cds watch --profile hybrid`.

## Remove everything

```bash
npm run undeploy   # cf undeploy cap-demo --delete-services --delete-service-keys
```
