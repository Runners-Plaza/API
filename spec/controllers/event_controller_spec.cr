require "./spec_helper"

describe EventController do
  describe "#index" do
    it "lists events" do
      with_distance do
        get "/events"

        status_code.should eq(200)
        json_body.should match([{
          "id"                => 1,
          "name"              => "name",
          "english_name"      => nil,
          "organizer"         => "organizer",
          "english_organizer" => nil,
          "location"          => "somewhere",
          "english_location"  => nil,
          "distances"         => [{
            "id"           => 1,
            "name"         => "name",
            "distance"     => nil,
            "cost"         => nil,
            "time_limit"   => nil,
            "runner_limit" => nil,
            "created_at"   => String,
            "updated_at"   => String,
          }],
          "level"         => "Full",
          "region"        => "Central",
          "url"           => nil,
          "start_at"      => String,
          "sign_start_at" => nil,
          "sign_end_at"   => nil,
          "iaaf"          => true,
          "aims"          => false,
          "measured"      => false,
          "recordable"    => true,
          "created_at"    => String,
          "updated_at"    => String,
        }])
      end
    end
  end

  describe "#show" do
    it "gets an event" do
      with_distance do
        get "/events/1"

        status_code.should eq(200)
        json_body.should match({
          "id"                => 1,
          "name"              => "name",
          "english_name"      => nil,
          "organizer"         => "organizer",
          "english_organizer" => nil,
          "location"          => "somewhere",
          "english_location"  => nil,
          "distances"         => [{
            "id"           => 1,
            "name"         => "name",
            "distance"     => nil,
            "cost"         => nil,
            "time_limit"   => nil,
            "runner_limit" => nil,
            "created_at"   => String,
            "updated_at"   => String,
          }],
          "level"         => "Full",
          "region"        => "Central",
          "url"           => nil,
          "start_at"      => String,
          "sign_start_at" => nil,
          "sign_end_at"   => nil,
          "iaaf"          => true,
          "aims"          => false,
          "measured"      => false,
          "recordable"    => true,
          "created_at"    => String,
          "updated_at"    => String,
        })
      end
    end
  end

  describe "#create" do
    it "creates an event" do
      time = Time.local

      with_manager do
        post "/events", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {
          "name"              => "this name",
          "english_name"      => "another name",
          "organizer"         => "org...",
          "english_organizer" => "organizer",
          "location"          => "here",
          "english_location"  => "there",
          "level"             => "triathlon",
          "region"            => "others",
          "url"               => "https://example.org",
          "start_at"          => (time + 30.days).to_s("%F %T %:z"),
          "sign_start_at"     => (time + 10.days).to_s("%F %T %:z"),
          "sign_end_at"       => (time + 20.days).to_s("%F %T %:z"),
          "iaaf"              => "false",
          "aims"              => "true",
          "measured"          => "true",
          "recordable"        => "false",
        }

        status_code.should eq(200)
        json_body.should match({
          "id"                => 1,
          "name"              => "this name",
          "english_name"      => "another name",
          "organizer"         => "org...",
          "english_organizer" => "organizer",
          "location"          => "here",
          "english_location"  => "there",
          "distances"         => [] of JSON::Any,
          "level"             => "Triathlon",
          "region"            => "Others",
          "url"               => "https://example.org",
          "start_at"          => (time + 30.days).to_s("%F %T %:z"),
          "sign_start_at"     => (time + 10.days).to_s("%F %T %:z"),
          "sign_end_at"       => (time + 20.days).to_s("%F %T %:z"),
          "iaaf"              => false,
          "aims"              => true,
          "measured"          => true,
          "recordable"        => false,
          "created_at"        => String,
          "updated_at"        => String,
        })
      end
    end
  end

  describe "#update" do
    it "updates an event" do
      time = Time.local

      with_distance do
        with_manager do
          patch "/events/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {
            "name"              => "this name",
            "english_name"      => "another name",
            "organizer"         => "org...",
            "english_organizer" => "organizer",
            "location"          => "here",
            "english_location"  => "there",
            "level"             => "triathlon",
            "region"            => "others",
            "url"               => "https://example.org",
            "start_at"          => (time + 30.days).to_s("%F %T %:z"),
            "sign_start_at"     => (time + 10.days).to_s("%F %T %:z"),
            "sign_end_at"       => (time + 20.days).to_s("%F %T %:z"),
            "iaaf"              => "false",
            "aims"              => "true",
            "measured"          => "true",
            "recordable"        => "false",
          }

          status_code.should eq(200)
          json_body.should match({
            "id"                => 1,
            "name"              => "this name",
            "english_name"      => "another name",
            "organizer"         => "org...",
            "english_organizer" => "organizer",
            "location"          => "here",
            "english_location"  => "there",
            "distances"         => [{
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            }],
            "level"         => "Triathlon",
            "region"        => "Others",
            "url"           => "https://example.org",
            "start_at"      => (time + 30.days).to_s("%F %T %:z"),
            "sign_start_at" => (time + 10.days).to_s("%F %T %:z"),
            "sign_end_at"   => (time + 20.days).to_s("%F %T %:z"),
            "iaaf"          => false,
            "aims"          => true,
            "measured"      => true,
            "recordable"    => false,
            "created_at"    => String,
            "updated_at"    => String,
          })
        end
      end
    end
  end

  describe "#destroy" do
    it "deletes an event" do
      with_distance do
        with_manager do
          delete "/events/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"                => 1,
            "name"              => "name",
            "english_name"      => nil,
            "organizer"         => "organizer",
            "english_organizer" => nil,
            "location"          => "somewhere",
            "english_location"  => nil,
            "distances"         => [{
              "id"           => 1,
              "name"         => "name",
              "distance"     => nil,
              "cost"         => nil,
              "time_limit"   => nil,
              "runner_limit" => nil,
              "created_at"   => String,
              "updated_at"   => String,
            }],
            "level"         => "Full",
            "region"        => "Central",
            "url"           => nil,
            "start_at"      => String,
            "sign_start_at" => nil,
            "sign_end_at"   => nil,
            "iaaf"          => true,
            "aims"          => false,
            "measured"      => false,
            "recordable"    => true,
            "created_at"    => String,
            "updated_at"    => String,
          })
          Event.find(1).should be_nil
        end
      end
    end
  end
end
