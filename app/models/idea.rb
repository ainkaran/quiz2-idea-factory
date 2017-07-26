class Idea < ApplicationRecord
  has_many :likes, dependent: :destroy

  has_many :likers, through: :likes, source: :user

  # Like `belongs_to`, `has_many` tells Rails that Idea is associated to
  # the Review model.
  has_many :reviews, dependent: :destroy
  # `dependent: :destroy` will delete all associated reviews to the idea
  # before the idea is deleted.

  # `dependent: :nullify` will update the `idea_id` in all associated reviews
  # to `NULL` before the is deleted.

  # reviews
  # reviews<<(object, ...)
  # reviews.delete(object, ...)
  # reviews.destroy(object, ...)
  # reviews=(objects)
  # reviews_singular_ids
  # reviews_singular_ids=(ids)
  # reviews.clear
  # reviews.empty?
  # reviews.size
  # reviews.find(...)
  # reviews.where(...)
  # reviews.exists?(...)
  # reviews.build(attributes = {}, ...)
  # reviews.create(attributes = {})
  # reviews.create!(attributes = {})

  belongs_to :user

  # we can define validations here, validations will be called before saving
  # or before creating a record and will prevent the saving or creation from
  # happening if the validation rules are not met.
  # we can call `.save` we will get back `true` if it completes successfully and
  # will get back `false` if validations fail
  validates(:title, { presence: { message: 'must be provided' },
                      uniqueness: true
                    })
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
