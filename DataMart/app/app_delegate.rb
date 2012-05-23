class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame( UIScreen.mainScreen.bounds )
    
    @window.rootViewController = UINavigationController
                                .alloc
                                .initWithRootViewController( ContactsController.alloc.init )
                                
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    
    puts "Path: #{Kernel.documents_path}"
    true
  end
end
