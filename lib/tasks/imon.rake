require 'csv'

namespace :imon do
  desc 'Ingest data from individual source, recalculate all'
  task :ingest, [:row_number] => [:environment] do |task, args|
    Retriever.retrieve!(args[:row_number])

#    puts 'Country.count_indicators'
#    Country.count_indicators!
#
#    puts 'DatumSource.recalc_min_max_and_values!'
#    DatumSource.recalc_min_max_and_values!
#
#    puts 'Country.calculate_scores_and_rank!'
#    Country.calculate_scores_and_rank!
  end

  desc 'Export most recent data for all countries'
  task :export_most_recent, [:filename] => [:environment] do |task, args|
    export_most_recent args[:filename]
  end

  desc 'Import country bboxes'
  task :import_country_bboxes, [:filename] => [:environment] do |task, args|
    import_country_bboxes args[:filename]
  end
end

def export_most_recent( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:export_most_recent['output_filename.csv']"
    return
  end

  puts "Exporting to #{filename}"

  countries = Country.order( :iso3_code )
  puts "#{countries.count} countries"
  
  CSV.open( filename, 'wb' ) { |csv|
    csv << [ 'c_iso3_code', 'c_name', 'ds_public_name', 'ds_admin_name', 'ds_group', 'ds_affects_score', 'ds_min', 'ds_max', 'ds_default_weight', 'd_start_date', 'd_original_value', 'd_value' ]

    count = 0

    countries.each { |c|
      indicators = c.indicators.most_recent
      puts "#{c.name} has #{indicators.count} data values"

      indicators.each { |d|
        ds = d.source
        csv << [ c.iso3_code, c.name, ds.public_name, ds.admin_name, ( ds.group.present? ? ds.group.admin_name : nil ), ds.affects_score, ds.min, ds.max, ds.default_weight, d.start_date, d.original_value, d.value ]

        count += 1
      }
    }

    puts "#{count} data values exported total"
  }
end

def import_country_bboxes( filename )
  if filename.to_s == ''
    puts "Usage: rake imon:import_country_bboxes['db/data_files/country_bbox.json']"
    return
  end

  if !File.exists? filename
    puts "cannot find #{filename}"
    return
  end

  bbox_json = IO.read filename

  if bbox_json.nil?
    puts "error reading #{filename}"
    return
  end

  bboxen = JSON.parse bbox_json

  if bboxen.nil?
    puts "error parsing JSON from #{filename}"
    return
  end

  bboxen.each { |bbox|
    puts "setting #{bbox[0]} to #{bbox[1]}"
    country = Country.find_by_iso3_code bbox[0]
    if country.present?
      country.bbox = bbox[1].to_s
      country.save
    end
  }


end
