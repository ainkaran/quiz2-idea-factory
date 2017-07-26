class Ability
  include CanCan::Ability

  def initialize(user)

    # user -> current_user
    # if the user is not signed in then `user` will be `nil`

    # it usually recommended that you initialize the `user` argument to a new
    # User so we don't have to check if `user` is nil all the time.
    user ||= User.new

    if user.is_admin?
      can :manage, :all
    end

    # DSL -> Domain Specific Language: Ruby code written in a certain way to
    #                                  looks like its own language but keep in
    #                                  mind it's just Ruby code

    # in this rule we're saying: the user can `manage` meaning do any action on
    # the question object if `ques.user == user` which means if the owner of
    # the question is the currently signed in user
    can :manage, Idea do |idea|
      idea.user == user
    end

    can :destroy, Review do |rev|
      rev.user == user || rev.idea.user == user
    end

    can :create, Review do |rev|
      rev.user == user && rev.user != rev.idea.user
    end

    can :like, Idea do |idea|
      idea.user != user
    end

    cannot :like, Idea do |idea|
      idea.user == user
    end

    # remember that this only defines the rules, you still have to enforce the
    # rules yourself by actually using those rules in the controllers and views
    # the advantage is that all of our authoization rules are in one file so we
    # only have to come and change this file when authoization rules change.

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
