module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Commentable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_commentable
          has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
        end
      end

    end
  end
end
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Commentable)

