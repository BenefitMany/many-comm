const environment = require('./environment')
const CommonChunks = require('./loaders/common_chunks.js')
const CompressionPlugin = require('./loaders/compression.js')

environment.loaders.append('json', { test: /\.json$/, use: 'json-loader' })
environment.config.merge(CommonChunks)

environment.config.merge(CompressionPlugin)
if (environment.plugins.getIndex('UglifyJs') !== -1) {
  const plugin = environment.plugins.get('UglifyJs')
  plugin.options.uglifyOptions.ecma = 5
}

module.exports = environment.toWebpackConfig()
