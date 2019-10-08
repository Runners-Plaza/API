require "./spec_helper"

describe CurrentUserController do
  describe "#show" do
    it "gets the authenticated user" do
      with_member do
        get "/user", HTTP::Headers{"Authorization" => "Bearer member_token"}

        status_code.should eq(200)
        json_body.should match({
          "id"         => 1,
          "fb_id"      => "member",
          "name"       => "Member",
          "email"      => "member@foo.com",
          "position"   => "Member",
          "created_at" => String,
          "updated_at" => String,
        })
      end
    end
  end

  describe "#update" do
    it "updates the authenticated user" do
      with_member do
        patch "/user", HTTP::Headers{"Authorization" => "Bearer member_token"}, form: {
          name:  "New Name",
          email: "member@bar.com",
        }

        status_code.should eq(200)
        json_body.should match({
          "id"         => 1,
          "fb_id"      => "member",
          "name"       => "New Name",
          "email"      => "member@bar.com",
          "position"   => "Member",
          "created_at" => String,
          "updated_at" => String,
        })
      end
    end
  end
end
