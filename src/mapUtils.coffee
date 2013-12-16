exports.strRepeat = (str, nb) ->
	new Array(nb+1).join(str)

lpad = (str, pad, len) ->
	(if str.length < len then exports.strRepeat(pad, len-str.length) else "")+str

exports.toHTML = (str) ->
	str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;')
		.replace(/</g, '&lt;').replace(/>/g, '&gt;'); # .replace(/\\/g, "\\\\")

lagrange = (val, a, b, c, d, e, f) -> ((a*Math.pow(val, 4) + b*Math.pow(val, 3) + c*Math.pow(val, 2) + d*val + e) / f)

exports.getColor = (val, color, invert=false) ->
	if invert then val = 100 - val
	color = color.toLowerCase()
	if color == "blue"
		# Lagrange interpolation for [[0, 144], [25, 100], [50, 49], [75, 29], [100, 21]]
		r = lagrange val, -57, 12350, -729375, -5093750, 1350000000, 9375000
		# Lagrange interpolation for [[0, 215], [25, 199], [50, 127], [75, 106], [100, 88]]
		g = lagrange val, -31, 6790, -457625, 6481250, 403125000, 1875000
		# Lagrange interpolation for [[0, 235], [25, 234], [50, 194], [75, 177], [100, 180]]
		b = lagrange val, -13, 3190, -240875, 4156250, 440625000, 1875000
	else if color == "red"
		# Lagrange interpolation for [[0, 255], [25, 247], [50, 240], [75, 213], [100, 164]]
		r = lagrange val, 19, -4950, 295625, -7593750, 2390625000, 9375000
		# Lagrange interpolation for [[0, 165], [25, 123], [50, 84], [75, 49], [100, 42]]
		g = lagrange val, 23, -3350, 173125, -18343750, 1546875000, 9375000
		# Lagrange interpolation for [[0, 120], [25, 100], [50, 70], [75, 53], [100, 39]]
		b = lagrange val, -33, 7250, -474375, 343750, 1125000000, 9375000
	else if color == "green"
		# Lagrange interpolation for [[0, 157], [25, 128], [50, 101], [75, 72], [100, 60]]
		r = lagrange val, 23, -3850, 203125, -13906250, 1471875000, 9375000
		# Lagrange interpolation for [[0, 195], [25, 177], [50, 159], [75, 138], [100, 125]]
		g = lagrange val, 7, -1200, 59375, -4218750, 914062500, 4687500
		# Lagrange interpolation for [[0, 148], [25, 114], [50, 83], [75, 46], [100, 29]]
		b = lagrange val, 7, -1230, 66125, -3543750, 277500000, 1875000

		# console.log val+" "+r+" "+g+" "+b
	"#"+lpad(Math.round(r).toString(16), "0", 2)+lpad(Math.round(g).toString(16), "0", 2)+lpad(Math.round(b).toString(16), "0", 2)

exports.buildCSS = (styling, containerID) ->
	container = if containerID? then "#"+containerID+" " else ""
	if styling?
		css = for own selector,style of styling
			container+selector+" {\n"+("\t"+k+" : "+v+";" for own k,v of style).join("\n")+"\n}\n"
		css.join "\n"
	else
		""
