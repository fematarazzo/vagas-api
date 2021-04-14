class Vaga < ApplicationRecord
  validates :título, :empresa, :nível, :descrição, :url, presence: true
end
