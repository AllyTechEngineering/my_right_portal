// ✅ Leave top imports as-is
// added a comment so that the code would change
/*
  "cancel_url": "https://right2staynow.com/#/cancel-subscription",
  "success_url": "https://right2staynow.com/#/success-subscription",
*/
const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const cors = require("cors")({ origin: true });

console.log("🟢 Firebase V2 function loaded");

exports.createCheckoutSession = onRequest((req, res) => {
  logger.info("🔥 Firebase V2 function called");

  cors(req, res, async () => {
    try {
      const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY); // ✅ Moved here

      if (!process.env.STRIPE_SECRET_KEY || !process.env.STRIPE_PRICE_ID) {
        throw new Error("Missing Stripe configuration.");
      }

      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [{ price: process.env.STRIPE_PRICE_ID, quantity: 1 }],
        success_url: process.env.SUCCESS_URL,
        cancel_url: process.env.CANCEL_URL,
      });

      logger.info("✅ Stripe session created", { sessionId: session.id });

      res.status(200).json({ sessionId: session.id, url: session.url });
    } catch (err) {
      logger.error("❌ Stripe session creation failed", err);
      res.status(500).send("Internal Server Error");
    }
  });
});