exports.css = """
		rect {
			fill-opacity : 0.7;
			fill : #FFFFFF;
		}
		text {
			font-family : Arial;
		}
		a {
			font-family : Arial;
			text-decoration : underline;
		}
		.nodatapattern {
			stroke : #FFFFFF;
			stroke-opacity : 0.75;
			stroke-width : 2px;
		}
		.stop1 {
			stop-opacity : 0.45;
		}
		.stop2 {
			stop-opacity : 0.85;
		}
		.scaleNumbers {
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
		.zoneid {
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
		.zone {
			stroke-opacity : 0.4;
			stroke-width : 4px;
		}
		.selected {
			stroke : #000000;
			stroke-opacity : 1;
			stroke-width : 6px;
			stroke-dasharray : none;
		}
		.hovered {
			stroke : #000000;
			stroke-opacity : 1;
			stroke-width : 6px;
			stroke-dasharray : 12,8;
		}
	"""