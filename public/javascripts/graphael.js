(function(){Raphael.fn.g=Raphael.fn.g||{};
	Raphael.fn.g.markers={disc:"disc",o:"disc",flower:"flower",f:"flower",diamond:"diamond",d:"diamond",square:"square",s:"square",triangle:"triangle",t:"triangle",star:"star","*":"star",cross:"cross",x:"cross",plus:"plus","+":"plus",arrow:"arrow","->":"arrow"};
	Raphael.fn.g.shim={stroke:"none",fill:"#000","fill-opacity":0};
	Raphael.fn.g.txtattr={font:"12px Arial, sans-serif"};
	//Raphael.fn.g.colors=[];
	//var b=[0.6,0.2,0.05,0.1333,0.75,0];
	/*for(var a=0;a<10;a++){
		if(a<b.length){
			Raphael.fn.g.colors.push("hsb("+b[a]+", .75, .75)");
		}else{
			Raphael.fn.g.colors.push("hsb("+b[a-b.length]+", 1, .5)");
		}
	}*/
	Raphael.fn.g.labelise=function(c,f,e){
		if(c){
			return(c+"").replace(/(##+(?:\.#+)?)|(%%+(?:\.%+)?)/g,function(g,i,h){
				if(i){
					return(+f).toFixed(i.replace(/^#+\.?/g,"").length);
				}if(h){
					return(f*100/e).toFixed(h.replace(/^%+\.?/g,"").length)+"%";
				}
			});
		}else{
			return(+f).toFixed(0);
		}
	};
	Raphael.fn.g.disc=function(c,f,e){
		return this.circle(c,f,e);
	};
})();
