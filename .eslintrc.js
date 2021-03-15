module.exports = {
  globals: {
    '_': true,
    'Stripe': true,
    'Chart': true
  },
  env: {
    'browser': true,
    'es6': true,
    'node': true,
    'jquery': true,
    'commonjs': true
  },
  parserOptions: {
    'ecmaVersion': 2019
  },
  extends: [
    'eslint:recommended',
    'plugin:vue/recommended'
  ],
  rules: {
    'arrow-spacing': 'error',
    'comma-dangle': ['error', 'never'],
    'indent': ['error', 2],
    'key-spacing': ['error', { 'beforeColon': false }],
    'linebreak-style': ['error', 'unix'],
    'max-depth': ['error', 4],
    'max-len': ['error', { 'code': 250, 'ignoreComments': true }],
    'max-lines-per-function': ['error', { 'max': 100 }],
    'max-params': ['error', 4],
    'multiline-comment-style': ['error', 'starred-block'],
    'no-console': 0,
    'no-multi-spaces': 'error',
    'no-trailing-spaces': ['error', { 'ignoreComments': true }],
    'no-unused-vars': 'error',
    'no-var': 'error',
    'prefer-const': 'error',
    'quotes': ['error', 'single'],
    'semi': ['error', 'never'],
    'space-before-blocks': 'error',
    'space-before-function-paren': ['error', 'always'],
    'spaced-comment': ['error', 'always'],
    'vue/attributes-order': 'error',
    'vue/html-end-tags': 'error',
    'vue/html-indent': [ 'error', 2, {
      'attribute': 1,
      'closeBracket': 0,
      'alignAttributesVertically': true
    }],
    'vue/max-attributes-per-line': [1, {
      'singleline': 6,
      'multiline': { 'max': 1, 'allowFirstLine': false }
    }],
    'vue/no-use-v-if-with-v-for': ['error', {
      'allowUsingIterationVar': false
    }],
    'vue/no-v-html': 0,
    'vue/order-in-components': 'error',
    'vue/require-default-prop': 'error',
    'vue/require-v-for-key': 'error',
    'vue/html-closing-bracket-newline': ['error', {
      'singleline': 'never',
      'multiline': 'never'
    }],
    'vue/html-closing-bracket-spacing': ['error', {
      'startTag': 'never',
      'endTag': 'never',
      'selfClosingTag': 'never'
    }]
  }
};
