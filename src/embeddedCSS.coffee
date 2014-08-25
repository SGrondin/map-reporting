exports.defaultCSS = """
		.mapReporting #defaultBackground {
			fill-opacity : 0.7;
			fill : #E5E5E5;
		}
		.mapReporting rect {
			fill-opacity : 0.7;
			fill : #FFFFFF;
		}
		.mapReporting text {
			font-family : Arial;
		}
		.mapReporting a {
			font-family : Arial;
			text-decoration : underline;
		}
		.mapReporting .nodatapattern {
			stroke : #FFFFFF;
			stroke-opacity : 0.75;
			stroke-width : 2px;
		}
		.mapReporting .stop1 {
			stop-opacity : 0.45;
		}
		.mapReporting .stop2 {
			stop-opacity : 0.85;
		}
		.mapReporting .scaleNumbers {
			font-weight: bold;
			font-size:18;
			fill:#000000;
			stroke:#FFFFFF;
			-webkit-user-select : none;
			-moz-user-select : none;
			-ms-user-select : none;
			-o-user-select : none;
			user-select : none;
		}
		.mapReporting .zoneid {
			stroke : #000000;
			fill : #000000;
			stroke-width : 2px;
			font-family : Courier;
			font-size : 32px;
			-webkit-user-select : none;
			-moz-user-select : none;
			-ms-user-select : none;
			-o-user-select : none;
			user-select : none;
		}
		.mapReporting .zone {
			stroke-opacity : 0.4;
			stroke-width : 4px;
		}
		.mapReporting .selected {
			stroke : #000000;
			stroke-opacity : 1;
			stroke-width : 6px;
			stroke-dasharray : none;
		}
		.mapReporting .hovered {
			stroke : #000000;
			stroke-opacity : 1;
			stroke-width : 6px;
			stroke-dasharray : 12,8;
		}
	"""