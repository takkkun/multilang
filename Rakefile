require 'bundler/gem_tasks'
require 'open-uri'
require 'nokogiri'
require 'yaml'

desc 'Update language_names.yaml that refer from http://www.loc.gov/standards/iso639-2/php/code_list.php'
task :update do
  document = Nokogiri::HTML(open('http://www.loc.gov/standards/iso639-2/php/code_list.php').read)
  table = document.xpath('//h1/following-sibling::table')

  language_names = table.xpath('tr/td[@scope="row"]/parent::tr').map do |row|
    iso_639_2, iso_639_1, name = row.children.map(&:text).map(&:strip).reject(&:empty?)

    if match = /([a-z]{3})\s*\(B\)/.match(iso_639_2)
      iso_639_2 = match.captures[0]
    end

    aliases = [iso_639_2]
    aliases << iso_639_1 unless iso_639_1 == "\u00a0"
    [name, aliases]
  end

  File.open(File.join(File.dirname(__FILE__), %w(lib multilang language_names.yaml)), 'w') do |file|
    YAML.dump(Hash[language_names], file)
  end
end
