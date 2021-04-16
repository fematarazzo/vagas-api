class Api::V1::VagasController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, except: [ :index, :show ]
  skip_before_action :authenticate_user!, only: [ :index, :show ], raise: false
  before_action :set_vaga, only: [ :show, :update, :destroy ]

  def index
    # If no field is used, return all
    if params[:search][:título] == "" && params[:search][:empresa] == "" && params[:search][:nível] == "" && params[:search][:descrição] == "" && params[:search][:local] == ""
      @vagas = policy_scope(Vaga)

    # If only título
    elsif params[:search][:título] && params[:search][:empresa] == "" && params[:search][:nível] == "" && params[:search][:descrição] == "" && params[:search][:local] == ""
      @vagas = policy_scope(Vaga).where('título LIKE ? ', '%' + params[:search][:título] + '%')

    # If only empresa
    elsif params[:search][:empresa] && params[:search][:título] == "" && params[:search][:nível] == "" && params[:search][:descrição] == "" && params[:search][:local] == ""
      @vagas = policy_scope(Vaga).where('empresa LIKE ? ', '%' + params[:search][:empresa] + '%')

    # If only nível
    elsif params[:search][:nível] && params[:search][:título] == "" && params[:search][:empresa] == "" && params[:search][:descrição] == "" && params[:search][:local] == ""
      @vagas = policy_scope(Vaga).where('nível LIKE ? ', '%' + params[:search][:nível] + '%')

    # If only descrição
    elsif params[:search][:descrição] && params[:search][:título] == "" && params[:search][:nível] == "" && params[:search][:título] == "" && params[:search][:local] == ""
      @vagas = policy_scope(Vaga).where('descrição LIKE ? ', '%' + params[:search][:descrição] + '%')

    # If only local
    elsif params[:search][:local] && params[:search][:título] == "" && params[:search][:nível] == "" && params[:search][:título] == "" && params[:search][:descrição] == ""
      @vagas = policy_scope(Vaga).where('local LIKE ? ', '%' + params[:search][:local] + '%')
    end
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

  def destroy
    @vaga.destroy
    head :no_content
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
