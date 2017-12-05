#Added by Kevin M
#ApplicationRecord added in 5.0 to replace ActiveRecord::Base inheritance in all models.
#Provides a single spot to configure app-wide model behavior.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end