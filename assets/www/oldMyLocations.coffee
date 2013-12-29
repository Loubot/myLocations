class myLocsInfo
  constructor: () ->
    @offersInfo = new Array()
    @savedInfo = new Array()
    @attrsInfo = new Array()
    @mapChecker = 0
  setOffersInfo: (key, offer) ->
    @offersInfo[key] = offer
    # console.log 'offers' + key
  setSavedInfo: (key, offer) ->
    @savedInfo[key] = offer
    console.log 'saved' + JSON.stringify @offer[key]
  setAttrsInfo: (key, attr) ->
    @attrsInfo[key] = attr
    # console.log 'attrs' + JSON.stringify @attrsInfo[key]
  getOffersInfo: (key) ->
    # console.log JSON.stringify @offersInfo
    return @offersInfo[key]
    console.log 'offers' + JSON.stringify @offersInfo[key]
  getSavedInfo: (key) ->
    return @savedInfo[key]
  getAttrsInfo: (key) ->
    return @attrsInfo[key]
  

myLocsInfo = new myLocsInfo()
map = null

window.init = () -> 
  $.mobile.showPageLoadingMsg("a", "Please wait");
  centerLatLon = new google.maps.LatLng 51.855079,-8.296752
  map = new google.maps.Map document.getElementById('mapDiv'),
    zoom:14
    center:centerLatLon
    mapTypeId:google.maps.MapTypeId.ROADMAP
  x = window.innerWidth
  $('#my_locations_content').css 'width','x'
  

  comms = new BTAjax()
  comms.pushToQ '#',
  	lat:51.899138
  	lon: -8.297131
  	myLocationsGotAttrs, myLocationsFailAttrs
  comms.execute()

  comms.pushToQ "#{}",
    lat:51.899138
    lon: -8.297131
    myLocsGotOffers, myLocsFailOffers
  comms.execute()

  comms.pushToQ "#{}",
    userID:'520b88d8e4b032fe34fd3c63'
    myLocsSaved, myLocsFailSaved
  comms.execute()


myLocsSaved = (results) ->
  # alert(results)
  # window.localStorage.setItem 'myLocsSaved',JSON.stringify results
  console.log 'saved' + JSON.stringify results
  if results?
    $(results).each ->
      myLocsInfo.setSavedInfo(@.id,@)
      latlng = new google.maps.LatLng this.lat,this.lon
      marker = new google.maps.Marker 
        position:latlng
        icon:'http://maps.google.com/mapfiles/marker_purple.png'
        map:map
      contentString = """ <div id = "info_link"><a href="#" id=#{this.id}>#{this.name}</a></div> """
      # contelon: -8.297131lon: -8.297131lon: -8.297131lon: -8.297131lon: -8.297131ntString =  '<div id = "info_link" class="info_link"><a href="#" id="'+this.id+'" class="info_link_a">'+this.advertiser+'</a></div>'
      infoWindow = new google.maps.InfoWindow
        content:contentString
      google.maps.event.addListener marker, 'click', ->
        infoWindow.open map,@ 
      # id = '#' + this.id
      # $(id).live 'click', ->
      #   console.log myLocsInfo.getOffersInfo
    

myLocsGotOffers = (results) ->
  # console.log 'alloffers'+JSON.stringify results
  if results? 
    $(results).each ->
      # window.localStorage.setItem 'myLocsOffers',JSON.stringify(results)
      myLocsInfo.setOffersInfo(@.id, @)
      latlng = new google.maps.LatLng this.lat,this.lon
      marker = new google.maps.Marker 
        position:latlng
        icon:'http://maps.google.com/mapfiles/marker_purple.png'
        map:map
        contentString = """ <div id = "info_link"><a href="#" id=#{this.id}>#{this.advertiser}</a></div> """
      # contentString =  '<div id = "info_link" class="info_link"><a href="#" id="'+this.id+'" class="info_link_a">'+this.advertiser+'</a></div>'
      infoWindow = new google.maps.InfoWindow
        content:contentString
      google.maps.event.addListener marker, 'click', ->
        infoWindow.open map,@ 
      id = '#' + this.id
      $(id).live 'click', ->
        alert JSON.stringify myLocsInfo.getOffersInfo $(@).attr 'id'
    # console.log JSON.stringify('success' + JSON.stringify myLocsInfo.getSavedInfo())
  else 
    alert 'a'  
  $.mobile.hidePageLoadingMsg();

 
myLocationsGotAttrs = (results) ->
  # window.localStorage.setItem 'myLocsAttrs',JSON.stringify(results)
  # console.log 'attrs' + window.localStorage.getItem 'myLocsAttrs'
  if results?
    $(results).each ->
      # window.localStorage.setItem 'myLocsOffers',JSON.stringify(results)
      myLocsInfo.setAttrsInfo(@.id, @)
      latlng = new google.maps.LatLng this.lat,this.lon
      marker = new google.maps.Marker 
        position:latlng
        icon:'http://maps.google.com/mapfiles/marker_yellow.png'
        map:map
        contentString = """ <div id = "info_link"><a href="#" id=#{this.id}>#{this.name}</a></div> """
      # contentString =  '<div id = "info_link" class="info_link"><a href="#" id="'+this.id+'" class="info_link_a">'+this.advertiser+'</a></div>'
      infoWindow = new google.maps.InfoWindow
        content:contentString
      google.maps.event.addListener marker, 'click', ->
        infoWindow.open map,@ 
      id = '#' + this.id
      $(id).live 'click', ->
        alert $(@).attr 'id'
    # console.log JSON.stringify('success' + JSON.stringify myLocsInfo.getSavedInfo())
  else 
    alert 'a'  
  $.mobile.hidePageLoadingMsg();



myLocationsFailAttrs = (error) ->
	console.log error

myLocsFailOffers = (error) ->
  console.log error

myLocsFailSaved = (error) ->
  console.log error

