distance = (x1, y1, x2, y2) ->
	Math.sqrt(Math.pow((x2-x1), 2) + Math.pow((y2-y1), 2))

rotate = (x, y, a) ->
	[
		Math.cos(a)*(x) - Math.sin(a)*(y)
		Math.sin(a)*(x) + Math.cos(a)*(y)
	]

# Is C to the left of the line that passes through A and B?
isLeftSide = (xa, ya, xb, yb, xc, yc) ->
	((xb - xa)*(yc - ya) - (yb - ya)*(xc - xa)) > 0

toDeg = (x) -> x*(180/Math.PI)

toRad = (x) -> x*(Math.PI/180)

sum = (arr) -> arr.reduce (a,b) -> a+b

avg = (arr) -> sum(arr) / arr.length

calculateEllipse = (xa, ya, xb, yb, xc, yc) ->
	# Keep a copy of the original coordinates before transformations
	[oxa, oya, oxb, oyb, oxc, oyc] = [xa, ya, xb, yb, xc, yc]

	# Find center and r1
	[xcenter, ycenter] = [(xa+xb)/2, (ya+yb)/2]
	r1 = distance xa, ya, xcenter, ycenter

	# Calculate angle, basic trigonometry
	opposite = Math.abs(yb-ycenter)
	angle = Math.asin(opposite/r1)

	# Translate center to origin
	[[xa, ya], [xb, yb], [xc, yc]] = [[xa-xcenter, ya-ycenter], [xb-xcenter, yb-ycenter], [xc-xcenter, yc-ycenter]]

	# Rotate around origin
	[[xa, ya], [xb, yb], [xc, yc]] = [rotate(xa, ya, angle), rotate(xb, yb, angle), rotate(xc, yc, angle)]

	# xc needs to be on the ellipse for the equation to work no matter which axis is on the x-axis
	if xc > r1 then [yc, xc] = [xc, yc]

	# Isolate r2 in the ellipse's parametric equation
	t = (Math.pow(xc, 2)/Math.pow(r1, 2))
	u = Math.pow(yc, 2)
	r2 = Math.sqrt(u/(1-t))

	# Sweep flag. Which one of the two possible half-ellipses should be drawn?
	sweep = if oya == oyb # Special case if aligned on the x-axis
		if oxc > oxa then (if oyc < oya then 1 else 0)
		else 			  (if oyc < oya then 0 else 1)
	else if oxa == oxb # Special case if aligned on the y-axis
		if oya < oyb then (if oxc < oxa then 0 else 1)
		else 			  (if oxc < oxa then 1 else 0)
	else (if (xc < 0 and yc < 0) or (xc > 0 and yc > 0) then 0 else 1)

	{r1, r2, xcenter, ycenter, angle:toDeg(angle), sweep}

calculatePie = (xa, ya, xb, yb, xc, yc) ->
	# Large arc flag. Draw x degrees or 360-x degrees?
	large = if isLeftSide(xa, ya, xb, yb, xc, yc) then 0 else 1

	r = (distance(xa, ya, xc, yc) + distance(xb, yb, xc, yc))/2

	{r, large}

module.exports = {calculateEllipse, calculatePie, avg}

