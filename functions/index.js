const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const cors = require("cors")({ origin: true });
const { handleStripeWebhook } = require("./handle_stripe_webhook");

console.log("🟢 Firebase V2 function loaded");

// Define Firebase secrets
const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const PRICE_ID = defineSecret("PRICE_ID");
const SUCCESS_URL = defineSecret("SUCCESS_URL");
const CANCEL_URL = defineSecret("CANCEL_URL");

exports.createCheckoutSession = onRequest(
  {
    secrets: [STRIPE_SECRET_KEY, PRICE_ID, SUCCESS_URL, CANCEL_URL],
  },
  async (req, res) => {
    logger.info("index.js version 1.0.0 build 10");

    cors(req, res, async () => {
      try {
        logger.info("Stripe configuration", {
          stripeSecret: !!STRIPE_SECRET_KEY.value(),
          stripePriceId: !!PRICE_ID.value(),
          successUrl: !!SUCCESS_URL.value(),
          cancelUrl: !!CANCEL_URL.value(),
        });

        if (
          !STRIPE_SECRET_KEY.value() ||
          !PRICE_ID.value() ||
          !SUCCESS_URL.value() ||
          !CANCEL_URL.value()
        ) {
          logger.error("Missing Stripe configuration", {
            stripeSecret: !!STRIPE_SECRET_KEY.value(),
            stripePriceId: !!PRICE_ID.value(),
            successUrl: !!SUCCESS_URL.value(),
            cancelUrl: !!CANCEL_URL.value(),
          });
          throw new Error("Missing Stripe configuration.");
        }

        const stripe = require("stripe")(STRIPE_SECRET_KEY.value());
        logger.info("📨 Received email for Stripe session", {
          email: req.body?.email,
          body: req.body,
        });

        const admin = require("firebase-admin");
        if (!admin.apps.length) {
          admin.initializeApp();
        }

        const userId = req.body.client_reference_id;
        let customerId = null;

        try {
          const userRef = admin.firestore().collection("lawyers").doc(userId);
          const userDoc = await userRef.get();
          if (userDoc.exists) {
            const data = userDoc.data();
            if (data.stripeCustomerId) {
              customerId = data.stripeCustomerId;
              logger.info("✅ Found existing Stripe customer ID", { customerId });
            }
          }
        } catch (lookupErr) {
          logger.warn("⚠️ Failed to fetch Firestore user document", lookupErr);
        }

        const sessionParams = {
          payment_method_types: ["card"],
          mode: "subscription",
          client_reference_id: userId,
          line_items: [{ price: PRICE_ID.value(), quantity: 1 }],
          success_url: SUCCESS_URL.value(),
          cancel_url: CANCEL_URL.value(),
          allow_promotion_codes: true,
        };
        
        if (customerId) {
          sessionParams.customer = customerId;
        } else {
          sessionParams.customer_email = req.body.email;
        }
        
        const session = await stripe.checkout.sessions.create(sessionParams);

        logger.info("✅ Stripe session created", { sessionId: session.id });
        res.status(200).json({ sessionId: session.id, url: session.url });
      } catch (err) {
        logger.error("❌ Stripe session creation failed", err);
        res.status(500).send("Internal Server Error");
      }
    });
  }
);

exports.createBillingPortalSession = onRequest(
  {
    secrets: [STRIPE_SECRET_KEY],
  },
  async (req, res) => {
    // ✅ CORS headers need to go BEFORE the cors() wrapper
    res.set('Access-Control-Allow-Origin', 'https://right2staynow.com');
    res.set('Access-Control-Allow-Methods', 'POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    // ✅ Wrap only the functional logic
    cors(req, res, async () => {
      const admin = require("firebase-admin");
      if (!admin.apps.length) admin.initializeApp();

      const stripe = require("stripe")(STRIPE_SECRET_KEY.value());
      const userId = req.body.userId;

      try {
        const userDoc = await admin.firestore().collection("lawyers").doc(userId).get();
        if (!userDoc.exists || !userDoc.data().stripeCustomerId) {
          return res.status(400).send("Customer not found");
        }

        const stripeCustomerId = userDoc.data().stripeCustomerId;

        const session = await stripe.billingPortal.sessions.create({
          customer: stripeCustomerId,
          return_url: "https://right2staynow.com/#/lawyer-dashboard",
        });

        res.status(200).json({ url: session.url });
      } catch (error) {
        console.error("Error creating billing portal session:", error);
        res.status(500).send("Internal Server Error");
      }
    });
  }
);

exports.handleStripeWebhook = handleStripeWebhook;