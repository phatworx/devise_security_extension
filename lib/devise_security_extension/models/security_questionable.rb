module Devise
  module Models
    # SecurityQuestionable is an accessible add-on for visually handicapped people,
    # to ship around the captcha with screenreader compatibility.
    #
    # You need to add two text_field_tags to the associated form:
    # :security_question_answer and :captcha
    #
    # And add the security_question to the register/edit form.
    module SecurityQuestionable
      extend ActiveSupport::Concern

    end
  end
end