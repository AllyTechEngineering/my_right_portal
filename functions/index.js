/* eslint-env node */
const functions = require("firebase-functions");

const isEmulated = process.env.FUNCTIONS_EMULATOR === "true";
if (isEmulated) {
  require("dotenv").config();
}

const stripe = require("stripe")(
  isEmulated ? process.env.STRIPE_SECRET_KEY : functions.config().stripe.secret,
);

const cors = require("cors")({ origin: true });

exports.createCheckoutSession = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [
          {
            price: isEmulated
              ? process.env.STRIPE_PRICE_ID
              : functions.config().stripe.price_id,
            quantity: 1,
          },
        ],
        success_url: isEmulated
          ? process.env.SUCCESS_URL
          : functions.config().stripe.success_url,
        cancel_url: isEmulated
          ? process.env.CANCEL_URL
          : functions.config().stripe.cancel_url,
      });

      functions.logger.info(`✅ Stripe session created: ${session.id}`);
      res.status(200).json({ url: session.url });
    } catch (error) {
      console.error("❌ Stripe session error:", error.message);
      res.status(500).json(error.message);
    }
  });
});