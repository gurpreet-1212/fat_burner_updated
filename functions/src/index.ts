/**
 * Firebase Cloud Functions for Fat Burner.
 *
 * Setup (choose one):
 *
 * A) Secret Manager (production):
 *    firebase functions:secrets:set SHOPIFY_ACCESS_TOKEN
 *    firebase functions:config:set shopify.shop_domain="your-store.myshopify.com"
 *
 * B) .env for local emulator (copy .env.example to .env)
 */

import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { hasPurchasedPlantProtein } from './shopify.js';

const shopifyAccessToken = defineSecret('SHOPIFY_ACCESS_TOKEN');
const shopifyShopDomain = defineString('SHOPIFY_SHOP_DOMAIN', { default: '' });

interface CheckPurchaseRequest {
  email?: string;
  phone?: string;
}

function getShopifyConfig(): { shopDomain: string; accessToken: string } {
  const shopDomain = process.env.SHOPIFY_SHOP_DOMAIN ?? shopifyShopDomain.value();
  const accessToken = process.env.SHOPIFY_ACCESS_TOKEN ?? shopifyAccessToken.value();

  if (!shopDomain || !accessToken) {
    throw new HttpsError(
      'failed-precondition',
      'Shopify is not configured. Set SHOPIFY_SHOP_DOMAIN and SHOPIFY_ACCESS_TOKEN.'
    );
  }

  return { shopDomain, accessToken };
}

export const checkPlantProteinPurchase = onCall(
  { secrets: [shopifyAccessToken] },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Must be signed in to check purchase status.');
    }

    const data = request.data as CheckPurchaseRequest | undefined;

    if (!data || (typeof data !== 'object')) {
      throw new HttpsError('invalid-argument', 'Request must include email or phone.');
    }

    const { email, phone } = data;

    if (!email && !phone) {
      throw new HttpsError('invalid-argument', 'Provide at least one of: email, phone.');
    }

    const emailStr = typeof email === 'string' ? email.trim() : undefined;
    const phoneStr = typeof phone === 'string' ? phone.trim() : undefined;

    if (!emailStr && !phoneStr) {
      throw new HttpsError('invalid-argument', 'Email or phone cannot be empty.');
    }

    try {
      const purchased = await hasPurchasedPlantProtein(
        getShopifyConfig(),
        emailStr || undefined,
        phoneStr || undefined
      );
      return { purchased };
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Unknown error';
      console.error('checkPlantProteinPurchase failed:', message);
      throw new HttpsError('internal', 'Unable to verify purchase. Please try again later.');
    }
  }
);
