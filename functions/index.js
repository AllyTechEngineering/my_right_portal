const functions = require("firebase-functions");
// eslint-disable-next-line max-len
const stripe = require("stripe")(
    "test",
); // Replace with your actual Stripe test secret key
const cors = require("cors")({origin: true});

exports.createCheckoutSession = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: [
          "card",
        ],
        mode: "subscription",
        line_items: [
          {
            price: "price_1RDseWGAAx7cwW9KqyRfw9Rv",
            quantity: 1,
          },
        ],
        success_url:
          "https://right2staynow.com/success-subscription",
        cancel_url:
          "https://right2staynow.com/cancel-subscription",
      });

      functions.logger.info(
          `✅ Stripe session created: ${session.id}`,
      );
      res.status(200).json({url: session.url});
    } catch (error) {
      console.error("❌ Stripe session error:", error.message);
      res.status(500).send(error.message);
    }
  });
});
