cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-plugin-estimote/plugin/src/js/EstimoteBeacons.js",
        "id": "cordova-plugin-estimote.EstimoteBeacons",
        "pluginId": "cordova-plugin-estimote",
        "clobbers": [
            "estimote"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/barcode.js",
        "id": "com.mirasense.scanditsdk.plugin.Barcode",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.Barcode"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/barcodepicker.js",
        "id": "com.mirasense.scanditsdk.plugin.BarcodePicker",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.BarcodePicker"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/license.js",
        "id": "com.mirasense.scanditsdk.plugin.License",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.License"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/margins.js",
        "id": "com.mirasense.scanditsdk.plugin.Margins",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.Margins"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/point.js",
        "id": "com.mirasense.scanditsdk.plugin.Point",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.Point"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/quadrilateral.js",
        "id": "com.mirasense.scanditsdk.plugin.Quadrilateral",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.Quadrilateral"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/rect.js",
        "id": "com.mirasense.scanditsdk.plugin.Rect",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.Rect"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/overlay.js",
        "id": "com.mirasense.scanditsdk.plugin.ScanOverlay",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.ScanOverlay"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/session.js",
        "id": "com.mirasense.scanditsdk.plugin.ScanSession",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.ScanSession"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/settings.js",
        "id": "com.mirasense.scanditsdk.plugin.ScanSettings",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.ScanSettings"
        ]
    },
    {
        "file": "plugins/com.mirasense.scanditsdk.plugin/src/symbologysettings.js",
        "id": "com.mirasense.scanditsdk.plugin.SymbologySettings",
        "pluginId": "com.mirasense.scanditsdk.plugin",
        "clobbers": [
            "Scandit.SymbologySettings"
        ]
    },
    {
        "file": "plugins/cordova-plugin-inappbrowser/www/inappbrowser.js",
        "id": "cordova-plugin-inappbrowser.inappbrowser",
        "pluginId": "cordova-plugin-inappbrowser",
        "clobbers": [
            "cordova.InAppBrowser.open",
            "window.open"
        ]
    },
    {
        "file": "plugins/cordova-plugin-splashscreen/www/splashscreen.js",
        "id": "cordova-plugin-splashscreen.SplashScreen",
        "pluginId": "cordova-plugin-splashscreen",
        "clobbers": [
            "navigator.splashscreen"
        ]
    },
    {
        "file": "plugins/cordova-plugin-vibration/www/vibration.js",
        "id": "cordova-plugin-vibration.notification",
        "pluginId": "cordova-plugin-vibration",
        "merges": [
            "navigator.notification",
            "navigator"
        ]
    },
    {
        "file": "plugins/at.modalog.cordova.plugin.cache/www/Cache.js",
        "id": "at.modalog.cordova.plugin.cache.Cache",
        "pluginId": "at.modalog.cordova.plugin.cache",
        "clobbers": [
            "cache"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{}
// BOTTOM OF METADATA
});