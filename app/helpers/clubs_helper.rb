module ClubsHelper
  def link_to_team_club(club)
    if !club.nil?
      if current_page?(team_club_path(club))
        content_tag :li, link_to("#{t('layouts.application.my_team')}: (#{club.name})", team_club_path(club)), :class => 'active'
      else
        content_tag :li, link_to("#{t('layouts.application.my_team')}: (#{club.name})", team_club_path(club))
      end
    end
  end

  def link_to_trainings_club(club)
    if !club.nil?
      if current_page?(trainings_club_path(club))
        content_tag :li, link_to(t('clubs.trainings.header'), trainings_club_path(club)), :class => 'active'
      else
        content_tag :li, link_to(t('clubs.trainings.header'), trainings_club_path(club))
      end
    end
  end

  def link_to_received_offers_club(club)
    if !club.nil?
      text  = pending_offers(t('clubs.received_offers.header'), club.pending_offers_as_seller.count)
      if current_page?(received_offers_club_path(club))
        content_tag :li, link_to(text, received_offers_club_path(club)), :class => 'active'
      else
        content_tag :li, link_to(text, received_offers_club_path(club))
      end
    end
  end

  def link_to_sent_offers_club(club)
    if !club.nil?
      text = pending_offers(t('clubs.sent_offers.header'), club.pending_offers_as_buyer.count)
      if current_page?(sent_offers_club_path(club))
        content_tag :li, link_to(text, sent_offers_club_path(club)), :class => :active
      else
        content_tag :li, link_to(text, sent_offers_club_path(club))
      end
    end
  end

  def link_to_last_match(club)
    if !club.nil?
      match = club.last_match
      if match.finished?
        string = "#{t('clubs.matchs.last_match')}: "
      else
        string = "#{t('clubs.matchs.next_match')}: "
      end
      string += "#{match.local.name} #{match.local_goals}
      - #{match.guest_goals} #{match.guest.name}"

      if current_page?(match_general_path(match))
        content_tag :li, link_to(string, match_general_path(match)), :class => 'active'
      else
        content_tag :li, link_to(string, match_general_path(match))
      end
    end
  end

  def cash(number)
    cash = t('clubs.finances.cash')
    return "#{cash}: #{number_to_currency(number,
    :precision => 2)}"
  end

  def link_to_finances_club(club)
    if !club.nil?
      if current_page?(finances_club_path(club))
        content_tag :li, link_to(t('clubs.finances.header').pluralize, finances_club_path(club)), :class => 'active'
      else
        content_tag :li, link_to(t('clubs.finances.header').pluralize, finances_club_path(club))
      end
    end
  end

  private
  def pending_offers(text, count)
    if  count > 0
      text = "#{text} (#{pluralize(count,
      "#{t('clubs.offers.header')} #{t('clubs.offers.pending').downcase}")})"
    end
    text
  end
end
