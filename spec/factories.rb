# -*- coding: utf-8 -*-
FactoryGirl.define do
  factory :project_task do
    factory :project_task1 do
      name "要件定義"
    end
    factory :project_task2 do
      name "設計"
    end
    factory :project_task3 do
      name "試験"
    end
    factory :project_task4 do
      name "マニュアル"
    end
    factory :project_task5 do
      name "導入"
    end
  end
  factory :template_task do
    factory :template_task1 do
      name "要件定義テンプレート"
      price_per_day 55000
    end
    factory :template_task2 do
      name "設計テンプレート"
      price_per_day 45000
    end
  end
end
