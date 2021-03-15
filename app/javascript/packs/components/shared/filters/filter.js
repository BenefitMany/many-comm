import Vue from 'vue/dist/vue.esm'

import BooleanYesNo from './boolean_yes_no.js'
import CapitalizeFilter from './capitalize.js'
import CurrencyFilter from './currency.js'
import dateMMDDYYHHMM from './dates/mm_dd_yy_hh_mm.js'
import dateMMDDYYYY from './dates/mm_dd_yyyy.js'
import dateMMDDYY from './dates/mm_dd_yy.js'
import DecimalToPercent from './decimal_to_percent.js'
import intToPercent from './int_to_percent.js'
import LowerCaseFilter from './lowercase.js'
import Titleize from './titleize.js'
import minutesToHoursMinutes from './minutes_to_hours_minutes.js'
import defaultString from './default_string.js'


Vue.filter('booleanYesNo', BooleanYesNo)
Vue.filter('capitalize', CapitalizeFilter)
Vue.filter('currency', CurrencyFilter)
Vue.filter('dateMMDDYYYY', dateMMDDYYYY)
Vue.filter('dateMMDDYYHHMM', dateMMDDYYHHMM)
Vue.filter('dateMMDDYY', dateMMDDYY)
Vue.filter('decimalToPercent', DecimalToPercent)
Vue.filter('defaultString', defaultString)
Vue.filter('minutesToHoursMinutes', minutesToHoursMinutes)
Vue.filter('intToPercent', intToPercent)
Vue.filter('lowercase', LowerCaseFilter)
Vue.filter('titleize', Titleize)
