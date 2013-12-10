$(document).on("pageshow","#map_page", function(event) {
	$("#map_page_content").css("height",window.innerHeight);
	$.mobile.loading('show',{
		text:"Please wait",
		textVisible:true,
		theme:"a"
	});
	
	createPage();	
	$("#mapAttractionButton").on("click",function(e){
		displayInfoMessage();
	});
});

function createPage(){	
	
	var zoom;
	var mapInfo = JSON.parse(window.sessionStorage.getItem("mapInfo"));
	if(mapInfo.dist<20){
		zoom = 9;
	}else{
		zoom = 7;
	}
	//getting rid of the "scroll for more" instruction as this appears even if there is no overflow in the div $("#mapAttractionInfo").append('<p id="boldScroll"><i>(Scroll for more)</i> <br>'+mapInfo.info+'</p>').trigger("create");
	$("#mapAttractionInfo").append('<p id="boldScroll"><i>(Scroll for more)</i> <br>'+mapInfo.info+'</p>').trigger("create");
	$("#mapAttractionButton").append('<a href="#" id = "attractionSite" data-role="button"data-mini="true">Visit webpage</a>').trigger("create");
	$("#mapHeader").text(mapInfo.name);
	$("#boldScroll").css("text-align","left");
	var latlng = new google.maps.LatLng(window.localStorage.getItem("positionLat"), window.localStorage.getItem("positionLon"));
	var map = new google.maps.Map(document.getElementById('map'), {
        zoom: zoom,
        center: latlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      });
	var marker = new google.maps.Marker({
		position : latlng,
		icon: "http://maps.google.com/mapfiles/marker_green.png",
		map:map
	});
	
	var marker = new MarkerWithLabel({
		position:new google.maps.LatLng(mapInfo.lat,mapInfo.lon),
		map:map,
		labelContent:mapInfo.name,
		labelAnchor: new google.maps.Point(22, 65),
		labelClass: "labels", // the CSS class for the label
		labelStyle: {opacity: 0.75}
	});
	$.mobile.loading('hide');
}
function displayInfoMessage(){
	var mapInfo = JSON.parse(window.sessionStorage.getItem("mapInfo"));
	navigator.notification.confirm(
	        'Tap done to return to your adventure',  	// message
	        openSite(mapInfo.url),              		// callback to invoke with index of button pressed
	        'Visit attraction site',            		// title
	        'OK'          								// buttonLabels
	    );	
}

function openSite(url){
	window.open(url,'_blank', 'location=yes');	

}
