class ContactStore
  
  def self.shared
    @shared ||= ContactStore.new
  end

  def store() "Contact"; end
  
  def contacts
    @contacts ||= begin
      request                 = NSFetchRequest.alloc.init
      request.entity          = NSEntityDescription.entityForName(store, inManagedObjectContext:@context)
      request.sortDescriptors = [ NSSortDescriptor.alloc.initWithKey('created_at', ascending:false) ] 

      error_ptr = Pointer.new(:object)
      data = @context.executeFetchRequest(request, error:error_ptr)
      if data == nil
        raise "Error when fetching data: #{error_ptr[0].description}"
      end
      data
    end
  end

  def add_contact
    yield NSEntityDescription.insertNewObjectForEntityForName(store, inManagedObjectContext:@context)
    save
  end

  def remove_contact( contact )
    @context.deleteObject( contact )
    save
  end

  private

  def initialize
    model          = NSManagedObjectModel.alloc.init
    model.entities = [Contact.entity]

    store     = NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(model)
    store_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', 'Contacts.sqlite'))
    error_ptr = Pointer.new(:object)
    unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:store_url, options:nil, error:error_ptr)
      raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
    end

    @context = NSManagedObjectContext.alloc.init
    @context.persistentStoreCoordinator = store    
  end

  def save
    error_ptr = Pointer.new(:object)
    unless @context.save(error_ptr)
      raise "Error when saving the model: #{error_ptr[0].description}"
    end
    @contacts = nil
  end
end
