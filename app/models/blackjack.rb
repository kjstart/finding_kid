class Blackjack < ActiveRecord::Base
        belongs_to :holder , {class_name: :User, foreign_key: 'holder'}
        belongs_to :attender , {class_name: :User, foreign_key: 'attender'}
        belongs_to :winner , {class_name: :User, foreign_key: 'winner'}
end
