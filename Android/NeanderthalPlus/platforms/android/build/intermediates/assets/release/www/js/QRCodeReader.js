document.addEventListener("deviceready", init, false);
function init() {
	document.querySelector("#startScan").addEventListener("touchend", startScan, false);
	
}

function startScan() {

	cordova.plugins.barcodeScanner.scan(
		function (result) {
        	$.mobile.changePage( "../rundgang/"+qr+"" +result.text+ ".html", { transition: "fade", changeHash: false });
        	beacon = 0;

		}, 
		function (error) {
			
		}
	);

}