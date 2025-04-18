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
    logger.info("index.js version 1.0.0 build 3");

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

        const session = await stripe.checkout.sessions.create({
          payment_method_types: ["card"],
          mode: "subscription",
          customer_email: req.body.email,
          client_reference_id: req.body.client_reference_id,
          line_items: [{ price: PRICE_ID.value(), quantity: 1 }],
          success_url: SUCCESS_URL.value(),
          cancel_url: CANCEL_URL.value(),
          allow_promotion_codes: true,
        });

        logger.info("✅ Stripe session created", { sessionId: session.id });
        res.status(200).json({ sessionId: session.id, url: session.url });
      } catch (err) {
        logger.error("❌ Stripe session creation failed", err);
        res.status(500).send("Internal Server Error");
      }
    });
  }
);

exports.handleStripeWebhook = handleStripeWebhook;