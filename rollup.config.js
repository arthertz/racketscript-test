import { getBabelOutputPlugin } from '@rollup/plugin-babel';

export default {
  input: 'js-build/modules/factorial.rkt.js',
  plugins: [
    getBabelOutputPlugin({
      presets: ['@babel/preset-env']
    })
  ],
  output: [
    { file: 'bundle.js', format: 'cjs' },
  ]
};