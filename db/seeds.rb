require 'nokogiri'
require 'httparty'
require 'byebug'

puts "Limpando base..."
Vaga.destroy_all

api_token = ENV['API_TOKEN']

url = CGI.escape "https://www.vagas.com.br/vagas-de-"

unparsed_url = HTTParty.get('https://api.scraperbox.com/scrape?token=' + api_token + '&url=' + url + '&javascript_enabled=true')
parsed_url = Nokogiri::HTML(unparsed_url)

lista_vagas = parsed_url.css('li.vaga') #lista de vagas (40)
page = 1
per_page = lista_vagas.count # 40 vagas
total = parsed_url.css('div.faixa').text.strip!.split(" ").first.to_i # 2680 vagas de tecnologia hoje (14/04/2021)
last_page = ( total.to_f / per_page.to_f ).round # contagem de paginas total

while page <= last_page
  puts "Page: #{page}"
  puts ''
  pagination_url = CGI.escape "https://www.vagas.com.br/vagas-de-?pagina=#{page}&q="
  pagination_unparsed_url = HTTParty.get('https://api.scraperbox.com/scrape?token=' + api_token + '&url=' + pagination_url + '&javascript_enabled=true')
  pagination_parsed_url = Nokogiri::HTML(pagination_unparsed_url)
  pagination_lista_vagas = pagination_parsed_url.css('li.vaga')

  pagination_lista_vagas.each do |vaga|
    puts "Achando vaga..."
    vaga = Vaga.new(
      título: vaga.css('h2').text.strip!,
      empresa: vaga.css('span.emprVaga').text.strip!,
      nível: vaga.css('div.nivelQtdVagas').text.strip!,
      descrição:  vaga.css('div.detalhes').text.strip!,
      local: vaga.css('span.vaga-local').text.strip!,
      url: "https://www.vagas.com.br#{vaga.css('a')[0].attributes["href"].value}",
      user_id: User.first.id
    )
    puts "...salvando..."
    vaga.save!
    puts "...tudo certo! Vaga de #{vaga.título} criada!"
    puts ''
  end
  page += 1
end
