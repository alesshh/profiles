require 'rails_helper'

RSpec.feature 'User sign up' do
  let!(:state) { create(:state) }
  let(:profile) { attributes_for(:profile) }

  before { visit new_profile_registration_path }

  scenario 'With valid parameters' do
    fill_in t('activerecord.attributes.profile.email'), with: profile[:email]

    fill_in t('activerecord.attributes.profile.password'),
            with: profile[:password]

    fill_in t('activerecord.attributes.profile.password_confirmation'),
            with: profile[:password]

    fill_in t('activerecord.attributes.profile.age'), with: profile[:age]

    select state.name, from: t('activerecord.attributes.profile.state')

    fill_in t('activerecord.attributes.profile.title_position'),
            with: profile[:title_position]

    click_button t('devise.registrations.new.submit')

    expect(page).to have_text('Cadastro efetuado com sucesso')
  end

  scenario 'With invalid parameters' do
    click_button t('devise.registrations.new.submit')

    expect(page).to have_text(
      t('simple_form.error_notification.default_message')
    )
  end
end
