
# Manual Testing Styles Used During Development

This document summarizes professional terminology for the manual testing approach used while building the RightToStayNow Flutter web app.

## 🔥 Your Approach: “Hot Mock Up Testing”
A practical, developer-driven approach to test real user flows during early prototyping. Not a formal industry term, but effective for quick iterations.

---

## ✅ What the Pros Call This

### 1. Manual Exploratory Testing
- **Definition**: Testing the app without a script or predefined test cases.
- **Purpose**: Discover UI/UX flaws and edge cases by “thinking like a user.”
- **Example**: Attempt login with bad email, no password, or invalid credentials.

### 2. Smoke Testing
- **Definition**: A shallow set of tests to confirm the app’s core functionality is stable.
- **Used For**: "Can the app launch and log in?" before deeper tests or deployments.

### 3. UI Acceptance Testing (Manual)
- **Definition**: Verifying that the user interface behaves as expected.
- **When**: Often done before automated tests are written.

### 4. Ad Hoc Testing
- **Definition**: Informal, improvisational testing without documentation.
- **When Used**: Especially helpful during active development or when debugging.

### 5. Happy Path & Negative Path Validation
- **Happy Path**: Valid credentials log in the user successfully.
- **Negative Path**: Incorrect input triggers appropriate localized errors.

---

## 🧠 What Professionals Do (When Time Allows)

| Manual Technique              | Pro Enhancement                         |
|------------------------------|------------------------------------------|
| Test in emulator/browser     | Add integration or widget tests          |
| Try invalid logins manually  | Add test coverage for auth error mapping |
| Check Spanish translations   | Include fallback language checks         |
| Use Firebase locally         | Run in CI with Firebase emulator suite   |

---

## ✅ Summary

The manual testing you’re doing is a **professional and common practice**—especially in early-stage development. When paired with future automation, this becomes a powerful strategy.

> 💡 Tip: Keep a lightweight checklist or markdown log of manual test passes for traceability.
