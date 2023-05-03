class RoomsController < InheritedResources::Base
  before_action :authenticate_user!

  def show
    @room = Room.find(params[:id])
    opentok = OpenTok::OpenTok.new('47709001', '246826d154470c432e2f35bede808d4239841b41')
    @token = opentok.generate_token @room.vonage_session_id, {name: current_user.id}
  end
  private

    def room_params
      params.require(:room).permit(:name, :vonage_session_id)
    end

end
