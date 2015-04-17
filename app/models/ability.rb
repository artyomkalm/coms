class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all
    can :create, Comment    
  end
end
