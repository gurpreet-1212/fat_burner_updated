# Fat Burner – Cloud Functions

Firebase Cloud Functions for the Fat Burner health app.

## `checkPlantProteinPurchase`

Callable function that checks if a user has purchased "Plant Protein" from your Shopify store.

**Input:**
```json
{
  "email": "user@example.com",
  "phone": "+1234567890"
}
```
Provide at least one of `email` or `phone`.

**Output:**
```json
{
  "purchased": true
}
```
or
```json
{
  "purchased": false
}
```

**Auth:** Requires the user to be signed in (Firebase Auth).

---

## Setup

### 1. Shopify Admin API

1. In [Shopify Admin](https://admin.shopify.com) go to **Settings → Apps and sales channels → Develop apps → Create an app**.
2. Configure Admin API scopes: `read_orders`, `read_customers`.
3. Install the app and copy the **Admin API access token**.

### 2. Store credentials securely

**Production (Secret Manager):**
```bash
firebase functions:secrets:set SHOPIFY_ACCESS_TOKEN
# Paste your token when prompted
```

**Shop domain** (not secret, but required):
```bash
firebase functions:config:set shopify.shop_domain="your-store.myshopify.com"
```

Then in `index.ts`, read `shopify.shop_domain` from `functions.config()`.  
*Note: For Firebase Functions v2, prefer `defineString` from `firebase-functions/params` or set `SHOPIFY_SHOP_DOMAIN` in the function’s environment.*

**Local development:**
1. Copy `.env.example` to `.env`
2. Fill in `SHOPIFY_SHOP_DOMAIN` and `SHOPIFY_ACCESS_TOKEN`
3. Load `.env` in your emulator config (e.g. via `dotenv` in your build/serve script)

### 3. Deploy

```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

---

## Security

- **API keys:** Never commit tokens. Use Secret Manager or environment variables.
- **Auth:** `checkPlantProteinPurchase` requires Firebase Auth; unauthenticated calls are rejected.
- **Input validation:** Email and phone are validated; invalid input returns an error.

---

## Product name

The function checks for the product title `"Plant Protein"` (case-insensitive).  
To change it, update `PLANT_PROTEIN_PRODUCT_NAME` in `src/shopify.ts`.
