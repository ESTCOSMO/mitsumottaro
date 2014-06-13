# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

require "csv"

CSV.foreach('db/templatetask.csv') do |row|
  TemplateTask.create(name: row[0], position: row[1], price_per_day: row[2], default_task: false)
end

