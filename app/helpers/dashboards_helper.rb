# -*- coding: utf-8 -*-
module DashboardsHelper
  def up_arrow_link_to_unless(condition, options={}, anchor_name)
    link_to_unless(condition, '↑', options, name: anchor_name, class: 'arrow'){ }
  end
  def down_arrow_link_to_unless(condition, options={}, anchor_name)
    link_to_unless(condition, '↓', options, name: anchor_name, class: 'arrow'){ }
  end
end
