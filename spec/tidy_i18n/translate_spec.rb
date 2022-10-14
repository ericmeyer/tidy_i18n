require 'spec_helper'
require 'mocks/view'

describe 'TidyI18n.translate' do
  it 'does not barf when sending options' do
    expect { TidyI18n.t("spec.mocks.view.translation_with_interpolation", name: 'blah') }.not_to raise_error
  end
end
