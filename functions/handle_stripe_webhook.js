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
    logger.info("handle_stripe_webhook.js version 1.0.0 build 4");

    if (!req.rawBody) {
      console.error("❌ Missing rawBody in request.");
      return res.status(400).send("Missing rawBody for Stripe webhook verification.");
    }

    const sig = req.headers["stripe-signature"];
    const endpointSecret = STRIPE_WEBHOOK_SECRET.value();
    const stripe = require("stripe")(STRIPE_SECRET_KEY.value());

    let event;
    try {
      event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
    } catch (err) {
      console.error("❌ Webhook error:", err.message);
      return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    console.log("📦 Stripe webhook event received:", event.type);

    // ✅ Checkout session completed
    if (event.type === "checkout.session.completed") {
      const session = event.data.object;
      const userId = session.client_reference_id;
      const stripeCustomerId = session.customer;

      if (!userId || !stripeCustomerId) {
        console.warn("⚠️ Missing userId or Stripe customer ID");
        return res.status(400).send("Missing IDs.");
      }

      const userRef = admin.firestore().collection("lawyers").doc(userId);
      await userRef.set({
        subscriptionActive: true,
        stripeCustomerId: stripeCustomerId
      }, { merge: true });

      console.log(`✅ Subscription activated and Stripe customer ID stored for user ID: ${userId}`);
    }

    // ✅ Subscription updated
    if (event.type === "customer.subscription.updated") {
      const customerId = event.data.object.customer;

      const snapshot = await admin.firestore()
        .collection("lawyers")
        .where("stripeCustomerId", "==", customerId)
        .limit(1)
        .get();

      if (!snapshot.empty) {
        const userRef = snapshot.docs[0].ref;
        await userRef.set({
          subscriptionStatus: event.data.object.status,
          currentPeriodEnd: event.data.object.current_period_end,
          planNickname: event.data.object.items?.data[0]?.price?.nickname || "unknown"
        }, { merge: true });
        console.log(`✅ Updated Firestore for customer ID: ${customerId}`);
      } else {
        console.warn("⚠️ No user found with stripeCustomerId:", customerId);
      }
    }

    // ✅ Subscription deleted
    if (event.type === "customer.subscription.deleted") {
      const customerId = event.data.object.customer;

      const snapshot = await admin.firestore()
        .collection("lawyers")
        .where("stripeCustomerId", "==", customerId)
        .limit(1)
        .get();

      if (!snapshot.empty) {
        const userRef = snapshot.docs[0].ref;
        await userRef.update({ subscriptionActive: false });
        console.log(`✅ Updated Firestore for customer ID: ${customerId}`);
      } else {
        console.warn("⚠️ No user found with stripeCustomerId:", customerId);
      }
    }

    // ✅ Invoice paid
    if (event.type === "invoice.payment_succeeded") {
      const customerId = event.data.object.customer;

      const snapshot = await admin.firestore()
        .collection("lawyers")
        .where("stripeCustomerId", "==", customerId)
        .limit(1)
        .get();

      if (!snapshot.empty) {
        const userRef = snapshot.docs[0].ref;
        await userRef.set({
          lastInvoicePaid: event.data.object.created,
          amountPaid: event.data.object.amount_paid
        }, { merge: true });
        console.log(`✅ Updated Firestore for customer ID: ${customerId}`);
      } else {
        console.warn("⚠️ No user found with stripeCustomerId:", customerId);
      }
    }

    // ✅ Invoice failed
    if (event.type === "invoice.payment_failed") {
      const customerId = event.data.object.customer;

      const snapshot = await admin.firestore()
        .collection("lawyers")
        .where("stripeCustomerId", "==", customerId)
        .limit(1)
        .get();

      if (!snapshot.empty) {
        const userRef = snapshot.docs[0].ref;
        await userRef.set({ lastPaymentFailed: true }, { merge: true });
        console.log(`✅ Updated Firestore for customer ID: ${customerId}`);
      } else {
        console.warn("⚠️ No user found with stripeCustomerId:", customerId);
      }
    }

    res.status(200).send("✅ Webhook received");
  }
);