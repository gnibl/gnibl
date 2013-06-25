require 'spec_helper'

describe CommentsController do

  describe "GET 'upvote'" do
    it "returns http success" do
      get 'upvote'
      response.should be_success
    end
  end

end
