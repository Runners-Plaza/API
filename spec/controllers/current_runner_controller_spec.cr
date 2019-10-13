require "./spec_helper"

describe CurrentRunnerController do
  describe "#show" do
    it "gets the runner" do
      with_approved_runner do
        get "/runner", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        json_body.should match({
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
        })
      end
    end
  end

  describe "#create" do
    it "creates a request to be a runner" do
      with_member do
        post "/runner", HTTP::Headers{"Authorization" => "Bearer member_token"}, form: {
          "name"                     => "runner1",
          "alternative_name"         => "runner2",
          "english_name"             => "runner3",
          "alternative_english_name" => "runner4",
          "birthday"                 => "1999-10-13",
          "phone"                    => "0912345678",
          "organization"             => "org",
        }

        status_code.should eq(200)
        json_body.should match({
          "id"                       => 1,
          "name"                     => "runner1",
          "alternative_name"         => "runner2",
          "english_name"             => "runner3",
          "alternative_english_name" => "runner4",
          "birthday"                 => "1999-10-13",
          "phone"                    => "0912345678",
          "organization"             => "org",
          "status"                   => "Pending",
          "approved_at"              => nil,
          "created_at"               => String,
          "updated_at"               => String,
        })
      end
    end
  end

  describe "#update" do
    it "updates the runner" do
      with_approved_runner do
        patch "/runner", HTTP::Headers{"Authorization" => "Bearer member_token"}, form: {
          "phone"        => "0987654321",
          "organization" => "organization",
        }

        status_code.should eq(200)
        json_body.should contain({
          "phone"        => "0987654321",
          "organization" => "organization",
        })
      end
    end
  end

  describe "#destroy" do
    it "cancels the request to be a runner" do
      with_pending_runner do
        delete "/runner", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        json_body.should match({
          "id"                       => 1,
          "name"                     => "runner",
          "alternative_name"         => nil,
          "english_name"             => nil,
          "alternative_english_name" => nil,
          "birthday"                 => String,
          "phone"                    => "0912345678",
          "organization"             => "org",
          "status"                   => "Pending",
          "approved_at"              => nil,
          "created_at"               => String,
          "updated_at"               => String,
        })
        Runner.find(1).should be_nil
      end
    end
  end

  describe "#error" do
    it "gets the rejected reason for the request to be a runner" do
      with_rejected_runner do
        get "/runner/error", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        json_body.should match({
          "title"       => "Runner: Rejected",
          "description" => "desc",
        })
      end
    end
  end
end
