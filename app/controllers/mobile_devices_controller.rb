class MobileDevicesController < ApplicationController

  def index
    @title = 'Mobile Devices'
    iphone = MobileDevice.find_by_foursquare_name("foursquare for iPhone")
    blackberry = MobileDevice.find_by_foursquare_name("foursquare for BlackBerry")
    android = MobileDevice.find_by_foursquare_name("foursquare for Android")
    @iphone_results = iphone.polling
    @blackberry_results = blackberry.polling
    @android_results = android.polling
    @parties = Party.find(:all)
  end

end
