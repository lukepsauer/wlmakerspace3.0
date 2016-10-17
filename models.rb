class User < Sequel::Model
  one_to_many :trainings
  one_to_many
end
class Post < Sequel::Model

end
class Activity < Sequel::Model

end
class Training < Sequel::Model
  many_to_one :users
end
