class Vaga < ApplicationRecord
  validates :título, :empresa, :nível, :descrição, :local, :url, presence: true
end
