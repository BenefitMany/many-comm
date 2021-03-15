// https://alligator.io/vuejs/model-form-validation-vuelidate/
export const PaymentAmountValidator = (value, component) => { // eslint-disable-line no-unused-vars
  const amt = parseFloat(value)
  if(amt > 0) { return true }
  return false
}
