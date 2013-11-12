exports.strRepeat = (str, nb) ->
	new Array(nb+1).join(str)

lpad = (str, pad, len) ->
	(if str.length < len then exports.strRepeat(pad, len-str.length) else "")+str

exports.toHTML = (str) ->
	str.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;')
	.replace(/</g, '&lt;').replace(/>/g, '&gt;'); # .replace(/\\/g, "\\\\")

exports.getColor = (val, color, invert=false) ->
	if invert then val = 100 - val
	color = color.toLowerCase()
	if color == "blue"
		# Lagrange interpolation for [[0, 144], [25, 100], [50, 49], [75, 29], [100, 21]]
		r = (-(57*Math.pow(val, 4) - 12350*Math.pow(val, 3) + 729375*Math.pow(val, 2) + 5093750*val - 1350000000) / 9375000)
		# Lagrange interpolation for [[0, 215], [25, 199], [50, 127], [75, 106], [100, 88]]
		g = (-(31*Math.pow(val, 4) - 6790*Math.pow(val, 3) + 457625*Math.pow(val, 2) - 6481250*val - 403125000) / 1875000)
		# Lagrange interpolation for [[0, 235], [25, 234], [50, 194], [75, 177], [100, 180]]
		b = (-(13*Math.pow(val, 4) - 3190*Math.pow(val, 3) + 240875*Math.pow(val, 2) - 4156250*val - 440625000) / 1875000)
	else if color == "red"
		# Lagrange interpolation for [[0, 255], [25, 247], [50, 240], [75, 213], [100, 164]]
		r = ((19*Math.pow(val, 4) - 4950*Math.pow(val, 3) + 295625*Math.pow(val, 2) - 7593750*val + 2390625000) / 9375000)
		# Lagrange interpolation for [[0, 165], [25, 123], [50, 84], [75, 49], [100, 42]]
		g = ((23*Math.pow(val, 4) - 3350*Math.pow(val, 3) + 173125*Math.pow(val, 2) - 18343750*val + 1546875000) / 9375000)
		# Lagrange interpolation for [[0, 120], [25, 100], [50, 70], [75, 53], [100, 39]]
		b = (-(33*Math.pow(val, 4) - 7250*Math.pow(val, 3) + 474375*Math.pow(val, 2) - 343750*val - 1125000000) / 9375000)
	else if color == "green"
		# Lagrange interpolation for [[0, 157], [25, 128], [50, 101], [75, 72], [100, 60]]
		r = ((23*Math.pow(val, 4) - 3850*Math.pow(val, 3) + 203125*Math.pow(val, 2) - 13906250*val + 1471875000) / 9375000)
		# Lagrange interpolation for [[0, 195], [25, 177], [50, 159], [75, 138], [100, 125]]
		g = ((7*Math.pow(val, 4) - 1200*Math.pow(val, 3) + 59375*Math.pow(val, 2) - 4218750*val + 914062500) / 4687500)
		# Lagrange interpolation for [[0, 148], [25, 114], [50, 83], [75, 46], [100, 29]]
		b = ((7*Math.pow(val, 4) - 1230*Math.pow(val, 3) + 66125*Math.pow(val, 2) - 3543750*val + 277500000) / 1875000)

		# console.log val+" "+r+" "+g+" "+b
	"#"+lpad(Math.round(r).toString(16), "0", 2)+lpad(Math.round(g).toString(16), "0", 2)+lpad(Math.round(b).toString(16), "0", 2)
