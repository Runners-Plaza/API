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
    if record.certificate.nil? &&
       (filename = image.filename) &&
       (md = filename.match /\.(gif|jpg|jpeg|png|pdf)$/) &&
       (type = md[1] == "jpg" ? "jpeg" : md[1]) &&
       (certificate = Certificate.new(record_id: record.id, data: data_uri(type, image.file.gets_to_end))) &&
       certificate.save
      certificate.data
    else
      bad_request! t("errors.certificate.create")
    end
  end

  def show
    authenticate!(User::Position::Manager).try { |e| return e } unless current_user.id == record.runner.user_id

    if certificate = record.certificate
      certificate.data
    else
      not_found! t("errors.certificate.not_found")
    end
  end

  private def data_uri(type, data)
    type = if type == "pdf"
             "application/pdf"
           else
             "image/#{type}"
           end
    "data:#{type};base64,#{Base64.encode(data)}"
  end

  private def set_runner
    not_found! t("errors.current_runner.not_found") unless @runner = current_user.runner?
  end

  private def set_record(runner = nil)
    if runner
      not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find_by(id: params["id"], runner_id: runner.id)
    else
      not_found! t("errors.record.not_found", {id: params["id"]}) unless @record = Record.find_by(id: params["id"])
    end
  end
end
