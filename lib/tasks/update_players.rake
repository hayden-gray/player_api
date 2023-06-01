namespace :players do
  desc 'Refresh players table with most up to date data'

  task :update => :environment do
    SPORTS = ['football', 'basketball', 'baseball']

    SPORTS.each do |sport|
      puts "Updating #{sport} players"
      players_from_api = get_players(sport)

      players_from_api.each do |player|
        # check if player is already in the database
        if Player.find_by(api_id: player['id']).present?
          puts "Existing player"
          existing_player = Player.find_by(api_id: player['id'])

          #assumption - only position, age are likely to change
          existing_player.position = player['position'],
          existing_player.age = player['age'].to_i

          # only perform db write if there are changes
          if existing_player.changes.present?
            puts "Changes detected - Performing update"
            existing_player.save
          end
        else
          puts "Adding new player"
          Player.create(
            first_name: player['firstname'],
            last_name: player['lastname'],
            name_brief: name_brief(player, sport),
            position: player['position'],
            age: player['age'].to_i,
            sport: sport,
            api_id: player['id']
          )
        end
      end

      # Remove players that weren't returned from the API from the db
      cleanup_old_players(players_from_api, sport)
    end
  end

  def get_players(sport)
    players = RestClient.get(
      "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=#{sport}&response_format=JSON"
    )
    JSON.parse(players)['body']['players']
  end

  def name_brief(player, sport)
    if sport == 'football'
      "#{player['firstname'].chr.capitalize} #{player['lastname'].capitalize}"
    elsif sport == 'basketball'
      "#{player['firstname'].capitalize} #{player['lastname'].chr.capitalize}"
    else
      "#{player['firstname'].chr.capitalize} #{player['lastname'].chr.capitalize}"
    end
  end

  def cleanup_old_players(players, sport)
    old_players = Player.where(sport: sport).where.not(api_id: players.pluck('id'))
    old_players.destroy_all
  end
end
