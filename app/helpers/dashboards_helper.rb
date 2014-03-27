# -*- coding: utf-8 -*-
module DashboardsHelper
  def up_arrow_link_to_unless(condition, options={})
    link_to_unless(condition, '↑', options, class: 'arrow'){ }
  end
  def down_arrow_link_to_unless(condition, options={})
    link_to_unless(condition, '↓', options, class: 'arrow'){ }
  end
end
