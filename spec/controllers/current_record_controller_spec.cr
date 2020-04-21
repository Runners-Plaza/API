require "./spec_helper"

describe CurrentRecordController do
  describe "#index" do
    it "lists records of the runner" do
      with_record do
        get "/runner/records", HTTP::Headers{"Authorization" => "Bearer member_token"}

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
            "url"               => nil,
            "status"            => nil,
            "region"            => {
              "id"           => 1,
              "name"         => "test region name",
              "english_name" => "test region english name",
            },
            "start_at"      => String,
            "sign_start_at" => nil,
            "sign_end_at"   => nil,
            "iaaf"          => true,
            "aims"          => false,
            "measured"      => false,
            "recordable"    => true,
            "created_at"    => String,
            "updated_at"    => String,
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
        }])
      end
    end
  end

  describe "#create" do
    it "creates a record" do
      with_approved_runner do
        with_distance do
          post "/distances/1/records", HTTP::Headers{"Authorization" => "Bearer member_token"}, form: {
            "bib_number" => "5566",
            "group"      => "group",
            "time"       => "31415",
            "chip_time"  => "31414",
            "rank"       => "2345",
            "group_rank" => "21",
            "remark"     => "remark",
          }

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
              "url"               => nil,
              "status"            => nil,
              "region"            => {
                "id"           => 1,
                "name"         => "test region name",
                "english_name" => "test region english name",
              },
              "start_at"      => String,
              "sign_start_at" => nil,
              "sign_end_at"   => nil,
              "iaaf"          => true,
              "aims"          => false,
              "measured"      => false,
              "recordable"    => true,
              "created_at"    => String,
              "updated_at"    => String,
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
            "bib_number"  => "5566",
            "group"       => "group",
            "time"        => 31415,
            "chip_time"   => 31414,
            "rank"        => 2345,
            "group_rank"  => 21,
            "remark"      => "remark",
            "status"      => "Pending",
            "approved_at" => nil,
            "updated_at"  => String,
            "created_at"  => String,
          })
        end
      end
    end
  end

  describe "#update" do
    it "updates a record" do
      with_record do
        patch "/records/1", HTTP::Headers{"Authorization" => "Bearer member_token"}, form: {
          "remark" => "new remark",
        }

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
            "url"               => nil,
            "status"            => nil,
            "region"            => {
              "id"           => 1,
              "name"         => "test region name",
              "english_name" => "test region english name",
            },
            "start_at"      => String,
            "sign_start_at" => nil,
            "sign_end_at"   => nil,
            "iaaf"          => true,
            "aims"          => false,
            "measured"      => false,
            "recordable"    => true,
            "created_at"    => String,
            "updated_at"    => String,
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
          "remark"      => "new remark",
          "status"      => "Pending",
          "approved_at" => nil,
          "updated_at"  => String,
          "created_at"  => String,
        })
      end
    end
  end

  describe "#destroy" do
    it "deletes a record" do
      with_record do
        delete "/records/1", HTTP::Headers{"Authorization" => "Bearer member_token"}

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
            "url"               => nil,
            "status"            => nil,
            "region"            => {
              "id"           => 1,
              "name"         => "test region name",
              "english_name" => "test region english name",
            },
            "start_at"      => String,
            "sign_start_at" => nil,
            "sign_end_at"   => nil,
            "iaaf"          => true,
            "aims"          => false,
            "measured"      => false,
            "recordable"    => true,
            "created_at"    => String,
            "updated_at"    => String,
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
        Record.find(1).should be_nil
      end
    end
  end
end
