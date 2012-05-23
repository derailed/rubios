class Contact < NSManagedObject
  def self.entity
    @entity ||= begin
      entity                        = NSEntityDescription.alloc.init
      entity.name                   = 'Contact'
      entity.managedObjectClassName = 'Contact'
      
      entity.properties = {
        name:       NSStringAttributeType,
        age:        NSInteger16AttributeType,
        created_at: NSDateAttributeType,
        updated_at: NSDateAttributeType}.each_pair.map do |name, type|
           property = NSAttributeDescription.alloc.init
           property.name          = name.to_s
           property.attributeType = type
           property.optional      = false
           property
         end
      entity
    end
  end  
end