import $ from 'jquery'

export default {
  data () {
    return {
      appMessages: { successes: [], errors: [] }
    }
  },
  methods: {
  // Display messages methods
    appendSuccess ({message = '', notification = false}) {
      // Reset messages by default on subsequent calls unless resetMessages is false.
      if (this.isBlank(this.appMessages)) { this.resetAppMessages() }
      if (typeof message == 'string') {
        if (notification) {
          this.$store.dispatch('setNotificationSuccesses', message)
        } else {
          this.appMessages.successes.push(message)
        }
      } else {
        message.forEach((msg) => { this.appMessages.successes.push(msg) })
      }
    },
    appendError ({ error = '', notification = false } = {}) {
      let tempError = ''
      tempError = this.appendResponseError(error)
      error = tempError

      this.resetAppMessages()
      if (typeof error == 'string') {
        if (notification) {
          this.$store.dispatch('setNotificationErrors', error)
        } else {
          this.appMessages.errors.push(error)
        }
      } else if (Array.isArray(error)) {
        error.forEach((er) => {
          if (notification) { this.$store.dispatch('setNotificationErrors', er)
          } else {
            this.appMessages.errors.push(er)

          }
        })
      } else if (error == 'Unauthorized Request') {
        this.$router.push({ name: 'login', query: { unauthorized: true }})
      } else {
        this.appMessages.errors.push('Something went wrong')
      }
    },
    appendResponseError (response) {
      let error = ''
      if (response && response.data && response.data.error) {
        error = response.data.error
      } else if (typeof response === 'string' || Array.isArray(response) ) {
        error = response
      } else if (typeof response === 'object') {
        error = JSON.parse(JSON.stringify(response))
        if (error.message) {
          error = error.message
        }
      } else {
        error = 'Undefined response from server'
      }
      return error
    },

    objectAttributize (objPath, oldKey) {
      if (objPath[oldKey] == undefined) { return }
      const newKey = `${oldKey}Attributes`
      delete Object.assign(objPath, {[newKey]: objPath[oldKey]})[oldKey]
    },
    resetAppMessages () {
      this.$store.dispatch('resetNotificationMessages')
      this.appMessages = { successes: [], errors: [] }
    },
    capitalize (string) {
      return string.charAt(0).toUpperCase() + string.slice(1)
    },
    // Helper methods
    isZero (value) {
      return value == 0
    },
    isEmpty (value) {
      if (Array.isArray(value) && value.length == 0) { return true }
      return this.isBlank(value)
    },
    isEmptyObject (value) {
      return (typeof value == typeof {} && Object.keys(value).length === 0)
    },
    isFile (value) {
      return value instanceof File
    },
    isBlank (value) {
      return (value === '' || value == undefined || value == null || this.isEmptyObject(value))
    },
    isUndefined (value) {
      return value == undefined
    },
    isAnyUndefined (values) {
      return values.filter((value) => this.isUndefined(value)).length > 0
    },
    toId (value) {
      return isNaN(value) ? '' : value
    },
    toDestroy (value) {
      return (value == '1' || value == 1) ? 1 : 0
    },
    deepCloneObject (obj) {
      return JSON.parse(JSON.stringify(obj))
    },

    roundCurrency (amount) {
      return Number(`${Math.round(`${amount}e2`)}e-2`)
    },

    cleanCurrency (amount) {
      return parseFloat(amount.toString().replace(/[^0-9.]/g, ''))
    },
    getMask (type = 'phone') {
      if (type == 'phone') {
        return '(###) ###-#### ?X?X?X?X?X?X?X?X?X?X?X?X?X' // Phone number plus 13 extra characters for ext. 121231231 just in case
      } else if (type == 'ssn') {
        return '###-##-####'
      } else if (type == 'tin') {
        return '##-#######'
      } else if (type == 'masked-ssn') {
        return 'XXX-XX-XXXX'
      } else if (type == 'masked-tin') {
        return 'XX-XXXXXXX'
      }
      return ''
    },

    getOrdinalSuffix (num) {
      const int = parseInt(num),
        digits = [int % 10, int % 100],
        ordinals = ['st', 'nd', 'rd', 'th'],
        oPattern = [1, 2, 3, 4],
        tPattern = [11, 12, 13, 14, 15, 16, 17, 18, 19]
      /*
       * return oPattern.includes(digits[0]) && !tPattern.includes(digits[1])
       *   ? int + ordinals[digits[0] - 1]
       *   : int + ordinals[3]
       */
      return oPattern.includes(digits[0]) && !tPattern.includes(digits[1])
        ? `${ordinals[digits[0] - 1]}`
        : `${ordinals[3]}`
    },

    // Expects this.errors to exist
    validatePresenceOf (value, message) {
      if (this.isBlank(value)) { this.appendError({error: message}) }
    },
    validateGreaterThanZero (value, message) {
      if (isNaN(value) || value <= 0) { this.appendError({error: message}) }
    },
    valueify (value) {
      return this.isBlank(value) ? '' : value
    },

    // Date helpers
    beginningOfMonth () {
      const currentDate = new Date()
      return [
        this.padNumberToTwoDigits(currentDate.getMonth() + 1),
        '01',
        currentDate.getFullYear()
      ].join('/')
    },

    beginningOfYear () {
      const currentDate = new Date()
      return [
        '01',
        '01',
        currentDate.getFullYear()
      ].join('/')
    },
    chunkArray (myArray, chunkSize) {
      let index = 0
      const arrayLength = myArray.length
      const tempArray = []
      for (index = 0; index < arrayLength; index += chunkSize) {
        const myChunk = myArray.slice(index, index + chunkSize)
        tempArray.push(myChunk)
      }
      return tempArray
    },

    endOfYear () {
      const currentDate = new Date()
      return [
        '12',
        '31',
        currentDate.getFullYear()
      ].join('/')
    },

    endOfNextYear () {
      const currentDate = new Date()
      return [
        '12',
        '31',
        currentDate.getFullYear() + 1
      ].join('/')
    },

    currentDateString () {
      const currentDate = new Date()
      return [
        this.padNumberToTwoDigits(currentDate.getMonth() + 1),
        this.padNumberToTwoDigits(currentDate.getDate()),
        currentDate.getFullYear()
      ].join('/')
    },

    padNumberToTwoDigits (num) {
      return num.toString().length > 1 ? num.toString() : `0${num}`
    },

    sortStringsStartingWithNumbers (strArr) {
      return strArr.sort((x, y) => {
        if (/^[0-9]/.test(x.name.trim())) {
          return parseInt(x.name.trim().split(' ')[0]) - parseInt(y.name.trim().split(' ')[0])
        }
        return x.name.trim().localeCompare(y.name.trim())

      })
    },

    setUserLoggedIn () {
      this.$http.get('/api/me').then((result) => {
        $('#logged-in-user').html(result.body.email)
      }, (responseError) => {
        this.appendError({error: responseError.body.error})
      })
    }
  },
  created () {
    if (!this.isUndefined($('#logged-in-user').html()) && this.isBlank($('#logged-in-user').html())) {
      this.setUserLoggedIn()
    }
  }
}
