require "./spec_helper"

describe CertificateController do
  describe "#create" do
    it "uploads a certificate to a record" do
      clear Certificate do
        with_record do
          io = IO::Memory.new
          builder = HTTP::FormData::Builder.new(io, "certificate_controller_spec")
          certificate = File.new("spec/support/1.jpg")
          builder.file("certificate", certificate, HTTP::FormData::FileMetadata.new(filename: "1.jpg"))
          builder.finish
          io.rewind
          post("/records/1/certificate", HTTP::Headers{
            "Authorization" => "Bearer member_token",
            "Content-Type"  => builder.content_type,
          }, body: io)

          status_code.should eq(200)
          body.should eq(<<-JPEG
                            data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAAAAAAAD/wAARCAABAAEDASIAAhEBAxEB/8QAHwAA
                            AQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
                            AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcY
                            GRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4
                            eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJ
                            ytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEB
                            AQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEE
                            BSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygp
                            KjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaH
                            iImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX
                            2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9sAQwAcHBwcHBwwHBwwRDAwMERcRERE
                            RFx0XFxcXFx0jHR0dHR0dIyMjIyMjIyMqKioqKioxMTExMTc3Nzc3Nzc3Nzc
                            /9sAQwEiJCQ4NDhgNDRg5pyAnObm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm
                            5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm/90ABAAB/9oADAMBAAIRAxEAPwDm
                            6KKKAP/Z

                            JPEG
          )
        end
      end
    end
  end

  describe "#show" do
    it "gets a certificate of a record" do
      with_certificate do
        get "/records/1/certificate", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        body.should eq(<<-JPEG
                          data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAAAAAAAD/wAARCAABAAEDASIAAhEBAxEB/8QAHwAA
                          AQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
                          AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcY
                          GRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4
                          eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJ
                          ytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEB
                          AQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEE
                          BSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygp
                          KjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaH
                          iImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX
                          2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9sAQwAcHBwcHBwwHBwwRDAwMERcRERE
                          RFx0XFxcXFx0jHR0dHR0dIyMjIyMjIyMqKioqKioxMTExMTc3Nzc3Nzc3Nzc
                          /9sAQwEiJCQ4NDhgNDRg5pyAnObm5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm
                          5ubm5ubm5ubm5ubm5ubm5ubm5ubm5ubm/90ABAAB/9oADAMBAAIRAxEAPwDm
                          6KKKAP/Z

                          JPEG
        )
      end
    end
  end
end
