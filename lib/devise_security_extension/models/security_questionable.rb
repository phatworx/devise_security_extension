module Devise
  module Models
    # SecurityQuestionable is an accessible add-on for visually handicapped people,
    # to ship around the captcha with screenreader compatibility.
    #
    # You need to add two text_field_tags to the associated forms (unlock,
    # password, confirmation):
    # :security_question_answer and :captcha
    #
    # And add the security_question to the register/edit form.
    # f.select :security_question_id, SecurityQuestion.where(locale: I18n.locale).map{|s| [s.name, s.id]}
    # f.text_field :security_question_answer
    module SecurityQuestionable
      extend ActiveSupport::Concern

    end
  end
end