json.array! @vagas do |vaga|
  json.extract! vaga, :título, :empresa, :nível, :descrição, :local, :url
end
