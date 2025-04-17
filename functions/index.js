const { onRequest } = require("firebase-functions/v2/https");
const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");
const cors = require("cors")({ origin: true });

console.log("🟢 Firebase V2 function loaded");

exports.createCheckoutSession = onRequest((req, res) => {
  logger.info("🔥 Firebase V2 function called");

  cors(req, res, async () => {
    try {
      const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY); // ✅ Moved here

      if (!process.env.STRIPE_SECRET_KEY) {
        throw new Error("Missing Stripe configuration.");
      }

      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [{ price: functions.config().stripe.price_id, quantity: 1 }],
        success_url: functions.config().stripe.success_url,
        cancel_url: functions.config().stripe.cancel_url,
      });

      logger.info("✅ Stripe session created", { sessionId: session.id });

      res.status(200).json({ sessionId: session.id, url: session.url });
    } catch (err) {
      logger.error("❌ Stripe session creation failed", err);
      res.status(500).send("Internal Server Error");
    }
  });
});