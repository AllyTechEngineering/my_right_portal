const functions = require("firebase-functions");

const stripe = require("stripe")(functions.config().stripe.secret);

const cors = require("cors")({ origin: true });

exports.createCheckoutSession = functions.https.onRequest((req, res) => {
  console.log("🔥 Firebase function file loaded.");
  cors(req, res, async () => {
    try {
      const successUrl = "https://right2staynow.com/success-subscription";
      const cancelUrl = "https://right2staynow.com/cancel-subscription";

     // 🔍 Enhanced logging for Stripe redirect URLs
      functions.logger.info("👉 Stripe Checkout session will redirect to:");
      functions.logger.info("✅ Success URL", { successUrl });
      functions.logger.info("❌ Cancel URL", { cancelUrl });
//firebase functions:config:set stripe.cancel_url="https://yournewdomain.com/cancel-subscription" stripe.success_url="https://yournewdomain.com/success-subscription"
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [
          {
            price: functions.config().stripe.price_id,
            quantity: 1,
          },
        ],
        success_url: successUrl,
        cancel_url: cancelUrl,
      });

      // Updated structured logging for session creation
      functions.logger.info("✅ Stripe session created ver. 3", { sessionId: session.id });

      // 🔁 Enhanced response includes debug info
      res.status(200).json({
        sessionId: session.id,
        successUrl: successUrl,
        cancelUrl: cancelUrl,
        url: session.url, // Required for frontend redirection
      });
    } catch (error) {
      // Log the error message for debugging
      functions.logger.error("❌ Stripe session error", { error: error.message });
      res.status(500).json(error.message);
    }
  });
});