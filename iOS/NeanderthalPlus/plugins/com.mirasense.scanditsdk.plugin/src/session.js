
function ScanSession(newlyRecognizedCodes, newlyLocalizedCodes, allRecognizedCodes) {
	this.newlyRecognizedCodes = newlyRecognizedCodes;
	this.newlyLocalizedCodes = newlyLocalizedCodes;
	this.allRecognizedCodes = allRecognizedCodes;
}

ScanSession.prototype.stopScanning = function() {
    cordova.exec(null, null, "ScanditSDK", "stop", []);
}

ScanSession.prototype.pauseScanning = function() {
    cordova.exec(null, null, "ScanditSDK", "pause", []);
}

module.exports = ScanSession;