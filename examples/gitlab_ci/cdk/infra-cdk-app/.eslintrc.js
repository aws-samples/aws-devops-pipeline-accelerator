module.exports = {
    "env": {
        "browser": true,
        "es2021": true,
        "jest": true
    },
    "extends": [
        "eslint:recommended",
        "plugin:react/recommended"
    ],
    "overrides": [
    ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module",
        "angular": false,
    },
    "plugins": [
        "react"
    ],
    "rules": {

    },
    "ignorePatterns": ["lib/*.js", "lib/*.ts", "*.js","bin/*.js","jest.config.js"],
}
