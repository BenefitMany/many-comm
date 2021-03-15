const environment = require('./environment')
const CommonChunks = require('./loaders/common_chunks.js')
const CompressionPlugin = require('./loaders/compression.js')

environment.loaders.append('json', { test: /\.json$/, use: 'json-loader' })
environment.config.merge(CommonChunks)

// environment.config.merge(CompressionPlugin)

module.exports = environment.toWebpackConfig()
