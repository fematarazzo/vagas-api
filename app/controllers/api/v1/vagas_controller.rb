class Api::V1::VagasController < Api::V1::BaseController
  def index
    @vagas = policy_scope(Vaga)
  end
end
