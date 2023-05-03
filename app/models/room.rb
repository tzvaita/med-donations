class Room < ApplicationRecord
  before_create do
    opentok = OpenTok::OpenTok.new('47709001', '246826d154470c432e2f35bede808d4239841b41')
    session = opentok.create_session

    self.vonage_session_id = session.session_id
  end
end
