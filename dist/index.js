"use strict";

var _interopRequireWildcard = require("@babel/runtime/helpers/interopRequireWildcard");

Object.defineProperty(exports, "__esModule", {
  value: true
});
var _exportNames = {};
exports["default"] = void 0;

var _render = _interopRequireWildcard(require("./render"));

Object.keys(_render).forEach(function (key) {
  if (key === "default" || key === "__esModule") return;
  if (Object.prototype.hasOwnProperty.call(_exportNames, key)) return;
  Object.defineProperty(exports, key, {
    enumerable: true,
    get: function get() {
      return _render[key];
    }
  });
});
var _default = _render["default"];
exports["default"] = _default;