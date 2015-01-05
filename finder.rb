
require 'csv'

gis = [501,502,503]

# Org Name,Category Name,Position,Score,CI Upper,CI Lower,CI

csv = CSV.generate do |csv|
  csv << ["Org Name","Category Name","Position","Score","CI Upper","CI Lower","CI"]
  Org.where(id: gis).each do |org|
    s=org.current_survey
    c=s.current_cycle
    crs = CategoryReport.any_in(model_id: s.categories.map(&:id)).where(cycle_id: c.id)
    crs.each do |cr|
      score = cr.score
      ci = Analytics.ci(cr.tau)
      csv << [org.name,cr.name,cr.position,score,score+ci,score-ci,ci]
    end
  end
end
puts csv

