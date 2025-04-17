const { onRequest } = require("firebase-functions/v2/https");
const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");
const cors = require("cors")({ origin: true });

// Load local .env variables if running in the emulator
if (process.env.FUNCTIONS_EMULATOR) {
  require("dotenv").config();
}

console.log("🟢 Firebase V2 function loaded");

exports.createCheckoutSession = onRequest((req, res) => {
  logger.info("🔥 Firebase V2 function called");
  
  cors(req, res, async () => {
    try {
      // Retrieve configuration from environment variables or Firebase functions config.
      const config = functions.config();
      const stripeSecret = process.env.STRIPE_SECRET_KEY || config.stripe.secret;
      const stripePriceId = process.env.STRIPE_PRICE_ID || config.stripe.price_id;
      const successUrl = process.env.SUCCESS_URL || config.stripe.success_url;
      const cancelUrl = process.env.CANCEL_URL || config.stripe.cancel_url;

      if (!stripeSecret || !stripePriceId || !successUrl || !cancelUrl) {
        throw new Error("Missing Stripe configuration.");
      }

      const stripe = require("stripe")(stripeSecret);
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [{ price: stripePriceId, quantity: 1 }],
        success_url: successUrl,
        cancel_url: cancelUrl,
      });

      logger.info("✅ Stripe session created", { sessionId: session.id });
      res.status(200).json({ sessionId: session.id, url: session.url });
    } catch (err) {
      logger.error("❌ Stripe session creation failed", err);
      res.status(500).send("Internal Server Error");
    }
  });
});