const { environment } = require('@rails/webpacker')
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin

environment.plugins.append(
  'BundleAnalyzerPlugin',
  new BundleAnalyzerPlugin()
)