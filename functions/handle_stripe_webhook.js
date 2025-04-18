const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");
const STRIPE_SECRET_KEY = defineSecret("STRIPE_SECRET_KEY");
const STRIPE_WEBHOOK_SECRET = defineSecret("STRIPE_WEBHOOK_SECRET");

admin.initializeApp();

exports.handleStripeWebhook = onRequest(
  {
    secrets: [STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET],
    region: "us-central1",
  },
  async (req, res) => {
    logger.info("handle_stripe_webhook.js version 1.0.0 build 1");
    if (!req.rawBody) {
      console.error("❌ Missing rawBody in request.");
      return res.status(400).send("Missing rawBody for Stripe webhook verification.");
    }

    const sig = req.headers["stripe-signature"];
    const endpointSecret = STRIPE_WEBHOOK_SECRET.value();
    console.log("🔐 Stripe webhook signing secret (testing only):", endpointSecret);
    const stripe = require("stripe")(STRIPE_SECRET_KEY.value());

    let event;
    try {
      event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
    } catch (err) {
      console.error("❌ Webhook error:", err.message);
      return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    console.log("📦 Stripe webhook event received:", event.type);

    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const userId = session.client_reference_id;

      if (!userId) {
        console.warn("⚠️ No client_reference_id found in session.");
        return res.status(400).send("Missing user ID.");
      }

      const userRef = admin.firestore().collection("lawyers").doc(userId);
      const userDoc = await userRef.get();

      if (userDoc.exists) {
        await userRef.update({ subscriptionActive: true });
        console.log(`✅ Subscription activated for user ID: ${userId}`);
      } else {
        console.warn(`⚠️ No user found with ID: ${userId}`);
      }
    }

    res.status(200).send("✅ Webhook received");
  }
);