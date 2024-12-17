module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", {"allowTemplateLiterals": true}],
    "no-unused-vars": "warn", // Altere de "error" para "warn" ou "off"
    "require-jsdoc": "off", // Desativa obrigatoriedade de JSDoc
    "indent": ["error", 2], // Define indentação de 2 espaços
    "max-len": ["warn", {"code": 100}], // Permite linhas até 100 caracteres
    "comma-dangle": ["error", "always-multiline"], // Exige vírgulas em listas multilinhas
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
