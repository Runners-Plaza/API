class CertificateController < ApplicationController
  property! runner : Runner
  property! record : Record

  before_action do
    all { response.content_type = "text/plain" }
    only [:create] { authenticate!(User::Position::Member) || set_runner || set_record(runner) }
    only [:show] { authenticate!(User::Position::Member) || set_record }
  end

  def create
    return forbidden!(t("errors.user.denied")) unless record.status.pending?

    image = params.files["certificate"]
    if record.certificate.nil? && (filename = image.filename) && (md = filename.match /\.(gif|jpg|jpeg|png)$/)
      type = md[1] == "jpg" ? "jpeg" : md[1]
      certificate = Certificate.create(record_id: record.id, type: type)
      FileUtils.cp(image.file.path, "certificates/#{certificate.id}.#{type}")
      data_uri(type, image.file.gets_to_end)
    else
      bad_request! t("errors.certificate.create")
    end
  end

  def show
    authenticate!(User::Position::Manager).try { |e| return e } unless current_user.id == record.runner.user_id

    if certificate = record.certificate
      data_uri(certificate.type, File.read("certificates/#{certificate.id}.#{certificate.type}"))
    else
      not_found! t("errors.certificate.not_found")
    end
  end

  private def data_uri(type, data)
    "data:image/#{type};base64,#{Base64.encode(data)}"
  end

  private def set_runner
    not_found! t("errors.current_runner.not_found") unless @runner = Runner.find_by(user_id: current_user.id)
  end

  private def set_record(runner = nil)
    if runner
      not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find_by(id: params["id"], runner_id: runner.id)
    else
      not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find_by(id: params["id"])
    end
  end
end
