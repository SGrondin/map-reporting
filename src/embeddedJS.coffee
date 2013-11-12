exports.getEmbeddedJS = (labels) ->
	"""
	\n<![CDATA[\n
		var usingAlternateColor = false;
		var hoveredStroke = null;
		var selectedShape = null;
		var selectedStroke = null;
		var head = document.getElementById("head");

		function displayShapeInDashboard(shape){
			document.getElementById("dashboardTitle").firstChild.nodeValue = shape.getAttribute("id")+" "+shape.getAttribute("name");
			document.getElementById("dashboardLink").setAttribute("xlink:href", shape.getAttribute("link").replace(/&/g, "%26"));
			document.getElementById("dashboardLinkText").firstChild.nodeValue = """+"\""+labels.link+"""";
			document.getElementById("dashboardSatisfaction").firstChild.nodeValue = """+"\""+labels.value+""": "+shape.getAttribute("value");
		}
		function emptyDashboard(){
			document.getElementById("dashboardTitle").firstChild.nodeValue = "Nothing selected";
			document.getElementById("dashboardLinkText").firstChild.nodeValue = "";
			document.getElementById("dashboardSatisfaction").firstChild.nodeValue = "";
		}

		function putOnTop(shape){
			displayShapeInDashboard(shape);
			head.appendChild(shape);
			//Then put the shape's id back on top of it
			id = document.getElementById("id"+shape.getAttribute("id"));
			head.appendChild(id);
		}
		function selectShape(shape){
			selectedShape = shape;
			selectedStroke = hoveredStroke;
			shape.setAttribute("stroke", "#000000");
			shape.setAttribute("stroke-opacity", "1");
			shape.setAttribute("stroke-width", "6");
			shape.removeAttribute("stroke-dasharray");
		}
		function releaseShape(){
			selectedShape.setAttribute("stroke", selectedStroke);
			selectedShape.setAttribute("stroke-width", "4");
			selectedShape.setAttribute("stroke-opacity", "0.4");
			selectedStroke = null;
			selectedShape = null;
		}
		function mouseOver(evt){
			putOnTop(evt.target);
			if (evt.target !== selectedShape){
				hoveredStroke = evt.target.getAttribute("stroke");
				evt.target.setAttribute("stroke", "#000000");
				evt.target.setAttribute("stroke-opacity", "1");
				evt.target.setAttribute("stroke-width", "6");
				evt.target.setAttribute("stroke-dasharray", "12,8");
			}
		}
		function mouseOut(evt){
			if (selectedShape !== null){
				putOnTop(selectedShape);
			}else{
				emptyDashboard();
			}
			evt.target.removeAttribute("stroke-dasharray");
			if (evt.target !== selectedShape){
				evt.target.setAttribute("stroke", hoveredStroke);
				evt.target.setAttribute("stroke-opacity", "0.4");
				evt.target.setAttribute("stroke-width", "4");
			}
		}
		function mouseDown(evt){
			if (selectedShape === null){
				selectShape(evt.target);
			}else if (evt.target === selectedShape){
				hoveredStroke = selectedStroke;
				selectedStroke = null;
				selectedShape = null;
				evt.target.setAttribute("stroke-dasharray", "12,8");
			}else{
				releaseShape();
				selectShape(evt.target);
			}
		}
		function changeScaleColor(evt){
			elements = document.getElementsByClassName("good");
			console.log(elements.length);
			for (var i=0;i<elements.length;i++){
				var element = elements[i];
				if (usingAlternateColor){
					element.setAttribute("fill", "url(#"+element.getAttribute("initialFilter")+")");
					element.setAttribute("stroke", element.getAttribute("initialColor"));
				}else{
					element.setAttribute("fill", "url(#"+element.getAttribute("alternateFilter")+")");
					element.setAttribute("stroke", element.getAttribute("alternateColor"));
				}
			}
			usingAlternateColor = !usingAlternateColor;
		}
	]]>
	"""