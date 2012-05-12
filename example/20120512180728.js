// 20120512180728.js
(function() {
    var require = function(module) {
        return require.modules[module];
    }
    require.modules = {};
    var exports;
    var context;
// scripts/test1.coffee
exports = {};
    context = { window : window, document : document, require : require };
    (function(exports) {
// source scripts/test1.coffee
exports.aFun = function() {
  return "aFun from test1";
};
// end source scripts/test1.coffee
}).call(context, exports);
    require.modules['test1'] = exports;
// scripts/test2.coffee
exports = {};
    context = { window : window, document : document, require : require };
    (function(exports) {
// source scripts/test2.coffee
exports.aFun = function() {
  return "aFun from test2";
};
// end source scripts/test2.coffee
}).call(context, exports);
    require.modules['test2'] = exports;
// scripts/zzz-main.coffee
exports = {};
    context = { window : window, document : document, require : require };
    (function(exports) {
// source scripts/zzz-main.coffee
document.write(require('test1').aFun());

document.write(require('test2').aFun());
// end source scripts/zzz-main.coffee
}).call(context, exports);
    require.modules['zzz-main'] = exports;
}).call(this);
