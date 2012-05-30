module AdminHelper
  def admin_messages
    if params[:locale] == "es"
      AdminMessages.last_spanish
    else
      AdminMessages.last_english
    end
  end

  def link_to_admin
    if current_page?(leagues_path)
      content_tag :li, link_to(t('admin.link'), leagues_path), :class => 'active'
    else
      content_tag :li, link_to(t('admin.link'), leagues_path)
    end

  end

  def link_to_admin_leagues
    if current_page?(leagues_path)
      content_tag :li, link_to(t('admin.leagues'), leagues_path), :class => 'active'
    else
      content_tag :li, link_to(t('admin.leagues'), leagues_path)
    end
  end

  def link_to_admin_no_club_users
    if current_page?(no_club_users_path)
      content_tag :li, link_to(t('admin.no_club_users'), no_club_users_path), :class => 'active'
    else
      content_tag :li, link_to(t('admin.no_club_users'), no_club_users_path)
    end
  end

  def link_to_admin_messages
    if current_page?(messages_leagues_path)
      content_tag :li, link_to(t('admin.messages'), messages_leagues_path), :class => 'active'
    else
      content_tag :li, link_to(t('admin.messages'), messages_leagues_path)
    end
  end

  def link_to_admin_all_users
    if current_page?(all_users_path)
      content_tag :li, link_to(t('admin.all_users'), all_users_path), :class => 'active'
    else
      content_tag :li, link_to(t('admin.all_users'), all_users_path)
    end
  end

  def user_is_an_admin(user)
    if user.admin?
      return t("defaults.yes")
    else
      return t("defaults.no")
    end
  end

  def user_or_no_user(club)
    if club.user.nil?
      return t("default.no_user")
    else
      return h(club.user.login)
    end
  end
end
