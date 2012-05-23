class PrefsController < UIViewController
  
  def loadView
    self.view = UIScrollView.alloc.init    
  end
  
  def viewDidLoad
    button = UIButton.buttonWithType(UIButtonTypeDetailDisclosure)
    
    self.view.addSubview( create_label( "SuckMeSideways!" ) )
    
    @button = create_button
    self.view.addSubview( @button )    
    @button.when( UIControlEventTouchUpInside ) do
      title = @button.titleForState( !@button.selected? ? UIControlStateSelected : UIControlStateNormal )
      App::Persistence['splash'] = title[/Show/].nil?
      @button.selected = !@button.selected?
    end
  end
  
  # ===========================================================================
  private 
    
  def create_label( text )
    label                 = UILabel.alloc.initWithFrame( [[0,330], [320, 80]] )
    label.text            = text
    label.backgroundColor = UIColor.clearColor
    label.font            = UIFont.boldSystemFontOfSize(34)
    label.color           = UIColor.blueColor
    label.textAlignment   = UITextAlignmentCenter
    label
  end
  
  def create_button
    states       = %w[Hide Show]
    text, s_text = App::Persistence['splash'] ? states : states.reverse
    
    button       = UIButton.buttonWithType( UIButtonTypeRoundedRect )
    size         = UIScreen.mainScreen.bounds.size
    button_size  = CGSize.new( 130, 30 )
    button.frame = [center( button_size), button_size]
    
    button.setTitle( "#{text} Splash"  , forState:UIControlStateNormal )
    button.setTitle( "#{s_text} Splash", forState:UIControlStateSelected )
    button
  end
  
  def center( size )
    screen_size = UIScreen.mainScreen.bounds.size
    CGPoint.new( screen_size.width/2-size.width/2,screen_size.height/2-size.height/2 )
  end
end