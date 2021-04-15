class Api::V1::VagasController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  before_action :set_vaga, only: [ :show, :update ]

  def index
    @vagas = policy_scope(Vaga)
  end

  def show
  end

  def update
    if @vaga.update(vaga_params)
      render :show
    else
      render_error
    end
  end

  def create
    @vaga = Vaga.new(vaga_params)
    @vaga.user = current_user
    authorize @vaga
    if @vaga.save
      render :show, status: :created
    else
      render_error
    end
  end

  private

  def vaga_params
    params.require(:vaga).permit(:título, :empresa, :nível, :descrição, :local, :url)
  end

  def render_error
    render json: { errors: @vaga.errors.full_messages },
      status: :unprocessable_entity
  end

  def set_vaga
    @vaga = Vaga.find(params[:id])
    authorize @vaga  # For Pundit
  end
end
