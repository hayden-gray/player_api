class PlayersController < ApplicationController
  before_action :validate_params, only: :search

# GET /players/1
  def show
    player = Player.find(params[:id])
    render json: present_single(player)
  end

# GET /players/search
  def search
    players = Player.where(map_search_params)
    players = match_last_name(players)
    render json: present_many(players)
  end

  private

  def present_single(player)
    {
      id: player.id,
      name_brief: player.name_brief,
      first_name: player.first_name,
      last_name: player.last_name,
      position: player.position,
      age: player.age,
      average_position_age_diff: player.average_position_age_diff
    }
  end

  def present_many(players_to_present)
    players = []
    players_to_present.each do |player|
      players << present_single(player)
    end
  end

  def map_search_params
    q_params = {}
    q_params.merge!({ sport: params['sport'] }) if params.include?('sport')
    q_params.merge!({ age: params['age'] }) if params.include?('age')
    q_params.merge!({ age: get_age_range }) if params.include?('age_range')
    q_params.merge!({ position: params['position'] }) if params.include?('position')
    q_params
  end

  def match_last_name(players)
    players.where("last_name like :prefix", prefix: "#{params['last_name']}%") if params.include?('last_name')
  end

  def get_age_range
    range = params['age_range'].sub('-', '..').delete(' ')
    range = range.split('..').map(&:to_i)
  end

  def validate_params
    if params.include?('sport') && !Player.sports.keys.include?(params['sport'])
      raise "sport can only be football, basketball, or baseball"
    end

    if params.include?('age_range') && !params['age_range'].include?('-')
      raise "age range should be formatted like so: 19-30"
    end
  end
end
