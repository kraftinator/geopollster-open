var minmax_elements;minmax_props=new Array(new Array("min-width","minWidth"),new Array("max-width","maxWidth"),new Array("min-height","minHeight"),new Array("max-height","maxHeight"));function minmax_bind(f){var d,c,b;var a=f.style,e=f.currentStyle;if(minmax_elements==window.undefined){if(!document.body||!document.body.currentStyle){return}minmax_elements=new Array();window.attachEvent("onresize",minmax_delayout);c=document.createElement("div");c.setAttribute("id","minmax_em");c.style.position="absolute";c.style.visibility="hidden";c.style.fontSize="xx-large";c.style.height="5em";c.style.top="-5em";c.style.left="0";if(c.style.setExpression){c.style.setExpression("width","minmax_checkFont()");document.body.insertBefore(c,document.body.firstChild)}}for(d=minmax_props.length;d-->0;){if(e[minmax_props[d][0]]){a[minmax_props[d][1]]=e[minmax_props[d][0]]}}for(d=minmax_props.length;d-->0;){b=e[minmax_props[d][1]];if(b&&b!="auto"&&b!="none"&&b!="0"&&b!=""){a.minmaxWidth=e.width;a.minmaxHeight=e.height;minmax_elements[minmax_elements.length]=f;minmax_delayout();break}}}var minmax_fontsize=0;function minmax_checkFont(){var a=document.getElementById("minmax_em").offsetHeight;if(minmax_fontsize!=a&&minmax_fontsize!=0){minmax_delayout()}minmax_fontsize=a;return"5em"}var minmax_delaying=false;function minmax_delayout(){if(minmax_delaying){return}minmax_delaying=true;window.setTimeout(minmax_layout,0)}function minmax_stopdelaying(){minmax_delaying=false}function minmax_layout(){window.setTimeout(minmax_stopdelaying,100);var d,f,c,e,b,a;for(d=minmax_elements.length;d-->0;){f=minmax_elements[d];c=f.style;e=f.currentStyle;c.width=c.minmaxWidth;b=f.offsetWidth;a=true;if(a&&e.minWidth&&e.minWidth!="0"&&e.minWidth!="auto"&&e.minWidth!=""){c.width=e.minWidth;a=(f.offsetWidth<b)}if(a&&e.maxWidth&&e.maxWidth!="none"&&e.maxWidth!="auto"&&e.maxWidth!=""){c.width=e.maxWidth;a=(f.offsetWidth>b)}if(a){c.width=c.minmaxWidth}c.height=c.minmaxHeight;b=f.offsetHeight;a=true;if(a&&e.minHeight&&e.minHeight!="0"&&e.minHeight!="auto"&&e.minHeight!=""){c.height=e.minHeight;a=(f.offsetHeight<b)}if(a&&e.maxHeight&&e.maxHeight!="none"&&e.maxHeight!="auto"&&e.maxHeight!=""){c.height=e.maxHeight;a=(f.offsetHeight>b)}if(a){c.height=c.minmaxHeight}}}var minmax_SCANDELAY=500;function minmax_scan(){var b;for(var a=0;a<document.all.length;a++){b=document.all[a];if(!b.minmax_bound){b.minmax_bound=true;minmax_bind(b)}}}var minmax_scanner;function minmax_stop(){window.clearInterval(minmax_scanner);minmax_scan()}minmax_scan();minmax_scanner=window.setInterval(minmax_scan,minmax_SCANDELAY);window.attachEvent("onload",minmax_stop);