map-reporting
=============

Generate SVG images with interactive areas to display geographic data.

Low resolution static preview:
<img src="http://simongrondin.name/files/map-reporting/map2preview.png" />

[Click here for a high resolution interative example.](http://simongrondin.name/files/map-reporting/map2.svg) The scale is clickable


## Installation

```
npm install map-reporting
```

## Usage
```generateMap``` returns a valid SVG.
```javascript
var map = require("map-reporting");

svg = map.generateMap(config, zones, background);
```

### Config

```config``` is an object with the following structure:

```json
{
	"width":800,                     // SVG file width
	"height":700,                    // SVG file height
	"background":{
		"width":800,                 // Background bitmap width
		"height":531,                // Background bitmap height
		"x":0,                       // Background bitmap top left corner x
		"y":160,                     // Background bitmap top left corner y
		"saturation":1.0             // Background bitmap color saturation (0 to 1)
	},
	"dashboard":{
		"x":10,                      // Dashboard top left corner x
		"y":10,                      // Dashboard top left corner y
		"width":480,                 // Dashboard width
		"height":150                 // Dashboard height
	},
	"scale":{
		"initial":"green",           // Scale default color: "green" or "blue"
		"alternate":"blue",          // Scale second color: "green" or "blue"
		"width":240,                 // Scale width
		"height":20,                 // Scale height
		"x":500,                     // Scale top left corner x
		"y":10                       // Scale top right corner y
	},
	"threshold":70,                  // Values above the threshold are considered good
	"IDs":{
		"show":true,                 // Draw the zones' ID
		"color":"#000000"            // ID text color
	},
	"labels":{
		"value":"Satisfaction: ",    // The value's label in the dashboard
		"link":"View data"           // Link text
	}
}
```

### Zones

```zones``` is an array of objects with the following structure:
```javascript
zones = [
	{"ID":"A", "link":"http://google.com/?q=Aisles", "name":"Aisles", "coordinates":"[97,157], [370,157], [370,355], [97,355]", "value":0},
	{"ID":"B", "link":"http://google.com/?q=Checkout", "name":"Checkout", "coordinates":"[182,384], [182,411], [361,411], [361,384]", "value":15},
	{"ID":"C", "link":"http://google.com/?q=Medical", "name":"Medical", "coordinates":"[31,231], [75,231], [75,379], [152,379], [152,411], [31,411]", "value":30},
	{"ID":"D", "link":"http://google.com/?q=Raw ingredients", "name":"Raw ingredients", "coordinates":"[76,64], [615,64], [615,134], [76,136]", "value":45},
	{"ID":"E", "link":"http://google.com/?q=Bakery", "name":"Bakery", "coordinates":"[381,157], [438,157], [438,234], [567,234], [567,255], [438,255], [440,414], [381,414]", "value":60},
	{"ID":"F", "link":"http://google.com/?q=Produce", "name":"Produce", "coordinates":"[453,157], [615,157], [617,315], [584,315], [584,223], [453,224]", "value":75},
	{"ID":"G", "link":"http://google.com/?q=Prepared meals", "name":"Prepared meals", "coordinates":"[453,265], [565,265], [565,321], [618,321], [618,436], [585,436], [585,417], [453,417]", "value":90},
	{"ID":"H", "link":"http://google.com/?q=Café", "name":"Café", "coordinates":"[368,424], [406,424], [406,468], [449,468], [449,453], [502,453], [502,495], [368,495]", "value":""}
];
```

All the fields are strings except for ```value```.

Value must be between 0 and 100. To indicate lack of data, enter -1 or an empty string.


#### Coordinates

Enter the coordinates of each zone in a clock-wise order.

Drawing a rectangle is as easy as ```[x1,y1], [x2,y2], [x3, y3], [x4,y4]```

Each coordinate is separated by ```, ```.

Don't use spaces within a coordinate.

There's 2 types of advanced coordinates: arcs and pies.

##### Arc

```
arc[[startx,starty],[endx,endy],[pointx,pointy]]
```

```[pointx,pointy]``` is a point anywhere on the arc.
The arc will be a half-ellipse drawn from the start point to the end point, passing through the specified third point.

##### Pie

```
pie[[startx,starty],[endx,endy],[centerx,centery]]
```

A pie is a circle (or part of a circle) drawn from the start point to the end point with the specified center point.


### Background

```background``` is a base-64 formatted string of a PNG or JPG image.


## Examples

#### Example 1

config

```json
{
	"width":800,
	"height":700,
	"background":{
		"width":800,
		"height":531,
		"x":0,
		"y":160,
		"saturation":1.0
	},
	"dashboard":{
		"x":10,
		"y":10,
		"width":480,
		"height":150
	},
	"scale":{
		"initial":"green",
		"alternate":"blue",
		"width":240,
		"height":20,
		"x":500,
		"y":10
	},
	"threshold":70,
	"IDs":{
		"show":true,
		"color":"#000000"
	},
	"labels":{
		"value":"Satisfaction: ",
		"link":"View data"
	}
}
```

zones

```json
{"ID":"A", "link":"http://google.com/?q=Aisles", "name":"Aisles", "coordinates":"[97,157], [370,157], [370,355], [97,355]", "value":0}
{"ID":"B", "link":"http://google.com/?q=Checkout", "name":"Checkout", "coordinates":"[182,384], [182,411], [361,411], [361,384]", "value":15}
{"ID":"C", "link":"http://google.com/?q=Medical", "name":"Medical", "coordinates":"[31,231], [75,231], [75,379], [152,379], [152,411], [31,411]", "value":30}
{"ID":"D", "link":"http://google.com/?q=Raw ingredients", "name":"Raw ingredients", "coordinates":"[76,64], [615,64], [615,134], [76,136]", "value":45}
{"ID":"E", "link":"http://google.com/?q=Bakery", "name":"Bakery", "coordinates":"[381,157], [438,157], [438,234], [567,234], [567,255], [438,255], [440,414], [381,414]", "value":60}
{"ID":"F", "link":"http://google.com/?q=Produce", "name":"Produce", "coordinates":"[453,157], [615,157], [617,315], [584,315], [584,223], [453,224]", "value":75}
{"ID":"G", "link":"http://google.com/?q=Prepared meals", "name":"Prepared meals", "coordinates":"[453,265], [565,265], [565,321], [618,321], [618,436], [585,436], [585,417], [453,417]", "value":90}
{"ID":"H", "link":"http://google.com/?q=Café", "name":"Café", "coordinates":"[368,424], [406,424], [406,468], [449,468], [449,453], [502,453], [502,495], [368,495]", "value":""}
```

```background``` is the base64 string of [this image](http://simongrondin.name/files/map-reporting/map1background.jpg).

[This is the SVG generated.](http://simongrondin.name/files/map-reporting/map1.svg)

#### Example 2

config

```json
{
	"width":1463,
	"height":918,
	"background":{
		"width":1463,
		"height":918,
		"x":0,
		"y":0,
		"saturation":0.5
	},
	"dashboard":{
		"x":10,
		"y":10,
		"width":480,
		"height":150
	},
	"scale":{
		"initial":"blue",
		"alternate":"green",
		"width":240,
		"height":20,
		"x":500,
		"y":10
	},
	"threshold":70,
	"IDs":{
		"show":false,
		"color":"#000000"
	},
	"labels":{
		"value":"Satisfaction: ",
		"link":"View data"
	}
}
```

zones

```json
{"ID":"1", "link":"http://google.com/?q=Lobby/Front Desk", "name":"Lobby/Front Desk", "coordinates":"[727,262], [979,261], [979,332], [934,318], [727,318]", "value":5}
{"ID":"2", "link":"http://google.com/?q=Tour Desk", "name":"Tour Desk", "coordinates":"[979,261], [1234,261], [1234,318], [1024,318], [979,332]", "value":10}
{"ID":"3", "link":"http://google.com/?q=Player's Lounge", "name":"Player’s Lounge", "coordinates":"[727,318], [823,318], [823,425], [727,425]", "value":15}
{"ID":"4", "link":"http://google.com/?q=Gym &amp; Sauna", "name":"Gym & Sauna", "coordinates":"[979,206], [1234,206], [1234,261], [979,260]", "value":25}
{"ID":"5", "link":"http://google.com/?q=Pocomania Gift Shop", "name":"Pocomania Gift Shop", "coordinates":"[727,425], [823,425], [823,480], [727,480]", "value":30}
{"ID":"6", "link":"http://google.com/?q=Bay Window Restaurant", "name":"Bay Window Restaurant", "coordinates":"[1137,318], [1234,318], [1234,481], [1137,481]", "value":35}
{"ID":"7", "link":"http://google.com/?q=The Carlyle Restaurant", "name":"The Carlyle Restaurant", "coordinates":"[405,300], [592,300], [546,328], [546,381], [451,381], [451,328], [405,300]", "value":40}
{"ID":"8", "link":"http://google.com/?q=Nibbles", "name":"Nibbles", "coordinates":"pie[[449,382],[367,312],[403,355]], pie[[360,288],[375,280],[356,259]], pie[[383,303],[403,299],[403,355]], [449,325]", "value":45}
{"ID":"9", "link":"http://google.com/?q=Bay Window Bar", "name":"Bay Window Bar", "coordinates":"[1086,318], [1139,318], [1139,481], [1086,481]", "value":50}
{"ID":"10", "link":"http://google.com/?q=Sunset Bar", "name":"Sunset Bar", "coordinates":"[546,325], pie[[592,299],[546,383],[592,355]]", "value":55}
{"ID":"11", "link":"http://google.com/?q=Freshwater Pool", "name":"Freshwater Pool", "coordinates":"[899,359], [1061,358], arc[[1061,373],[1061,422],[1086,397.5]], [1061,437], [899,437], arc[[899,425],[899,371],[918,398]]", "value":60}
{"ID":"12", "link":"http://google.com/?q=Whirlpool", "name":"Whirlpool", "coordinates":"arc[[899,371],[899,425],[918,398]], arc[[899,425],[899,371],[878,398]]", "value":65}
{"ID":"13", "link":"http://google.com/?q=Public Beach", "name":"Public Beach", "coordinates":"[0,521], [1104,521], [1389,648], [1389,918], [0,918]", "value":69}
{"ID":"14", "link":"http://google.com/?q=Treatment Room", "name":"Treatment Room", "coordinates":"[727,206], [979,206], [979,261], [727,261]", "value":70}
{"ID":"15", "link":"http://google.com/?q=Entertainment &amp; Wedding Centre", "name":"Entertainment & Wedding Centre", "coordinates":"[569,425], [678,425], [678,464], [569,464]", "value":75}
{"ID":"16", "link":"http://google.com/?q=Amphitheatre", "name":"Amphitheatre", "coordinates":"[459,217], [535,217], [591,300], [403,299]", "value":80}
{"ID":"17", "link":"http://google.com/?q=Shuffleboard Court", "name":"Shuffleboard Court", "coordinates":"[334,436], [450,436], [450,464], [334,464]", "value":85}
{"ID":"18", "link":"http://google.com/?q=Volleyball Court", "name":"Volleyball Court", "coordinates":"[81,390], [214,390], [214,463], [81,463]", "value":90}
{"ID":"19", "link":"http://google.com/?q=Lighted Tennis Court", "name":"Lighted Tennis Court", "coordinates":"[70,283], [218,283], [218,352], [70,352]", "value":95}
```

```background``` is the base64 string of [this image](http://simongrondin.name/files/map-reporting/map2background.jpg).

[This is the SVG generated.](http://simongrondin.name/files/map-reporting/map2.svg)