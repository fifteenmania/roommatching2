class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Tokenable
  serialize :metadata, Oj

  has_and_belongs_to_many :dongs
  has_and_belongs_to_many :periods
  
  has_one :survey
  has_one :preference_survey
  belongs_to :univ
  
  scope :all_except, ->(user) { where.not(id: user) }
  
  MATCH_NUM = 3
  
  # ------------  token handle ------------- #
  
  def self.find_user_with_token(token)
    User.where(token: token).take
  end
  
  def self.find_id_with_token(token)
    User.where(token: token).ids.first
  end
  
  def self.search_email(email)
    
  end
  
  # ------------- json queries ------------- #
  def basic_info_as_json
    return self.as_json(only: @@basic_info)
  end
  
  def profile_as_json
    return self.as_json(only: @@profile)
  end
  
  def univ_as_json
    univ = self.univ
    dorms = univ.dongs.where(gender: self.gender)
    periods = univ.periods.where(in_progress: true)
    return {dorms: dorms.as_json(only: [:id, :name]), 
            periods: periods.as_json(only: [:id, :name])}
  end
  
  def surveys_as_json
    survey = self.survey
    preference_survey = self.preference_survey
    return {survey: survey.questions_as_json,
            preference_survey: preference_survey.questions_as_json}
  end
  
  #-------------- matching -------------- #
  # should be refactored with sql (performance matter)
  
  def matching_fitness(self_survey, user_survey)
    fitness = 0
    if self_survey.sociality == user_survey.sociality then fitness += 1 end
    if self_survey.familiarity == user_survey.familiarity then fitness += 1 end
    if self_survey.awaken == user_survey.awaken then fitness += 1 end
    if self_survey.smoke == user_survey.smoke then fitness += 1 end
    if self_survey.game == user_survey.game then fitness += 1 end
    if self_survey.waketime == user_survey.waketime then fitness += 1 end
    return fitness
  end
  
  def find_match_ids
    self_survey = self.preference_survey
    
    user_ids = User.all_except(self).where(stage: 4, gender: self.gender, univ: self.univ_id).ids
    user_surveys = Survey.where(user_id: user_ids)
    
    fitnesses = Array.new(user_ids.length)
    
    # calculate matching fitnesses with all the matchable users.
    user_surveys.each_with_index do |user_survey, i|
      fitnesses[i] = [self.matching_fitness(self_survey, user_survey), user_survey.user_id]
    end
    
    # pick top three best-fit users and match the current user with them.
    top_users = fitnesses.sort.reverse.first(MATCH_NUM)
    top_users_ids = Array.new(top_users.length)
    top_users.each_with_index do |top_user, i|
      top_users_ids[i] = top_user[1]
    end
    
    return top_users_ids
  end
  
  def find_matches
    return User.where(id: self.find_match_ids)
  end
  
  def find_matches_as_json
    user_matches = self.find_matches
    info = {}
    info[:users] = []
    user_matches.each do |user_match|
      info[:users] << user_match.as_json(only: @@profile, include: [:survey])
    end
    return info
  end
end