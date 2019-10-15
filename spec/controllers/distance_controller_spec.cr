require "./spec_helper"

describe DistanceController do
  describe "#index" do
    it "lists distances of an event" do
      with_distance do
        get "/events/1/distances"

        status_code.should eq(200)
        json_body.should match([{
          "id"           => 1,
          "name"         => "name",
          "distance"     => nil,
          "cost"         => nil,
          "time_limit"   => nil,
          "runner_limit" => nil,
          "created_at"   => String,
          "updated_at"   => String,
        }])
      end
    end
  end

  describe "#show" do
    it "gets a distance" do
      with_distance do
        get "/distances/1"

        status_code.should eq(200)
        json_body.should match({
          "id"           => 1,
          "name"         => "name",
          "distance"     => nil,
          "cost"         => nil,
          "time_limit"   => nil,
          "runner_limit" => nil,
          "created_at"   => String,
          "updated_at"   => String,
        })
      end
    end
  end

  describe "#create" do
    it "creates a distance" do
      with_manager do
        with_event do
          post "/events/1/distances", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {
            "name"         => "some name",
            "distance"     => "666",
            "cost"         => "777",
            "time_limit"   => "600",
            "runner_limit" => "1234",
          }

          status_code.should eq(200)
          json_body.should match({
            "id"           => 1,
            "name"         => "some name",
            "distance"     => 666,
            "cost"         => 777,
            "time_limit"   => 600,
            "runner_limit" => 1234,
            "created_at"   => String,
            "updated_at"   => String,
          })
        end
      end
    end
  end

  describe "#update" do
    it "updates a distance" do
      with_manager do
        with_distance do
          patch "/distances/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {
            "name"         => "some name",
            "distance"     => "666",
            "cost"         => "777",
            "time_limit"   => "600",
            "runner_limit" => "1234",
          }

          status_code.should eq(200)
          json_body.should match({
            "id"           => 1,
            "name"         => "some name",
            "distance"     => 666,
            "cost"         => 777,
            "time_limit"   => 600,
            "runner_limit" => 1234,
            "created_at"   => String,
            "updated_at"   => String,
          })
        end
      end
    end
  end

  describe "#destroy" do
    it "deletes a distance" do
      with_manager do
        with_distance do
          delete "/distances/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"           => 1,
            "name"         => "name",
            "distance"     => nil,
            "cost"         => nil,
            "time_limit"   => nil,
            "runner_limit" => nil,
            "created_at"   => String,
            "updated_at"   => String,
          })
          Distance.find(1).should be_nil
        end
      end
    end
  end
end
