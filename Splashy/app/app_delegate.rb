class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    init_defaults
    
    @window                    = UIWindow.alloc.initWithFrame( UIScreen.mainScreen.bounds )      
    @window.rootViewController = PrefsController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible      
            
    display_splash if splash?
    
    true
  end
  
  # ===========================================================================
  private
  
  def splash?
    App::Persistence['splash']
  end
  
  def init_defaults
    App::Persistence['splash'] = true if App::Persistence['splash'].nil?
  end
  
  def display_splash
    @splash       = UIImageView.alloc.initWithFrame( [[0,0],[320,480]] )
    @splash.image = UIImage.imageNamed( "splash.jpg" )
    
    @window.addSubview(@splash)
    @window.bringSubviewToFront(@splash)
    @window.rootViewController.view.alpha = 0.0
    
    self.performSelector( "remove_splash", withObject:nil, afterDelay:1.0 )
  end
    
  def remove_splash
    @splash.removeFromSuperview
    @window.rootViewController.view.alpha = 1.0
  end
end
