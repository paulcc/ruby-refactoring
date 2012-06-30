class Course < ActiveRecord::Base
  before_create :link_to_product

  has_many :categories
  has_many :resources
  has_many :teaching_sessions
  serialize :what_they_should_bring
  belongs_to :product

  validates_numericality_of :max_number_of_students
  validates_presence_of :product_id
  validates_associated :product		# need?

  def self.build_basics(params)
    fields = [:title, :number_of_teaching_classes, :max_number_of_students, 
              :start_date, :teaching_class_start_time, :teaching_class_end_time, 
              :recurrence, :standard_session_price]
    categories = Category.create_from_list(params[:categories])
    arg_hash = params.slice(*fields).merge :categories => categories 
    Course.create arg_hash
  end

  def self.create_and_add_teaching_session course_id, teaching_session_params
    course = Course.find(course_id)
    teaching_session = TeachingSession.new(teaching_session_params)
    course.add_teaching_session(teaching_session)
  end

  def duration
    duration_time = Time.parse(self.teaching_class_start_time) - Time.parse(self.teaching_class_end_time)
    (duration_time / 60 / 60 * -1).to_s
  end

  def self.add_overview course_id, params
    course = Course.find(course_id)
    course.overview = params[:overview]
    course.knowledge_and_skills = params[:knowledge_and_skills]
    course.practical_outcome = params[:practical_outcome]
    course.save
  end
  
  def add_teaching_session teaching_session
    self.teaching_sessions << teaching_session
  end
  
  def self.add_student_requirements course_id, params
  end

private

  def link_to_product
    p = Product.create! :name => title, :price => standard_session_price
    self.product_id = p.id
  end
  
end
