require "./spec_helper"

describe UserController do
  describe "#index" do
    context "not log in" do
      it "lists users" do
        with_users do
          get "/users"

          status_code.should eq(200)
          json_body.should contain([
            {
              "id"         => 2,
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            {
              "id"         => 1,
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
          ])
        end
      end
    end

    context "by Manager" do
      it "lists users with fb_id" do
        with_users do
          get "/users", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should contain([
            {
              "id"         => 2,
              "fb_id"      => "member",
              "name"       => "Member",
              "email"      => "member@foo.com",
              "position"   => "Member",
              "created_at" => String,
              "updated_at" => String,
            },
            {
              "id"         => 1,
              "fb_id"      => "manager",
              "name"       => "Manager",
              "email"      => "manager@bar.com",
              "position"   => "Manager",
              "created_at" => String,
              "updated_at" => String,
            },
          ])
        end
      end
    end
  end

  describe "#show" do
    context "not log in" do
      it "gets a user" do
        with_manager do
          get "/users/1"

          status_code.should eq(200)
          json_body.should contain({
            "id"         => 1,
            "name"       => "Manager",
            "email"      => "manager@bar.com",
            "position"   => "Manager",
            "created_at" => String,
            "updated_at" => String,
          })
        end
      end
    end

    context "by Manager" do
      it "gets a user with fb_id" do
        with_manager do
          get "/users/1", HTTP::Headers{"Authorization" => "Bearer manager_token"}

          status_code.should eq(200)
          json_body.should contain({
            "id"         => 1,
            "fb_id"      => "manager",
            "name"       => "Manager",
            "email"      => "manager@bar.com",
            "position"   => "Manager",
            "created_at" => String,
            "updated_at" => String,
          })
        end
      end
    end
  end
end
