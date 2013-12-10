window.init = () ->
	$.mobile.loading 'show',
		text:'Please wait'
		textVisible:true
		theme:'a'
	class myLocsInfo
		constructor: () ->
			@offersInfo = []
			@attrsInfo = []
			@attrsMarkers = new Array()
			@offersMarkers = new Array()
					    
		setAttrsInfo: (key, offer) ->
		    @attrsInfo[key] = offer
		    
		setOffersInfo: (key, offer) ->
			@offersInfo[key] = offer
		setAttrsMarkers: (marker) ->
			@attrsMarkers.push marker
			# console.log marker
		setOffersMarkers:(marker) ->
			@offersMarkers.push marker
		getAttrsInfo: (key) ->
			return @attrsInfo[key]
		getOffersInfo:(key) ->
			return @offersInfo[key]	
		displayAttrs:() ->
			@.clearOffersMarkers()
			for marker in @attrsMarkers
				marker.setMap map
		displayOffers:() ->
			@.clearAttrsMarkers()
			for marker in @offersMarkers
				marker.setMap map
		displayAll:() ->
			for marker in @attrsMarkers
				marker.setMap map
			for marker in @offersMarkers
				marker.setMap map
		clearAttrsMarkers: () ->
			for marker in @attrsMarkers
				marker.setMap null
		clearOffersMarkers: () ->
			for marker in @offersMarkers
				marker.setMap null
		
		

	window.myLocationInfo = new myLocsInfo()				
	latlng = new google.maps.LatLng 51.850731,-8.301129
	window.map = new google.maps.Map(document.getElementById('mapDiv'),
		zoom:11
		center:latlng
		mapTypeId: google.maps.MapTypeId.ROADMAP
	)
	ajax.init()	
	

ajax = init: ->

	attractionsAjax = getAttrs: ->
		promise = $.Deferred()
		$.ajax 'http://keyquests.elasticbeanstalk.com/attractions/getAllDynamic.app',
			data:lat:51.850731,lon:-8.301129
			type:'POST'
			dataType:'json'
			timeout: 100000
			success: (json) ->
				promise.resolve json.result
			error: (error) ->
				promise.reject(error)
		return promise

	adsAjax = getOffers:->
		adsPromise = $.Deferred()
		$.ajax 'http://keyquests.elasticbeanstalk.com/advertiser/getAllOffersAtLocation.app',
			data:lat:51.850731,lon:-8.301129
			type:'POST'
			dataType:'json'
			timeout: 100000
			success:(json) ->
				adsPromise.resolve json.result
			error:(error) ->
				adsPromise.reject error
		return adsPromise


	$.when(attractionsAjax.getAttrs(), adsAjax.getOffers()).then (getAttrsResult,getOffersResult) ->
		console.log 'Got attractions'		
		console.log 'Got Offers'
		saveOffersAndAttractions(getAttrsResult,getOffersResult)
		
	.fail (attrsError,offersError) ->
		console.log 'attrs Failed' + JSON.stringify attrsError
		console.log 'offers failed' + JSON.stringify offersError
	
saveOffersAndAttractions= (getAttrsResult,getOffersResult) ->
	window.infowindow = new google.maps.InfoWindow(content:"")
	$(getAttrsResult).each ->
		myLocationInfo.setAttrsInfo @.id, @
		if infowindow?
			latlng = new google.maps.LatLng @.lat, @.lon
			marker = new google.maps.Marker
				position:latlng
				icon:'http://maps.google.com/mapfiles/marker_purple.png'
				map: null
			marker['infowindow'] = """<div id = "content" class="attrsInfo"><a href = '#' onclick = "changePage('attr','#{@.id}')" id = #{@.id}>#{@.name}</a></div>"""
			myLocationInfo.setAttrsMarkers marker
			google.maps.event.addListener marker, 'click', ->
				infowindow.setContent @['infowindow']
				infowindow.open map, @	
	
	$(getOffersResult).each ->
		myLocationInfo.setOffersInfo @.id, @
		if infowindow?
			latlng = new google.maps.LatLng @.lat, @.lon
			marker = new google.maps.Marker 
				position:latlng
				icon:'http://maps.google.com/mapfiles/marker_green.png'
				map:null
			marker['infowindow'] = """<div id="content" class="offersInfo"><a href = '#' onclick = "changePage('offer', '#{@.id}')" id=#{@.id}>#{@.advertiser}</a></div>"""	
			myLocationInfo.setOffersMarkers marker
			google.maps.event.addListener marker, 'click', ->
				infowindow.setContent @['infowindow']
				infowindow.open map, @
	
	myLocationInfo.displayAttrs()
	$.mobile.loading 'hide'

window.displayOffers = () ->
	myLocationInfo.displayOffers()
	
window.displayAttrs = () ->
	myLocationInfo.displayAttrs()
					
window.displayAll = () ->	
	myLocationInfo.displayAll()		
				
window.changePage = (type,id) ->
	switch type
		when 'attr'			
			$.mobile.showPageLoadingMsg "a", "Please wait";
			window.sessionStorage.setItem 'mapInfo', JSON.stringify myLocationInfo.getAttrsInfo id
			window.localStorage.setItem 'positionLat', '51.850731'
			window.localStorage.setItem 'positionLon', '-8.301129'
			$.mobile.changePage '../mapPage/mapPage.html',
				transition:'pop'
				reverse:false
				changeHash:true
		when 'offer'
			alert JSON.stringify myLocationInfo.getOffersInfo id
			window.localStorage.setItem("displayOfferInfo", JSON.stringify myLocationInfo.getOffersInfo id)
			# $.mobile.changePage '../displayOffer/displayOffer.html',
			# 	transition:'pop'
			# 	reverse:false
			# 	changeHash:true



