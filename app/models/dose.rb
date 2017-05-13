class Dose < ApplicationRecord
  belongs_to :ingredient, -> { order(name: :asc) }
  belongs_to :cocktail

  validates :description, presence: true
  validates :cocktail, presence: true
  validates :ingredient, presence: true, uniqueness: { scope: :cocktail }
end
