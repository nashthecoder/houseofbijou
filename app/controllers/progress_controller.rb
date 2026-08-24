class ProgressController < BaseController
  def show
    @sections = ReviewNotes::SECTIONS
  end
end
