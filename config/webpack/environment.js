const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const vue = require('./loaders/vue')
const ResolvedRoutes = require('./loaders/resolved_routes.js')
// const BundleAnalyzer = require('./loaders/analysis.js')
console.log('WEBPACKER ENV', process.env.NODE_ENV)
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    'window.Tether': 'tether',
    Popper: ['popper.js', 'default'],
    ActionCable: 'actioncable',
    Vue: 'vue',
    VueResource: 'vue-resource'
  })
)
environment.loaders.prepend('vue', vue)
const VueLoaderPlugin = require('vue-loader/lib/plugin')
environment.plugins.prepend(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
)
environment.config.merge(ResolvedRoutes)
// environment.config.merge(BundleAnalyzer)

module.exports = environment
