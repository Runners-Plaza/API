require "./spec_helper"

describe RecordController do
  describe "#index" do
    context "not log in" do
      it "lists approved records" do
        with_record Record::Status::Approved, 1_i64 do
          get "/records"

          status_code.should eq(200)
          json_body.should match([{
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Approved",
            "approved_at" => String,
            "updated_at"  => String,
            "created_at"  => String,
          }])
        end
      end

      it "lists approved records of an event" do
        with_record Record::Status::Approved, 1_i64 do
          get "/records?event_id=1"

          status_code.should eq(200)
          json_body.should match([{
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Approved",
            "approved_at" => String,
            "updated_at"  => String,
            "created_at"  => String,
          }])
        end
      end
    end

    context "by Manager" do
      it "lists approved records with approver" do
        with_record Record::Status::Approved, 1_i64 do
          get "/records", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match([{
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number" => "1234",
            "group"      => nil,
            "time"       => 5678,
            "chip_time"  => nil,
            "rank"       => nil,
            "group_rank" => nil,
            "remark"     => nil,
            "status"     => "Approved",
            "approver"   => {
              "id"         => 1,
              "fb_id"      => "manager",
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
            "approved_at" => String,
            "updated_at"  => String,
            "created_at"  => String,
          }])
        end
      end

      it "lists pending records with nil approver" do
        with_record do
          get "/records?status=pending", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match([{
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Pending",
            "approver"    => nil,
            "approved_at" => nil,
            "updated_at"  => String,
            "created_at"  => String,
          }])
        end
      end
    end
  end

  describe "#show" do
    context "not log in" do
      it "gets an approved record" do
        with_record Record::Status::Approved, 1_i64 do
          get "/records/1"

          status_code.should eq(200)
          json_body.should match({
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Approved",
            "approved_at" => String,
            "updated_at"  => String,
            "created_at"  => String,
          })
        end
      end
    end

    context "by Manager" do
      it "gets an approved record with approver" do
        with_record Record::Status::Approved, 1_i64 do
          get "/records/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number" => "1234",
            "group"      => nil,
            "time"       => 5678,
            "chip_time"  => nil,
            "rank"       => nil,
            "group_rank" => nil,
            "remark"     => nil,
            "status"     => "Approved",
            "approver"   => {
              "id"         => 1,
              "fb_id"      => "manager",
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
            "approved_at" => String,
            "updated_at"  => String,
            "created_at"  => String,
          })
        end
      end

      it "gets a pending record with nil approver" do
        with_record do
          get "/records/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Pending",
            "approver"    => nil,
            "approved_at" => nil,
            "updated_at"  => String,
            "created_at"  => String,
          })
        end
      end
    end

    context "by owner" do
      it "gets his record" do
        with_record do
          get "/records/1", HTTP::Headers{"Authorization" => "Bearer member_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"     => 1,
            "runner" => {
              "id"                       => 1,
              "name"                     => "runner",
              "alternative_name"         => nil,
              "english_name"             => nil,
              "alternative_english_name" => nil,
              "birthday"                 => String,
              "phone"                    => "0912345678",
              "organization"             => "org",
              "status"                   => "Approved",
              "approved_at"              => String,
              "created_at"               => String,
              "updated_at"               => String,
            },
            "event" => {
              "id"                => 1,
              "name"              => "name",
              "english_name"      => nil,
              "organizer"         => "organizer",
              "english_organizer" => nil,
              "location"          => "somewhere",
              "english_location"  => nil,
              "level"             => "Full",
              "region"            => "Central",
              "url"               => nil,
              "start_at"          => String,
              "sign_start_at"     => nil,
              "sign_end_at"       => nil,
              "iaaf"              => true,
              "aims"              => false,
              "measured"          => false,
              "recordable"        => true,
              "created_at"        => String,
              "updated_at"        => String,
            },
            "distance" => {
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            },
            "bib_number"  => "1234",
            "group"       => nil,
            "time"        => 5678,
            "chip_time"   => nil,
            "rank"        => nil,
            "group_rank"  => nil,
            "remark"      => nil,
            "status"      => "Pending",
            "approved_at" => nil,
            "updated_at"  => String,
            "created_at"  => String,
          })
        end
      end
    end
  end

  describe "#update_status" do
    it "approves a record" do
      with_record do
        patch "/records/1/status", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {"status" => "approved"}

        status_code.should eq(204)

        record = Record.find!(1)

        record.status.should eq(Record::Status::Approved)
        record.approver_id.should eq(1)
        record.approved_at.should be_a(Time)
      end
    end

    it "rejects a record" do
      clear RecordError do
        with_record do
          patch "/records/1/status", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {"status" => "rejected", "reason" => "reason"}

          status_code.should eq(204)

          record = Record.find!(1)

          record.status.should eq(Record::Status::Rejected)
          record.approver_id.should eq(1)
          record.approved_at.should be_nil
          record.error!.description.should eq("reason")
        end
      end
    end
  end

  describe "error" do
    context "by Manager" do
      it "gets the rejected reason for a record" do
        with_record Record::Status::Rejected, 1_i64 do
          get "/records/1/error", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "title"       => "Record: Rejected",
            "description" => "desc",
          })
        end
      end
    end
  end
end
