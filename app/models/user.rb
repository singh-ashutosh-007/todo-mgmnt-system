class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  VALID_ROLES = ["super_admin", "manager", "developer"]

  validates :email, :password, :role, presence: true
  validates :team_id, presence: true, if: :developer?
  validates :email, uniqueness: true
  validate  :valid_role

  belongs_to  :development_team, class_name: "Team", foreign_key: :team_id
  has_many    :teams
  has_many    :developer_projects
  has_many    :projects, through: :developer_projects


  VALID_ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  private
    def valid_role
      errors.add(:role, "Invalid role") unless VALID_ROLES.include?(role)
    end
end
