import js from "@eslint/js";
import globals from "globals";

export default [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      globals: {
        ...globals.node,
      },
    },
    plugins: {},
    rules: {
      ...js.configs.recommended.rules,
      "quotes": ["error", "double", { allowTemplateLiterals: true }],
      "prefer-arrow-callback": "error",
      "no-restricted-globals": ["error", "name", "length"]
    }
  }
];