class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :gym_id, :role, :name
  # attr_accessible :title, :body

  belongs_to :gym

  def is_owner?
    role == "owner"
  end

  def is_member?
    role == "member"
  end
end
