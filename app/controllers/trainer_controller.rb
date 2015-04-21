class TrainerController < ApplicationController
  def index
    if current_user.decks.empty?
      redirect_to new_deck_path
    elsif current_user.current_deck.present?
      @card = current_user.current_deck.cards.for_review.first
    else
      @card = current_user.cards.for_review.first
    end
  end

  def check_translation
    @card = Card.find(params[:card_id])
    user_translation = params[:translated_text]
    right_translation = @card.translated_text
    original = @card.original_text

    if @card.check_translation(user_translation)
      flash[:notice] = "Правильно!"
    elsif @card.lev_dist(user_translation) == 1
      flash[:notice] = "Очепятка! \
                        Вы ввели #{user_translation}. \
                        Правильный перевод \"#{original}\" \
                        - \"#{right_translation}\"!"
    else
      flash[:notice] = "Неправильно!"
    end
    redirect_to root_path
  end
end
