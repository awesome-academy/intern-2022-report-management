class User < ApplicationRecord
  UPDATABLE_ATTRS = [:name, :email, :password, :password_confirmation,
                     :division_id, :avatar,
                      {addresses_attributes: [:id, :city,
                                             :country,
                                             :user_id,
                                             :_destroy]}].freeze

  enum role: {member: 0, manager: 1, admin: 2}

  VALID_EMAIL_REGEX = Settings.user.email_regex

  belongs_to :division, optional: true
  has_many :reports, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one_attached :avatar
  accepts_nested_attributes_for :addresses,
                                allow_destroy: true,
                                reject_if: :all_blank

  delegate :name, to: :division, prefix: true

  validates :name, presence: true,
            length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length},
            allow_nil: true

  validates :avatar,
            content_type: {in: Settings.user.image.image_path,
                           message: :wrong_format}

  has_secure_password

  before_save :downcase_email

  scope :recent, ->{order created_at: :desc}

  scope :by_division_id,
        (lambda do |division_id|
          where(division_id: division_id)
        end)
  scope :by_name,
        (lambda do |name|
          where("name like :name", name: "%#{name}%") if name.present?
        end)

  private

  def downcase_email
    email.downcase!
  end
end
