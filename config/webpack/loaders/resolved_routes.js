const path = require('path')

module.exports = {
  resolve: {
    alias: {
      '@components': path.resolve(__dirname, '..', '..', '..', 'app/javascript/packs/components'),
      '@shared': path.resolve(__dirname, '..', '..', '..', 'app/javascript/packs/components/shared'),
      '@utilities': path.resolve(__dirname, '..', '..', '..', 'app/javascript/packs/utilities'),
      '@styles': path.resolve(__dirname, '..', '..', '..', 'app/javascript/packs/styles'),
      '@submodules': path.resolve(__dirname, '..', '..', '..', 'app/javascript/packs/submodules'),
      '@node_modules': path.resolve(__dirname, '..', '..', '..', 'node_modules')
    }
  }
}
