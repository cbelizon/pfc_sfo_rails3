tactics_routes = Dir[Rails.root.join('lib/simulator/tactics/', '*.{yml}')]
TACTICS = {}
tactics_routes.each do |tactic_route|
  tactic = YAML.load_file(tactic_route)
  name = tactic["name"]
  tactic.delete("name")
  TACTICS[name] = tactic
end

TACTICS['available'] = TACTICS.keys
