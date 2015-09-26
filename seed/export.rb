#!/usr/bin/env ruby

require 'pg'

$intcols = %w(id brewery_id cat_id style_id upc add_user)
$floatcol = %w(abv ibu srm)
$datetime = %w(last_mod inserted_at updated_at)

def convertHash(table, hash)
  list = hash.keys.reduce [] do |acc, k|
    hashvalue = hash[k]
    unless hashvalue.nil?
      if hashvalue.include? '"'
        escapedvalue = hashvalue.gsub! '"', "\\\""
      else
        escapedvalue = hashvalue
      end
      if $intcols.include? k
        escapedvalue = escapedvalue.to_i
      elsif $floatcol.include? k
        escapedvalue = escapedvalue.to_f
      elsif $datetime.include? k
        escapedvalue = "elem(Ecto.DateTime.cast(\"#{escapedvalue}\"), 1)"
      else
        escapedvalue = "\"#{escapedvalue}\""
      end
      acc.push "#{k}: #{escapedvalue}";
    end
    acc
  end
  "%#{table}{#{list.join ', '}}"
end

conn = PG.connect( dbname: 'beers' )
puts "alias Beermusings.Beer"
conn.exec( "SELECT * FROM beers.beers;" ) do |results|
  results.each do |row|
    converted = convertHash('Beer', row)
    puts "Beermusings.Repo.insert!(#{converted})"
  end
end
puts "alias Beermusings.Brewery"
conn.exec( "SELECT * FROM beers.breweries;" ) do |results|
  results.each do |row|
    converted = convertHash('Brewery', row)
    puts "Beermusings.Repo.insert!(#{converted})"
  end
end
