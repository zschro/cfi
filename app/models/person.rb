class Person < ActiveRecord::Base
  acts_as_commentable
  has_many :photos
  has_one :student
  
  has_one :address
  accepts_nested_attributes_for :address
  
  has_one :public_education_info
  accepts_nested_attributes_for :public_education_info
  
  has_one :obligations
  accepts_nested_attributes_for :obligations
  
  has_one :social_development_info
  accepts_nested_attributes_for :social_development_info

  image_accessor :image

  delegate :name, :to => :village, :prefix => true, :allow_nil => true
  
  delegate :house_number, :group_number, :village, :to => :address, :allow_nil => true
  
  validates_presence_of :name

  def name_and_village
    "#{name} (Village: #{village_name})"
  end

  def add_comment(comment_text, user)
    comments.create!(:comment => comment_text, :user => user)
  end

  def recent_comments
    comments.find(:all, :order => "created_at desc")
  end
  
  def update_comment(comment, new_comment_text, user)
    comment = comments.find(comment.id)
    comment.comment = new_comment_text
    comment.user_id = user.id
    comment.updated_at = DateTime.now
    comment.save
  end
  
  def make_student!
    Student.create!(:person_id => self.id) unless student
  end
  
  def add_sibling(sibling)
    Relationship.create :from => self, :to => sibling, :relationship_type => "sibling"
  end
  
  def siblings
    Relationship.find(:all, :conditions => ["(from_id = :id OR to_id = :id) AND relationship_type = 'sibling'", {:id => self.id}]).map do |relationship|
      relationship.other_half(self)
    end
  end
  
  def remove_sibling(sibling)
    Relationship.including_people(self, sibling, 'sibling').destroy
  end
  
  
  def add_caretaker(caretaker, relationship_type)
    Relationship.create(:from_id => self.id, :to_id => caretaker.id, :caretaker => true, :relationship_type => relationship_type)
  end
  
  def caretakers
    Relationship.find(:all, :conditions => {:from_id => self.id, :caretaker => true}).map do |relationship| 
      relationship.to
    end
  end
  
  def caretaker_relationship(person)
    relationship = Relationship.find(:first, :conditions => {:from_id => self.id, :to_id => person.id, :caretaker => true})
    return '' if relationship.nil?
    relationship.relationship_type
  end
end
