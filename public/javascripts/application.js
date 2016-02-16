function returnColorArray() {
	return ['#d3d3d3', '#606', '#06a', '#090', '#f90', '#d00'];
}
function returnDemRepColorArray() {
	return ['#d3d3d3', '#06a', '#d00'];
}
function returnGenderColorArray() {
	return ['#259494', '#ff7373', '#818881'];
}
function returnOpaqueColorArray() {
	return ['#e5e5e5', '#a265a2', '#65a2cb', '#65c165', '#fec165', '#e96565'];
}
function returnLabelsHash() {
	return {	'AL' : 'Alabama', 'AK' : 'Alaska', 'AZ' : 'Arizona', 'AR' : 'Arkansas', 'CA' : 'California', 'CO' : 'Colorado', 'CT' : 'Connecticut',
				'DE' : 'Delaware', 'DC' : 'District of Columbia', 'FL' : 'Florida', 'GA' : 'Georgia', 'HI' : 'Hawaii', 'ID' : 'Idaho', 'IL' : 'Illinois',
				'IN' : 'Indiana', 'IA' : 'Iowa', 'KS' : 'Kansas', 'KY' : 'Kentucky', 'LA' : 'Louisiana', 'ME' : 'Maine', 'MD' : 'Maryland', 'MA' : 'Massachusetts',
				'MI' : 'Michigan', 'MN' : 'Minnesota', 'MS' : 'Mississippi', 'MO' : 'Missouri', 'MT' : 'Montana', 'NE' : 'Nebraska', 'NV' : 'Nevada',
				'NH' : 'New Hampshire', 'NJ' : 'New Jersey', 'NM' : 'New Mexico', 'NY' : 'New York', 'NC' : 'North Carolina', 'ND' : 'North Dakota', 
				'OH' : 'Ohio', 'OK' : 'Oklahoma', 'OR' : 'Oregon', 'PA' : 'Pennsylvania', 'RI' : 'Rhode Island', 'SC' : 'South Carolina', 'SD' : 'South Dakota',
				'TN' : 'Tennessee', 'TX' : 'Texas', 'UT' : 'Utah', 'VT' : 'Vermont', 'VA' : 'Virginia', 'WA' : 'Washington', 'WV' : 'West Virginia',
				'WI' : 'Wisconsin', 'WY' : 'Wyoming'};
}
function drawState(stateAbbrev, statePartyId) {
	var colors = returnColorArray();
	var state = paper.path(individualStates(stateAbbrev)).attr({fill:colors[statePartyId],'fill-opacity': 0.8, stroke:'none'});
	var box = state.getBBox();
	var scaleFactor = box.height > box.width ? 295/box.height : 295/box.width;
	paper.rect(0, 0, 900, 300, 10).attr({fill:colors[statePartyId], 'fill-opacity':0.1, stroke:'none'});
	state.scale(scaleFactor, scaleFactor);	
	box = state.getBBox();
	state.translate(((0 - box.x) + ((310 - box.width)/2)), ((0 - box.y) + ((300 - box.height)/2)));
	paper.setView('900px', '300px');
}
function drawPieChart(colorArray, numberArray, legendArray, partySlugArray, align, partyLinkBoolean, scale, label) {
	var pie;
	var partyLink = [];
	var tempColor, tempNumber, tempLegend;
	var temporaryString;
	var x;
	var xAlign = 450;
	var spacer = 0;
	var textStyle = '';
	if (navigator.userAgent.search(/MSIE/) === -1) {
		
	} else {
		paper.g.txtattr = {'font-size': 12 + "px", 'line-height': 12 + "px"};
	}
	if (align == 'left') xAlign = 150; 
	if (!scale) {
		var scale = 1;
	}
	if (label) {
		paper.text(0 + (150*scale), 0 + (8*scale), label);
		spacer = 8;
	}
	if (colorArray.length > 0) {
		paper.g.colors = colorArray;
		var x = 0;
		var length = legendArray.length;
		for (; x < length; x++) {
			partyLink[x] = '/parties/' + partySlugArray[x];
		}
		if (partyLinkBoolean === 0) {
			pie = paper.g.piechart(xAlign*scale, 150*scale, (125*scale)-spacer, numberArray, {legend: legendArray, legendpos: "east"});
		} else {
			pie = paper.g.piechart(xAlign*scale, 150*scale, (125*scale)-spacer, numberArray, {legend: legendArray, legendpos: "east", href: partyLink});
		}
	} else {
		paper.g.colors = ["#d3d3d3"];
		pie = paper.g.piechart(xAlign*scale, 150*scale, (125*scale)-spacer, [1], {legend: ["No Data"]});
	}
	if (partyLinkBoolean != 0) {
		pie.hover(function () {
			this.sector.stop();
			if (this.label) {
				this.label[0].stop();
				this.label[0].scale(1.5);
				this.label[1].attr({'font-weight':800});
			}
		}, function () {
			if (this.label) {
				this.label[0].animate({scale: 1}, 500, 'bounce');
				this.label[1].attr({'font-weight': 400});
			}
		});
	}
}
function mainPageChart(chartData, paper, boxX, boxY, dimensionX, dimensionY, fontSize, stateRulingParty, mapChartToggle) {     //0 = Party Name for Legend  - legendArray   //1 = Vote total for party - numberArray      //2 = Color for Legend - colorArray
	var pie,x;
	var temporary = [];
	var partyLink = [];
	for (x=0;x<4;x++) {
		temporary[x] = [];
	}
	var leftOffset = 150;
	paper.g.txtattr = {'font-size': fontSize + "px", 'line-height': fontSize + "px"};
	paper.g.dotRadius = 100;
	var textAlign = 200;
	if (!mapChartToggle) {
		var size = 200;
		var yAxis = 2.75;
	} else {
		var size = 200;
		var yAxis = 2.5;
		leftOffset = 150;
	}
	if (navigator.userAgent.search(/MSIE/) === -1) textAlign = 480;
	if (navigator.userAgent.search(/MSIE/) === -1) leftOffset = 30;
	if (chartData && chartData[2].length > 0) {
		var x = 0;
		var length = chartData[0].length;
		for (; x < length; x++) {
			partyLink[x] = '/parties/' + chartData[3][x];
		}
		paper.g.colors = chartData[2];
		pie = paper.g.piechart((boxX + (dimensionX/2)), (boxY + (dimensionY/yAxis)), size, chartData[1], {legend: chartData[0], legendpos: "southwest", href: partyLink},20,-15, 5, leftOffset, textAlign).attr({opacity:0});
		if (navigator.userAgent.search(/MSIE/) === -1) {
			pie.attr({opacity:1});
		} else {
			pie.animate({opacity:1}, 500);
		}
	} else {
		textAlign = 60;
		if (navigator.userAgent.search(/MSIE/) === -1) textAlign = 200;
		paper.g.colors = ["#d3d3d3"];
		pie = paper.g.piechart((boxX + (dimensionX/2)), (boxY + (dimensionY/yAxis)), size, [1], {legend: ["No Data"], legendpos: "southwest"}, 20, -15, 5, leftOffset, textAlign).attr({opacity:0});
		if (navigator.userAgent.search(/MSIE/) === -1) {
			pie.attr({opacity:1});
		} else {
			pie.animate({opacity:1}, 500);
		}
	}
	return pie;
}
function chartLogic() {
	var stop = false;
	var labels = returnLabelsHash();
	//multiplier variables
	var mult = 3.5;
	var mapMulti = 0.9;
	var mapModfy = 0.4;
	//where the grey box goes
	var boxX = 815 * mult;
	var boxY = 250 * mult;
	var dimensionX = 180 * mult;
	var dimensionY = 260 * mult;
	//change font size if browser is not IE
	var fontSize = 12 * mapMulti;
	var headerSize = 16 * mapMulti;
	var textMult = 0;
	var textYAxis = 35;
	var textStyle = '';
	if (navigator.userAgent.search(/MSIE/) === -1) {  //modify if not IE
		fontSize = 12 * mult;
		headerSize = 16 * mult;
		textMult = 0.4;
		textYAxs = 25;
		textStyle = 'serif';
	}
	var count = 0;
	for (var states in usa) {
		count += 1;
		(function (usaState, state, labelState, counter, stateData, totals, stateRulingParty) {
				usaState[0].style.cursor = 'pointer';
			if (navigator.userAgent.search(/MSIE/) === -1) {
				//increases opacity when mouse is over a state
				usaState[0].onmouseover = function () {
					if (navigator.userAgent.search(/MSIE/) === -1) {
						usaState.animate({'fill-opacity': 1}, 500);
						usaPie.animate({opacity:0}, 50);
					} else {
						//usaPie.animate({opacity:0}, 500);
					}
					usaLabel.animate({opacity:0}, 50);
					stateName = paper.text(boxX + (90*mult),boxY + (18*mult), labelState).attr({fill:"#555", "font-size": headerSize + "px", "font-family":textStyle, "font-weight":"bold"});
					if (total[counter]) {
						for (x = 0;x < total[counter].length; x++) {
							stateData[1][x] = total[counter][x];
						}
					}
					statePie = mainPageChart(stateData, paper, boxX, boxY, dimensionX, dimensionY, fontSize, stateRulingParty, 1);
					usaLabel.attr({opacity:0});
					paper.safari();
				};
				//decreases opacity when mouse leaves a state
				usaState[0].onmouseout = function () {
					if (navigator.userAgent.search(/MSIE/) === -1) usaState.animate({'fill-opacity': 0.6}, 500);
					if (stateName) stateName.remove();
					usaLabel.animate({opacity:1}, 1000);
					usaPie.animate({opacity:1}, 1000);
					if (navigator.userAgent.search(/MSIE/) === -1) {
						statePie.remove();
					} else {
						//statePie.animate({opacity:0}, 500);
					}
					paper.safari();
			};
		}
			//links to the states
			usaState[0].onclick = function () {
				window.location.href = '/states/' + labelState.replace(" ", "-").replace(" ", "-").toLowerCase();
			};
		})(usa[states], states, labels[states], count, stateResults[count], total[count], stateParty[count]);
	}
};
function stateLogic(paper, chartPaper, usa, countryResults, stateResults, parties, totalHold) {
	var labels = returnLabelsHash();
	//multiplier variables
	var mult = 3.5;
	var mapMulti = 0.9;
	//where the grey box goes
	var boxX = 815 * mult;
	var boxY = 250 * mult;
	var dimensionX = 180 * mult;
	var dimensionY = 260 * mult;
	//change font size if browser is not IE
	var fontSize = 12 * mapMulti;
	var headerSize = 16 * mapMulti;
	var textMult = 0;
	textYAxis = 35;
	var textStyle = '';
	if (navigator.userAgent.search(/MSIE/) === -1) {  //modify if not IE
		fontSize = 12 * mult;
		headerSize = 16 * mult;
		textMult = 0.4;
		textYAxis = 25;
		textStyle = 'serif';
	}
	var count = 0;
	var graph = [];
	var electoralTotal = 0;
	chartLogic();
	paper.setView((1000 * mapMulti) +'px', (514 * mapMulti) + 'px');
	rectangle = paper.rect(boxX,boxY,dimensionX,dimensionY,5*mult).attr({fill: '#e8e8df', 'fill-opacity': 0.7, 'stroke-color':'#555'});
	usaLabel = paper.text(boxX + (90*mult),boxY + (18*mult), 'USA').attr({fill:"#555555", "font-size": headerSize + "px", "font-family":textStyle, "font-weight":"bold"});
	usaPie = mainPageChart(countryResults, paper, boxX, boxY, dimensionX, dimensionY, fontSize, countryId, 1);
	
}

function toggleParties() {
	(document.getElementById('choose_party_-1').checked === true)  ? document.getElementById('hidden_parties').style.display = 'block' :  document.getElementById('hidden_parties').style.display = 'none';
}

function toggleVisibility( div_name ) {
  document.getElementById(div_name).style.display = "";
  if(document.getElementById(div_name).style.visibility == "hidden" ) {
    document.getElementById(div_name).style.visibility = "visible";
  }
  else {
   document.getElementById(div_name).style.visibility = "hidden";
  }
}

function toggleDisplay( div_name ) {
  document.getElementById(div_name).style.visibility = "visible";
  if(document.getElementById(div_name).style.display == "none" ) {
    document.getElementById(div_name).style.display = "";
  }
  else {
    document.getElementById(div_name).style.display = "none";
  }
}

if (navigator.userAgent.search(/MSIE/) === -1) window.addEventListener("unload", chartLogic, false);