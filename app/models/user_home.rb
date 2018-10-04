class UserHome < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :home, optional: true

  validates_uniqueness_of :home_id, scope: :user_id
  order(role: :DESC)

  # def as_json(option = {})
  #    @home = Home.where("id=?",self[:home_id])
  #    super().merge({
  #      home: @home[0],
  #    })
  # end
end
