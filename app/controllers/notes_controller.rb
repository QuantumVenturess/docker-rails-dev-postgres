class NotesController < ApplicationController
  def create
    @note = Note.create! params.require(:note).permit(:content)
    redirect_to notes_path
  end

  def destroy
    Note.find(params[:id]).destroy
    redirect_to notes_path
  end

  def index
    @notes = Note.order created_at: :desc
  end

  def new
    @note = Note.new
  end

  def show
    @note = Note.find params[:id]
  end
end
