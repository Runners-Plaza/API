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
    it "gets an image certificate of a record" do
      with_image_certificate do
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

    it "gets a pdf certificate of a record" do
      with_pdf_certificate do
        get "/records/1/certificate", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        body.should eq(<<-PDF
                          data:application/pdf;base64,JVBERi0xLjMKJcTl8uXrp/Og0MTGCjQgMCBvYmoKPDwgL0xlbmd0aCA1IDAg
                          UiAvRmlsdGVyIC9GbGF0ZURlY29kZSA+PgpzdHJlYW0KeAErVAhUKFTQD0gt
                          Sk4tKClNzFEoygQKGCoYAKGhgpGluYKJkYGeqUJyroK+Z66hgks+UEcgAK6s
                          DlwKZW5kc3RyZWFtCmVuZG9iago1IDAgb2JqCjU5CmVuZG9iagoyIDAgb2Jq
                          Cjw8IC9UeXBlIC9QYWdlIC9QYXJlbnQgMyAwIFIgL1Jlc291cmNlcyA2IDAg
                          UiAvQ29udGVudHMgNCAwIFIgL01lZGlhQm94IFswIDAgNTk1IDg0Ml0KL1Jv
                          dGF0ZSAwID4+CmVuZG9iago2IDAgb2JqCjw8IC9Qcm9jU2V0IFsgL1BERiAv
                          SW1hZ2VCIC9JbWFnZUMgL0ltYWdlSSBdIC9YT2JqZWN0IDw8IC9JbTEgNyAw
                          IFIgPj4gPj4KZW5kb2JqCjcgMCBvYmoKPDwgL0xlbmd0aCA4IDAgUiAvVHlw
                          ZSAvWE9iamVjdCAvU3VidHlwZSAvSW1hZ2UgL1dpZHRoIDEgL0hlaWdodCAx
                          IC9JbnRlcnBvbGF0ZQp0cnVlIC9Db2xvclNwYWNlIDkgMCBSIC9JbnRlbnQg
                          L1BlcmNlcHR1YWwgL0JpdHNQZXJDb21wb25lbnQgOCAvRmlsdGVyIC9EQ1RE
                          ZWNvZGUKPj4Kc3RyZWFtCv/Y/+AAEEpGSUYAAQEAAEgASAAA/8AAEQgAAQAB
                          AwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//E
                          ALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNC
                          scEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldY
                          WVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqy
                          s7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5
                          +v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQE
                          AwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy
                          0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdo
                          aWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5
                          usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAgIC
                          AgICAwICAwUDAwMFBgUFBQUGCAYGBgYGCAoICAgICAgKCgoKCgoKCgwMDAwM
                          DA4ODg4ODw8PDw8PDw8PD//bAEMBAgMDBAQEBwQEBxALCQsQEBAQEBAQEBAQ
                          EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEP/dAAQA
                          Af/aAAwDAQACEQMRAD8A/AeiiigD/9kKZW5kc3RyZWFtCmVuZG9iago4IDAg
                          b2JqCjYzNwplbmRvYmoKMTAgMCBvYmoKPDwgL0xlbmd0aCAxMSAwIFIgL04g
                          MyAvQWx0ZXJuYXRlIC9EZXZpY2VSR0IgL0ZpbHRlciAvRmxhdGVEZWNvZGUg
                          Pj4Kc3RyZWFtCngBnZZ3VFPZFofPvTe90BIiICX0GnoJINI7SBUEUYlJgFAC
                          hoQmdkQFRhQRKVZkVMABR4ciY0UUC4OCYtcJ8hBQxsFRREXl3YxrCe+tNfPe
                          mv3HWd/Z57fX2Wfvfde6AFD8ggTCdFgBgDShWBTu68FcEhPLxPcCGBABDlgB
                          wOFmZgRH+EQC1Py9PZmZqEjGs/buLoBku9ssv1Amc9b/f5EiN0MkBgAKRdU2
                          PH4mF+UClFOzxRky/wTK9JUpMoYxMhahCaKsIuPEr2z2p+Yru8mYlybkoRpZ
                          zhm8NJ6Mu1DemiXho4wEoVyYJeBno3wHZb1USZoA5fco09P4nEwAMBSZX8zn
                          JqFsiTJFFBnuifICAAiUxDm8cg6L+TlongB4pmfkigSJSWKmEdeYaeXoyGb6
                          8bNT+WIxK5TDTeGIeEzP9LQMjjAXgK9vlkUBJVltmWiR7a0c7e1Z1uZo+b/Z
                          3x5+U/09yHr7VfEm7M+eQYyeWd9s7KwvvRYA9iRamx2zvpVVALRtBkDl4axP
                          7yAA8gUAtN6c8x6GbF6SxOIMJwuL7OxscwGfay4r6Df7n4Jvyr+GOfeZy+77
                          VjumFz+BI0kVM2VF5aanpktEzMwMDpfPZP33EP/jwDlpzcnDLJyfwBfxhehV
                          UeiUCYSJaLuFPIFYkC5kCoR/1eF/GDYnBxl+nWsUaHVfAH2FOVC4SQfIbz0A
                          QyMDJG4/egJ961sQMQrIvrxorZGvc48yev7n+h8LXIpu4UxBIlPm9gyPZHIl
                          oiwZo9+EbMECEpAHdKAKNIEuMAIsYA0cgDNwA94gAISASBADlgMuSAJpQASy
                          QT7YAApBMdgBdoNqcADUgXrQBE6CNnAGXARXwA1wCwyAR0AKhsFLMAHegWkI
                          gvAQFaJBqpAWpA+ZQtYQG1oIeUNBUDgUA8VDiZAQkkD50CaoGCqDqqFDUD30
                          I3Qaughdg/qgB9AgNAb9AX2EEZgC02EN2AC2gNmwOxwIR8LL4ER4FZwHF8Db
                          4Uq4Fj4Ot8IX4RvwACyFX8KTCEDICAPRRlgIG/FEQpBYJAERIWuRIqQCqUWa
                          kA6kG7mNSJFx5AMGh6FhmBgWxhnjh1mM4WJWYdZiSjDVmGOYVkwX5jZmEDOB
                          +YKlYtWxplgnrD92CTYRm40txFZgj2BbsJexA9hh7DscDsfAGeIccH64GFwy
                          bjWuBLcP14y7gOvDDeEm8Xi8Kt4U74IPwXPwYnwhvgp/HH8e348fxr8nkAla
                          BGuCDyGWICRsJFQQGgjnCP2EEcI0UYGoT3QihhB5xFxiKbGO2EG8SRwmTpMU
                          SYYkF1IkKZm0gVRJaiJdJj0mvSGTyTpkR3IYWUBeT64knyBfJQ+SP1CUKCYU
                          T0ocRULZTjlKuUB5QHlDpVINqG7UWKqYup1aT71EfUp9L0eTM5fzl+PJrZOr
                          kWuV65d7JU+U15d3l18unydfIX9K/qb8uAJRwUDBU4GjsFahRuG0wj2FSUWa
                          opViiGKaYolig+I1xVElvJKBkrcST6lA6bDSJaUhGkLTpXnSuLRNtDraZdow
                          HUc3pPvTk+nF9B/ovfQJZSVlW+Uo5RzlGuWzylIGwjBg+DNSGaWMk4y7jI/z
                          NOa5z+PP2zavaV7/vCmV+SpuKnyVIpVmlQGVj6pMVW/VFNWdqm2qT9QwaiZq
                          YWrZavvVLquNz6fPd57PnV80/+T8h+qwuol6uPpq9cPqPeqTGpoavhoZGlUa
                          lzTGNRmabprJmuWa5zTHtGhaC7UEWuVa57VeMJWZ7sxUZiWzizmhra7tpy3R
                          PqTdqz2tY6izWGejTrPOE12SLls3Qbdct1N3Qk9LL1gvX69R76E+UZ+tn6S/
                          R79bf8rA0CDaYItBm8GooYqhv2GeYaPhYyOqkavRKqNaozvGOGO2cYrxPuNb
                          JrCJnUmSSY3JTVPY1N5UYLrPtM8Ma+ZoJjSrNbvHorDcWVmsRtagOcM8yHyj
                          eZv5Kws9i1iLnRbdFl8s7SxTLessH1kpWQVYbbTqsPrD2sSaa11jfceGauNj
                          s86m3ea1rakt33a/7X07ml2w3Ra7TrvP9g72Ivsm+zEHPYd4h70O99h0dii7
                          hH3VEevo4bjO8YzjByd7J7HTSaffnVnOKc4NzqMLDBfwF9QtGHLRceG4HHKR
                          LmQujF94cKHUVduV41rr+sxN143ndsRtxN3YPdn9uPsrD0sPkUeLx5Snk+ca
                          zwteiJevV5FXr7eS92Lvau+nPjo+iT6NPhO+dr6rfS/4Yf0C/Xb63fPX8Of6
                          1/tPBDgErAnoCqQERgRWBz4LMgkSBXUEw8EBwbuCHy/SXyRc1BYCQvxDdoU8
                          CTUMXRX6cxguLDSsJux5uFV4fnh3BC1iRURDxLtIj8jSyEeLjRZLFndGyUfF
                          RdVHTUV7RZdFS5dYLFmz5EaMWowgpj0WHxsVeyR2cqn30t1Lh+Ps4grj7i4z
                          XJaz7NpyteWpy8+ukF/BWXEqHhsfHd8Q/4kTwqnlTK70X7l35QTXk7uH+5Ln
                          xivnjfFd+GX8kQSXhLKE0USXxF2JY0muSRVJ4wJPQbXgdbJf8oHkqZSQlKMp
                          M6nRqc1phLT4tNNCJWGKsCtdMz0nvS/DNKMwQ7rKadXuVROiQNGRTChzWWa7
                          mI7+TPVIjCSbJYNZC7Nqst5nR2WfylHMEeb05JrkbssdyfPJ+341ZjV3dWe+
                          dv6G/ME17msOrYXWrlzbuU53XcG64fW+649tIG1I2fDLRsuNZRvfbore1FGg
                          UbC+YGiz7+bGQrlCUeG9Lc5bDmzFbBVs7d1ms61q25ciXtH1YsviiuJPJdyS
                          699ZfVf53cz2hO29pfal+3fgdgh33N3puvNYmWJZXtnQruBdreXM8qLyt7tX
                          7L5WYVtxYA9pj2SPtDKosr1Kr2pH1afqpOqBGo+a5r3qe7ftndrH29e/321/
                          0wGNA8UHPh4UHLx/yPdQa61BbcVh3OGsw8/rouq6v2d/X39E7Ujxkc9HhUel
                          x8KPddU71Nc3qDeUNsKNksax43HHb/3g9UN7E6vpUDOjufgEOCE58eLH+B/v
                          ngw82XmKfarpJ/2f9rbQWopaodbc1om2pDZpe0x73+mA050dzh0tP5v/fPSM
                          9pmas8pnS8+RzhWcmzmfd37yQsaF8YuJF4c6V3Q+urTk0p2usK7ey4GXr17x
                          uXKp2737/FWXq2euOV07fZ19ve2G/Y3WHruell/sfmnpte9tvelws/2W462O
                          vgV95/pd+y/e9rp95Y7/nRsDiwb67i6+e/9e3D3pfd790QepD14/zHo4/Wj9
                          Y+zjoicKTyqeqj+t/dX412apvfTsoNdgz7OIZ4+GuEMv/5X5r0/DBc+pzytG
                          tEbqR61Hz4z5jN16sfTF8MuMl9Pjhb8p/rb3ldGrn353+71nYsnE8GvR65k/
                          St6ovjn61vZt52To5NN3ae+mp4req74/9oH9oftj9MeR6exP+E+Vn40/d3wJ
                          /PJ4Jm1m5t/3hPP7CmVuZHN0cmVhbQplbmRvYmoKMTEgMCBvYmoKMjYxMgpl
                          bmRvYmoKOSAwIG9iagpbIC9JQ0NCYXNlZCAxMCAwIFIgXQplbmRvYmoKMyAw
                          IG9iago8PCAvVHlwZSAvUGFnZXMgL01lZGlhQm94IFswIDAgNjEyIDc5Ml0g
                          L0NvdW50IDEgL0tpZHMgWyAyIDAgUiBdID4+CmVuZG9iagoxMiAwIG9iago8
                          PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMyAwIFIgPj4KZW5kb2JqCjEgMCBv
                          YmoKPDwgL1Byb2R1Y2VyICj+/1wwMDBtXDAwMGFcMDAwY1wwMDBPXDAwMFNc
                          MDAwIHJIZyxcMDAwMVwwMDAwXDAwMC5cMDAwMVwwMDA1XDAwMC5cMDAwMv9c
                          MDEwckiGX1wwMDAxXDAwMDlcMDAwQ1wwMDAzXDAwMDlcMDAwZP9cMDExXDAw
                          MCBcMDAwUVwwMDB1XDAwMGFcMDAwclwwMDB0XDAwMHpcMDAwIFwwMDBQXDAw
                          MERcMDAwRlwwMDBDXDAwMG9cMDAwblwwMDB0XDAwMGVcMDAweFwwMDB0KQov
                          Q3JlYXRpb25EYXRlIChEOjIwMTkxMTIwMDczNTQ3WjAwJzAwJykgL01vZERh
                          dGUgKEQ6MjAxOTExMjAwNzM1NDdaMDAnMDAnKQo+PgplbmRvYmoKeHJlZgow
                          IDEzCjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwNDEzNSAwMDAwMCBuIAow
                          MDAwMDAwMTczIDAwMDAwIG4gCjAwMDAwMDQwMDIgMDAwMDAgbiAKMDAwMDAw
                          MDAyMiAwMDAwMCBuIAowMDAwMDAwMTU1IDAwMDAwIG4gCjAwMDAwMDAyODcg
                          MDAwMDAgbiAKMDAwMDAwMDM3NiAwMDAwMCBuIAowMDAwMDAxMjExIDAwMDAw
                          IG4gCjAwMDAwMDM5NjYgMDAwMDAgbiAKMDAwMDAwMTIzMCAwMDAwMCBuIAow
                          MDAwMDAzOTQ1IDAwMDAwIG4gCjAwMDAwMDQwODUgMDAwMDAgbiAKdHJhaWxl
                          cgo8PCAvU2l6ZSAxMyAvUm9vdCAxMiAwIFIgL0luZm8gMSAwIFIgL0lEIFsg
                          PDBlODBjNTU3NWY2YTM0ODVlOTAwYzc4OTVjOWQxNDVlPgo8MGU4MGM1NTc1
                          ZjZhMzQ4NWU5MDBjNzg5NWM5ZDE0NWU+IF0gPj4Kc3RhcnR4cmVmCjQ0NDkK
                          JSVFT0YK

                          PDF
        )
      end
    end
  end
end
