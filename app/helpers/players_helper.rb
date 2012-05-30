module PlayersHelper
  def rounds_training(training)
    num = training.round_count
    "#{pluralize(num, t('round.header'))} #{t('defaults.to_end_the')}
    #{t('clubs.trainings.header').
    singularize.downcase} #{t('defaults.of').downcase}
    #{t("players." + training.ability).downcase}"
  end
end
