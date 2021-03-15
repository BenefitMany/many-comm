const CompressionPlugin = require('compression-webpack-plugin')
const { environment } = require('@rails/webpacker')

environment.plugins.append(
  'Compression Plugin',
  new CompressionPlugin({
    asset: '[path].gz[query]',
    algorithm: 'gzip',
    test: /\.js$|\.css$|\.html$|\.eot?.+$|\.ttf?.+$|\.woff?.+$|\.svg?.+$/,
    threshold: 10240,
    minRatio: 0.8
  })
)