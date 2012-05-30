# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  #If the user is not logged print links to register or login, but if the user
  #are logged print the nick and option to logout
  def sign_in
    dropdown_menu = content_tag(:a, :class => 'dropdown-toggle', 'data-toggle' => 'dropdown', :href => "#") do
      icon = content_tag(:i, '', :class => 'icon-white icon-user')
      if current_user
        icon += ' ' + current_user.login.html_safe
      else
        icon += ' ' + t('user').html_safe
      end
      icon + ' ' + content_tag(:b, '', :class => 'caret')
    end
    dropdown_menu << content_tag(:ul, :class => 'dropdown-menu') do
      if current_user
        content_tag(:li, link_to(t("logout"), :logout))
      else
        content_tag(:li, link_to(t("login"), :login)) +
        content_tag(:li, link_to(t("register"), new_user_path))
      end
    end
    content_tag(:li, dropdown_menu, :class => 'dropdown')
  end
  #only returns something if the user is an admin
  def for_admin
    current_user.admin? ? yield : nil unless current_user.nil?
  end

  #returns an string with the ordinal of cardinal number passed
  def number_to_ordinal(num)
    if params[:locale] == "en"
      num = num.to_i
      if (10...20)===num
        "#{num}th"
      else
        g = %w{ th st nd rd th th th th th th }
        a = num.to_s
        c=a[-1..-1].to_i
        a + g[c]
      end
    else
      num = num.to_i
      raw "#{num}&ordf;"
    end
  end

  def link_to_home
    link_to t('defaults.sitename'), home_path, :class => 'brand'
  end

  #CSRF for UJS
  def csrf_meta_tag
    if protect_against_forgery?
      out = %(<meta name="csrf-param" content="%s"/>\n)
      out << %(<meta name="csrf-token" content="%s"/>)
      out % [ Rack::Utils.escape_html(request_forgery_protection_token),
      Rack::Utils.escape_html(form_authenticity_token) ]
    end
  end
end
