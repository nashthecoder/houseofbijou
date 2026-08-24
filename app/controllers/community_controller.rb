class CommunityController < BaseController
  def show
    @stories = Story.order(created_at: :desc, id: :desc)
    @vote = VoteProposal.first || VoteProposal.new(title: "No open proposals", supports_count: 0)
  end

  def support
    vote = VoteProposal.find(params[:id])
    vote.increment!(:supports_count)
    redirect_to community_path
  end

  def create_story
    @story = Story.new(author: settings.pseudonym, body: story_params[:body].to_s.strip,
                       visibility: "circle")
    if @story.save
      redirect_to community_path, toast: "Your story is shared with your trusted circle only."
    else
      redirect_to community_path, toast: "Write a little more before sharing."
    end
  end

  private

  def story_params
    params.require(:story).permit(:body)
  end
end
