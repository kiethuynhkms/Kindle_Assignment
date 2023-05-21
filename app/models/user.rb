class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, length: { minimum: 6, maximum: 160 }
    has_secure_password
    has_many :collections
    has_many :transactions
    has_many :highlights


    def as_json(options={})
        super(options.merge({ except: [:password, :password_digest] }))
    end

end