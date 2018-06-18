var app = (function()
{
	// Application object.
	var app = {};

	// Dictionary of beacons.
	var beacons = {};

	// Timer that displays list of beacons.
	var updateTimer = null;

	app.initialize = function()
	{
		document.addEventListener('deviceready', onDeviceReady, false);
	};

	function onDeviceReady()
	{
		// Start tracking beacons!
		startScan();

		// Display refresh timer.
		updateTimer = setInterval(displayBeaconList, 1000);
	}

	function startScan()
	{
		
		function onBeaconsRanged(beaconInfo)
		{
			//console.log('onBeaconsRanged: ' + JSON.stringify(beaconInfo))
			for (var i in beaconInfo.beacons)
			{
				// Insert beacon into table of found beacons.
				// Filter out beacons with invalid RSSI values.
				var beacon = beaconInfo.beacons[i];
				if (beacon.rssi < 0)
				{
					beacon.timeStamp = Date.now();
					var key = beacon.uuid + ':' + beacon.major + ':' + beacon.minor;
					beacons[key] = beacon;
					
					
				}
			}
		}

		function onError(errorMessage)
		{
			console.log('Ranging beacons did fail: ' + errorMessage);
		}

		// Request permission from user to access location info.
		// This is needed on iOS 8.
		estimote.beacons.requestAlwaysAuthorization();

		// Start ranging beacons.
		estimote.beacons.startRangingBeaconsInRegion(
			{}, // Empty region matches all beacons
			    // with the Estimote factory set UUID.
			onBeaconsRanged,
			onError);
	}

	function displayBeaconList()
	{
	
		
		// Clear beacon list.
		$('#found-beacons').empty();

		var timeNow = Date.now();

		// Update beacon list.
		$.each(beacons, function(key, beacon)
		{
			// Only show beacons that are updated during the last 60 seconds.
			if (beacon.timeStamp + 1000 > timeNow)
			{
		
		
		
		/* #######################  Auflistung der Beacons  ######################### */	
		
		// Kunstweg (Tour 1)
			
		if (beacon.major == 40822 && beacon.minor == 1031 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg27.html";
		}
			
		else if (beacon.major == 40822 && beacon.minor == 1032 && beacon.distance < 20 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg28.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1033 && beacon.distance < 8 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg29.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1156 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg30.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1049 && beacon.distance < 8 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg31.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1048 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg32.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1037 && beacon.distance < 10 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg33.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1038 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg34.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1039 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg35.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1052 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg36.html";
		}
		
		// Fundort (Tour 2)
		
		else if (beacon.major == 40822 && beacon.minor == 1053 && beacon.distance < 20 && tour == 2) {
			BeaconLink = "../rundgang/fundort18.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1023 && beacon.distance < 15 && tour == 2) {
			BeaconLink = "../rundgang/fundort19.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1024 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort20.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1050 && beacon.distance < 4 && tour == 2) {
			BeaconLink = "../rundgang/fundort21.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1026 && beacon.distance < 5 && tour == 2) {
			BeaconLink = "../rundgang/fundort22.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1027 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort23.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1051 && beacon.distance < 10 && tour == 2) {
			BeaconLink = "../rundgang/fundort24.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1029 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort25.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1030 && beacon.distance < 15 && tour == 2) {
			BeaconLink = "../rundgang/fundort26.html";
		}
		
		// MuseumsCafé (Tour 3)
		
		else if (beacon.major == 40822 && beacon.minor == 1041 && beacon.distance < 16 && tour == 3) {
			BeaconLink = "../dasmuseum/museumscafe_deal.html";
		}
		
		// MuseumsShop (Tour 4)
		
		else if (beacon.major == 40822 && beacon.minor == 1042 && beacon.distance < 7 && tour == 4) {
			BeaconLink = "../meinmuseum/specialoffer.html";
		}
		
		// Dauerausstellung (Tour 5)
		
		else if (beacon.major == 40822 && beacon.minor == 1001 && beacon.distance < 6 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung01.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1002 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung02.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1003 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung03.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1004 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1005 && beacon.distance < 4 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1006 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1007 && beacon.distance < 4 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung05.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1008 && beacon.distance < 4 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung06.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1009 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung07.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1010 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung08.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1011 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung09.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1012 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung10.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1013 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung10.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1014 && beacon.distance < 2 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung11.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1015 && beacon.distance < 4 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung12.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1016 && beacon.distance < 4 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung13.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1017 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung14.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1018 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung15.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1019 && beacon.distance < 3 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung16.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1020 && beacon.distance < 6 && tour == 5) {
			BeaconLink = "../rundgang/dauerausstellung17.html";
		}


		// Dauerausstellung Kinder (Tour 6)
		
		else if (beacon.major == 40822 && beacon.minor == 1002 && beacon.distance < 3 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder02.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1004 && beacon.distance < 2 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1005 && beacon.distance < 4 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1006 && beacon.distance < 3 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder04.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1008 && beacon.distance < 4 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder06.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1010 && beacon.distance < 3 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder08.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1012 && beacon.distance < 2 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder10.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1013 && beacon.distance < 2 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder10.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1014 && beacon.distance < 2 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder11.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1015 && beacon.distance < 4 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder12.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1017 && beacon.distance < 3 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder14.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1019 && beacon.distance < 3 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder16.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1020 && beacon.distance < 6 && tour == 6) {
			BeaconLink = "../rundgang/dauerausstellung_kinder17.html";
		}
		
		
		// Architektur (Tour 7)
		
		else if (beacon.major == 40822 && beacon.minor == 1053 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur18.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1021 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur44.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1043 && beacon.distance < 3 && tour == 7) {
			BeaconLink = "../rundgang/architektur39.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1044 && beacon.distance < 2 && tour == 7) {
			BeaconLink = "../rundgang/architektur40.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1001 && beacon.distance < 6 && tour == 7) {
			BeaconLink = "../rundgang/architektur01.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1045 && beacon.distance < 10 && tour == 7) {
			BeaconLink = "../rundgang/architektur41.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1042 && beacon.distance < 7 && tour == 7) {
			BeaconLink = "../rundgang/architektur38.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1008 && beacon.distance < 3 && tour == 7) {
			BeaconLink = "../rundgang/architektur06.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1041 && beacon.distance < 16 && tour == 7) {
			BeaconLink = "../rundgang/architektur37.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1047 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur43.html";
		}
		
		
		
		// Kunstweg (Reserve Beacon Einträge)
			
		else if (beacon.major == 40822 && beacon.minor == 1153 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg27.html";
		}
			
		else if (beacon.major == 40822 && beacon.minor == 1154 && beacon.distance < 20 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg28.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1155 && beacon.distance < 8 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg29.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1172 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg30.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1157 && beacon.distance < 8 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg31.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1158 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg32.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1159 && beacon.distance < 10 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg33.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1160 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg34.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1161 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg35.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1162 && beacon.distance < 15 && tour == 1) {
			BeaconLink = "../rundgang/kunstweg36.html";
		}
		
		
		// Fundort (Reserve Beacon Einträge)
		
		else if (beacon.major == 40822 && beacon.minor == 1163 && beacon.distance < 20 && tour == 2) {
			BeaconLink = "../rundgang/fundort18.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1164 && beacon.distance < 15 && tour == 2) {
			BeaconLink = "../rundgang/fundort19.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1165 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort20.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1166 && beacon.distance < 4 && tour == 2) {
			BeaconLink = "../rundgang/fundort21.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1167 && beacon.distance < 5 && tour == 2) {
			BeaconLink = "../rundgang/fundort22.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1168 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort23.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1169 && beacon.distance < 10 && tour == 2) {
			BeaconLink = "../rundgang/fundort24.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1170 && beacon.distance < 7 && tour == 2) {
			BeaconLink = "../rundgang/fundort25.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1171 && beacon.distance < 15 && tour == 2) {
			BeaconLink = "../rundgang/fundort26.html";
		}
		
		
		// Architektur (Reserve Einträge, nur Outdoor und Einzelverwendung)
		
		else if (beacon.major == 40822 && beacon.minor == 1163 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur18.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1173 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur44.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1174 && beacon.distance < 3 && tour == 7) {
			BeaconLink = "../rundgang/architektur39.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1175 && beacon.distance < 2 && tour == 7) {
			BeaconLink = "../rundgang/architektur40.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1176 && beacon.distance < 10 && tour == 7) {
			BeaconLink = "../rundgang/architektur41.html";
		}
		
		else if (beacon.major == 40822 && beacon.minor == 1177 && beacon.distance < 20 && tour == 7) {
			BeaconLink = "../rundgang/architektur43.html";
		}
		
		
		// else
		
		else {
			BeaconLink = ""; 
		} 
		
		/* ######################  Ende Auflistung Beacons  ########################*/	
			
			
			
			
			
				// Create tag to display beacon data.
				var element = $(
					'<li>'
					+	'Major: ' + beacon.major + '<br />'
					+	'Minor: ' + beacon.minor + '<br />'
					+	proximityHTML(beacon)
					+	distanceHTML(beacon)
					+	rssiHTML(beacon)
					+ '</li>'
				);

				$('#found-beacons').append(element);
			}
		});
	}

	function proximityHTML(beacon)
	{
		var proximity = beacon.proximity;
		if (!proximity) { return ''; }

		var proximityNames = [
			'Unknown',
			'Immediate',
			'Near',
			'Far'];

		return 'Proximity: ' + proximityNames[proximity] + '<br />';
	}

	function distanceHTML(beacon)
	{
		var meters = beacon.distance;
		if (!meters) { return ''; }

		var distance =
			(meters > 1) ?
				meters.toFixed(3) + ' m' :
				(meters * 100).toFixed(3) + ' cm';

		if (meters < 0) { distance = '?'; }

		return 'Distance: ' + distance + '<br />'
	}

	function rssiHTML(beacon)
	{
		var beaconColors = [
			'rgb(214,212,34)', // unknown
			'rgb(215,228,177)', // mint
			'rgb(165,213,209)', // ice
			'rgb(45,39,86)', // blueberry
			'rgb(200,200,200)', // white
			'rgb(200,200,200)', // transparent
		];

		// Get color value.
		var color = beacon.color || 0;
		// Eliminate bad values (just in case).
		color = Math.max(0, color);
		color = Math.min(5, color);
		var rgb = beaconColors[color];

		// Map the RSSI value to a width in percent for the indicator.
		var rssiWidth = 1; // Used when RSSI is zero or greater.
		if (beacon.rssi < -100) { rssiWidth = 100; }
		else if (beacon.rssi < 0) { rssiWidth = 100 + beacon.rssi; }
		// Scale values since they tend to be a bit low.
		rssiWidth *= 1.5;

		var html =
			'RSSI: ' + beacon.rssi + '<br />'
			+ '<div style="background:' + rgb + ';height:20px;width:'
			+ 		rssiWidth + '%;"></div>'

		return html;
	}

	return app;
})();

app.initialize();
