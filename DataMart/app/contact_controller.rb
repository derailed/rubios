class ContactsController < UITableViewController
  
  def cell_id() "contacts"; end
  
  def viewDidLoad
    view.dataSource = view.delegate = self
  end

  def viewWillAppear(animated)
    navigationItem.title              = 'Contacts'
    navigationItem.leftBarButtonItem  = editButtonItem
    navigationItem.rightBarButtonItem =  UIBarButtonItem.alloc
      .initWithBarButtonSystemItem( UIBarButtonSystemItemAdd, 
                                    target:self, action:'addContact')
    navigationItem.rightBarButtonItem.enabled = true
  end

  def addContact
    ContactStore.shared.add_contact do |contact|
      contact.name       = "Fernand"
      contact.age        = 21      
      contact.created_at = NSDate.date
      contact.updated_at = NSDate.date      
    end
    view.reloadData
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
