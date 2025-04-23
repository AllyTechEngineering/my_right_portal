# How to debug in vs code using the Firebase emulators and Stripe check out CLI
## Step one start the emulators
```
firebase emulators:start --only functions --inspect-functions
```
## Step two, in another terminal (do not close it while testing)
```
stripe listen --forward-to http://127.0.0.1:8081/my-right-portal/us-central1/handleStripeWebhook
```
## Step three, in yet another terminal window, trigger and successful checkout session
```
stripe trigger checkout.session.completed
```
## debug function keys
```
firebase functions:secrets:set STRIPE_WEBHOOK_SECRET_TEST
```
## view the key
```
firebase functions:secrets:access STRIPE_WEBHOOK_SECRET_TEST
```