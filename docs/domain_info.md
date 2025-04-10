
# Custom Domain Setup for Flutter Web App on Firebase Hosting

This document walks through how to connect a custom domain purchased through GoDaddy to a Flutter Web app hosted on Firebase Hosting, with automatic SSL enabled.

---

## ✅ Firebase Hosting Overview

Flutter Web apps are Single Page Applications (SPAs). The compiled output (HTML/CSS/JS) is placed in the `build/web` folder, and deployed using Firebase CLI.

### Flutter Build and Deploy
```bash
flutter build web
firebase deploy --only hosting
```

This creates a hosted version of your app at:

```
https://your-project-id.web.app
```

---

## ✅ Add a Custom Domain via Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com)
2. Open your project (`my-right-portal`)
3. Navigate to **Hosting**
4. Click **"Add custom domain"**
5. Enter your custom domain (e.g., `www.yourlawyerportal.com`)
6. Firebase provides A records and (optionally) CNAME records for DNS setup

---

## ✅ Update DNS on GoDaddy

1. Go to [GoDaddy](https://godaddy.com) and log in
2. Click **My Products**
3. Next to your domain, click **DNS**
4. Remove conflicting A or CNAME records (for `@` or `www`)
5. Add Firebase’s DNS records:

### Example DNS Records

| Type | Host | Points To            | TTL     |
|------|------|-----------------------|---------|
| A    | @    | 199.36.158.100        | Default |
| A    | @    | 199.36.158.101 (if given) | Default |
| CNAME | www | your-site-id.web.app | Default |

---

## ✅ Wait for Firebase to Verify

- DNS propagation may take a few minutes to several hours
- Firebase will show a “Verifying…” message
- Once verified, SSL is automatically provisioned

---

## ✅ Optional: Set Redirect from non-www to www

Update `firebase.json`:

```json
{
  "hosting": {
    "public": "build/web",
    "redirects": [
      {
        "source": "/",
        "destination": "https://www.yourlawyerportal.com",
        "type": 301
      }
    ]
  }
}
```

Then redeploy:
```bash
firebase deploy
```

---

## ✅ Final Result

- Your site is now available at `https://www.yourlawyerportal.com`
- Secure with HTTPS
- Powered by Flutter + Firebase Hosting + GoDaddy DNS

