import { getBabelOutputPlugin } from '@rollup/plugin-babel';

export default commandLineArgs => {
  return {
    input: 'js-build/modules/' + commandLineArgs.input,
    plugins: [
      getBabelOutputPlugin({
        presets: ['@babel/preset-env']
      })
    ],
    output: [
      { file: 'bundle.js', format: 'cjs' },
    ]
  }
};