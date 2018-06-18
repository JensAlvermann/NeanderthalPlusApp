
var ScanOverlay = cordova.require("com.mirasense.scanditsdk.plugin.ScanOverlay");
var ScanSettings = cordova.require("com.mirasense.scanditsdk.plugin.ScanSettings");
var ScanSession = cordova.require("com.mirasense.scanditsdk.plugin.ScanSession");
var Barcode = cordova.require("com.mirasense.scanditsdk.plugin.Barcode");

function BarcodePicker(scanSettings) {
	if (scanSettings instanceof ScanSettings) {
		this.scanSettings = scanSettings;
	} else {
		this.scanSettings = new ScanSettings();
	}
	
	// Keep the overlay private.
	var overlay = new ScanOverlay(this);
	this.getOverlayView = function() {
		return overlay;
	}
	
    this.isShown = false;
	this.continuousMode = false;
	this.portraitMargins = null;
	this.landscapeMargins = null;
	this.orientations = [];
}

BarcodePicker.Orientation = {
	PORTRAIT: "portrait",
	PORTRAIT_UPSIDE_DOWN: "portraitUpsideDown",
	LANDSCAPE_RIGHT: "landscapeLeft",
	LANDSCAPE_LEFT: "landscapeRight"
}


BarcodePicker.prototype.show = function(success, manual, failure) {
	var options = {"continuousMode": this.continuousMode};
	
	if (this.portraitMargins != null) {
		options["portraitMargins"] = this.portraitMargins;
	}
	if (this.landscapeMargins != null) {
		options["landscapeMargins"] = this.landscapeMargins;
	}
	if (this.orientations.length > 0) {
		options["orientations"] = this.orientations;
	}
	
	cordova.exec(function(session) {
		if (typeof session === 'string' || session instanceof String) {
			manual(session);
		} else {
			var newlyRecognized = BarcodePicker.codeArrayFromGenericArray(session.newlyRecognizedCodes);
			var newlyLocalized = BarcodePicker.codeArrayFromGenericArray(session.newlyLocalizedCodes);
			var all = BarcodePicker.codeArrayFromGenericArray(session.allRecognizedCodes);
			var properSession = new ScanSession(newlyRecognized, newlyLocalized, all);
			success(properSession);
		}
	}, failure, "ScanditSDK", "show", [this.scanSettings, options, this.getOverlayView()]);
    this.isShown = true;
}

BarcodePicker.codeArrayFromGenericArray = function(genericArray) {
	var codeArray = [];
	for (var i = 0; i < genericArray.length; i++) {
		var code = new Barcode(genericArray[i].gs1DataCarrier, genericArray[i].recognized);
		code.symbology = genericArray[i].symbology;
		code.data = genericArray[i].data;
		codeArray.push(code);
	}
	return codeArray;
}

BarcodePicker.prototype.applyScanSettings = function(settings) {
	if (this.isShown && settings instanceof ScanSettings) {
		cordova.exec(null, null, "ScanditSDK", "applySettings", [settings]);
	}
}

BarcodePicker.prototype.cancel = function() {
    this.isShown = false;
    cordova.exec(null, null, "ScanditSDK", "cancel", []);
}

BarcodePicker.prototype.startScanning = function(paused) {
    if (!this.isShown) {
        return;
    }
    var options = {
        paused : paused !== undefined ? !!paused : false
    };
    cordova.exec(null, null, "ScanditSDK", "start", [options]);
}

BarcodePicker.prototype.stopScanning = function() {
	if (this.isShown) {
    	cordova.exec(null, null, "ScanditSDK", "stop", []);
    }
}

BarcodePicker.prototype.pauseScanning = function() {
	if (this.isShown) {
	    cordova.exec(null, null, "ScanditSDK", "pause", []);
	}
}

BarcodePicker.prototype.resumeScanning = function() {
	if (this.isShown) {
    	cordova.exec(null, null, "ScanditSDK", "resume", []);
    }
}

BarcodePicker.prototype.switchTorchOn = function(enabled) {
	if (this.isShown) {
    	cordova.exec(null, null, "ScanditSDK", "torch", [enabled]);
    }
}

BarcodePicker.prototype.setOrientations = function(orientations) {
	this.orientations = orientations;
	if (this.isShown) {
    	cordova.exec(null, null, "ScanditSDK", "updateOverlay", [{"orientations": orientations}]);
	}
}

BarcodePicker.prototype.setMargins = function(portrait, landscape, animationDuration) {
	if (portrait == null) {
		this.portraitMargins = [0, 0, 0, 0];
	} else {
		this.portraitMargins = [portrait.left, portrait.top, 
								portrait.right, portrait.bottom];
	}
	if (landscape == null) {
		this.landscapeMargins = [0, 0, 0, 0];
	} else {
		this.landscapeMargins = [landscape.left, landscape.top, 
								 landscape.right, landscape.bottom];
	}
	if (this.isShown) {
		var duration = 0;
		if (typeof animationDuration !== "undefined") {
			duration = animationDuration;
		}
    	cordova.exec(null, null, "ScanditSDK", "resize", [{"portraitMargins": this.portraitMargins,
    													   "landscapeMargins": this.landscapeMargins,
    													   "animationDuration": duration}]);
	}
}

module.exports = BarcodePicker;
