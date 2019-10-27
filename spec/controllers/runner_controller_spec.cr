require "./spec_helper"

describe RunnerController do
  describe "#index" do
    context "not log in" do
      it "lists approved runners" do
        with_approved_runner do
          get "/runners"

          status_code.should eq(200)
          json_body.should match([{
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
          }])
        end
      end
    end

    context "by Manager" do
      it "lists approved runners with user and approver" do
        with_approved_runner do
          get "/runners", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match([{
            "id"   => 1,
            "user" => {
              "id"         => 2,
              "fb_id"      => "member",
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            "name"                     => "runner",
            "alternative_name"         => nil,
            "english_name"             => nil,
            "alternative_english_name" => nil,
            "birthday"                 => String,
            "phone"                    => "0912345678",
            "organization"             => "org",
            "status"                   => "Approved",
            "approver"                 => {
              "id"         => 1,
              "fb_id"      => "manager",
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
            "approved_at" => String,
            "created_at"  => String,
            "updated_at"  => String,
          }])
        end
      end

      it "lists pending runners with user and nil approver" do
        with_pending_runner do
          get "/runners?status=pending", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match([{
            "id"   => 1,
            "user" => {
              "id"         => 2,
              "fb_id"      => "member",
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            "name"                     => "runner",
            "alternative_name"         => nil,
            "english_name"             => nil,
            "alternative_english_name" => nil,
            "birthday"                 => String,
            "phone"                    => "0912345678",
            "organization"             => "org",
            "status"                   => "Pending",
            "approver"                 => nil,
            "approved_at"              => nil,
            "created_at"               => String,
            "updated_at"               => String,
          }])
        end
      end
    end
  end

  describe "#show" do
    context "not log in" do
      it "gets an approved runner" do
        with_approved_runner do
          get "/runners/1"

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

    context "by Manager" do
      it "gets an approved runner with user and approver" do
        with_approved_runner do
          get "/runners/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"   => 1,
            "user" => {
              "id"         => 2,
              "fb_id"      => "member",
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            "name"                     => "runner",
            "alternative_name"         => nil,
            "english_name"             => nil,
            "alternative_english_name" => nil,
            "birthday"                 => String,
            "phone"                    => "0912345678",
            "organization"             => "org",
            "status"                   => "Approved",
            "approver"                 => {
              "id"         => 1,
              "fb_id"      => "manager",
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
            "approved_at" => String,
            "created_at"  => String,
            "updated_at"  => String,
          })
        end
      end

      it "gets a pending runner with user and nil approver" do
        with_pending_runner do
          get "/runners/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should match({
            "id"   => 1,
            "user" => {
              "id"         => 2,
              "fb_id"      => "member",
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            "name"                     => "runner",
            "alternative_name"         => nil,
            "english_name"             => nil,
            "alternative_english_name" => nil,
            "birthday"                 => String,
            "phone"                    => "0912345678",
            "organization"             => "org",
            "status"                   => "Pending",
            "approver"                 => nil,
            "approved_at"              => nil,
            "created_at"               => String,
            "updated_at"               => String,
          })
        end
      end
    end
  end

  describe "#user_show" do
    it "gets the runner of a user with approver" do
      with_approved_runner do
        get "/users/2/runner", HTTP::Headers{"Authorization" => "Bearer manager_token"}

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
          "approver"                 => {
            "id"         => 1,
            "fb_id"      => "manager",
            "name"       => "Manager",
            "email"      => "manager@bar.com",
            "position"   => "Manager",
            "created_at" => String,
            "updated_at" => String,
          },
          "approved_at" => String,
          "created_at"  => String,
          "updated_at"  => String,
        })
      end
    end
  end

  describe "update_status" do
    it "approves a request to be a runner" do
      with_pending_runner do
        patch "/runners/1/status", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {"status" => "approved"}

        status_code.should eq(204)

        runner = Runner.find!(1)

        runner.status.should eq(Runner::Status::Approved)
        runner.approver_id.should eq(1)
        runner.approved_at.should be_a(Time)
      end
    end

    it "rejects a request to be a runner" do
      with_pending_runner do
        patch "/runners/1/status", HTTP::Headers{"Authorization" => "Bearer manager_token"}, form: {"status" => "rejected", "reason" => "reason"}

        status_code.should eq(204)

        runner = Runner.find!(1)

        runner.status.should eq(Runner::Status::Rejected)
        runner.approver_id.should eq(1)
        runner.approved_at.should be_nil

        error = runner.error!

        error.description.should eq("reason")
      end
    end
  end

  describe "#error" do
    it "gets the rejected reason for the request of a runner" do
      with_rejected_runner do
        get "/runners/1/error", HTTP::Headers{"Authorization" => "Bearer manager_token"}

        status_code.should eq(200)
        json_body.should match({
          "title"       => "Runner: Rejected",
          "description" => "desc",
        })
      end
    end
  end
end
