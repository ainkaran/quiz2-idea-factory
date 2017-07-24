class Idea < ApplicationRecord

  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates(:description, { presence: true, length: { minimum: 5, maximum: 4000 }})

  validate :no_monkey

  after_save :capitalize_title

  def self.search(str)
    search_term = str
    where(["title ILIKE? OR description ILIKE?", "%#{search_term}%", "%#{search_term}%"]).order(:title, :description)
  end

  def self.recent(count)
    order({ created_at: :desc }).limit(count)
  end

  private

  def no_monkey
    if title.present? && title.downcase.include?('monkey')
      errors.add(:title, 'No monkey please! 🙈')
    end
  end

  def capitalize_title
    self.title = title.capitalize if title.present?
  end

  def destroy_notification
    Rails.logger.warn("The Idea #{self.title} is about to be deleted")
  end

end
