class MoviePolicy < ApplicationPolicy
  def show?
    user.admin? || user.moderator? || user.user?
  end

  def create?
    user.admin? || user.moderator?
  end

  def update?
    user.admin? || user.moderator?
  end

  def destroy?
    user.admin?
  end
end
