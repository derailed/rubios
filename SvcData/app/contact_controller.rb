class ContactsController < UITableViewController

  def cell_id() "contacts"; end
    
  def viewDidLoad
    view.dataSource = view.delegate = self    
  end

  def viewWillAppear(animated)
    navigationItem.title = 'Contacts'
    navigationItem.leftBarButtonItem  = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc
                                                       .initWithBarButtonSystemItem( UIBarButtonSystemItemAdd, 
                                                                                     target:self, 
                                                                                     action:'add_contact')
    navigationItem.rightBarButtonItem.enabled = true    
    
    get_contacts    
  end

  def from_string_date_formatter
    @from_string_date_formatter ||= begin
      dateFormat = NSDateFormatter.alloc.init
      dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
      dateFormat
    end
  end
  
  def to_time( str )
    from_string_date_formatter.dateFromString( str )
  end
        
  def add_contact( map={ name:"Fernand", age:21, created_at:NSDate.date, updated_at:NSDate.date }, reload=true )
    ContactStore.shared.add_contact do |contact|
      contact.name       = map[:name]
      contact.age        = map[:age]
      contact.created_at = (map[:created_at].class == String ? to_time(map[:created_at]) : map[:created_at] )
      contact.updated_at = (map[:updated_at].class == String ? to_time(map[:updated_at]) : map[:updated_at] )
    end
    view.reloadData if reload
  end
  
  def get_contacts
    BubbleWrap::HTTP.get( "http://localhost:4567/contacts.json" ) do |response|
      if response.ok?
        data = BubbleWrap::JSON.parse( response.body.to_str )
        data.each do |row|
          add_contact( row, false )
        end
        view.reloadData
      else
        raise "Hoy - service is not running"
      end
    end    
  end
    
  def tableView(tableView, numberOfRowsInSection:section)
    ContactStore.shared.contacts.size
  end
    
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(cell_id) || 
           UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:cell_id)
           
    contact = ContactStore.shared.contacts[indexPath.row]
    
    @date_formatter ||= NSDateFormatter.alloc.init.tap do |df|
      df.timeStyle = NSDateFormatterMediumStyle
      df.dateStyle = NSDateFormatterMediumStyle
    end
    cell.textLabel.text       = @date_formatter.stringFromDate(contact.created_at)
    cell.detailTextLabel.text = "%10s:%d" % [contact.name, contact.age]
    cell
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    contact = ContactStore.shared.contacts[indexPath.row]
    ContactStore.shared.remove_contact(contact)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade)
  end
end