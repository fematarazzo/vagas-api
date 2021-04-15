class Api::V1::VagasController < Api::V1::BaseController
  before_action :set_vaga, only: [ :show ]

  def index
    @vagas = policy_scope(Vaga)
  end

  def show
  end

  private

  def set_vaga
    @vaga = Vaga.find(params[:id])
    authorize @vaga  # For Pundit
  end
end
