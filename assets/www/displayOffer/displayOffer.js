$("#display_offer_page").on("pageshow",function(){
	$.mobile.showPageLoadingMsg("a", "Please wait");
	setHeight();
	$("#displayOfferInfo").empty();
	

	var offerInfo = JSON.parse(window.localStorage.getItem("displayOfferInfo"));
	var info_esc =  (offerInfo.info).replace(/â¬/g, "&euro;");
	//make sure timestamp is coming in as a js number 
	var ts = new Number(offerInfo.expiry);
	
	//this is the Date.js method -> from toString onwards
	var dateFromTS = new Date(ts).toString("dd-MM-yyyy");
	$("#displayOfferInfo").append('<p class="cl_offerHeader">'+offerInfo.advertiser+'</p>');
	$("#displayOfferInfo").append('<p style="text-align:center"><img class="displayOfferImage" src="http://keyquests.elasticbeanstalk.com/advertiser/getAdvertiserOrOfferImage.app?path='+offerInfo.imagePath+'"></p>');
	$("#displayOfferInfo").append('<p class="cl_offerH2">'+offerInfo.headline+'</p><br>');	
	$("#displayOfferInfo").append(info_esc+"<br>");
	$("#displayOfferInfo").append('<p class="cl_offerH3">Show Merchant : ' + offerInfo.offerCode +'</p><br>');
	$("#displayOfferInfo").append('<p class="cl_offerH3">Offer Expires : ' + dateFromTS +'</p><br>');

	var comms = new BTAjax();
	comms.pushToQ("http://keyquests.elasticbeanstalk.com/userOffers/setUserViewedOffer.app", {
		userID:window.localStorage.getItem("userId"),
		offerID:offerInfo.id
	}, loggedOfferView,failedOfferview);
	comms.execute();	


	console.log(window.localStorage.getItem("userId"));
	console.log(offerInfo.id);
	
	$("#saveOffer").on("click",function(){
		
		var comms = new BTAjax();
		comms.pushToQ("http://keyquests.elasticbeanstalk.com/userOffers/setUserSavedOffer.app", {
			userID:window.localStorage.getItem("userId"),
			offerID:offerInfo.id
		}, savedOfferSuccess,savedOfferFail);
		comms.execute();
	});
});


function savedOfferSuccess(result){
	alert("Offer saved.  View your offers in 'saved offers'. Offers will remain saved until they expire.");
    console.log(result.text);
}

function savedOfferFail(error){
    console.log(error.text);
}

function loggedOfferView(result){
	$.mobile.hidePageLoadingMsg();
	console.log(result);
}

function failedOfferview(error){	
	$.mobile.hidePageLoadingMsg();
	console.log(error);
}