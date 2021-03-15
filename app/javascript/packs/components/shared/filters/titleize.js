export default function (str) {
  if (str.charAt(0).toUpperCase() == str.charAt(0)) {
    return str
  }
  str = str.replace(/_/g, ' ')
  return str.charAt(0).toUpperCase() + str.replace(/([A-Z])/g, ' $1').slice(1)
}