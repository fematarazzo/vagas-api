class Api::V1::VagasController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @vagas = policy_scope(Vaga)
  end
end
