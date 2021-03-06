require 'rails_helper'

RSpec.feature 'Search Profiles' do
  context 'authenticated profile' do
    let(:current_profile) { create(:profile, age: 28) }

    let!(:profile_1) { create(:profile, email: 'alex@example.com', age: 12) }
    let!(:profile_2) { create(:profile, email: 'ben@example.com', age: 22) }
    let!(:profile_3) { create(:profile, email: 'carlos@example.com', age: 22) }

    before { sign_in current_profile }

    scenario 'load profiles by params criteria' do
      select t('profiles.search_form.match_options.all'),
             from: t('profiles.search_form.match')

      select t('profiles.search_form.criteria_options.equals'),
             from: t('profiles.search_form.age_criteria')

      fill_in :criteria_age_value, with: 22

      click_button t('profiles.search_form.submit')

      expect(page).to have_text(profile_2.email)
      expect(page).to have_text(profile_3.email)
      expect(page).to_not have_text(profile_1.email)
    end

    scenario 'load ordered and paginated data' do
      Profile.paginates_per 2

      visit search_path

      expect(page).to have_text(profile_1.email)
      expect(page).to have_text(profile_2.email)
      expect(page).to_not have_text(profile_3.email)

      click_link t('views.pagination.next')

      expect(page).to_not have_text(profile_1.email)
      expect(page).to_not have_text(profile_2.email)
      expect(page).to have_text(profile_3.email)
    end
  end

  it_behaves_like 'unauthenticated' do
    let(:path) { search_path }
  end
end
