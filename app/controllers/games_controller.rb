class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy invite ]

  # GET /games or /games.json
  def index
    @games = Game.all
  end

  def invite
    # binding.b
    GameMailer.with(game: @game).invite.deliver_now
    redirect_to @game, notice: 'Invite sent'
  end

  # GET /games/1 or /games/1.json
  def show
    respond_to do |format|
      format.html
      format.ics do
        # render plain: @game.to_icalendar
        game_ics = Games::IcalendarEvent.new(game: @game).call
        # send_data @game.to_icalendar, filename: "#{@game.title}.ics"
        send_data game_ics, filename: "#{@game.title}.ics"
      end
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit(:starts_at, :ends_at, :title, :description, :address)
    end
end
