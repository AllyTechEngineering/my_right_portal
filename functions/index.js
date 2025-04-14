/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51QygwRGAAx7cwW9KKjbcA6EcyjptFCkPdqHGJwb5Di1PLIt0c5O6YscWMkAMb62ozjmSQ9AX8P9qo4TELAnEv7eF00Z0jXR4hI"); // Replace with your actual Stripe test secret key
const cors = require("cors")({ origin: true });

exports.createCheckoutSession = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const session = await stripe.checkout.sessions.create({
        payment_method_types: ["card"],
        mode: "subscription",
        line_items: [
          {
            price: "price_1RDseWGAAx7cwW9KqyRfw9Rv", // Replace with your actual test Price ID
            quantity: 1,
          },
        ],
        success_url: "http://localhost:8080/success",
        cancel_url: "http://localhost:8080/cancel",
      });

      functions.logger.info("✅ Stripe session created:", session.id);
      res.status(200).json({ id: session.id });
    } catch (error) {
      console.error("❌ Stripe session error:", error.message);
      res.status(500).send(error.message);
    }
  });
});